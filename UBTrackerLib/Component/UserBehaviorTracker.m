//
//  UserBehaviorTracker.m
//  UBTracker
//
//  Created by qinzhiwei on 2016/10/25.
//  Copyright © 2016年 lobster. All rights reserved.
//

#import "UserBehaviorTracker.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "TrackingCodeMakerPlugin.h"
#import "UBViewHierarchyDumper.h"
#import "UBViewNode.h"

@interface UserBehaviorTracker ()

@property (nonatomic, strong) UBViewNode *headNode;/*current view head node*/
@property (nonatomic, strong) NSMutableSet<NSString*>*accessIdSet;/*存放事件accessId*/

@end

static UserBehaviorTracker *sharedInstance = nil;

void trackExchangeMethod(Class aClass, SEL oldSEL, SEL newSEL)
{
    Method oldMethod = class_getInstanceMethod(aClass, oldSEL);
    if(oldMethod){
        Method newMethod = class_getInstanceMethod(aClass, newSEL);
        assert(newMethod);
        method_exchangeImplementations(oldMethod, newMethod);
    }
}

#pragma mark--UINavigationController--
@implementation UINavigationController (TrackHook)

+ (void)trackHook{
    trackExchangeMethod([UINavigationController class], @selector(navigationBar:shouldPopItem:), @selector(track_navigationBar:shouldPopItem:));
}

- (BOOL)track_navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item{
    BOOL isPop = [self track_navigationBar:navigationBar shouldPopItem:item];
    
    NSString *accessibilityIdentifier = [navigationBar accessibilityIdentifier];
    
    if (!accessibilityIdentifier) {
        UBViewNode *targetNode = [UBViewHierarchyDumper retrieveNodeWithSender:navigationBar withHeadNode:[UserBehaviorTracker sharedInstance].headNode];
        if (targetNode) {
            /*发现目标*/
            accessibilityIdentifier = [targetNode.nodeSelf accessibilityIdentifier];
        }
        
    }
    
    if (accessibilityIdentifier.length) {
        
        dispatch_async([UserBehaviorTracker sharedInstance].codeMakerQueue, ^{
            [[UserBehaviorTracker sharedInstance].codeMaker recordTapActionWithAccessibilityIdentifier:accessibilityIdentifier];
        });
    }
    
    return isPop;
}

@end

#pragma mark--UIApplication--
@implementation UIApplication (TrackHook)

+ (void)trackHook{
    trackExchangeMethod([UIApplication class],
                        @selector(sendAction:to:from:forEvent:),
                        @selector(track_sendAction:to:from:forEvent:));
}

- (BOOL)track_sendAction:(SEL)action to:(id)target from:(id)sender forEvent:(UIEvent *)event{
    
    NSString *accessibilityIdentifier = [sender accessibilityIdentifier];
    
    if (!accessibilityIdentifier) {
        UBViewNode *targetNode = [UBViewHierarchyDumper retrieveNodeWithSender:sender withHeadNode:[UserBehaviorTracker sharedInstance].headNode];
        if (targetNode) {
            /*发现目标*/
            accessibilityIdentifier = [targetNode.nodeSelf accessibilityIdentifier];
        }
        
    }
    
    if (accessibilityIdentifier.length) {
        
        if ([[UserBehaviorTracker sharedInstance].accessIdSet containsObject:accessibilityIdentifier]) {
            return [self track_sendAction:action to:target from:sender forEvent:event];
        }
        
        [[UserBehaviorTracker sharedInstance].accessIdSet addObject:accessibilityIdentifier];
        
        dispatch_async([UserBehaviorTracker sharedInstance].codeMakerQueue, ^{
            [[UserBehaviorTracker sharedInstance].codeMaker recordTapActionWithAccessibilityIdentifier:accessibilityIdentifier];
        });
    }
    
    return [self track_sendAction:action to:target from:sender forEvent:event];
}

@end

#pragma mark--UIViewController--
@implementation UIViewController (TraceHook)

+ (void)trackHook{
    trackExchangeMethod([UIViewController class], @selector(viewDidAppear:), @selector(track_viewDidAppear:));
}

- (void)track_viewDidAppear:(BOOL)animated{
    [self track_viewDidAppear:animated];
    /*dump current view*/
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [UserBehaviorTracker sharedInstance].headNode = [UBViewHierarchyDumper dumpCurrentViewHierarchy];
    });
    
}

@end

#pragma mark--UIControl--
@implementation UIControl (TrackHook)

+ (void)trackHook{
    trackExchangeMethod([UIControl class],
                   @selector(sendAction:to:forEvent:),
                   @selector(track_sendAction:to:forEvent:));
}

- (void)track_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    [self track_sendAction:action to:target forEvent:event];
    

}

@end

#pragma mark--UITouch--
@implementation UITouch (TrackHook)

+ (void)trackHook{
    trackExchangeMethod([UITouch class], @selector(locationInView:), @selector(track_locationInView:));
}

- (CGPoint)track_locationInView:(nullable UIView *)view{
    return [self track_locationInView:view];
}

@end

#pragma mark--UIActionSheet--
@implementation UIActionSheet (TrackHook)

+ (void)trackHook{
    trackExchangeMethod([UIActionSheet class], @selector(setDelegate:), @selector(track_setDelegate:));
}

- (void)track_setDelegate:(id<UIActionSheetDelegate>)delegate{
    [self track_setDelegate:delegate];
    
    if (![delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        return;
    }
    
    Method orignialEvent = class_getInstanceMethod([delegate class], @selector(actionSheet:clickedButtonAtIndex:));
    IMP originalEventImp = method_getImplementation(orignialEvent);
    
    Method sendEventMySelf = class_getInstanceMethod([self class], @selector(track_actionSheet:clickedButtonAtIndex:));
    IMP sendEventImp = method_getImplementation(sendEventMySelf);
    
    class_addMethod([delegate class], @selector(track_actionSheet:clickedButtonAtIndex:), sendEventImp, method_getTypeEncoding(sendEventMySelf));
    
    BOOL didAddMethod = class_addMethod([delegate class], @selector(actionSheet:clickedButtonAtIndex:), sendEventImp, method_getTypeEncoding(sendEventMySelf));
    if (didAddMethod) {
        class_replaceMethod([delegate class], @selector(actionSheet:clickedButtonAtIndex:), originalEventImp, method_getTypeEncoding(orignialEvent));
    } else {
        trackExchangeMethod([delegate class], @selector(actionSheet:clickedButtonAtIndex:), @selector(track_actionSheet:clickedButtonAtIndex:));
    }
}

- (void)track_actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self track_actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];
    
}

@end

#pragma mark--UIAlertAction--
@implementation UIAlertAction (TrackHook)

+ (void)trackHook{
    trackExchangeMethod([UIAlertAction class], @selector(actionWithTitle:style:handler:), @selector(track_actionWithTitle:style:handler:));
}

+ (instancetype)track_actionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style handler:(void (^ __nullable)(UIAlertAction *action))handler{
    id actionObj = [self track_actionWithTitle:title style:style handler:handler];
    
    return actionObj;
}

@end

#pragma mark--UIAlertView--
@implementation UIAlertView (TrackHook)

+ (void)trackHook{
    trackExchangeMethod([UIAlertView class], @selector(setDelegate:), @selector(track_setDelegate:));
}

- (void)track_setDelegate:(id<UIAlertViewDelegate>)delegate{
    [self track_setDelegate:delegate];

    if (![delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        return;
    }

    Method orignialEvent = class_getInstanceMethod([delegate class], @selector(alertView:clickedButtonAtIndex:));
    IMP originalEventImp = method_getImplementation(orignialEvent);

    Method sendEventMySelf = class_getInstanceMethod([self class], @selector(track_alertView:clickedButtonAtIndex:));
    IMP sendEventImp = method_getImplementation(sendEventMySelf);

    class_addMethod([delegate class], @selector(track_alertView:clickedButtonAtIndex:), sendEventImp, method_getTypeEncoding(sendEventMySelf));

    BOOL didAddMethod = class_addMethod([delegate class], @selector(alertView:clickedButtonAtIndex:), sendEventImp, method_getTypeEncoding(sendEventMySelf));
    if (didAddMethod) {
        class_replaceMethod([delegate class], @selector(track_alertView:clickedButtonAtIndex:), originalEventImp, method_getTypeEncoding(orignialEvent));
    } else {
        trackExchangeMethod([delegate class], @selector(alertView:clickedButtonAtIndex:), @selector(track_alertView:clickedButtonAtIndex:));
    }
}

- (void)track_alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self track_alertView:alertView clickedButtonAtIndex:buttonIndex];
}

@end

#pragma mark--UITextField--
@implementation UITextField (TrackHook)

+ (void)trackHook{
    trackExchangeMethod([UITextField class], @selector(setDelegate:), @selector(track_setDelegate:));
}

- (void)track_setDelegate:(id<UITextFieldDelegate>)delegate{
    [self track_setDelegate:delegate];
    
    if (![delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return;
    }
    
    Method orignialEvent = class_getInstanceMethod([delegate class], @selector(textFieldShouldReturn:));
    IMP originalEventImp = method_getImplementation(orignialEvent);
    
    Method sendEventMySelf = class_getInstanceMethod([self class], @selector(track_textFieldShouldReturn:));
    IMP sendEventImp = method_getImplementation(sendEventMySelf);
    
    class_addMethod([delegate class], @selector(track_textFieldShouldReturn:), sendEventImp, method_getTypeEncoding(sendEventMySelf));
    
    BOOL didAddMethod = class_addMethod([delegate class], @selector(textFieldShouldReturn:), sendEventImp, method_getTypeEncoding(sendEventMySelf));
    
    if (didAddMethod) {
        class_replaceMethod([delegate class], @selector(track_textFieldShouldReturn:), originalEventImp, method_getTypeEncoding(orignialEvent));
    } else {
        trackExchangeMethod([delegate class],
                            @selector(textFieldShouldReturn:),
                            @selector(track_textFieldShouldReturn:));
    }

}

- (BOOL)track_textFieldShouldReturn:(UITextField *)textField{
    
    return [self track_textFieldShouldReturn:textField];
}

@end

#pragma mark--UICollectionView--
@implementation UICollectionView (TrackHook)

+ (void)trackHook{
    trackExchangeMethod([UICollectionView class], @selector(setDelegate:),@selector(track_setDelegate:));
}

- (void)track_setDelegate:(id<UICollectionViewDelegate>)delegate{
    [self track_setDelegate:delegate];
    
    if (![delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        return;
    }
    
    Method orignialEvent = class_getInstanceMethod([delegate class], @selector(collectionView:didSelectItemAtIndexPath:));
    IMP originalEventImp = method_getImplementation(orignialEvent);
    
    Method sendEventMySelf = class_getInstanceMethod([self class], @selector(track_collectionView:didSelectItemAtIndexPath:));
    IMP sendEventImp = method_getImplementation(sendEventMySelf);
    
    class_addMethod([delegate class], @selector(track_collectionView:didSelectItemAtIndexPath:), sendEventImp, method_getTypeEncoding(sendEventMySelf));
    
    BOOL didAddMethod = class_addMethod([delegate class], @selector(collectionView:didSelectItemAtIndexPath:), sendEventImp, method_getTypeEncoding(sendEventMySelf));
    
    if (didAddMethod) {
        class_replaceMethod([delegate class], @selector(track_collectionView:didSelectItemAtIndexPath:), originalEventImp, method_getTypeEncoding(orignialEvent));
    } else {
        trackExchangeMethod([delegate class],
                            @selector(collectionView:didSelectItemAtIndexPath:),
                            @selector(track_collectionView:didSelectItemAtIndexPath:));
    }
}

-(void)track_collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self track_collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    
    
}

@end

#pragma mark--UITableView--
@implementation UITableView (TrackHook)

+ (void)trackHook{
    trackExchangeMethod([UITableView class],
                        @selector(setDelegate:),
                        @selector(track_setDelegate:));
}

- (void)track_setDelegate:(id<UITableViewDelegate>)delegate{
    [self track_setDelegate:delegate];
    
    
    if (![delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        return;
    }
    
    Method orignialEvent = class_getInstanceMethod([delegate class], @selector(tableView:didSelectRowAtIndexPath:));
    IMP originalEventImp = method_getImplementation(orignialEvent);
    
    Method sendEventMySelf = class_getInstanceMethod([self class], @selector(track_tableView:didSelectRowAtIndexPath:));
    IMP sendEventImp = method_getImplementation(sendEventMySelf);
    
    class_addMethod([delegate class], @selector(track_tableView:didSelectRowAtIndexPath:), sendEventImp, method_getTypeEncoding(sendEventMySelf));
    
    BOOL didAddMethod = class_addMethod([delegate class], @selector(tableView:didSelectRowAtIndexPath:), sendEventImp, method_getTypeEncoding(sendEventMySelf));
    
    if (didAddMethod) {
        class_replaceMethod([delegate class], @selector(track_tableView:didSelectRowAtIndexPath:), originalEventImp, method_getTypeEncoding(orignialEvent));
    } else {
        trackExchangeMethod([delegate class],
                            @selector(tableView:didSelectRowAtIndexPath:),
                            @selector(track_tableView:didSelectRowAtIndexPath:));
    }
}

- (void)track_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self track_tableView:tableView didSelectRowAtIndexPath:indexPath];
    id sender = [tableView cellForRowAtIndexPath:indexPath];
    NSString *accessibilityIdentifier = [sender accessibilityIdentifier];
    
    if (!accessibilityIdentifier) {
        UBViewNode *targetNode = [UBViewHierarchyDumper retrieveNodeWithSender:sender withHeadNode:[UserBehaviorTracker sharedInstance].headNode];
        if (targetNode) {
            /*发现目标*/
            accessibilityIdentifier = [targetNode.nodeSelf accessibilityIdentifier];
        }
        
    }
    
    if (accessibilityIdentifier.length) {
        dispatch_async([UserBehaviorTracker sharedInstance].codeMakerQueue, ^{
            [[UserBehaviorTracker sharedInstance].codeMaker recordTapActionWithAccessibilityIdentifier:accessibilityIdentifier];
        });
    }

}

@end

#pragma mark--UserBehaviorTracker--
@implementation UserBehaviorTracker


+ (UserBehaviorTracker *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self alloc];
    });
    return sharedInstance;
}

- (dispatch_queue_t)codeMakerQueue{
    if (!_codeMakerQueue) {
        //serial queue
        _codeMakerQueue = dispatch_queue_create("com.codeMake.queue", DISPATCH_QUEUE_SERIAL);
    }
    return _codeMakerQueue;
}

- (void)hook{

    /*所有UIControl、UIBarButtonItem*/
    [UIApplication trackHook];
    
    [UIViewController trackHook];
    
    /*监控系统自带返回按钮*/
    [UINavigationController trackHook];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    /*iOS 9*/
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    [UIAlertView trackHook];
#pragma clang diagnostic pop
    
#endif
    

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_3
    /*iOS 8.3*/
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    [UIActionSheet trackHook];
#pragma clang diagnostic pop
#endif
    
    [UIAlertAction trackHook];
    
    [UITextField trackHook];
    
    [UITableView trackHook];
    
    [UICollectionView trackHook];
    
}

- (void)track_applicationDidFinishLaunching{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self hook];
    });
}

- (void)track_applicationWillResignActive{
    dispatch_async([UserBehaviorTracker sharedInstance].codeMakerQueue, ^{
        [[UserBehaviorTracker sharedInstance].codeMaker stopRecord];
    });
}

#pragma mark--Getters & Setters--

- (TrackingCodeMakerPlugin *)codeMaker{
    if (!_codeMaker) {
        _codeMaker = [TrackingCodeMakerFactory codeMakerPluginWithCodeMaker:nil];
    }
    return _codeMaker;
}

- (NSMutableSet *)accessIdSet{
    if (!_accessIdSet) {
        _accessIdSet = [NSMutableSet set];
    }
    return _accessIdSet;
}
    
@end

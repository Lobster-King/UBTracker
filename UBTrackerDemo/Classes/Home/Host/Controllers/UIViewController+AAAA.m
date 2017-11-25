//
//  UIViewController+AAAA.m
//  UBTracker
//
//  Created by qinzhiwei on 17/11/24.
//  Copyright © 2017年 lobster. All rights reserved.
//

#import "UIViewController+AAAA.h"
#import <objc/runtime.h>

@implementation UIViewController (AAAA)

void trackExchangeMethodTest(Class class, SEL originalSelector, SEL swizzledSelector)
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        trackExchangeMethodTest([self class], @selector(viewDidAppear:), @selector(track_viewDidAppear:));
    });
}


- (void)track_viewDidAppear:(BOOL)animated{
    [self track_viewDidAppear:animated];
    
    
}

@end

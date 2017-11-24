//
//  UBViewHierarchyDumper.m
//  UBTracker
//
//  Created by qinzhiwei on 17/11/22.
//  Copyright © 2017年 lobster. All rights reserved.
//

#import "UBViewHierarchyDumper.h"
#import <UIKit/UIKit.h>
#import "UBNode.h"

@implementation UBViewHierarchyDumper

+ (UBNode *)dumpCurrentViewHierarchy{
    UIApplication *mainApplication = [UIApplication sharedApplication];
    UBNode *headNode = [[UBNode alloc]init];
    headNode.nodeSelf = mainApplication;
    headNode.nodeSuper = nil;
    headNode.nodeContemporarieIndex = 0;
    headNode.nodeDepth = 0;
    headNode.nodeXCType = NSStringFromClass([mainApplication class]);
    
    /*先遍历第一个window，然后递归遍历window的所有子view，依此类推*/
    /*类名和层次为键，索引为值increase*/
    NSMutableDictionary *increaseRecoder = [NSMutableDictionary dictionary];
    for (UIWindow *window in mainApplication.windows) {
        static NSInteger index = 0;
        UBNode *winNode = [[UBNode alloc]init];
        winNode.nodeSelf = window;
        winNode.nodeSuper = headNode;
        winNode.nodeIndex = index;
        winNode.nodeContemporarieIndex = index;
        winNode.nodeDepth = 1;
        winNode.nodeXCType = NSStringFromClass([window class]);
        [headNode.nodeChilds addObject:winNode];
        [self dumpViewRecursiveWithNode:winNode withRecoder:increaseRecoder];
        index++;
    }
    
    return headNode;
}

+ (void)dumpViewRecursiveWithNode:(UBNode *)node withRecoder:(NSMutableDictionary *)recoder{
    /*若node为叶子节点，则退出*/
    if (![node.nodeSelf subviews].count) {
        return;
    }
    
    /*同层次索引控制变量*/
    NSInteger index = 0;
    for (UIView *subview in [node.nodeSelf subviews]) {
        
        /*以类名和层次为键，例：UIView->2*/
        NSString *key = [NSString stringWithFormat:@"%@->%ld",NSStringFromClass([subview class]),node.nodeDepth + 1];
        NSNumber *increaseIndex = [recoder objectForKey:key];
        if (increaseIndex) {
            increaseIndex = @([increaseIndex integerValue] + 1);
        } else{
            increaseIndex = @(0);
        }
        [recoder setValue:increaseIndex forKey:key];
        
        UBNode *childNode = [[UBNode alloc]init];
        childNode.nodeSelf = subview;
        childNode.nodeSuper = node;
        childNode.nodeIndex = index;
        childNode.nodeContemporarieIndex = [increaseIndex integerValue];
        childNode.nodeDepth = node.nodeDepth + 1;
        childNode.nodeXCType = NSStringFromClass([subview class]);
        [node.nodeChilds addObject:childNode];
        [self dumpViewRecursiveWithNode:childNode withRecoder:recoder];
        index ++;
    }
    
}

+ (UBNode *)retrieveNodeWithSender:(id)sender{
    UBNode *headNode = [self dumpCurrentViewHierarchy];
    UBNode *targetNode = nil;
    [self findTargetNodeWithNode:headNode withSender:sender withCusor:&targetNode];
    return targetNode;
}

+ (void)findTargetNodeWithNode:(UBNode *)node withSender:(id)sender withCusor:(UBNode**)cusor{
    
    for (UBNode *subNode in node.nodeChilds) {
        
        if (subNode.nodeSelf == sender) {
            *cusor = subNode;
            break;
        } else{
            [self findTargetNodeWithNode:subNode withSender:sender withCusor:cusor];
        }
    }
}

@end

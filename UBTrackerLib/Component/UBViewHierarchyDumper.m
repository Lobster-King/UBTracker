//
//  UBViewHierarchyDumper.m
//  UBTracker
//
//  Created by qinzhiwei on 17/11/22.
//  Copyright © 2017年 lobster. All rights reserved.
//

#import "UBViewHierarchyDumper.h"
#import <UIKit/UIKit.h>
#import "UBViewNode.h"

@implementation UBViewHierarchyDumper

+ (UBViewNode *)dumpCurrentViewHierarchy{
    UIApplication *mainApplication = [UIApplication sharedApplication];
    UBViewNode *headNode = [[UBViewNode alloc]init];
    headNode.nodeSelf = mainApplication;
    headNode.nodeSuper = nil;
    headNode.nodeIndex = 0;
    headNode.nodeSameIndex = 0;
    headNode.nodeContemporarieIndex = 0;
    headNode.nodeDepth = 0;
    headNode.nodeXCType = NSStringFromClass([mainApplication class]);
    
    /*先遍历第一个window，然后递归遍历window的所有子view，依此类推*/
    /*类名和层次为键，索引为值increase*/
    NSMutableDictionary *increaseRecoder = [NSMutableDictionary dictionary];
    for (UIWindow *window in mainApplication.windows) {
        static NSInteger index = 0;
        UBViewNode *winNode = [[UBViewNode alloc]init];
        winNode.nodeSelf = window;
        winNode.nodeSuper = headNode;
        winNode.nodeIndex = index;
        winNode.nodeSameIndex = index;
        winNode.nodeContemporarieIndex = index;
        winNode.nodeDepth = 1;
        winNode.nodeXCType = NSStringFromClass([window class]);
        [headNode.nodeChilds addObject:winNode];
        [self dumpViewRecursiveWithNode:winNode withRecoder:increaseRecoder];
        index++;
    }
    
    return headNode;
}

+ (void)dumpViewRecursiveWithNode:(UBViewNode *)node withRecoder:(NSMutableDictionary *)recoder{
    /*若node为叶子节点，则退出*/
    if (![node.nodeSelf subviews].count) {
        return;
    }
    
    /*同父节点所在的索引（家中排行）*/
    NSInteger index = 0;
    /*同父节点家中的同性别排行*/
    NSMutableDictionary *increaseSameRecoder = [NSMutableDictionary dictionary];
    for (UIView *subview in [node.nodeSelf subviews]) {
        
        
        /*同父节点中同性别索引，以类名为键*/
        NSString *keySame = NSStringFromClass([subview class]);
        NSNumber *increaseSameIndex = [increaseSameRecoder objectForKey:keySame];
        
        if (increaseSameIndex) {
            increaseSameIndex = @([increaseSameIndex integerValue] + 1);
        } else{
            increaseSameIndex = @(0);
        }
        [increaseSameRecoder setValue:increaseSameIndex forKey:keySame];
        
        /*同族中所有同辈中排行索引，以类名和层次为键，例：UIView->2*/
        NSString *key = [NSString stringWithFormat:@"%@->%ld",NSStringFromClass([subview class]),node.nodeDepth + 1];
        NSNumber *increaseIndex = [recoder objectForKey:key];
        if (increaseIndex) {
            increaseIndex = @([increaseIndex integerValue] + 1);
        } else{
            increaseIndex = @(0);
        }
        [recoder setValue:increaseIndex forKey:key];
        
        UBViewNode *childNode = [[UBViewNode alloc]init];
        childNode.nodeSelf = subview;
        childNode.nodeSuper = node;
        childNode.nodeIndex = index;
        childNode.nodeSameIndex = [increaseSameIndex integerValue];
        childNode.nodeContemporarieIndex = [increaseIndex integerValue];
        childNode.nodeDepth = node.nodeDepth + 1;
        childNode.nodeXCType = NSStringFromClass([subview class]);
        [node.nodeChilds addObject:childNode];
        [self dumpViewRecursiveWithNode:childNode withRecoder:recoder];
        index ++;
    }
    
}

+ (UBViewNode *)retrieveNodeWithSender:(id)sender withHeadNode:(UBViewNode *)headNode{
    if (!headNode) {
        headNode = [self dumpCurrentViewHierarchy];
    }
    UBViewNode *targetNode = nil;
    [self findTargetNodeWithNode:headNode withSender:sender withCusor:&targetNode];
    return targetNode;
}

+ (void)findTargetNodeWithNode:(UBViewNode *)node withSender:(id)sender withCusor:(UBViewNode**)cusor{
    
    for (UBViewNode *subNode in node.nodeChilds) {
        
        if (subNode.nodeSelf == sender) {
            *cusor = subNode;
            break;
        } else{
            [self findTargetNodeWithNode:subNode withSender:sender withCusor:cusor];
        }
    }
}

@end

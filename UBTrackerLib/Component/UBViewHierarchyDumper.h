//
//  UBViewHierarchyDumper.h
//  UBTracker
//
//  Created by qinzhiwei on 17/11/22.
//  Copyright © 2017年 lobster. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UBViewNode;
@interface UBViewHierarchyDumper : NSObject

+ (UBViewNode *)dumpCurrentViewHierarchy;
+ (UBViewNode *)retrieveNodeWithSender:(id)sender withHeadNode:(UBViewNode *)headNode;

@end

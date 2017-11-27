//
//  UBViewHierarchyDumper.h
//  UBTracker
//
//  Created by qinzhiwei on 17/11/22.
//  Copyright © 2017年 lobster. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UBViewNode;
@interface UBViewHierarchyDumper : NSObject

+ (UBViewNode *)dumpCurrentViewHierarchy;
+ (nullable UBViewNode *)retrieveNodeWithSender:(id)sender withHeadNode:(nullable UBViewNode *)headNode;

@end

NS_ASSUME_NONNULL_END

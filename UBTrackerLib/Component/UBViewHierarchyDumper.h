//
//  UBViewHierarchyDumper.h
//  UBTracker
//
//  Created by qinzhiwei on 17/11/22.
//  Copyright © 2017年 lobster. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UBNode;
@interface UBViewHierarchyDumper : NSObject

+ (UBNode *)dumpCurrentViewHierarchy;

+ (UBNode *)retrieveNodeWithSender:(id)sender;

@end

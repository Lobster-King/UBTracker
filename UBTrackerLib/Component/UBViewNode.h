//
//  UBViewNode.h
//  UBTracker
//
//  Created by qinzhiwei on 17/11/22.
//  Copyright © 2017年 lobster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UBViewNode : NSObject

@property (nonatomic, assign, readonly) NSUInteger nodeHash;/*nodeSelf hash值*/
@property (nonatomic, strong) id nodeSelf;/*自己*/
@property (nonatomic, strong) UBViewNode *nodeSuper;/*父节点,为空则为头节点*/
@property (nonatomic, assign) NSInteger nodeIndex;/*同父节点所在的索引（家中排行）*/
@property (nonatomic, assign) NSInteger nodeSameIndex;/*家中同性别排行*/
@property (nonatomic, assign) NSInteger nodeContemporarieIndex;/*所在家族中所有同辈的索引*/
@property (nonatomic, assign) NSInteger nodeDepth;/*节点深度（层次）*/
@property (nonatomic, copy)   NSString *nodeXCType;/*XCUITest框架中对应的Type*/
@property (nonatomic, copy, readonly)   NSString *nodePath;/*头节点到该节点的路径*/
@property (nonatomic, copy, readonly)   NSString *nodeUniquePath;/*唯一路径*/
@property (nonatomic, copy, readonly)   NSString *nodeXPath;/*XPath*/
@property (nonatomic, strong) NSMutableArray <UBViewNode*>*nodeChilds;/*孩子,为空则为尾节点*/

@end

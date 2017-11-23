//
//  UBNode.m
//  UBTracker
//
//  Created by qinzhiwei on 17/11/22.
//  Copyright © 2017年 lobster. All rights reserved.
//

#import "UBNode.h"

@interface UBNode()

@property (nonatomic, assign, readwrite) NSUInteger nodeHash;
@property (nonatomic, copy, readwrite)   NSString *nodeXPath;
@property (nonatomic, copy, readwrite)   NSString *nodePath;

@end

@implementation UBNode

#pragma mark--Life Cycle--
- (instancetype)init{
    if (self = [super init]) {
        _nodeChilds = [NSMutableArray array];
    }
    return self;
}

#pragma mark--Getters & Setters--
- (void)setNodeSelf:(id)nodeSelf{
    _nodeSelf = nodeSelf;
    _nodeHash = [_nodeSelf hash];
}

- (void)setNodeXCType:(NSString *)nodeXCType{
    if (nodeXCType) {
        _nodeXCType = nodeXCType;
    }
    [self setNodeXPathWithXCType];
    
    /*暂取同一个*/
    [self setNodePathWithXCType];
}

- (void)setNodeContemporarieIndex:(NSInteger)nodeContemporarieIndex{
    _nodeContemporarieIndex = nodeContemporarieIndex;
    [self setNodeXPathWithXCType];
}

- (void)setNodeIndex:(NSInteger)nodeIndex{
    _nodeIndex = nodeIndex;
    [self setNodePathWithXCType];
}

- (void)setNodeXPathWithXCType{
    
    if (!_nodeSuper && _nodeSuper.nodeDepth == 0) {
        /*头节点*/
        _nodeXPath = [NSString stringWithFormat:@"//%@",_nodeXCType];
        return;
    }
    
    if (!_nodeXCType || !_nodeSuper) {
        return;
    }
    _nodeXPath = [_nodeSuper.nodeXPath stringByAppendingString:[NSString stringWithFormat:@"/%@[%ld]",_nodeXCType,_nodeContemporarieIndex]];
}

- (void)setNodePathWithXCType{
    
    if (!_nodeSuper && _nodeSuper.nodeDepth == 0) {
        /*头节点*/
        _nodePath = [NSString stringWithFormat:@"%@",_nodeXCType];
        return;
    }
    
    if (!_nodeXCType || !_nodeSuper) {
        return;
    }
    _nodePath = [_nodeSuper.nodePath stringByAppendingString:[NSString stringWithFormat:@">%@[%ld]",_nodeXCType,_nodeIndex]];
    NSLog(@"nodePath_____%@",_nodePath);
}

@end

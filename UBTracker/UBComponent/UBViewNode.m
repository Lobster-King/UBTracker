//
//  UBViewNode.m
//  UBTracker
//
//  Created by qinzhiwei on 17/11/22.
//  Copyright © 2017年 lobster. All rights reserved.
//

#import "UBViewNode.h"
#import <UIKit/UIKit.h>

@interface UBViewNode()

@property (nonatomic, assign, readwrite) NSUInteger nodeHash;
@property (nonatomic, copy, readwrite)   NSString *nodePath;
@property (nonatomic, copy, readwrite)   NSString *nodeUniquePath;
@property (nonatomic, copy, readwrite)   NSString *nodeXPath;

@end

@implementation UBViewNode

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
    
    [self setNodeUniquePathWithXCType];
}

- (void)setNodeContemporarieIndex:(NSInteger)nodeContemporarieIndex{
    _nodeContemporarieIndex = nodeContemporarieIndex;
    [self setNodeXPathWithXCType];
}

- (void)setNodeIndex:(NSInteger)nodeIndex{
    _nodeIndex = nodeIndex;
    [self setNodePathWithXCType];
}

- (void)setNodeSameIndex:(NSInteger)nodeSameIndex{
    _nodeSameIndex = nodeSameIndex;
    [self setNodeUniquePathWithXCType];
    
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

- (void)setNodeUniquePathWithXCType{
    if (!_nodeSuper && _nodeSuper.nodeDepth == 0) {
        /*头节点*/
        _nodeUniquePath = [NSString stringWithFormat:@"%@",_nodeXCType];
        return;
    }
    
    if (!_nodeXCType || !_nodeSuper) {
        return;
    }
    
    _nodeUniquePath = [_nodeSuper.nodeUniquePath stringByAppendingString:[NSString stringWithFormat:@">%@[%ld]",_nodeXCType,_nodeSameIndex]];
    /*同步设置accessibilityIdentifier*/
    [_nodeSelf setAccessibilityIdentifier:_nodeUniquePath];
//    [_nodeSelf setAccessibilityLabel:_nodeUniquePath];
}

@end

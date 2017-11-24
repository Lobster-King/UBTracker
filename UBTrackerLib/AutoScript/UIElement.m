//
//  UIElement.m
//  UBTracker
//
//  Created by qinzhiwei on 2016/10/26.
//  Copyright © 2016年 lobster. All rights reserved.
//

#import "UIElement.h"

@implementation UIElement

- (id)init{
    if (self = [super init]) {
        _timeStamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    }
    return self;
}

@end

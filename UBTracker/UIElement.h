//
//  UIElement.h
//  UBTracker
//
//  Created by qinzhiwei on 2016/10/26.
//  Copyright © 2016年 lobster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIElement : NSObject

@property (nonatomic, strong) id actionSender;
@property (nonatomic, strong) id actionReciever;
@property (nonatomic, assign) SEL action;
@property (nonatomic, strong) UIEvent *event;
@property (nonatomic, copy) NSString *timeStamp;
@property (nonatomic, assign) NSInteger index;
@end

//
//  UserBehaviorTracker.h
//  UBTracker
//
//  Created by qinzhiwei on 2016/10/25.
//  Copyright © 2016年 lobster. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TrackingCodeMakerPlugin;
@interface UserBehaviorTracker : NSObject
@property (nonatomic, strong) dispatch_queue_t codeMakerQueue;
@property (nonatomic, strong) TrackingCodeMakerPlugin *codeMaker;
+ (UserBehaviorTracker *)sharedInstance;
- (void)hook;

@end

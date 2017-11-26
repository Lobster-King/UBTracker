//
//  UIApplication+UBHook.m
//  UBTracker
//
//  Created by qinzhiwei on 17/11/25.
//  Copyright © 2017年 lobster. All rights reserved.
//

#import "UIApplication+UBHook.h"
#import "UserBehaviorTracker.h"

@implementation UIApplication (UBHook)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[UserBehaviorTracker sharedInstance] hook];
        
//        [[NSNotificationCenter defaultCenter]addObserver:[UserBehaviorTracker sharedInstance] selector:@selector(track_applicationDidFinishLaunching) name:UIApplicationDidFinishLaunchingNotification object:nil];

        [[NSNotificationCenter defaultCenter]addObserver:[UserBehaviorTracker sharedInstance] selector:@selector(track_applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
        
    });
}



@end

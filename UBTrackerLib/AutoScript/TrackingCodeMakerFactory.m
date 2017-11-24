//
//  TrackingCodeMakerFactory.m
//  UBTracker
//
//  Created by qinzhiwei on 2016/10/26.
//  Copyright © 2016年 lobster. All rights reserved.
//

#import "TrackingCodeMakerFactory.h"
#import "TrackingCapabilities.h"
#import "TrackingCodeMakerPlugin.h"

@implementation TrackingCodeMakerFactory

+ (TrackingCodeMakerPlugin *)codeMakerPluginWithCodeMaker:(TrackingCapabilities *)capabilities{
    return coderMakerPluginFactory(capabilities == nil?[self defaultCapabilities]:capabilities);
}

static inline TrackingCodeMakerPlugin *coderMakerPluginFactory(TrackingCapabilities *capabilities){
    if ([capabilities.appiumLanguage isEqualToString: @"Ruby"]) {
        return [[NSClassFromString(@"TrackingCodeMakerRubyPlugin") alloc]initCodeMakerPluginWith:capabilities];
    }
    return nil;
}

+ (TrackingCapabilities *)defaultCapabilities{
    TrackingCapabilities *capabilities = [TrackingCapabilities new];
    capabilities.appiumVersion = @"1.7.1";
    capabilities.platformName  = @"iOS";
    capabilities.platformVersion = @"9.3";
    capabilities.deviceName    = @"iPhone 6s";
    capabilities.app           = @"/Users/lobster/Desktop/appium_test/ElongTrain.app";
    capabilities.serverAddress = @"127.0.0.1";
    capabilities.serverPort    = @"4723";
    capabilities.appiumLanguage= @"Ruby";
    capabilities.autoAcceptAlerts = @"true";
    capabilities.showIOSLog    = @"false";
    capabilities.waitTime      = @"10";
    return capabilities;
}

@end

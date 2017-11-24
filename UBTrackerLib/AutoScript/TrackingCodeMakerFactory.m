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
#import "TrackingCodeMakerRubyPlugin.h"

@implementation TrackingCodeMakerFactory

+ (TrackingCodeMakerPlugin *)codeMakerPluginWithCodeMaker:(TrackingCapabilities *)capabilities{
    return coderMakerPluginFactory(capabilities == nil?[self defaultCapabilities]:capabilities);
}

static inline TrackingCodeMakerPlugin *coderMakerPluginFactory(TrackingCapabilities *capabilities){
    if ([capabilities.appiumLanguage isEqualToString: @"Ruby"]) {
        Class rubyClass =  NSClassFromString(@"TrackingCodeMakerRubyPlugin");
        TrackingCodeMakerPlugin *plugin = [[rubyClass alloc]initCodeMakerPluginWith:capabilities];
        [plugin startRecord];
        return plugin;
    }
    return nil;
}

+ (TrackingCapabilities *)defaultCapabilities{
    TrackingCapabilities *capabilities = [TrackingCapabilities new];
    capabilities.appiumVersion = @"1.7.1";
    capabilities.platformName  = @"iOS";
    capabilities.platformVersion = @"9.3";
    capabilities.deviceName    = @"iPhone 6s";
    capabilities.app           = @"/Users/lobster/Desktop/UBTrackerDemo.app";
    capabilities.serverAddress = @"127.0.0.1";
    capabilities.serverPort    = @"4723";
    capabilities.appiumLanguage= @"Ruby";
    capabilities.autoAcceptAlerts = @"true";
    capabilities.showIOSLog    = @"false";
    capabilities.waitTime      = @"10";
    capabilities.automationName= @"XCUITest";
    return capabilities;
}

@end

//
//  TrackingCodeMakerRubyPlugin.m
//  UBTracker
//
//  Created by qinzhiwei on 2016/10/26.
//  Copyright © 2016年 lobster. All rights reserved.
//

#import "TrackingCodeMakerRubyPlugin.h"
#import "TrackingCapabilities.h"

@implementation TrackingCodeMakerRubyPlugin

- (void)preBoilerplateCode{
    NSString *code = [NSString stringWithFormat:@"\n#User Behavior Tracking Demo.Rquire Appium Version(%@)#\n\nrequire 'rubygems'\n\
require 'appium_lib'\
\n\ caps = {}\n\
caps[\"platformName\"] = \"%@\"\n\
caps[\"platformVersion\"] = \"%@\"\n\
caps[\"deviceName\"] = \"%@\"\n\
caps[\"automationName\"] = \"%@\"\n\
caps[\"app\"] = \"%@\"\n ", self.capabilities.appiumVersion,self.capabilities.platformName,self.capabilities.platformVersion,self.capabilities.deviceName,self.capabilities.automationName,self.capabilities.app];
    
    code = [code stringByAppendingFormat:@"\n\
\n\
opts = {\n\
\tsauce_username = nil,\n\
\tserver_url = \"http://%@:%@/wd/hub\"\n\
}\n\
driver = Appium::Driver.new({caps: caps, appium_lib: opts}).start_driver\n\
\n", self.capabilities.serverAddress, self.capabilities.serverPort];
    
    [[NSFileManager defaultManager] removeItemAtPath:self.scriptPath error:nil];
    [self writeToFileWithCode:code];
}

- (void)startRecord{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self preBoilerplateCode];
    });
}
    
- (void)stopRecord{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self postBoilerplateCode];
    });
}

- (void)postBoilerplateCode
{
    NSString *code = @"\ndriver_quit\n";
    [self writeToFileWithCode:code];
}

- (void)recordTapActionWithElement:(UIElement *)element{
//    NSString *code = [self.hierarchyViewer behaviorTimelineWithElement:element];
    NSString *code = nil;
//    if ([element.actionSender isKindOfClass:[UITableViewCell class]]) {
//        NSString *targetCode = [NSString stringWithFormat:@"#class->%@ sel->%@ to->%@#\nwait_true(%@) {exists{find_element(:xpath, \"%@\").click}}\n",[element.actionSender class],NSStringFromSelector(element.action),[element.actionReciever description],self.capabilities.waitTime,code];
//        [self writeToFileWithCode:targetCode];
        return;
//    }
    
//    NSString *targetCode = [NSString stringWithFormat:@"#title->%@ sel->%@ to->%@#\nwait_true(%@) {exists{find_element(:xpath, \"%@\").click}}\n",[((UIButton *)element.actionSender) respondsToSelector:@selector(currentTitle)]?((UIButton *)element.actionSender).currentTitle:@"",NSStringFromSelector(element.action),[element.actionReciever description],self.capabilities.waitTime,code];

//    [self writeToFileWithCode:targetCode];
}

@end

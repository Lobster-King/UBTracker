//
//  TrackingCodeMakerRubyPlugin.m
//  UBTracker
//
//  Created by qinzhiwei on 2016/10/26.
//  Copyright © 2016年 lobster. All rights reserved.
//

#import "TrackingCodeMakerRubyPlugin.h"
#import "TrackingCapabilities.h"
#import "UIElement.h"

@implementation TrackingCodeMakerRubyPlugin

- (void)preBoilerplateCode{
    NSString *code = [NSString stringWithFormat:@"\n#User Behavior Tracking Demo Version#\n\nrequire 'rubygems'\n\
require 'appium_lib'\
\n\
capabilities = {\n\
\t'appium-version'=>'%@',\n\
\t'platformName'=>'%@',\n\
\t'platformVersion'=>'%@',\n\
\t'showIOSLog'=>'%@',\n\
\t'autoAcceptAlerts'=>'%@',\n", self.capabilities.appiumVersion,self.capabilities.platformName,self.capabilities.platformVersion,self.capabilities.showIOSLog,self.capabilities.autoAcceptAlerts];
    
    if ([self.capabilities.deviceName length] > 0){
        code = [code stringByAppendingFormat:@"\t'deviceName'=>'%@',\n", self.capabilities.deviceName];
    }
    if ([self.capabilities.app length] > 0){
        code = [code stringByAppendingFormat:@"\t'app'=>'%@'\n", self.capabilities.app];
    }
    code = [code stringByAppendingFormat:@"}\n\
\n\
server_url = \"http://%@:%@/wd/hub\"\n\
\n\
Appium::Driver.new(caps: capabilities).start_driver\n\
Appium.promote_appium_methods Object\n\
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
    if ([element.actionSender isKindOfClass:[UITableViewCell class]]) {
        NSString *targetCode = [NSString stringWithFormat:@"#class->%@ sel->%@ to->%@#\nwait_true(%@) {exists{find_element(:xpath, \"%@\").click}}\n",[element.actionSender class],NSStringFromSelector(element.action),[element.actionReciever description],self.capabilities.waitTime,code];
        [self writeToFileWithCode:targetCode];
        return;
    }
    
    NSString *targetCode = [NSString stringWithFormat:@"#title->%@ sel->%@ to->%@#\nwait_true(%@) {exists{find_element(:xpath, \"%@\").click}}\n",[((UIButton *)element.actionSender) respondsToSelector:@selector(currentTitle)]?((UIButton *)element.actionSender).currentTitle:@"",NSStringFromSelector(element.action),[element.actionReciever description],self.capabilities.waitTime,code];
    
    [self writeToFileWithCode:targetCode];
}

@end

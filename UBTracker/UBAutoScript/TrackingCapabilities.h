//
//  TrackingCapabilities.h
//  UBTracker
//
//  Created by qinzhiwei on 2016/10/26.
//  Copyright © 2016年 lobster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackingCapabilities : NSObject
@property (nonatomic, copy) NSString *appiumVersion;/*appium version 1.0*/
@property (nonatomic, copy) NSString *platformName;/*iOS*/
@property (nonatomic, copy) NSString *platformVersion;/*9.3,10.x will be supported soon*/
@property (nonatomic, copy) NSString *deviceName;/*iPhone 6s ..*/
@property (nonatomic, copy) NSString *app;/*app path*/
@property (nonatomic, copy) NSString *serverAddress;/*127.0.0.1 default*/
@property (nonatomic, copy) NSString *serverPort;/*4723 default*/
@property (nonatomic, copy) NSString *appiumLanguage;/*language,Ruby default*/
@property (nonatomic, copy) NSString *autoAcceptAlerts;/*false default*/
@property (nonatomic, assign) NSInteger interKeyDelay;/*click delay*/
@property (nonatomic, copy) NSString *showIOSLog;/*false default*/
@property (nonatomic, copy) NSString *waitTime;/*find element timeout,10s default*/
@property (nonatomic, copy) NSString *automationName;/*XCUITest default*/

@end

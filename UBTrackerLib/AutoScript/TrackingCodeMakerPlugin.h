//
//  TrackingCodeMakerPlugin.h
//  UBTracker
//
//  Created by qinzhiwei on 2016/10/26.
//  Copyright © 2016年 lobster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrackingCodeMakerFactory.h"

@class TrackingCapabilities;

@interface TrackingCodeMakerPlugin : NSObject

@property (nonatomic, readonly, strong)TrackingCapabilities *capabilities;
@property (nonatomic, copy) NSString *scriptPath;
@property (nonatomic, assign) NSInteger tapIndex;
@property (nonatomic, assign) NSInteger swapIndex;

- (instancetype)initCodeMakerPluginWith:(TrackingCapabilities *)capabilities;
- (void)recordTapActionWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier;
- (void)writeToFileWithCode:(NSString *)code;
- (void)startRecord;
- (void)stopRecord;

@end

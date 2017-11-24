//
//  TrackingCodeMakerPlugin.h
//  UBTracker
//
//  Created by qinzhiwei on 2016/10/26.
//  Copyright © 2016年 lobster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrackingCodeMakerFactory.h"
//#import "HierarchyViewer.h"

@class TrackingCapabilities;
@class UIElement;

@interface TrackingCodeMakerPlugin : NSObject
@property (nonatomic, readonly, strong)TrackingCapabilities *capabilities;
@property (nonatomic, copy) NSString *scriptPath;
//@property (nonatomic, strong) HierarchyViewer *hierarchyViewer;

- (instancetype)initCodeMakerPluginWith:(TrackingCapabilities *)capabilities;
- (void)recordTapActionWithElement:(UIElement *)element;
- (void)writeToFileWithCode:(NSString *)code;
- (void)startRecord;
- (void)stopRecord;
@end

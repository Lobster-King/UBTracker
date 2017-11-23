//
//  TrackingCodeMakerFactory.h
//  UBTracker
//
//  Created by qinzhiwei on 2016/10/26.
//  Copyright © 2016年 lobster. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TrackingCodeMakerPlugin;
@class TrackingCapabilities;

@interface TrackingCodeMakerFactory : NSObject

+ (TrackingCodeMakerPlugin *)codeMakerPluginWithCodeMaker:(TrackingCapabilities *)capabilities;

@end

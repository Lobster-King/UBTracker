//
//  TrackingCodeMakerPlugin.m
//  UBTracker
//
//  Created by qinzhiwei on 2016/10/26.
//  Copyright © 2016年 lobster. All rights reserved.
//

#import "TrackingCodeMakerPlugin.h"
#import "TrackingCapabilities.h"

@implementation TrackingCodeMakerPlugin

- (instancetype)initCodeMakerPluginWith:(TrackingCapabilities *)capabilities{
    if (self = [super init]) {
        _capabilities = capabilities;
    }
    return self;
}

- (instancetype)init{
    return [self initCodeMakerPluginWith:nil];
}

- (void)recordTapActionWithElement:(UIElement *)element{
    
}

- (void)startRecord{
    
}

- (void)stopRecord{
    
}

- (void)writeToFileWithCode:(NSString *)code{
    if (!code) {
        return;
    }
    
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.scriptPath]) {
        [code writeToFile:self.scriptPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    }else{
        NSString *originCode = [NSString stringWithContentsOfFile:self.scriptPath encoding:NSUTF8StringEncoding error:nil];
        originCode = [originCode stringByAppendingString:code];
        [originCode writeToFile:self.scriptPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    }
}

#pragma mark--Getters & Setters--

- (NSString *)scriptPath{
    if (!_scriptPath) {
        NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
        NSString *documentDirectory = [directoryPaths objectAtIndex:0];
        _scriptPath = [documentDirectory stringByAppendingPathComponent:@"scriptCode.rb"];
        NSLog(@"scriptCode.rb:%@",_scriptPath);
    }
    return _scriptPath;
}

//- (HierarchyViewer *)hierarchyViewer{
//    if (!_hierarchyViewer) {
//        _hierarchyViewer = [HierarchyViewer new];
//    }
//    return _hierarchyViewer;
//}

@end

//
//  ScreenOrientationMonitor.h
//  屏幕旋转测试
//
//  Created by Jack on 16/11/10.
//  Copyright © 2016年 Zhang Qingjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ScreenOrientationMonitorProtocol <NSObject>

- (void)didChangeScreenOrientation:(UIDeviceOrientation)orientation;

@end

@interface ScreenOrientationMonitor : NSObject

@property (nonatomic, weak) id <ScreenOrientationMonitorProtocol> delegate;

+ (instancetype)sharedMonitor;
- (void)startMonitor;
- (void)stopMonitor;

@end

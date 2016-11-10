//
//  ScreenOrientationMonitor.m
//  屏幕旋转测试
//
//  Created by Jack on 16/11/10.
//  Copyright © 2016年 Zhang Qingjie. All rights reserved.
//

#import "ScreenOrientationMonitor.h"
#import <CoreMotion/CoreMotion.h>

@interface ScreenOrientationMonitor()

@property (nonatomic, assign) NSTimeInterval updateInterval;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, assign) double acceleration_x;
@property (nonatomic, assign) double acceleration_y;

@end

@implementation ScreenOrientationMonitor

+ (instancetype)sharedMonitor {
    static ScreenOrientationMonitor *monitor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        monitor = [[ScreenOrientationMonitor alloc] init];
        monitor.updateInterval = 1.0 / 15.0;
        monitor.motionManager = [[CMMotionManager alloc] init];
    });
    return monitor;
}

- (void)startMonitor {
    // 屏幕旋转监听
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOrientationNotification) name:UIDeviceOrientationDidChangeNotification object:nil];
    // 加速计监听
    if ([self.motionManager isDeviceMotionAvailable]) {
        [self.motionManager setDeviceMotionUpdateInterval:self.updateInterval];
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            self.acceleration_x = motion.gravity.x;
            self.acceleration_y = motion.gravity.y;
        }];
    }
}

- (void)stopMonitor {
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    if ([self.motionManager isDeviceMotionAvailable]) {
        [self.motionManager stopDeviceMotionUpdates];
    }
}

- (void)changeOrientationNotification {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    switch (orientation) {
        case UIDeviceOrientationPortrait: {
            if (self.acceleration_y < -0.5 && (fabs(self.acceleration_y) - fabs(self.acceleration_x) >= 0.4)) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeScreenOrientation:)]) {
                    [self.delegate didChangeScreenOrientation:UIDeviceOrientationPortrait];
                }
            }
            break;
        }
        case UIDeviceOrientationLandscapeLeft: {
            if (self.acceleration_x < -0.5 && (fabs(self.acceleration_x) - fabs(self.acceleration_y) >= 0.4)) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeScreenOrientation:)]) {
                    [self.delegate didChangeScreenOrientation:UIDeviceOrientationLandscapeLeft];
                }
            }
            break;
        }
        case UIDeviceOrientationLandscapeRight: {
            if (self.acceleration_x > 0.5 && (fabs(self.acceleration_x) - fabs(self.acceleration_y) >= 0.4)) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeScreenOrientation:)]) {
                    [self.delegate didChangeScreenOrientation:UIDeviceOrientationLandscapeRight];
                }
            }
            break;
        }

        default:
            break;
    }
}

@end

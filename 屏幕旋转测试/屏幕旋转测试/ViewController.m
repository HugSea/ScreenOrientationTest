//
//  ViewController.m
//  屏幕旋转测试
//
//  Created by Jack on 16/11/10.
//  Copyright © 2016年 Zhang Qingjie. All rights reserved.
//

#import "ViewController.h"
#import "ScreenOrientationMonitor.h"

@interface ViewController () <ScreenOrientationMonitorProtocol>

@property (weak, nonatomic) IBOutlet UILabel *directionLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [ScreenOrientationMonitor sharedMonitor].delegate = self;
    [[ScreenOrientationMonitor sharedMonitor] startMonitor];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[ScreenOrientationMonitor sharedMonitor] stopMonitor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didChangeScreenOrientation:(UIDeviceOrientation)orientation {
    switch (orientation) {
        case UIDeviceOrientationPortrait: {
            self.directionLabel.text = @"Portrait";
            break;
        }
        case UIDeviceOrientationLandscapeLeft: {
            self.directionLabel.text = @"Left";
            break;
        }
        case UIDeviceOrientationLandscapeRight: {
            self.directionLabel.text = @"Right";
            break;
        }

        default:
            break;
    }
}


@end

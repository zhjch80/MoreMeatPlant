//
//  RMCustomNavController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/13.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMCustomNavController.h"

@interface RMCustomNavController ()
@property (nonatomic, assign) BOOL isCanRotate;

@end

@implementation RMCustomNavController
@synthesize isCanRotate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isCustomNavCanRotate {
    return isCanRotate;
}

- (void)setIsCustomNavCanRotate:(BOOL)isCustomNavCanRotate {
    isCanRotate = isCustomNavCanRotate;
}

#pragma mark - 设备方向

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIDeviceOrientationIsLandscape(toInterfaceOrientation);
}

- (BOOL)shouldAutorotate {
    return isCanRotate;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape | UIInterfaceOrientationMaskPortrait;
}

@end

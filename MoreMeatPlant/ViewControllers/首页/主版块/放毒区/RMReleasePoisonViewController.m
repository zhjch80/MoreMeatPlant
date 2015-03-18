//
//  RMReleasePoisonViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMReleasePoisonViewController.h"
#import "RMReleasePoisonLeftViewController.h"
#import "RMReleasePoisonCenterViewController.h"

#define kSlideWidth     180

@interface RMReleasePoisonViewController (){
    BOOL isLeftOpen;
}
@property (nonatomic, strong) RMReleasePoisonLeftViewController * leftCtl;
@property (nonatomic, strong) RMReleasePoisonCenterViewController * centerCtl;

@end

@implementation RMReleasePoisonViewController
@synthesize leftCtl, centerCtl;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    leftCtl = [[RMReleasePoisonLeftViewController alloc] init];
    leftCtl.PoisonDelegate = self;
    centerCtl = [[RMReleasePoisonCenterViewController alloc] init];
    centerCtl.PoisonDelegate = self;
    centerCtl.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:centerCtl.view];
    centerCtl.view.tag = 2;
    centerCtl.view.frame = self.view.bounds;
    
    [self.view addSubview:leftCtl.view];
    leftCtl.view.tag = 1;
    leftCtl.view.frame = self.view.bounds;
    
    
    [self.view bringSubviewToFront:centerCtl.view];
    
    UISwipeGestureRecognizer * swipRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipGesture:)];
    [swipRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [centerCtl.view addGestureRecognizer:swipRight];
    
    UISwipeGestureRecognizer * swipLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipGesture:)];
    [swipLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [centerCtl.view addGestureRecognizer:swipLeft];
    
}

- (void)swipGesture:(UISwipeGestureRecognizer *)swip {
    CALayer * layer = [centerCtl.view layer];
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(1, 1);
    layer.shadowOpacity = 1;
    layer.shadowRadius = 20.0;
    
    if (swip.direction == UISwipeGestureRecognizerDirectionRight) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDidStopSelector:@selector(stopRightAnimation)];
        [UIView setAnimationDelegate:self];
        
        isLeftOpen = YES;
        centerCtl.enabledGesture.numberOfTapsRequired = 1;
        
        if (centerCtl.view.frame.origin.x == self.view.frame.origin.x || centerCtl.view.frame.origin.x == -kSlideWidth){
            [centerCtl.view setFrame:CGRectMake(centerCtl.view.frame.origin.x + kSlideWidth, centerCtl.view.frame.origin.y, centerCtl.view.frame.size.width, centerCtl.view.frame.size.height)];
        }
        [UIView commitAnimations];
    }
    
    if (swip.direction == UISwipeGestureRecognizerDirectionLeft) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDidStopSelector:@selector(stopLeftAnimation)];
        [UIView setAnimationDelegate:self];

        isLeftOpen = NO;
        centerCtl.enabledGesture.numberOfTapsRequired = 100;

        if (centerCtl.view.frame.origin.x == kSlideWidth){
            [centerCtl.view setFrame:CGRectMake(centerCtl.view.frame.origin.x - kSlideWidth, centerCtl.view.frame.origin.y, centerCtl.view.frame.size.width, centerCtl.view.frame.size.height)];
        }
        [UIView commitAnimations];
    }
}

- (void)stopLeftAnimation {
    [leftCtl.view setHidden:YES];
}

- (void)stopRightAnimation {
    [leftCtl.view setHidden:NO];
}

- (void)updateSlideSwitchState {
    if (isLeftOpen){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDidStopSelector:@selector(stopLeftAnimation)];
        isLeftOpen = NO;
        centerCtl.enabledGesture.numberOfTapsRequired = 100;

        if (centerCtl.view.frame.origin.x == kSlideWidth){
            [centerCtl.view setFrame:CGRectMake(centerCtl.view.frame.origin.x - kSlideWidth, centerCtl.view.frame.origin.y, centerCtl.view.frame.size.width, centerCtl.view.frame.size.height)];
        }
        [UIView commitAnimations];
    }else{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDidStopSelector:@selector(stopRightAnimation)];
        isLeftOpen = YES;
        centerCtl.enabledGesture.numberOfTapsRequired = 1;

        if (centerCtl.view.frame.origin.x == self.view.frame.origin.x || centerCtl.view.frame.origin.x == -kSlideWidth){
            [centerCtl.view setFrame:CGRectMake(centerCtl.view.frame.origin.x + kSlideWidth, centerCtl.view.frame.origin.y, centerCtl.view.frame.size.width, centerCtl.view.frame.size.height)];
        }
        [UIView commitAnimations];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

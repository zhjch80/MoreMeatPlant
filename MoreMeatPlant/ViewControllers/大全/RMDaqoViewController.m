//
//  RMDaqoViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/13.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMDaqoViewController.h"
#import "RMDaqoCenterViewController.h"
#import "RMDaqoRightViewController.h"
#import "RMSlideParameter.h"
#import "AppDelegate.h"
@interface RMDaqoViewController (){
    BOOL isLeftOpen;
    BOOL isFirstViewDidAppear;
}
@property (nonatomic, strong) RMDaqoCenterViewController * centerCtl;
@property (nonatomic, strong) RMDaqoRightViewController * rightCtl;

@end

@implementation RMDaqoViewController
@synthesize centerCtl, rightCtl;



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate * dele = [[UIApplication sharedApplication] delegate];
    [dele queryInfoNumber];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!isFirstViewDidAppear){
        [centerCtl requestDataWithPageCount:1 withPlantType:@"" withGrow:@""];
        [centerCtl requestPlantSubjects];
        [centerCtl requestDaqoAllCounts];
        [rightCtl requestPlantSubs];
        isFirstViewDidAppear = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    rightCtl = [[RMDaqoRightViewController alloc] init];
    rightCtl.DaqoDelegate = self;
    
    centerCtl = [[RMDaqoCenterViewController alloc] init];
    centerCtl.DaqoDelegate = self;
    centerCtl.view.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.62 alpha:1];

    [self.view addSubview:centerCtl.view];
    centerCtl.view.tag = 2;
    centerCtl.view.frame = self.view.bounds;
    
    [self.view addSubview:rightCtl.view];
    rightCtl.view.tag = 1;
    rightCtl.view.frame = self.view.bounds;
    
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
    
    if (swip.direction == UISwipeGestureRecognizerDirectionLeft) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDidStopSelector:@selector(stopRightAnimation)];
        [UIView setAnimationDuration:0.1];
        [UIView setAnimationDelegate:self];
        
        isLeftOpen = YES;
        centerCtl.recognizerView.hidden = NO;
        
        if (centerCtl.view.frame.origin.x == self.view.frame.origin.x || centerCtl.view.frame.origin.x == -kSlideWidth){
            [centerCtl.view setFrame:CGRectMake(centerCtl.view.frame.origin.x - kSlideWidth, centerCtl.view.frame.origin.y, centerCtl.view.frame.size.width, centerCtl.view.frame.size.height)];
        }
        [UIView commitAnimations];
    }
    
    if (swip.direction == UISwipeGestureRecognizerDirectionRight) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDidStopSelector:@selector(stopLeftAnimation)];
        [UIView setAnimationDuration:0.1];
        [UIView setAnimationDelegate:self];
        
        isLeftOpen = NO;
        centerCtl.recognizerView.hidden = YES;
        
        if (centerCtl.view.frame.origin.x == kSlideWidth){
            [centerCtl.view setFrame:CGRectMake(centerCtl.view.frame.origin.x + kSlideWidth, centerCtl.view.frame.origin.y, centerCtl.view.frame.size.width, centerCtl.view.frame.size.height)];
        }
        [UIView commitAnimations];
    }
}

- (void)stopLeftAnimation {
    [rightCtl.view setHidden:YES];
}

- (void)stopRightAnimation {
    [rightCtl.view setHidden:NO];
}

- (void)updateSlideSwitchState {
    if (isLeftOpen){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDidStopSelector:@selector(stopLeftAnimation)];
        [UIView setAnimationDuration:0.1];
        [UIView setAnimationDelegate:self];
        
        isLeftOpen = NO;
        centerCtl.recognizerView.hidden = YES;
        
        if (centerCtl.view.frame.origin.x == -kSlideWidth){
            [centerCtl.view setFrame:CGRectMake(centerCtl.view.frame.origin.x + kSlideWidth, centerCtl.view.frame.origin.y, centerCtl.view.frame.size.width, centerCtl.view.frame.size.height)];
        }
        [UIView commitAnimations];
    }else{
        CALayer * layer = [centerCtl.view layer];
        layer.shadowColor = [UIColor blackColor].CGColor;
        layer.shadowOffset = CGSizeMake(1, 1);
        layer.shadowOpacity = 1;
        layer.shadowRadius = 20.0;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDidStopSelector:@selector(stopRightAnimation)];
        [UIView setAnimationDuration:0.1];
        [UIView setAnimationDelegate:self];
        
        isLeftOpen = YES;
        centerCtl.recognizerView.hidden = NO;
        
        if (centerCtl.view.frame.origin.x == self.view.frame.origin.x || centerCtl.view.frame.origin.x == kSlideWidth){
            [centerCtl.view setFrame:CGRectMake(centerCtl.view.frame.origin.x - kSlideWidth, centerCtl.view.frame.origin.y, centerCtl.view.frame.size.width, centerCtl.view.frame.size.height)];
        }
        [UIView commitAnimations];
    }
}

- (void)updataSlideStateClose {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDidStopSelector:@selector(stopLeftAnimation)];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:self];
    
    isLeftOpen = NO;
    centerCtl.recognizerView.hidden = YES;
    
    if (centerCtl.view.frame.origin.x == -kSlideWidth){
        [centerCtl.view setFrame:CGRectMake(centerCtl.view.frame.origin.x + kSlideWidth, centerCtl.view.frame.origin.y, centerCtl.view.frame.size.width, centerCtl.view.frame.size.height)];
    }
    [UIView commitAnimations];
}

- (void)updateCenterListWithModel:(RMPublicModel *)model withRow:(NSInteger)row {
    [centerCtl updateCurrentList:model withRow:row];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

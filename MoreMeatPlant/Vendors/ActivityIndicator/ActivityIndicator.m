//
//  ActivityIndicator.m
//  Si Gema
//
//  Created by 易龙天 on 13-7-17.
//  Copyright (c) 2013年 易龙天. All rights reserved.
//

#import "ActivityIndicator.h"
#import "ActivityIndictButton.h"
#define ReLabelX 80

@interface ActivityIndicator ()
@property (assign,nonatomic) CGRect Sframe;
@property (nonatomic,retain) UIView * bgView;
@property (nonatomic,retain) UILabel * _refeshSpLabel;
@property (nonatomic,retain) UIActivityIndicatorView * refreshSpinner;
@property (nonatomic,retain) ActivityIndictButton * abnormalButton;

@property (nonatomic,retain) UIView * refreshSpinnerView;
@end


@implementation ActivityIndicator
@synthesize refreshSpinner;
@synthesize _refeshSpLabel;
@synthesize abnormalButton;
@synthesize delegate;
@synthesize refreshSpinnerView;
@synthesize bgView;

- (void)dealloc
{

}


- (void)setIndicatorType:(ActivityIndicatorType)indicatorType
{
    if(indicatorType == ActivityIndicatorDefault)
    {
        bgView.backgroundColor = [UIColor whiteColor];
        //            bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
    }
    else
    {
        bgView.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark - 初始化方法
- (id)initWithFrame:(CGRect)frame LabelText:(NSString *)Ltext withdelegate:(id)dele withType:(ActivityIndicatorType)type andAction:(SEL)action
{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.Sframe = frame;
        
              
        self.backgroundColor =[UIColor clearColor];
        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        [self addSubview:bgView];
       
        self.indicatorType = type;
        
//        _svprogress = [[SVProgressHUD alloc]initWithFrame:bgView.frame];
        
        
        abnormalButton = [ActivityIndictButton buttonWithType:UIButtonTypeCustom];
        abnormalButton.frame = CGRectMake(0, 0, 90, 90);
        abnormalButton.center = CGPointMake(bgView.frame.size.width/2,bgView.frame.size.height/2);
        [abnormalButton addTarget:dele action:action forControlEvents:UIControlEventTouchDown];
        [self addSubview:abnormalButton];
        
        refreshSpinnerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ReLabelX, 80)];
        refreshSpinnerView.backgroundColor = [UIColor blackColor];
        refreshSpinnerView.backgroundColor = [refreshSpinnerView.backgroundColor colorWithAlphaComponent:0.7];
        refreshSpinnerView.layer.cornerRadius = 10;
        [self addSubview:refreshSpinnerView];
        
        refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        refreshSpinner.frame = CGRectMake(0, 0, 40, 40);
        refreshSpinner.hidesWhenStopped = YES;
        [refreshSpinnerView addSubview:refreshSpinner];
        
        //
        _refeshSpLabel = [[UILabel alloc] initWithFrame:CGRectMake(refreshSpinner.frame.size.width , refreshSpinner.frame.origin.y+20, 80, 30)];
        _refeshSpLabel.text = Ltext;
        CGSize size = CGSizeMake(100, 30);
        size = [_refeshSpLabel.text sizeWithFont:_refeshSpLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
        _refeshSpLabel.frame = CGRectMake(_refeshSpLabel.frame.origin.x, _refeshSpLabel.frame.origin.y, size.width, size.height);
        _refeshSpLabel.backgroundColor = [UIColor clearColor];
        _refeshSpLabel.textAlignment = NSTextAlignmentCenter;
        _refeshSpLabel.textColor = [UIColor lightGrayColor];
        _refeshSpLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [refreshSpinnerView addSubview:_refeshSpLabel];
        refreshSpinnerView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        refreshSpinner.center = CGPointMake(refreshSpinnerView.frame.size.width/2, 30);
        _refeshSpLabel.center = CGPointMake(refreshSpinnerView.frame.size.width/2, refreshSpinnerView.frame.size.height-_refeshSpLabel.frame.size.height);
        NSLog(@"views = %@",self.subviews);
        self.hidden = YES;
    }
    return self;
}

- (void)tap:(id )tap
{
}

- (void)startAnimatingActivit{
    self.hidden = NO;
    [refreshSpinner startAnimating];
    [_refeshSpLabel setHidden:NO];
//    [_svprogress showWithStatus:@"请稍后" maskType:SVProgressHUDMaskTypeNone networkIndicator:NO];
    abnormalButton.hidden = YES;
    refreshSpinnerView.hidden = NO;
    self.hidden = NO;

}

- (void)stopAnimationgActivit{
    [refreshSpinner stopAnimating];
    [_refeshSpLabel setHidden:YES];
    refreshSpinnerView.hidden = YES;
}
-(void)addImage:(UIImage *)image
{
    [abnormalButton setImage:image forState:UIControlStateNormal];
}
-(void)LoadSuccess
{
    [self stopAnimationgActivit];
//    [_svprogress dismiss];
    self.hidden = YES;
}
-(void)LoadFailed
{
    refreshSpinnerView.hidden = YES;
    abnormalButton.hidden = NO;
    abnormalButton.enabled = YES;
//    [_svprogress dismiss];
    [self addImage:[UIImage imageNamed:@"base_empty_view"]];
}
- (void)abnormalButtonShow:(UIImage *)image text:(NSString *)text
{
    refreshSpinnerView.hidden = YES;
    abnormalButton.hidden = NO;
    abnormalButton.frame = CGRectMake(0, 0, kScreenWidth/2.5, kScreenHeight/2.5);
    abnormalButton.center = CGPointMake(self.Sframe.size.width/2, self.Sframe.size.height/2);
    [abnormalButton setImage:image forState:UIControlStateNormal];
    
//    [abnormalButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [abnormalButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateSelected];
    abnormalButton.imageView.contentMode = UIViewContentModeScaleToFill;
    [abnormalButton setTitle:text forState:UIControlStateNormal];
    [abnormalButton layoutSubviews];
}

- (void)NoResults
{
    refreshSpinnerView.hidden = YES;
    abnormalButton.hidden = NO;
    abnormalButton.frame = CGRectMake(0, 0, 200, 200);
    abnormalButton.center = CGPointMake(kScreenWidth/2, (kScreenHeight-64)/2);
//    [self addImage:[UIImage imageNamed:@"kong2"]];
//    [_svprogress dismiss];
    abnormalButton.enabled = NO;
}

- (void)activityHidden
{
    [self stopAnimationgActivit];
//    [_svprogress dismiss];
    self.hidden = YES;
}
- (void)changeBgFrame:(CGRect)rect
{
    //CGRectMake(0, 45, 320, self.bgView.frame.size.height-45)
    self.frame = rect;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end

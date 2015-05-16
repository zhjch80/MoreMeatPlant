//
//  BBRGuideViewController.h
//  BuyBuyring
//
//  Created by 颜沛贤 on 14-2-15.
//  Copyright (c) 2014年 易龙天. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface BBRGuideViewController : UIViewController<UIScrollViewDelegate>
{
    UIImageView *imageView;
    UIButton *beginButton;
}

@property (strong,nonatomic) UIScrollView *scrollView;
@property (retain,nonatomic) UIPageControl * pageControl;

@end

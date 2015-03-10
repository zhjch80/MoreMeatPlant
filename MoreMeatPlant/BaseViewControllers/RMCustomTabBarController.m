//
//  CustomTabBarController.m
//  自定义UITabBarController
//
//  Created by 严明俊 on 13-6-9.
//  Copyright (c) 2013年 严明俊. All rights reserved.
//

#import "RMCustomTabBarController.h"
#import "CONST.h"

@interface RMCustomTabBarController ()
{
    NSInteger viewControllerCount;
}

@end

@implementation RMCustomTabBarController
@synthesize tabbarHeight;
@synthesize isTabbarHidden;
@synthesize TabarItemWidth;
@synthesize selectDelegate = _selectDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBar.hidden = YES;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.tabBar.hidden = YES;
    }
    return self;
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    [super setViewControllers:viewControllers];
    
    viewControllerCount = [viewControllers count];
    
    CGFloat height = 0.f;
    if (self.isInDeck)
        if(isIOS7)
            height = kScreenHeight - tabbarHeight;
        else
            height = kScreenHeight - tabbarHeight - 20.f;
        else
            height = kScreenHeight - tabbarHeight;
    
    UIImageView * bgTabImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, height, self.view.frame.size.width, tabbarHeight)];
    bgTabImg.image = LOADIMAGE(@"bottom", kImageTypePNG);
    bgTabImg.userInteractionEnabled = YES;
    bgTabImg.multipleTouchEnabled = YES;
    [self.view addSubview:bgTabImg];
    
    CGRect frame = CGRectMake(0, height, self.view.frame.size.width, tabbarHeight);
    _myTabbarView = [[UIScrollView alloc] initWithFrame:frame];
    _myTabbarView.showsHorizontalScrollIndicator = NO;
    _myTabbarView.showsVerticalScrollIndicator = NO;
    _myTabbarView.bounces = NO;
    _myTabbarView.backgroundColor = [UIColor clearColor];
    _myTabbarView.pagingEnabled = YES;
    _myTabbarView.contentSize = CGSizeMake(viewControllerCount*self.TabarItemWidth, tabbarHeight);
    
    for (int i = 0; i != viewControllerCount; ++i) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(self.TabarItemWidth * i, 0, self.TabarItemWidth, tabbarHeight);
        button.tag = i;
        button.adjustsImageWhenHighlighted = NO;
        [button addTarget:self action:@selector(tabbarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_myTabbarView addSubview:button];
        
    }
    [self.view addSubview:_myTabbarView];
}

- (UIButton *)customTabbarItemWithIndex:(NSInteger)index
{
    UIButton *button = (UIButton *)[_myTabbarView.subviews objectAtIndex:index];
    return button;
}

- (void)clickButtonWithIndex:(NSInteger)index
{
    UIButton *button = [self customTabbarItemWithIndex:index];
    [self tabbarButtonClicked:button];
}

- (void)setTabbarHidden:(BOOL)isHidden animated:(BOOL)animated
{
    if (isHidden)
    {
        if (self.isTabbarHidden)
            return;
        
        CGRect frame = _myTabbarView.frame;
        frame.origin.y += self.tabbarHeight;
        if (animated)
        {
            [UIView animateWithDuration:0.3f animations:^{
                _myTabbarView.frame = frame;
            }];
        }
        else
            _myTabbarView.frame = frame;
        self.isTabbarHidden = YES;
    }
    else
    {
        if (!self.isTabbarHidden)
            return;
        
        CGRect frame = _myTabbarView.frame;
        frame.origin.y -= self.tabbarHeight;
        if (animated)
        {
            [UIView animateWithDuration:0.3f animations:^{
                _myTabbarView.frame = frame;
            }];
        }
        else
            _myTabbarView.frame = frame;
        self.isTabbarHidden = NO;
    }
}

- (void)tabbarButtonClicked:(id)sender {
    NSArray * unselectedImageArr;
    NSArray * selectedImageArr;
    
//    if (IS_IPHONE_6_SCREEN){
//        unselectedImageArr = [NSArray arrayWithObjects:@"home_unselected_6", @"ranking_unselected_6", @"myChannel_unselected_6", @"setUp_unselected_6", nil];
//        selectedImageArr = [NSArray arrayWithObjects:@"home_selected_6", @"ranking_selected_6", @"myChannel_selected_6", @"setUp_selected_6", nil];
//        
//    }else if (IS_IPHONE_6p_SCREEN){
//        unselectedImageArr = [NSArray arrayWithObjects:@"home_unselected_6p", @"ranking_unselected_6p", @"myChannel_unselected_6p", @"setUp_unselected_6p", nil];
//        selectedImageArr = [NSArray arrayWithObjects:@"home_selected_6p", @"ranking_selected_6p", @"myChannel_selected_6p", @"setUp_selected_6p", nil];
//    }else{
        unselectedImageArr = [NSArray arrayWithObjects:@"img_34", @"img_36", @"imgg_36", @"img_40", nil];
        selectedImageArr = [NSArray arrayWithObjects:@"imgg_38", @"imgd_38", @"img_38", @"imgd_40", nil];
//    }
    
    UIButton *selectedButton = (UIButton *)sender;
    [selectedButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[selectedImageArr objectAtIndex:selectedButton.tag]]] forState:UIControlStateNormal];
    
    if (self.selectDelegate) {
        [self.selectDelegate selctTabbarItemWithIndex:selectedButton.tag];
        return;
    }
    [self setSelectedIndex:selectedButton.tag];
    
    for (UIButton *button in _myTabbarView.subviews) {
        if (button == selectedButton){
            button.selected = YES;
        }else{
            button.selected = NO;
        }
        
        if (button.tag != selectedButton.tag){
            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[unselectedImageArr objectAtIndex:button.tag]]] forState:UIControlStateNormal];
        }
    }
    
    if(viewControllerCount>4){
        if(selectedButton.tag*self.TabarItemWidth+self.TabarItemWidth >= kScreenWidth&&_myTabbarView.contentOffset.x==0){
            
            [UIView animateWithDuration:0.5f animations:^{
                _myTabbarView.contentOffset = CGPointMake((viewControllerCount-(kScreenWidth/self.TabarItemWidth))*self.TabarItemWidth, 0);
            }];
        }else if(selectedButton.tag == (viewControllerCount-(kScreenWidth/self.TabarItemWidth))&&_myTabbarView.contentOffset.x>0){
            
            [UIView animateWithDuration:0.5f animations:^{
                _myTabbarView.contentOffset = CGPointMake(0, 0);
            }];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  RMEditContentViewController.m
//  MoreMeatPlant
//
//  Created by mobei on 15/4/23.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMEditContentViewController.h"
#import "RMBaseTextField.h"
#import "UITextField+LimitLength.h"

@interface RMEditContentViewController ()<UITextFieldDelegate> {
    BOOL isCancel;
    
}
@property (nonatomic, strong) RMBaseTextField * titleText;

@end

@implementation RMEditContentViewController
@synthesize titleText, mTitle, sectionTag, rowTag, text;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    titleText.text = text;
    [titleText becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [titleText resignFirstResponder];

    if (isCancel){
        if ([self.delegate respondsToSelector:@selector(getEditContent:withSectionTag:withRowTag:)]){
            [self.delegate getEditContent:text withSectionTag:sectionTag withRowTag:rowTag];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(getEditContent:withSectionTag:withRowTag:)]){
            [self.delegate getEditContent:titleText.text withSectionTag:sectionTag withRowTag:rowTag];
        }
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[RMEditContentViewController class]];
    
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[RMEditContentViewController class]];
    
    [self setCustomNavBackgroundColor:[UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1] withStatusViewBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    [self setCustomNavTitle:[NSString stringWithFormat:@"%@",mTitle]];
    [self setRightBarButtonNumber:1];
    
    [leftBarButton setTitle:@"取消" forState:UIControlStateNormal];
    leftBarButton.frame = CGRectMake(10, 0, 50, 44);
    [leftBarButton setTitleColor:[UIColor colorWithRed:0 green:0.62 blue:0.59 alpha:1] forState:UIControlStateNormal];
    [rightOneBarButton setTitle:@"添加" forState:UIControlStateNormal];
    rightOneBarButton.frame = CGRectMake(kScreenWidth - 60, 0, 50, 44);
    [rightOneBarButton setTitleColor:[UIColor colorWithRed:0 green:0.62 blue:0.59 alpha:1] forState:UIControlStateNormal];
    
    titleText = [[RMBaseTextField alloc] init];
    titleText.frame = CGRectMake(0, 70,  kScreenWidth, 30);
    titleText.placeholder = @"请填写标题";
    titleText.font = FONT_1(14.0);
    titleText.keyboardType = UIKeyboardTypeDefault;
    titleText.delegate = self;
    [titleText limitTextLength:20];
    [self.view addSubview:titleText];
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    switch (sender.tag) {
        case 1:{
            isCancel = YES;
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case 2:{
            if (titleText.text.length == 0){
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"亲，写点内容吧" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alert show];
                return ;
            }
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

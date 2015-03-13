//
//  RMStartPostingViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/13.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMStartPostingViewController.h"
#import "RMStartPostingHeaderView.h"
#import "UITextField+LimitLength.h"

#define kMaxLength 18

@interface RMStartPostingViewController ()<UITextFieldDelegate,StartPostingHeaderDelegate>{
    BOOL isShow;
}
@property (nonatomic, strong) RMStartPostingHeaderView * headerView;
@property (nonatomic, strong) UIButton * dragBtn;

@end

@implementation RMStartPostingViewController
@synthesize headerView, dragBtn;

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.mTextField resignFirstResponder];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];

    [self.mTextField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self hideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    
    [self loadHeaderView];
    
    [self.mTextField limitTextLength:kMaxLength];
    [self.mTextField setValue:[UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [[UITextField appearance] setTintColor:[UIColor colorWithRed:0 green:0.67 blue:0.65 alpha:1]];
    [[UITextView appearance] setTintColor:[UIColor colorWithRed:0 green:0.67 blue:0.65 alpha:1]];

    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignResponder)];
    [self.mScrollView addGestureRecognizer:gesture];

}

- (void)loadHeaderView {
    headerView = [[[NSBundle mainBundle] loadNibNamed:@"RMStartPostingHeaderView" owner:nil options:nil] objectAtIndex:0];
    headerView.delegate = self;
    [self.view addSubview:headerView];
}

- (void)headerNavMethodWithTag:(NSInteger)tag {
    switch (tag) {
        case 1:{
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case 2:{
            NSLog(@"发布");
            break;
        }
            
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.mTextField resignFirstResponder];
    return  YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }else{
        return YES;
    }
}

- (void)keyboardWillShow:(NSNotification *)noti {
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.mTextView.frame = CGRectMake(0, 37, kScreenWidth, kScreenHeight - 37 - 64 - size.height);
}

- (void)keyboardDidShow:(NSNotification *)noti {
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
}

- (void)keyboardWillHide:(NSNotification *)noti {
    self.mTextView.frame = CGRectMake(0, 37, kScreenWidth, kScreenHeight - 37 - 64);
}

- (void)keyboardDidHide:(NSNotification *)noti {
}

- (void)resignResponder{
    [self.mTextField resignFirstResponder];
    [self.mTextView resignFirstResponder];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.mTextField resignFirstResponder];
    [self.mTextView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

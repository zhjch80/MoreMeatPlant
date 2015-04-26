//
//  RMEditContentViewController.m
//  MoreMeatPlant
//
//  Created by mobei on 15/4/23.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMEditContentViewController.h"
#import "RMBaseTextField.h"
#import "RMBaseTextView.h"
#import "UITextField+LimitLength.h"

@interface RMEditContentViewController ()<UITextFieldDelegate,UITextViewDelegate> {
    BOOL isCancel;
    
}
@property (nonatomic, strong) RMBaseTextField * titleText;
@property (nonatomic, strong) RMBaseTextView * textView;
@property (nonatomic, strong) UIView * bgView;

@end

@implementation RMEditContentViewController
@synthesize titleText, textView, mTitle, sectionTag, rowTag, text, bgView, operationCellRow, operationType, operationStr;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    if ([self.mTitle isEqualToString:@"标题"]){
        titleText.text = text;
        [titleText becomeFirstResponder];
    }else{
        textView.text = text;
        [textView becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [titleText resignFirstResponder];
    [textView resignFirstResponder];
    
    if (isCancel){
        if ([self.mTitle isEqualToString:@"标题"]){
            if ([self.delegate respondsToSelector:@selector(getEditContent:withSectionTag:withRowTag:withOperationType:withOperationCellRow:)]){
                [self.delegate getEditContent:text withSectionTag:sectionTag withRowTag:rowTag withOperationType:@"取消" withOperationCellRow:operationCellRow];
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(getEditContent:withSectionTag:withRowTag:withOperationType:withOperationCellRow:)]){
                [self.delegate getEditContent:text withSectionTag:sectionTag withRowTag:rowTag withOperationType:@"取消" withOperationCellRow:operationCellRow];
            }
        }
    }else{
        if ([self.mTitle isEqualToString:@"标题"]){
            if ([self.delegate respondsToSelector:@selector(getEditContent:withSectionTag:withRowTag:withOperationType:withOperationCellRow:)]){
                [self.delegate getEditContent:titleText.text withSectionTag:sectionTag withRowTag:rowTag withOperationType:operationType withOperationCellRow:operationCellRow];
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(getEditContent:withSectionTag:withRowTag:withOperationType:withOperationCellRow:)]){
                [self.delegate getEditContent:textView.text withSectionTag:sectionTag withRowTag:rowTag withOperationType:operationType withOperationCellRow:operationCellRow];
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];

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
    [rightOneBarButton setTitle:operationStr forState:UIControlStateNormal];
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
    
    bgView = [[UIView alloc] init];
    bgView.userInteractionEnabled = YES;
    bgView.frame = CGRectMake(5, 70, kScreenWidth - 10, 0);
    bgView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [bgView.layer setCornerRadius:5];
    bgView.layer.borderWidth = 1.0;
    [self.view addSubview:bgView];
    
    textView = [[RMBaseTextView alloc] init];
    textView.frame = CGRectMake(5, 70, kScreenWidth - 10, 0);
    textView.keyboardType = UIKeyboardTypeDefault;
    textView.backgroundColor = [UIColor clearColor];
    textView.font = FONT_1(14.0);
    textView.delegate = self;
    [self.view addSubview:textView];
    
    if ([self.mTitle isEqualToString:@"标题"]){
        textView.hidden = YES;
        bgView.hidden = YES;
    }else{
        titleText.hidden = YES;
    }
}

- (void)keyboardWillShow:(NSNotification *)noti {
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    textView.frame = CGRectMake(5, 70, kScreenWidth - 10, kScreenHeight - size.height - 75);
    bgView.frame = CGRectMake(5, 70, kScreenWidth - 10, kScreenHeight - size.height - 75);

}

- (void)keyboardWillHide:(NSNotification *)noti {
    
}

- (void)keyboardDidShow:(NSNotification *)noti {
    
}

- (void)keyboardDidHide:(NSNotification *)noti {
    
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    switch (sender.tag) {
        case 1:{
            isCancel = YES;
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case 2:{
            if ([self.mTitle isEqualToString:@"标题"]) {
                if (titleText.text.length == 0){
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"亲，写点内容吧" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                    [alert show];
                    return ;
                }
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                if (textView.text.length == 0){
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"亲，写点内容吧" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                    [alert show];
                    return ;
                }
                [self dismissViewControllerAnimated:YES completion:nil];
            }
   
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

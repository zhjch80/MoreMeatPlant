//
//  RMAddressEditViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/11.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"
#import "RMBaseTextField.h"
#import "RMBaseTextView.h"

@protocol RMAddressEditViewCompletedDelegate <NSObject>

- (void)RMAddressEditViewCompleted;

@end
typedef void (^RMAddressEditViewCompleted)(void);
@interface RMAddressEditViewController : RMBaseViewController
@property (retain, nonatomic) NSString * auto_id;
@property (weak, nonatomic) IBOutlet RMBaseTextField *content_name;
@property (weak, nonatomic) IBOutlet RMBaseTextField *content_mobile;
@property (weak, nonatomic) IBOutlet RMBaseTextView *content_detail;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (retain, nonatomic) RMPublicModel * _model;
@property (copy, nonatomic) RMAddressEditViewCompleted completedCallback;
@property (assign, nonatomic) id <RMAddressEditViewCompletedDelegate> delegate;
@end

//
//  RMOrderReturnEditView.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/4/9.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMPublicModel.h"
@interface RMOrderReturnEditView : UIView
@property (weak, nonatomic) IBOutlet UITextField *expressName;
@property (weak, nonatomic) IBOutlet UITextField *express_price;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (retain, nonatomic) RMPublicModel * _model;//用于申请退货/发货
@property (retain, nonatomic) NSDictionary * _proDic;

@property (weak, nonatomic) IBOutlet UILabel *content_mobile;
@property (weak, nonatomic) IBOutlet UILabel *content_name;
@property (weak, nonatomic) IBOutlet UILabel *content_address;
@end

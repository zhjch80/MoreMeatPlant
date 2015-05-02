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
@property (weak, nonatomic) IBOutlet UIButton *seeBtn;
@property (retain, nonatomic) RMPublicModel * _model;

@end

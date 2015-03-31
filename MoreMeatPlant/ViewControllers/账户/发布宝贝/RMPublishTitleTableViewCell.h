//
//  RMPublishTitleTableViewCell.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/19.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMBaseTextField.h"
#import "RMBaseTextView.h"
@interface RMPublishTitleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet RMBaseTextField *titleTextfield;
@property (weak, nonatomic) IBOutlet RMBaseTextView *content_descField;
@property (weak, nonatomic) IBOutlet RMBaseTextField *content_price;
@property (weak, nonatomic) IBOutlet UIButton *select_shunf;
@property (weak, nonatomic) IBOutlet UIButton *selectQt;
@property (weak, nonatomic) IBOutlet RMBaseTextField *qt_nameField;
@property (weak, nonatomic) IBOutlet RMBaseTextField *qt_priceField;

@end

//
//  RMPublishNumberTableViewCell.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/19.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMBaseTextField.h"
@interface RMPublishNumberTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet RMBaseTextField *numTextfield;
@property (weak, nonatomic) IBOutlet UIImageView *bottom_line;

@end

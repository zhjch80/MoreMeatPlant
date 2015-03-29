//
//  RMBaseTextField.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/13.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMBaseTextField : UITextField
@property (nonatomic, strong) UIColor *placeHolderColor;
@property (nonatomic, strong) UILabel *customerLeftView;
@property (assign, nonatomic) CGFloat offset_top;//距离顶部的偏移
@end

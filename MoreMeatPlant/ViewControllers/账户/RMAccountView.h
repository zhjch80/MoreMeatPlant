//
//  RMAccountView.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/2/26.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RMAccountView;
typedef void (^AccountViewCallBack)(RMAccountView * view);

@interface RMAccountView : UIView

@property (retain, nonatomic) UIImageView * imgV;
@property (retain, nonatomic) UILabel * titleL;
@property (assign, nonatomic) NSInteger tag;
@property (copy  , nonatomic) AccountViewCallBack call_back;
@end

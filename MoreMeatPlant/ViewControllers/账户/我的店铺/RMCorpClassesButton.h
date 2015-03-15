//
//  RMCorpClassesButton.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/15.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RMCorpClassesButton;

typedef void (^RMCorpClassesButtonCallBack) (RMCorpClassesButton * sender);

@interface RMCorpClassesButton : UIButton
@property (retain, nonatomic) UILabel * numberL;
@property (retain, nonatomic) UILabel * classesNameL;
@property (copy, nonatomic) RMCorpClassesButtonCallBack callback;
@end

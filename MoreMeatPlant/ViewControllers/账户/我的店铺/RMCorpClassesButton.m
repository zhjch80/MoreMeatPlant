//
//  RMCorpClassesButton.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/15.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMCorpClassesButton.h"
@implementation RMCorpClassesButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initPlat];
        [self addAction];
    }
    return self;
}


- (void)initPlat{
//    _numberL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
//    _numberL.text = @"1200";
//    _numberL.textAlignment = NSTextAlignmentCenter;
//    
//    _classesNameL = [[UILabel alloc]initWithFrame:CGRectMake(0, _numberL.frame.size.height+_numberL.frame.origin.y, _numberL.frame.size.width, _numberL.frame.size.height)];
//    _classesNameL.textAlignment = NSTextAlignmentCenter;
//    _classesNameL.text = @"全部宝贝";
    
    _classesNameL = [[UILabel alloc]initWithFrame:CGRectMake(0, _numberL.frame.size.height+_numberL.frame.origin.y, self.frame.size.width, 20)];
    _classesNameL.textAlignment = NSTextAlignmentCenter;
    _classesNameL.center = CGPointMake(_classesNameL.center.x, self.frame.size.height/2);
    _classesNameL.text = @"全部宝贝";
    
    [self addSubview:_numberL];
    [self addSubview:_classesNameL];
}

- (void)addAction{
    _numberL.userInteractionEnabled = NO;
    _classesNameL.userInteractionEnabled = NO;
    [self addTarget:self action:@selector(didSelectBtn:) forControlEvents:UIControlEventTouchDown];
    
}
- (void)didSelectBtn:(UIButton *)sender{
    if(self.callback){
        _callback(self);
    }
}

@end

//
//  RMAccountView.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/2/26.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMAccountView.h"

#define distance 6.f
#define left_distance 15.f

@implementation RMAccountView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame])
    {
        [self layoutViews];
        [self addTarget];
    }
    return self;
}

- (void)layoutViews
{
    self.layer.cornerRadius = 5;
    _imgV = [[UIImageView alloc]initWithFrame:CGRectMake(distance, distance, self.frame.size.height-distance*2, self.frame.size.height-distance*2)];
    _imgV.backgroundColor = [UIColor redColor];
    self.backgroundColor = [UIColor blackColor];
    
    
    _titleL = [[UILabel alloc]initWithFrame:CGRectMake(_imgV.frame.origin.x+_imgV.frame.size.width+distance, distance, self.frame.size.width-(_imgV.frame.origin.x+_imgV.frame.size.width+distance), self.frame.size.height-distance*2)];
    _titleL.numberOfLines = 2;
    _titleL.text = @"等待\n开放";
    _titleL.font = [UIFont boldSystemFontOfSize:14];
    _titleL.adjustsFontSizeToFitWidth = YES;
    _titleL.textColor = [UIColor whiteColor];
    
    [self addSubview:_imgV];
    [self addSubview:_titleL];
}
- (void)addTarget
{
    _imgV.userInteractionEnabled = YES;
    _titleL.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    
}
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if(self.call_back)
    {
        _call_back(self);
    }
}

@end

//
//  RMOrderReturnEditView.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/4/9.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMOrderReturnEditView.h"

@implementation RMOrderReturnEditView
@synthesize _model;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (id)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        _model = [[RMPublicModel alloc]init];
        
        _bottom_line.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"heidian", @"png")];

        _bottom_line1.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"heidian", @"png")];

    }
    return self;
}


@end

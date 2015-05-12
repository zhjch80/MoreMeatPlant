//
//  RMSectionFooterTableViewCell.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/31.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMSectionFooterTableViewCell.h"

@implementation RMSectionFooterTableViewCell
- (void)awakeFromNib{
    _bottom_line.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"heidian", @"png")];
    
    _surePublish.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"red_btn", @"png")];
    _surePublish.layer.cornerRadius = 5;
    _surePublish.clipsToBounds = YES;
}
@end

//
//  RMPublishPhotoTableViewCell.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/19.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMPublishPhotoTableViewCell.h"

@implementation RMPublishPhotoTableViewCell

- (void)awakeFromNib {
    // Initialization code

    _camera1.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"hei_btn", @"png")];
    _camera1.layer.cornerRadius = 5;
    _camera1.clipsToBounds = YES;
    
    _camera2.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"hei_btn", @"png")];
    _camera2.layer.cornerRadius = 5;
    _camera2.clipsToBounds = YES;
    
    _camera3.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"hei_btn", @"png")];
    _camera3.layer.cornerRadius = 5;
    _camera3.clipsToBounds = YES;
    
    _camera4.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"hei_btn", @"png")];
    _camera4.layer.cornerRadius = 5;
    _camera4.clipsToBounds = YES;
    
    _camera5.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"hei_btn", @"png")];
    _camera5.layer.cornerRadius = 5;
    _camera5.clipsToBounds = YES;
    
    _picSelect1.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"hei_btn", @"png")];
    _picSelect1.layer.cornerRadius = 5;
    _picSelect1.clipsToBounds = YES;
    
    _picSelect2.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"hei_btn", @"png")];
    _picSelect2.layer.cornerRadius = 5;
    _picSelect2.clipsToBounds = YES;
    
    _picSelect3.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"hei_btn", @"png")];
    _picSelect3.layer.cornerRadius = 5;
    _picSelect3.clipsToBounds = YES;
    
    _picSelect4.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"hei_btn", @"png")];
    _picSelect4.layer.cornerRadius = 5;
    _picSelect4.clipsToBounds = YES;
    
    _picSelect5.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"hei_btn", @"png")];
    _picSelect5.layer.cornerRadius = 5;
    _picSelect5.clipsToBounds = YES;
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

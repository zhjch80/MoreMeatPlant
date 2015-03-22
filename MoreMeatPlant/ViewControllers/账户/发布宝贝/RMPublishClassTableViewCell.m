//
//  RMPublishClassTableViewCell.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/19.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMPublishClassTableViewCell.h"
#import "NSString+Addtion.h"
#import "CONST.h"
@implementation RMPublishClassTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews{
    
    CGFloat x = 10;
    CGFloat y = 31;
    for(NSString * title in self.titles){
        CGSize size = [title getcontentsizeWithfont:FONT_0(13) constrainedtosize:CGSizeMake(100, 20) linemode:NSLineBreakByCharWrapping];
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"fbbb_no_select"] forState:UIControlStateNormal];
        if(x+20+size.width+10*2>kScreenWidth){
            y+=20+5;
            x = 10;
        }
        btn.frame = CGRectMake(x, y, 20, 20);
        [self.contentView addSubview:btn];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(btn.frame.origin.x+btn.frame.size.width+10, y, size.width, size.height)];
        label.center = CGPointMake(label.center.x, btn.center.y);
        label.font = FONT_0(13);
        label.text = title;
        [self.contentView addSubview:label];
        
        x+= 10+20+size.width+10;
                                                            
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

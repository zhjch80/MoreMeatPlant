//
//  ActivityIndictButton.m
//  ilpUser
//
//  Created by elongtian on 14-11-17.
//  Copyright (c) 2014年 madongkai. All rights reserved.
//

#import "ActivityIndictButton.h"

@implementation ActivityIndictButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)layoutSubviews {
    [super layoutSubviews];
    
    // Center image
    CGRect imgFrame = CGRectMake(0, 0, self.frame.size.width-40, self.frame.size.height-40);
    self.imageView.frame = imgFrame;
    
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width/2;
    center.y = self.imageView.frame.size.height/2;
    
    self.imageView.center = center;
    
    //Center text
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = self.imageView.frame.size.height;
    newFrame.size.width = self.frame.size.width;
    newFrame.size.height = self.frame.size.height-self.imageView.frame.size.height;
    
    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = UIColorFromRGB(0xc8c8c8);
}
@end

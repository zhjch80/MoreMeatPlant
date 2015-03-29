//
//  UIView+Expland.m
//  ilpUser
//
//  Created by elongtian on 14-10-8.
//  Copyright (c) 2014年 madongkai. All rights reserved.
//

#import "UIView+Expland.h"

@implementation UIView (Expland)
- (void)drawCorner:(UIRectCorner)rectconer
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectconer cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
@end

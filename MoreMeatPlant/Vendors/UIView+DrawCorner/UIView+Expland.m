//
//  UIView+Expland.m
//  ilpUser
//
//  Created by elongtian on 14-10-8.
//  Copyright (c) 2014年 madongkai. All rights reserved.
//

#import "UIView+Expland.h"

@implementation UIView (Expland)
- (void)drawCorner:(UIRectCorner)rectconer withFrame:(CGRect)frame
{
    NSLog(@"%@",[NSValue valueWithCGRect:frame]);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:rectconer cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = frame;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
@end

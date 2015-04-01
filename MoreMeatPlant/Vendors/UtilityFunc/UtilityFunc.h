//
//  UtilityFunc.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/4/1.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UtilityFunc : NSObject
+ (CGSize)boundingRectWithSize:(CGSize)size
                          font:(UIFont *)font
                          text:(NSString *)text;

@end

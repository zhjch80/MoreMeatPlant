//
//  UtilityFunc.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/4/1.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "UtilityFunc.h"

@implementation UtilityFunc

+ (CGSize)boundingRectWithSize:(CGSize)size
                          font:(UIFont *)font
                          text:(NSString *)text {
    CGSize resultSize;
    //    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
    //        resultSize = [text sizeWithFont:font
    //                      constrainedToSize:size
    //                          lineBreakMode:NSLineBreakByTruncatingTail];
    //    } else {
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGRect rect = [text boundingRectWithSize:size
                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                  attributes:attrs
                                     context:nil];
    resultSize = rect.size;
    resultSize = CGSizeMake(ceil(resultSize.width), ceil(resultSize.height));
    //    }
    return resultSize;
}

@end

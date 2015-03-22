//
//  NSString+Addtion.h
//  ilpUser
//
//  Created by elongtian on 14-6-5.
//  Copyright (c) 2014年 madongkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Addtion)
/*
 根据字符串的长度、字体大小来自适应获取字符串占用的控件大小
 */
- (CGSize)getcontentsizeWithfont:(UIFont *)font constrainedtosize:(CGSize)std_size linemode:(NSLineBreakMode)lineBreakMode;
/*
 url加密处理，将参数根据key来排序，然后将value根据key的顺序进行md5加密，最后将md5的字符串尾追在url链接之后
 */
- (NSString *)urlmd5operation;

+(NSString *)changeFloat:(NSString *)stringFloat;

@end

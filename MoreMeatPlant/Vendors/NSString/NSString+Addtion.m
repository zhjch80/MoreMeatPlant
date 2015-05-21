//
//  NSString+Addtion.m
//  ilpUser
//
//  Created by elongtian on 14-6-5.
//  Copyright (c) 2014年 madongkai. All rights reserved.
//

#import "NSString+Addtion.h"
#import "FileMangerObject.h"
@implementation NSString (Addtion)
- (CGSize)getcontentsizeWithfont:(UIFont *)font constrainedtosize:(CGSize)std_size linemode:(NSLineBreakMode)lineBreakMode
{
    CGSize size = CGSizeZero;
    if(self == nil || self.length == 0)
    {
        return size;
    }
    if([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)] == YES)
    {
        size = [self boundingRectWithSize:std_size options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

        size = [self sizeWithFont:font constrainedToSize:std_size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return size;
}


- (NSString *)urlmd5operation
{
    NSRange range = [self rangeOfString:@"?"];
    NSString * parameter = [self substringFromIndex:range.location+range.length];
    NSArray * parameters = [parameter componentsSeparatedByString:@"&"];
    NSMutableArray * keys = [[NSMutableArray alloc]init];
    NSMutableArray * values = [[NSMutableArray alloc]init];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    for(NSString * str in parameters)
    {
        NSRange equlrange  = [str rangeOfString:@"="];
        [dic setObject:[str substringFromIndex:equlrange.location+equlrange.length] forKey:[str substringToIndex:equlrange.location]];
    }
    NSLog(@"%@",dic);
    //排序
    keys = [NSMutableArray arrayWithArray:[dic allKeys]];
    NSArray *changedkeys = [keys sortedArrayUsingComparator:
                       
                       ^NSComparisonResult(NSString *obj1, NSString *obj2) {
                           NSComparisonResult result = [obj1 compare:obj2];
                           
                           return result;  
       
                       }];
    
    for(NSString * key in changedkeys)
    {
        [values addObject:[dic objectForKey:key]];
    }
    
    NSString * str = [values componentsJoinedByString:@""];
    NSString * md5str = [FileMangerObject md5:str];
    
    NSLog(@"%@",values);
    return [self stringByAppendingFormat:@"&md5=%@",md5str];
    
}

+(NSString *)changeFloat:(NSString *)stringFloat
{
//    return stringFloat;
    const char *floatChars = [stringFloat UTF8String];
    NSUInteger length = [stringFloat length];
    NSUInteger zeroLength = 0;
    if([stringFloat rangeOfString:@"."].location == NSNotFound)
    {
        return stringFloat;
    }
    int i = (int)length-1;
    NSLog(@"%c",floatChars[length]);
    if(floatChars[length] != '0')
    {
        return stringFloat;
    }
    for(; i>=0; i--)
    {
        if(floatChars[i] == '0'/*0x30*/) {
            zeroLength++;
        } else {
            if(floatChars[i] == '.')
                i--;
            break;
        }
    }
    NSString *returnString;
    if(i == -1) {
        returnString = @"0";
    } else {
        returnString = [stringFloat substringToIndex:i];
    }
    return returnString;
}

@end

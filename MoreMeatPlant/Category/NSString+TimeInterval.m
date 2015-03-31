//
//  NSString+TimeInterval.m
//  WxbClient
//
//  Created by RainStone on 13-7-17.
//  Copyright (c) 2013年 Run Mobile. All rights reserved.
//

#import "NSString+TimeInterval.h"

@implementation NSString (TimeInterval)

- (NSString*)intervalSinceNow {
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:self];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    
    if(cha < 0)
    {
        timeString = [NSString stringWithFormat:@"1分钟前"];
    }
    
    if(cha >=0 && cha/60 < 1){
        timeString = [NSString stringWithFormat:@"%.0f",cha];
        
        timeString = [NSString stringWithFormat:@"%@秒前",timeString];
    }
    
    if (cha/3600<1 && cha/60 >= 1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        
    }
    if (cha/3600>1 && cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    if (cha/86400>1 && cha/86400<30)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
        
    }
    
    if(cha/86400 >= 30)
    {
        NSArray* array = [self componentsSeparatedByString:@" "];
        if([array count] > 0)
        {
            timeString = [array objectAtIndex:0];
        }
    }
    return timeString;
}
@end

//
//  NSString+TransformToDate.m
//  project
//
//  Created by Lau RainStone on 12-11-21.
//
//

#import "NSString+TransformToDate.h"

@implementation NSString (TransformToDate)
- (NSDate*)toDate {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* date = [dateFormatter dateFromString:self];
    return date;
}

- (NSDate*)toDateTime {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date = [dateFormatter dateFromString:self];
    return date;
}
@end

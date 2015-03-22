//
//  FileMangerObject.m
//  JingRuiApp
//
//  Created by 易龙天 on 13-12-17.
//  Copyright (c) 2013年 易龙天. All rights reserved.
//

#import "FileMangerObject.h"
#import <CommonCrypto/CommonDigest.h>
@implementation FileMangerObject
+(NSString *)md5:(NSString *)str {
    if (![str isEqualToString:@""] ) {
        const char *cStr = [str UTF8String];
        unsigned char result[32];
        if(str == nil)
            return nil;
        CC_MD5(cStr, strlen(cStr), result );
        return [NSString stringWithFormat:
                @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                result[0], result[1], result[2], result[3],
                result[4], result[5], result[6], result[7],
                result[8], result[9], result[10], result[11],
                result[12], result[13], result[14], result[15]
                ];
    }else{
        return @"";
    }
    
}@end

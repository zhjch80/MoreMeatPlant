//
//  ELHttpRequestOperation.h
//  ElongtianRequest
//
//  Created by elongtian on 14-5-22.
//  Copyright (c) 2014年 elongtian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface RMHttpOperationShared : AFHTTPRequestOperationManager

+ (instancetype)sharedClient;

@end

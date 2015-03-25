//
//  ELHttpRequestOperation.m
//  ElongtianRequest
//
//  Created by elongtian on 14-5-22.
//  Copyright (c) 2014年 elongtian. All rights reserved.
//

#import "RMHttpOperationShared.h"

@implementation RMHttpOperationShared

+ (instancetype)sharedClient {
    static RMHttpOperationShared *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [RMHttpOperationShared manager];
        [_sharedClient setResponseSerializer:[AFJSONResponseSerializer serializer]];
//        [[_sharedClient responseSerializer] setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
        _sharedClient.responseSerializer.acceptableContentTypes = [_sharedClient.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
        _sharedClient.requestSerializer.timeoutInterval = 15;//超时
    });
    
    return _sharedClient;
}


@end

//
//  RMAFNRequestManager.h
//  RMVideo
//
//  Created by 润华联动 on 14-10-29.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMPublicModel.h"
#import "AFNetworking.h"

@protocol RMAFNRequestManagerDelegate <NSObject>

@optional
- (void)requestFinishiDownLoadWith:(NSMutableArray *)data;
- (void)requestFinishiDownLoadWithModel:(RMPublicModel *)model;
- (void)requestFinishiDownLoadWithToken:(NSString *)token;
- (void)requestFinishiDownLoadWithResults:(NSString *)results;

@required
- (void)requestError:(NSError *)error;

@end

@interface RMAFNRequestManager : NSObject

@property(assign,nonatomic) id<RMAFNRequestManagerDelegate>delegate;
@property(assign,nonatomic) NSInteger downLoadType;


@end

//
//  RMAFNRequestManager.h
//  RMVideo
//
//  Created by 润华联动 on 14-10-29.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMPublicModel.h"

@protocol RMAFNRequestManagerDelegate <NSObject>

@optional
- (void)requestFinishiDownLoadWith:(NSMutableArray *)array;
- (void)requestFinishiDownLoadWithModel:(RMPublicModel *)model;
- (void)requestFinishiDownLoadWithResults:(NSString *)results;

@required
- (void)requestError:(NSError *)error;

@end

@interface RMAFNRequestManager : NSObject

@property(assign,nonatomic) id<RMAFNRequestManagerDelegate>delegate;

/**
 *  @method     广告查询
 *  @param      type        广告类型
 *   1：首页广告、2：放毒区、3：放毒区帖子底部、4：一物一拍、5：鲜肉市场
 */
- (void)getAdvertisingQueryWithType:(NSInteger)type;

/**
 *  @method     首页栏目
 */
- (void)getHomeColumns;

@end

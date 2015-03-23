//
//  RMAFNRequestManager.m
//  RMVideo
//
//  Created by 润华联动 on 14-10-29.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import "RMAFNRequestManager.h"
#import "CONST.h"

#define baseUrl             @"http://218.240.30.6/drzw/index.php?com=com_appService&"

#define kMSGSuccess         @"数据返回成功"
#define kMSGFailure         @"数据返回失败"

@interface RMAFNRequestManager (){

}
@property (nonatomic, strong) AFHTTPRequestOperationManager * AFManager;

@end

@implementation RMAFNRequestManager
@synthesize AFManager;

- (void)creatAFNNetWorkRequestManager {
    AFManager = [AFHTTPRequestOperationManager manager];
    AFManager.responseSerializer = [AFJSONResponseSerializer serializer];
    AFManager.requestSerializer.timeoutInterval = 15;//超时
    AFManager.responseSerializer.acceptableContentTypes = [AFManager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
}

- (void)cancelRMAFNRequestManagerRequest {
    if (AFManager){
        [AFManager.operationQueue cancelAllOperations];
    }
}

#pragma mark - 工具

- (NSString *)checkEmptyStringFromNULL:(NSString *)str {
    if ([str isEqualToString:@"<null>"] || [str isEqualToString:@"(null)"] || str == nil){
        return @"";
    }else{
        return str;
    }
}

#pragma mark - 接口

/**
 *  @method     广告查询
 *  @param      type        广告类型
 *   1：首页广告、2：放毒区、3：放毒区帖子底部、4：一物一拍、5：鲜肉市场
 */
- (void)getAdvertisingQueryWithType:(NSInteger)type {
    __weak RMAFNRequestManager *weekSelf = self;
    [self creatAFNNetWorkRequestManager];
    NSString * url = [NSString stringWithFormat:@"%@method=appSev&app_com=com_shop&task=ad&auto_id=%ld",baseUrl,(long)type];
    [AFManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"msg"] isEqualToString:kMSGSuccess]){
            NSMutableArray * array = [NSMutableArray array];
            for (NSInteger i=0; i<[[responseObject objectForKey:@"data"] count]; i++){
                RMPublicModel * model = [[RMPublicModel alloc] init];
                model.content_img = [[[responseObject objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_img"];
                model.content_img = [self checkEmptyStringFromNULL:model.content_img];
                [array addObject:model];
            }
            if ([self.delegate respondsToSelector:@selector(requestFinishiDownLoadWith:)]){
                [self.delegate requestFinishiDownLoadWith:array];
            }
        }else{
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if([weekSelf.delegate respondsToSelector:@selector(requestError:)]){
            [weekSelf.delegate requestError:error];
        }
    }];
}

/**
 *  @method     首页栏目
 */
- (void)getHomeColumns {
    __weak RMAFNRequestManager *weekSelf = self;
    [self creatAFNNetWorkRequestManager];
    NSString * url = [NSString stringWithFormat:@"%@method=appSev&app_com=com_shop&task=indexNum&level=2",baseUrl];
    [AFManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"msg"] isEqualToString:kMSGSuccess]){
            NSMutableArray * array = [NSMutableArray array];
            for (NSInteger i=0; i<[[responseObject objectForKey:@"data"] count]; i++){
                RMPublicModel * model = [[RMPublicModel alloc] init];
                               [array addObject:model];
            }
            if ([self.delegate respondsToSelector:@selector(requestFinishiDownLoadWith:)]){
                [self.delegate requestFinishiDownLoadWith:array];
            }
        }else{
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if([weekSelf.delegate respondsToSelector:@selector(requestError:)]){
            [weekSelf.delegate requestError:error];
        }
    }];
}

/**
 *  @method     植物大全列表
 */
- (void)getPlantDaqo {

    
}





@end


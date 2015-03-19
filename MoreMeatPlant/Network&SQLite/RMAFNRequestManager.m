//
//  RMAFNRequestManager.m
//  RMVideo
//
//  Created by 润华联动 on 14-10-29.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import "RMAFNRequestManager.h"
#import "CONST.h"
#import "Reachability.h"

#define baseUrl         @"http://vodapi.runmobile.cn/version2_00/api.php/vod/"

@interface RMAFNRequestManager (){
    UIImageView * HUDImage;
}

@end

@implementation RMAFNRequestManager

- (AFHTTPRequestOperationManager *)creatAFNNetworkRequestManager{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15;//超时
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    return manager;
}

- (void)cancelRMAFNRequestManagerRequest:(AFHTTPRequestOperationManager *)manager {
    if (manager){
        [manager.operationQueue cancelAllOperations];
    }
}

- (NSString *)urlPathadress:(NSInteger)tag{
    NSString *strUrl;
    switch (tag) {
        case 1:{
            strUrl = [NSString stringWithFormat:@"%@getSlideList?",baseUrl];
            break;
        }
        default:{
            strUrl = nil;
        }
            break;
    }
    return strUrl;
}

- (NSString *)setOffsetWith:(NSString *)page andCount:(NSString *)count{
    return [NSString stringWithFormat:@"%d",([page intValue] -1)*[count intValue]];
}

- (void)checkTheNetworkConnectionWithTitle:(NSString *)title {
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:{
            break;
        }
        default:{
            break;
        }
    }
}

#pragma mark - 接口

- (void)getSlideListWithVideo_type:(NSString *)video_type {
    __weak RMAFNRequestManager *weekSelf = self;
    AFHTTPRequestOperationManager *manager = [self creatAFNNetworkRequestManager];
    self.downLoadType = 1;
    NSString *url = [self urlPathadress:1];
    url = [NSString stringWithFormat:@"%@video_type=%@",url,video_type];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if([[responseObject objectForKey:@"code"] intValue] == 4001){
            NSMutableArray *dataArray = [NSMutableArray array];
            for (NSDictionary *dict in [responseObject objectForKey:@"data"]){
                RMPublicModel *model = [[RMPublicModel alloc] init];
                
                               [dataArray addObject:model];
            }
            if([weekSelf.delegate respondsToSelector:@selector(requestFinishiDownLoadWith:)]){
                [weekSelf.delegate requestFinishiDownLoadWith:dataArray];
            }
        }
        else{
            if([weekSelf.delegate respondsToSelector:@selector(requestError:)]){
                [weekSelf.delegate requestError:nil];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weekSelf checkTheNetworkConnectionWithTitle:@"下载失败"];
        if([weekSelf.delegate respondsToSelector:@selector(requestError:)]){
            [weekSelf.delegate requestError:error];
        }
    }];
}

@end

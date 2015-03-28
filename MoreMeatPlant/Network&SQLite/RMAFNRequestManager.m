//
//  RMAFNRequestManager.m
//  RMVideo
//
//  Created by 润华联动 on 14-10-29.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import "RMAFNRequestManager.h"
#import "RMHttpOperationShared.h"
#import "CONST.h"

#define baseUrl             @"http://218.240.30.6/drzw/index.php?com=com_appService"

#define kMSGSuccess         @"1"
#define kMSGFailure         @"0"

#define RequestFailed @"请检查您的网络！"

@interface RMAFNRequestManager (){

}

@end

@implementation RMAFNRequestManager

#pragma mark - 接口

/**
 *  @method     广告查询
 *  @param      type        广告类型
 *   1：首页广告、2：放毒区、3：放毒区帖子底部、4：一物一拍、5：鲜肉市场
 */
+ (void)getAdvertisingQueryWithType:(NSInteger)type callBack:(RMAFNRequestManagerCallBack)block {
    NSString * url = [NSString stringWithFormat:@"%@&method=appSev&app_com=com_shop&task=ad&auto_id=%ld",baseUrl,(long)type];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary * responseObject) {
        if (block){
            block (nil, [responseObject objectForKey:@"status"], responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block){
            block (error, NO, kMSGFailure);
        }
    }];
}

/**
 *  @method     首页栏目
 */
+ (void)getHomeColumnsNumberCallBack:(RMAFNRequestManagerCallBack)block {
    NSString * url = [NSString stringWithFormat:@"%@&method=appSev&app_com=com_shop&task=indexNum&level=2",baseUrl];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block){
            block (nil, [responseObject objectForKey:@"status"], responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block){
            block (error, NO, kMSGFailure);
        }
    }];
}

/**
 *  @method     植物分类
 */
+ (void)getPlantClassificationWithxCallBack:(RMAFNRequestManagerCallBack)block {
    NSString * url = [NSString stringWithFormat:@"%@&method=appSev&app_com=com_shop&task=otherVars&type=classType",baseUrl];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block){
            block (nil, [responseObject objectForKey:@"status"], responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block){
            block (error, NO, kMSGFailure);
        }
    }];
}

/**
 *  @method     植物大全列表          少一个auto_id 字段
 *  @param      pageCount       分页
 */
+ (void)getPlantDaqoListWithPageCount:(NSInteger)pageCount callBack:(RMAFNRequestManagerCallBack)block {
    NSString * url = [NSString stringWithFormat:@"%@&method=appSev&app_com=com_shop&task=shopAll&data=series&order=asc&per=1&row=10&page=%ld",baseUrl,(long)pageCount];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block){
            block (nil, [responseObject objectForKey:@"status"], responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block){
            block (error, NO, kMSGFailure);
        }
    }];
}

/**
 *  @method     News
 *  @param      pageCount       页数
 *  @param      optionid        类别
 *      970（放毒区）971（一肉一拍）972（鲜肉市场）973（肉肉交换）977（新手教程）
 */
+ (void)getNewsWithOptionid:(NSInteger)optionid withPageCount:(NSInteger)pageCount callBack:(RMAFNRequestManagerCallBack)block {
    NSString * url = [NSString stringWithFormat:@"%@&method=appSev&app_com=com_shop&task=shopNews&data=1&per=1&row=10&optionid=%ld&page=%ld",baseUrl,optionid,pageCount];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block){
            block (nil, [responseObject objectForKey:@"status"], responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block){
            block (error, NO, kMSGFailure);
        }
    }];
}

/**
 *  @method     News    详情页
 *  @param      auto_id         新闻标识
 */
+ (void)getNewsDetailsWithAuto_id:(NSString *)auto_id callBack:(RMAFNRequestManagerCallBack)block {
    NSString * url = [NSString stringWithFormat:@"%@&method=appSev&app_com=com_shop&task=shopNewsview&auto_id=%@",baseUrl,auto_id];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block){
            block (nil, [responseObject objectForKey:@"status"], responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block){
            block (error, NO, kMSGFailure);
        }
    }];
}

/**
 *  @method     植物大全详情页面
 *  @param      auto_id     植物标识
 */
- (void)getPlantDaqoDetailsWithAuto_id:(NSString *)auto_id {
    __weak RMAFNRequestManager *weekSelf = self;
    NSString * url = [NSString stringWithFormat:@"%@&method=appSev&app_com=com_shop&task=shopAllview&auto_id=%@",baseUrl,auto_id];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"status"] isEqualToString:kMSGSuccess]){
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
 *  @method     植物科目 大全
 *  @param      level       级别      1：一级：大全顶部分类，2:二级：侧滑分类
 */
+ (void)getPlantSubjectsListWithLevel:(NSInteger)level callBack:(RMAFNRequestManagerCallBack)block {
    NSString * url = [NSString stringWithFormat:@"%@&method=appSev&app_com=com_shop&task=shopCourse&level=%ld",baseUrl,level];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(block){
            block(nil, [responseObject objectForKey:@"status"], responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(block){
            block(error, NO, kMSGFailure);
        }
    }];
}

/**
 *  @method     植物大全添加图片            未完成
 *  @param
 */
- (void)postPlantDaqoAddImage {
    __weak RMAFNRequestManager *weekSelf = self;
    NSString *url = @"http://218.240.30.6/drzw/index.php";
    NSDictionary * parameter = @{
                                 @"com": @"com_appService",
                                 @"method": @"save",
                                 @"app_com": @"com_center",
                                 @"task": @"addAllimg",
                                 @"frm[all_id]": @"植物大全标识",
                                 @"content_img": @"图片字段",
                                 @"ID": @"会员用户名",
                                 @"PWD": @"会员密码"
                                 };
    [[RMHttpOperationShared sharedClient] POST:url parameters:parameter success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
       
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if([weekSelf.delegate respondsToSelector:@selector(requestError:)]){
            [weekSelf.delegate requestError:error];
        }
    }];
}

/**
 *  @method     植物大全添加纠正补充
 *  @param      all_id              植物大全标识
 *  @param      content_desc        补充纠正说明
 *  @param      user_id             会员用户名
 *  @param      user_password       会员密码
 */
- (void)getPlantDaqoDetailsAddTheCorrectAddWithPlantAll_id:(NSString *)all_id
                                   withCorrectInstructions:(NSString *)content_desc
                                               withUser_id:(NSString *)user_id
                                          withUserPassword:(NSString *)user_password {
    __weak RMAFNRequestManager *weekSelf = self;
    NSString * url = [NSString stringWithFormat:@"%@&method=save&app_com=com_center&task=addAlldesc&frm[all_id]=%@&frm[content_desc]=%@&ID=%@&PWD=%@",baseUrl,all_id,content_desc,user_id,user_password];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"status"] isEqualToString:kMSGSuccess]){
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
 *  @method     帖子列表
 *  @param      postsType       帖子分类 1:防毒区、2:肉肉交换
 *  @param      plantType       植物分类
 *  @param      plantSubjects   植物科目
 *  @param      pageCount       页数
 *  @param      user_id         会员用户名
 *  @param      user_password   会员密码

 */
+ (void)getPostsListWithPostsType:(NSString *)postsType
                    withPlantType:(NSString *)plantType
                withPlantSubjects:(NSString *)plantSubjects
                    withPageCount:(NSInteger)pageCount
                      withUser_id:(NSString *)user_id
                withUser_password:(NSString *)user_password
                         callBack:(RMAFNRequestManagerCallBack)block {
    NSString * url = [NSString stringWithFormat:@"%@&method=appSev&app_com=com_shop&task=shopNote&type=%@&class=%@&course=%@&per=1&row=10&page=%ld&ID=%@&PWD=%@",baseUrl,postsType,plantType,plantSubjects,(long)pageCount,user_id,user_password];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if (block){
            block (nil, [responseObject objectForKey:@"status"], responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block){
            block(error, NO, kMSGFailure);
        }
    }];
}

/**
 *  @method     帖子最终
 *  @param      auto_id             标识
 *  @param      user_id             会员用户名
 *  @param      user_password       会员密码
 */
- (void)getPostsListDetailsWithAuto_id:(NSString *)auto_id
                           withUser_id:(NSString *)user_id
                     withUser_password:(NSString *)user_password {
    __weak RMAFNRequestManager *weekSelf = self;
    NSString * url = [NSString stringWithFormat:@"%@&method=appSev&app_com=com_shop&task=shopNote&auto_id=%@&ID=%@&PWD=%@",baseUrl,auto_id,user_id,user_password];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"status"] isEqualToString:kMSGSuccess]){
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
 *  @method     帖子评论列表
 *  @param      review_id       帖子标识
 *  @param      pageCount       页数
 */
- (void)getPostsCommentsListWithReview_id:(NSString *)review_id
                            withPageCount:(NSInteger)pageCount {
    __weak RMAFNRequestManager *weekSelf = self;
    NSString * url = [NSString stringWithFormat:@"%@&method=appSev&app_com=com_shop&task=shopNotereview&review_id=%@&per=1&row=10&page=%ld",baseUrl,review_id,(long)pageCount];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"status"] isEqualToString:kMSGSuccess]){
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
 *  @method     帖子点赞       未完成
 */
- (void)PostPostsAddPraise {
    __weak RMAFNRequestManager *weekSelf = self;
    NSString *url = @"http://218.240.30.6/drzw/index.php";
    NSDictionary * parameter = @{
                                 @"com": @"com_appService",
                                 @"method": @"save",
                                 @"app_com": @"com_center",
                                 @"task": @"noteTop",
                                 @"note_id": @"帖子标识",
                                 @"ID": @"会员用户名",
                                 @"PWD": @"会员密码",
                                 };
    [[RMHttpOperationShared sharedClient] POST:url parameters:parameter success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if([weekSelf.delegate respondsToSelector:@selector(requestError:)]){
            [weekSelf.delegate requestError:error];
        }
    }];
}

/**
 *  @method     会员收藏
 *  @param
 */
- (void)postCollect {
    __weak RMAFNRequestManager *weekSelf = self;
    NSString *url = @"http://218.240.30.6/drzw/index.php";
    NSDictionary * parameter = @{
                                 @"com": @"com_appService",
                                 @"method": @"save",
                                 @"app_com": @"com_center",
                                 @"task": @"addmemberCollect",
                                 @"collect_id": @"收藏的标识",
                                 @"content_type": @"收藏类型",
                                 @"ID": @"会员用户名",
                                 @"PWD": @"会员密码",
                                 };
    [[RMHttpOperationShared sharedClient] POST:url parameters:parameter success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if([weekSelf.delegate respondsToSelector:@selector(requestError:)]){
            [weekSelf.delegate requestError:error];
        }
    }];
}

/**
 *  @method     帖子评论
 */
- (void)postPostsAddComments {
    __weak RMAFNRequestManager *weekSelf = self;
    NSString *url = @"http://218.240.30.6/drzw/index.php";
    NSDictionary * parameter = @{
                                 @"com": @"com_appService",
                                 @"method": @"save",
                                 @"app_com": @"com_center",
                                 @"task": @"addComment",
                                 @"review_id": @"帖子标识",
                                 @"content_body": @"评论内容",
                                 @"ID": @"会员用户名",
                                 @"PWD": @"会员密码",
                                 };
    [[RMHttpOperationShared sharedClient] POST:url parameters:parameter success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if([weekSelf.delegate respondsToSelector:@selector(requestError:)]){
            [weekSelf.delegate requestError:error];
        }
    }];
}

/**
 *  @method     回复帖子评论
 */
- (void)postReplyToPostsComment {
    __weak RMAFNRequestManager *weekSelf = self;
    NSString *url = @"http://218.240.30.6/drzw/index.php";
    NSDictionary * parameter = @{
                                 @"com": @"com_appService",
                                 @"method": @"save",
                                 @"app_com": @"com_center",
                                 @"task": @"returnComment",
                                 @"comment_id": @"评论标识",
                                 @"content_body": @"回复评论内容",
                                 @"ID": @"会员用户名",
                                 @"PWD": @"会员密码",
                                 };
    [[RMHttpOperationShared sharedClient] POST:url parameters:parameter success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if([weekSelf.delegate respondsToSelector:@selector(requestError:)]){
            [weekSelf.delegate requestError:error];
        }
    }];
}

//1.1~1.17 如上

//1.18 ...

/*************************************************************************/

/**
 *  @method     登录
 *  @param      user            用户名
 *  @param      pwd             密码 （md5编码之后的）
 */
+ (void)loginRequestWithUser:(NSString *)user Pwd:(NSString *)pwd andCallBack:(RMAFNRequestManagerCallBack)block{
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@",baseUrl,@"&method=save&app_com=com_passport&task=app_doLogin",user,pwd];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        RMPublicModel * model = [[RMPublicModel alloc]init];
        model.status = [[dic objectForKey:@"status"] boolValue];
        model.msg = [dic objectForKey:@"msg"];
        if(![[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]]){
        
        }else{
            model.s_type = [OBJC([dic objectForKey:@"data"]) objectForKey:@"s_type"];
        }
        if(block){
            block(nil,YES,model);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(block){
            block(error,NO,RequestFailed);
        }
    }];
}

+ (void)registerRequestWithUser:(NSString *)user Pwd:(NSString *)pwd Code:(NSString *)code Nick:(NSString *)nick Type:(NSString *)type Gps:(NSString *)gps andCallBack:(RMAFNRequestManagerCallBack)block{
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&frm[content_name]=%@&content_code=%@&GPS=%@&type=%@",baseUrl,@"&method=save&app_com=com_passport&task=app_register",user,pwd,nick,code,gps,type];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        RMPublicModel * model = [[RMPublicModel alloc]init];
        model.status = [[dic objectForKey:@"status"] boolValue];
        model.msg = [dic objectForKey:@"msg"];
        if(block){
            block(nil,YES,model);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(block){
            block(error,NO,RequestFailed);
        }
    }];
}


+ (void)registerSendCodeWith:(NSString *)mobile andCallBack:(RMAFNRequestManagerCallBack)block{
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@",baseUrl,@"&method=save&app_com=com_passport&task=registerCode",mobile];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        RMPublicModel * model = [[RMPublicModel alloc]init];
        model.status = [[dic objectForKey:@"status"] boolValue];
        model.msg = [dic objectForKey:@"msg"];
        if(block){
            block(nil,YES,model);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(block){
            block(error,NO,RequestFailed);
        }
    }];
}


+ (void)forgotPwdSendCodeWith:(NSString *)mobile andCallBack:(RMAFNRequestManagerCallBack)block{
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@",baseUrl,@"&method=save&app_com=com_passport&task=app_pwdCode",mobile];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        RMPublicModel * model = [[RMPublicModel alloc]init];
        model.status = [[dic objectForKey:@"status"] boolValue];
        model.msg = [dic objectForKey:@"msg"];
        if(block){
            block(nil,YES,model);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(block){
            block(error,NO,RequestFailed);
        }
    }];
}


+ (void)resetPwdRequestWithUser:(NSString *)user Pwd:(NSString *)pwd Code:(NSString *)code andCallBack:(RMAFNRequestManagerCallBack)block{
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&content_code=%@",baseUrl,@"&method=save&app_com=com_passport&task=app_register",user,pwd,code];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        RMPublicModel * model = [[RMPublicModel alloc]init];
        model.status = [[dic objectForKey:@"status"] boolValue];
        model.msg = [dic objectForKey:@"msg"];
        if(block){
            block(nil,YES,model);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(block){
            block(error,NO,RequestFailed);
        }
    }];
}
@end


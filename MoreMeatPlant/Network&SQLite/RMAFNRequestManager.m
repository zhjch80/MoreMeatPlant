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

#define PayHttp @"http://http://218.240.30.6/drzw/pay/app_js/alipayapi.php?"


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
            block (nil, [[responseObject objectForKey:@"status"] boolValue], responseObject);
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
            block (nil, [[responseObject objectForKey:@"status"] boolValue], responseObject);
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
            block (nil, [[responseObject objectForKey:@"status"] boolValue], responseObject);
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
            block (nil, [[responseObject objectForKey:@"status"] boolValue], responseObject);
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
    NSString * url = [NSString stringWithFormat:@"%@&method=appSev&app_com=com_shop&task=shopNews&data=1&per=1&row=10&optionid=%ld&page=%ld",baseUrl,(long)optionid,(long)pageCount];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block){
            block (nil, [[responseObject objectForKey:@"status"] boolValue], responseObject);
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
            block (nil, [[responseObject objectForKey:@"status"] boolValue], responseObject);
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
+ (void)getPlantDaqoDetailsWithAuto_id:(NSString *)auto_id
                              callBack:(RMAFNRequestManagerCallBack)block {
    NSString * url = [NSString stringWithFormat:@"%@&method=appSev&app_com=com_shop&task=shopAllview&auto_id=%@",baseUrl,auto_id];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if (block){
            block (nil, [[responseObject objectForKey:@"status"] boolValue], responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block){
            block (error, NO, kMSGFailure);
        }
    }];
}

/**
 *  @method     植物科目 大全
 *  @param      level       级别      1：一级：大全顶部分类，2:二级：侧滑分类
 */
+ (void)getPlantSubjectsListWithLevel:(NSInteger)level callBack:(RMAFNRequestManagerCallBack)block {
    NSString * url = [NSString stringWithFormat:@"%@&method=appSev&app_com=com_shop&task=shopCourse&level=%ld",baseUrl,(long)level];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(block){
            block(nil, [[responseObject objectForKey:@"status"] boolValue], responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(block){
            block(error, NO, kMSGFailure);
        }
    }];
}

/**
 *  @method     植物大全添加图片
 *  @param      all_id          植物标识
 *  @param      content_img     图片字段
 *  @param      user_id         会员用户名
 *  @param      user_password   会员密码
 */
+ (void)postPlantDaqoAddImageWithAll_id:(NSString *)all_id
                        withContent_img:(NSString *)content_img
                                 withID:(NSString *)user_id
                                withPWD:(NSString *)user_password
                               callBack:(RMAFNRequestManagerCallBack)block {
    NSString *url = @"http://218.240.30.6/drzw/index.php";
    NSDictionary * parameter = @{
                                 @"com": @"com_appService",
                                 @"method": @"save",
                                 @"app_com": @"com_center",
                                 @"task": @"addAllimg",
                                 @"frm[all_id]": all_id,
                                 @"content_img": content_img,
                                 @"ID": user_id,
                                 @"PWD": user_password
                                 };
    [[RMHttpOperationShared sharedClient] POST:url parameters:parameter success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if (block) {
            block (nil, [[responseObject objectForKey:@"status"] boolValue], responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block){
            block (error, NO, kMSGFailure);
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
+ (void)getPlantDaqoDetailsAddTheCorrectAddWithPlantAll_id:(NSString *)all_id
                                   withCorrectInstructions:(NSString *)content_desc
                                               withUser_id:(NSString *)user_id
                                          withUserPassword:(NSString *)user_password callBack:(RMAFNRequestManagerCallBack)block {
    NSString * url = [NSString stringWithFormat:@"%@&method=save&app_com=com_center&task=addAlldesc&frm[all_id]=%@&frm[content_desc]=%@&ID=%@&PWD=%@",baseUrl,all_id,content_desc,user_id,user_password];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if (block){
            block (nil, [[responseObject objectForKey:@"status"] boolValue], responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block){
            block (error, NO, kMSGFailure);
        }
    }];
}

/**
 *  @method     宝贝列表
 *  @param      plantClass      宝贝分类    1、为一肉一拍 2、鲜肉市场
 *  @param      plantCourse     植物科目
 *  @param      pageCount       分页
 */
+ (void)getBabyListWithPlantClassWith:(NSInteger)plantClass
                           withCourse:(NSInteger)plantCourse
                            withCount:(NSInteger)pageCount
                             callBack:(RMAFNRequestManagerCallBack)block {
    NSString * url = [NSString stringWithFormat:@"%@&method=appSev&app_com=com_shop&task=shopProduct&class=%ld&course=%ld&per=1&row=10&page=%ld",baseUrl,(long)plantClass,(long)plantCourse,(long)pageCount];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block){
            block (nil, [[responseObject objectForKey:@"status"] boolValue], responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block){
            block (error, NO, kMSGFailure);
        }
    }];
}

/**
 *  @method     宝贝列表详情
 *  @param      auto_id         宝贝标识
 */
+ (void)getBabyListDetalisWithAuto_id:(NSString *)auto_id
                             callBack:(RMAFNRequestManagerCallBack)block {
    NSString * url = [NSString stringWithFormat:@"%@&method=appSev&app_com=com_shop&task=shopProductview&auto_id=%@",baseUrl,auto_id];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block){
            block (nil, [[responseObject objectForKey:@"status"] boolValue], responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block){
            block (error, NO, kMSGFailure);
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
            block (nil, [[responseObject objectForKey:@"status"] boolValue], responseObject);
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
 *  @param      user_id             会员用户名      不是必须
 *  @param      user_password       会员密码       不是必须
 */
+ (void)getPostsListDetailsWithAuto_id:(NSString *)auto_id
                           withUser_id:(NSString *)user_id
                     withUser_password:(NSString *)user_password callBack:(RMAFNRequestManagerCallBack)block {
    NSString * url = [NSString stringWithFormat:@"%@&method=appSev&app_com=com_shop&task=shopNote&auto_id=%@&ID=%@&PWD=%@",baseUrl,auto_id,user_id,user_password];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if (block){
            block (nil, [[responseObject objectForKey:@"status"] boolValue], responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block){
            block (error, NO, kMSGFailure);
        }
    }];
}

/**
 *  @method     帖子评论列表
 *  @param      review_id       帖子标识
 *  @param      pageCount       页数
 */
+ (void)getPostsCommentsListWithReview_id:(NSString *)review_id
                            withPageCount:(NSInteger)pageCount
                                 callBack:(RMAFNRequestManagerCallBack)block{
    NSString * url = [NSString stringWithFormat:@"%@&method=appSev&app_com=com_shop&task=shopNotereview&review_id=%@&per=1&row=10&page=%ld",baseUrl,review_id,(long)pageCount];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if (block) {
            block (nil, [[responseObject objectForKey:@"status"] boolValue], responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block){
            block (error, NO, kMSGFailure);
        }
    }];
}

/**
 *  @method     帖子点赞
 *  @param      auto_id             帖子标识
 *  @param      user_id             用户名
 *  @param      user_password       用户密码
 */
+ (void)postPostsAddPraiseWithAuto_id:(NSString *)auto_id
                               withID:(NSString *)user_id
                              withPWD:(NSString *)user_password
                             callBack:(RMAFNRequestManagerCallBack)block {
    NSString *url = @"http://218.240.30.6/drzw/index.php";
    NSDictionary * parameter = @{
                                 @"com": @"com_appService",
                                 @"method": @"save",
                                 @"app_com": @"com_center",
                                 @"task": @"noteTop",
                                 @"note_id": auto_id,
                                 @"ID": user_id,
                                 @"PWD": user_password,
                                 };
    [[RMHttpOperationShared sharedClient] POST:url parameters:parameter success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if (block){
            block (nil, [[responseObject objectForKey:@"status"] boolValue], responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block){
            block (error, NO, kMSGFailure);
        }
    }];
}

/**
 *  @method     会员收藏
 *  @param      collect_id          收藏的标识
 *  @param      content_type        收藏类型：1：帖子、2：店铺、3：宝贝
 *  @param      user_id             会员用户名
 *  @param      user_password       会员密码
 */
+ (void)postMembersCollectWithCollect_id:(NSString *)collect_id
                        withContent_type:(NSString *)content_type
                                  withID:(NSString *)user_id
                                 withPWD:(NSString *)user_password
                                callBack:(RMAFNRequestManagerCallBack)block {
    NSString *url = @"http://218.240.30.6/drzw/index.php";
    NSDictionary * parameter = @{
                                 @"com": @"com_appService",
                                 @"method": @"save",
                                 @"app_com": @"com_center",
                                 @"task": @"addmemberCollect",
                                 @"collect_id": collect_id,
                                 @"content_type": content_type,
                                 @"ID": user_id,
                                 @"PWD": user_password,
                                 };
    [[RMHttpOperationShared sharedClient] POST:url parameters:parameter success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if (block){
            block (nil, [[responseObject objectForKey:@"status"] boolValue], responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block (error, NO, kMSGFailure);
        }
    }];
}

/**
 *  @method     帖子评论
 *  @param      review_id               帖子标识
 *  @param      content_body            评论内容
 *  @param      user_id                 会员用户名
 *  @param      user_password           会员密码
 */
+ (void)postPostsAddCommentsWithReview_id:(NSString *)review_id
                         withContent_body:(NSString *)content_body
                                   withID:(NSString *)user_id
                                  withPWD:(NSString *)user_password
                                 callBack:(RMAFNRequestManagerCallBack)block {
    NSString *url = @"http://218.240.30.6/drzw/index.php";
    NSDictionary * parameter = @{
                                 @"com": @"com_appService",
                                 @"method": @"save",
                                 @"app_com": @"com_center",
                                 @"task": @"addComment",
                                 @"review_id": review_id,
                                 @"content_body": content_body,
                                 @"ID": user_id,
                                 @"PWD": user_password,
                                 };
    [[RMHttpOperationShared sharedClient] POST:url parameters:parameter success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if (block){
            block (nil, [[responseObject objectForKey:@"status"] boolValue], responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block){
            block (error, NO, kMSGFailure);
        }
    }];
}

/**
 *  @method     回复帖子评论
 *  @param      comment_id              评论标识
 *  @param      content_body            回复评论内容
 *  @param      user_id                 会员用户名
 *  @param      user_password           会员密码
 */
+ (void)postReplyToPostsCommentWithComment_id:(NSString *)comment_id
                             withContent_body:(NSString *)content_body
                                       withID:(NSString *)user_id
                                      withPWD:(NSString *)user_password
                                     callBack:(RMAFNRequestManagerCallBack)block {
    NSString *url = @"http://218.240.30.6/drzw/index.php";
    NSDictionary * parameter = @{
                                 @"com": @"com_appService",
                                 @"method": @"save",
                                 @"app_com": @"com_center",
                                 @"task": @"returnComment",
                                 @"comment_id": comment_id,
                                 @"content_body": content_body,
                                 @"ID": user_id,
                                 @"PWD": user_password,
                                 };
    [[RMHttpOperationShared sharedClient] POST:url parameters:parameter success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if (block){
            block (nil, [[responseObject objectForKey:@"status"] boolValue], responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block){
            block (error, NO, kMSGFailure);
        }
    }];
}

/**
 *  @method     匿名提交升级建议
 *  @param      title
 *  @param      content
 */
+ (void)postAnonymousSubmissionsUpgradeSuggestionsWithContent_title:(NSString *)title
                                                   withContent_body:(NSString *)content
                                                           callBack:(RMAFNRequestManagerCallBack)block {
    NSString *url = @"http://218.240.30.6/drzw/index.php";
    NSDictionary * parameter = @{
                                 @"com": @"com_appService",
                                 @"method": @"save",
                                 @"app_com": @"com_shop",
                                 @"task": @"addGuest",
                                 @"frm[content_title]": title,
                                 @"frm[content_body]": content,
                                 };
    [[RMHttpOperationShared sharedClient] POST:url parameters:parameter success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if (block){
            block (nil, [[responseObject objectForKey:@"status"] boolValue], responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block){
            block (error, NO, kMSGFailure);
        }
    }];
}

/**
 *  @method         放毒区详情举报
 *  @param          user_id                 会员名
 *  @param          user_password           会员密码
 *  @param          note_id                 帖子标识
 *  @param          note_content            举报内容
 */
+ (void)postReleasePoisonDetailsToReportWithID:(NSString *)user_id
                                       withPWD:(NSString *)user_password
                                   wirhNote_id:(NSString *)note_id
                              withNote_content:(NSString *)note_content
                                      callBack:(RMAFNRequestManagerCallBack)block {
    NSString *url = @"http://218.240.30.6/drzw/index.php";
    NSDictionary * parameter = @{
                                 @"com": @"com_appService",
                                 @"method": @"save",
                                 @"app_com": @"com_center",
                                 @"task": @"com_center",
                                 @"ID": user_id,
                                 @"PWD": user_password,
                                 @"frm[note_id]": note_id,
                                 @"note_id": note_content,
                                 };
    [[RMHttpOperationShared sharedClient] POST:url parameters:parameter success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if (block){
            block (nil, [[responseObject objectForKey:@"status"] boolValue], responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block){
            block (error, NO, kMSGFailure);
        }
    }];
}

/*************************************************************************/

/**
 *  @method     登录
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

/**
 *  @method     注册
 */
+ (void)registerRequestWithUser:(NSString *)user Pwd:(NSString *)pwd Code:(NSString *)code Nick:(NSString *)nick Type:(NSString *)type Gps:(NSString *)gps YPWD:(NSString *)ypwd andCallBack:(RMAFNRequestManagerCallBack)block{
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&frm[content_name]=%@&content_code=%@&GPS=%@&type=%@&YPWD=%@",baseUrl,@"&method=save&app_com=com_passport&task=app_register",user,pwd,nick,code,gps,type,ypwd];
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

/**
 *  @method     注册发送验证码
 */
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

/**
 *  @method     忘记密码发送验证码
 */
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

/**
 *  @method     重设密码
 */
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

/**
 *  @method     修改会员信息（签名、支付宝、头像）
 */
+ (void)myInfoModifyRequestWithUser:(NSString *)user Pwd:(NSString *)pwd Type:(NSString *)type AlipayNo:(NSString *)alipayno Signature:(NSString *)signature Dic:(NSDictionary *)dic andCallBack:(RMAFNRequestManagerCallBack)block {
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&frm[zfb_no]=%@&frm[content_qm]=%@",baseUrl,@"&method=save&app_com=com_passport&task=app_editInfo",user,pwd,alipayno,signature];
    [[RMHttpOperationShared sharedClient] POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileURL:filePath name:@"content_face" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

/**
 *  @method     修改密码
 */
+ (void)passwordModifyWithUser:(NSString *)user Pwd:(NSString *)pwd NewPass:(NSString *)newpass andCallBack:(RMAFNRequestManagerCallBack)block{
    //218.240.30.6/drzw/index.php?com=com_appService&method=save&app_com=com_passport&task=app_editPwd&ID=test&PWD=202cb962ac59075b964b07152d234b70&frm%5bPWD%5d=202cb962ac59075b964b07152d234b70
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&frm[PWD]=%@",baseUrl,@"&method=save&app_com=com_passport&task=app_editPwd",user,pwd,newpass];
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

/**
 *  @method     会员信息获取
 */
+ (void)myInfoRequestWithUser:(NSString *)user Pwd:(NSString *)pwd andCallBack:(RMAFNRequestManagerCallBack)block{
    //218.240.30.6/drzw/index.php?com=com_appService&method=appSev&app_com=com_center&task=memberInfo&ID=18513217782&PWD=202cb962ac59075b964b07152d234b70
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@",baseUrl,@"&method=appSev&app_com=com_center&task=memberInfo",user,pwd];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        NSDictionary * dataDic = OBJC_Nil([dic objectForKey:@"data"]);
        RMPublicModel * model = [[RMPublicModel alloc]init];
        model.status = [[dic objectForKey:@"status"] boolValue];
        model.msg = [dic objectForKey:@"msg"];
        model.contentMobile = OBJC_Nil([dataDic objectForKey:@"content_mobile"]);
        model.levelId = OBJC_Nil([dataDic objectForKey:@"level_id"]);
        model.contentAddress = OBJC_Nil([dataDic objectForKey:@"content_address"]);
        model.contentEmail = OBJC_Nil([dataDic objectForKey:@"content_email"]);
        model.contentContact = OBJC_Nil([dataDic objectForKey:@"content_contact"]);
        model.contentUser = OBJC_Nil([dataDic objectForKey:@"content_user"]);
        model.balance = [OBJC_Nil([dataDic objectForKey:@"balance"]) doubleValue];
        model.zfbNo = OBJC_Nil([dataDic objectForKey:@"zfb_no"]);
        model.spendmoney = [OBJC_Nil([dataDic objectForKey:@"spendmoney"]) doubleValue];
        model.contentName = OBJC_Nil([dataDic objectForKey:@"content_name"]);
        model.contentQm = OBJC_Nil([dataDic objectForKey:@"content_qm"]);
        model.contentFace = OBJC_Nil([dataDic objectForKey:@"content_face"]);
        model.contentGps = OBJC_Nil([dataDic objectForKey:@"content_gps"]);
        model.contentLinkname = OBJC_Nil([dataDic objectForKey:@"content_linkname"]);
        if(block){
            block(nil,YES,model);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(block){
            block(error,NO,RequestFailed);
        }
    }];
}

/**
 *  @method     会员地址列表
 */
+ (void)addressRequestWithUser:(NSString *)user Pwd:(NSString *)pwd andCallBack:(RMAFNRequestManagerCallBack)block{
    //218.240.30.6/drzw/index.php?com=com_appService&method=appSev&app_com=com_pcenter&task=addrlist&per=all&ID=test&PWD=202cb962ac59075b964b07152d234b70
     NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@",baseUrl,@"&method=appSev&app_com=com_pcenter&task=addrlist&per=all",user,pwd];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        NSMutableArray * Array = [[NSMutableArray alloc]init];
        NSArray * dataArray = OBJC_Nil([dic objectForKey:@"data"]);
        for(NSDictionary * dataDic in dataArray){
            RMPublicModel * model = [[RMPublicModel alloc]init];
            model.status = [[dic objectForKey:@"status"] boolValue];
            model.msg = [dic objectForKey:@"msg"];
            model.auto_id = [dataDic objectForKey:@"auto_id"];
            model.contentMobile = OBJC_Nil([dataDic objectForKey:@"content_mobile"]);
            model.contentAddress = OBJC_Nil([dataDic objectForKey:@"content_address"]);
            model.contentName = OBJC_Nil([dataDic objectForKey:@"content_name"]);
            [Array addObject:model];
        }
        if(block){
            block(nil,YES,Array);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(block){
            block(error,NO,RequestFailed);
        }
    }];
}
/**
 *  @method     某一个地址的详细
 */
+ (void)addressDetailRequestWithUser:(NSString *)user Pwd:(NSString *)pwd Autoid:(NSString *)auto_id andCallBack:(RMAFNRequestManagerCallBack)block{
    //218.240.30.6/drzw/index.php?com=com_appService&method=appSev&app_com=com_pcenter&task=addrlist&auto_id=3&ID=test&PWD=202cb962ac59075b964b07152d234b70
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&auto_id=%@",baseUrl,@"&method=appSev&app_com=com_pcenter&task=addrlist",user,pwd,auto_id];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        NSDictionary * dataDic = OBJC_Nil([dic objectForKey:@"data"]);
        RMPublicModel * model = [[RMPublicModel alloc]init];
        model.status = [[dic objectForKey:@"status"] boolValue];
        model.msg = [dic objectForKey:@"msg"];
        model.auto_id = [dataDic objectForKey:@"auto_id"];
        model.contentMobile = OBJC_Nil([dataDic objectForKey:@"content_mobile"]);
        model.contentAddress = OBJC_Nil([dataDic objectForKey:@"content_address"]);
        model.contentName = OBJC_Nil([dataDic objectForKey:@"content_name"]);
        if(block){
            block(nil,YES,model);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(block){
            block(error,NO,RequestFailed);
        }
    }];

}

/**
 *  @method     新建或者编辑地址提交
 *
 */
+ (void)addressEditOrNewPostWithUser:(NSString *)user Pwd:(NSString *)pwd Autoid:(NSString *)auto_id ContactName:(NSString *)name Mobile:(NSString *)mobile Address:(NSString *)address andCallBack:(RMAFNRequestManagerCallBack)block{
    //218.240.30.6/drzw/index.php?com=com_appService&method=save&app_com=com_pcenter&task=updateAdd&auto_id=3&ID=test&PWD=202cb962ac59075b964b07152d234b70&frm[content_name]=小马哥&frm[content_mobile]=15678789900&frm[content_address]=朝阳区慈云寺
    //218.240.30.6/drzw/index.php?com=com_appService&method=save&app_com=com_pcenter&task=updateAdd&ID=test&PWD=202CB962AC59075B964B07152D234B70&frm[content_name]=%E5%B0%8F%E5%87%AF&frm[content_mobile]=15456765555&frm[content_address]=%25E5%258C%2597%25E4%25BA%25AC%25E5%25B8%2582%25E6%259C%259D%25E9%2598%25B3%25E5%258C%25BA%25E6%2585%2588%25E4%25BA%2591%25E5%25AF%25BA%25E7%258F%25A0%25E8%259A%258C%25202000%25203%2520%25E5%258F%25B7%25E6%25A5%25BC%25201605%25E5%25AE%25A4
    NSString * url = nil;
    if(auto_id == nil){
        url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&frm[content_name]=%@&frm[content_mobile]=%@&frm[content_address]=%@",baseUrl,@"&method=save&app_com=com_pcenter&task=updateAdd",user,pwd,name,mobile,address];
    }else{
        url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&auto_id=%@&frm[content_name]=%@&frm[content_mobile]=%@&frm[content_address]=%@",baseUrl,@"&method=appSev&app_com=com_pcenter&task=updateAdd",user,pwd,auto_id,name,mobile,address];
    }
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

/**
 *  @method     会员信息获取
 */
+ (void)mywalletInfoRequestWithUser:(NSString *)user Pwd:(NSString *)pwd andCallBack:(RMAFNRequestManagerCallBack)block{
    //218.240.30.6/drzw/index.php?com=com_appService&method=appSev&app_com=com_center&task=memAccount&ID=test&PWD=202cb962ac59075b964b07152d234b70
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@",baseUrl,@"&method=appSev&app_com=com_center&task=memAccount",user,pwd];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        NSDictionary * dataDic = OBJC_Nil([dic objectForKey:@"data"]);
        RMPublicModel * model = [[RMPublicModel alloc]init];
        model.status = [[dic objectForKey:@"status"] boolValue];
        model.msg = [dic objectForKey:@"msg"];
        model.balance = [OBJC_Nil([dataDic objectForKey:@"balance"]) doubleValue];
        model.spendmoney = [OBJC_Nil([dataDic objectForKey:@"spendmoney"]) doubleValue];
        if(block){
            block(nil,YES,model);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(block){
            block(error,NO,RequestFailed);
        }
    }];
}

/**
 *  @method     余额转花币
 */
+ (void)yu_eTurnHuabiWithUser:(NSString *)user Pwd:(NSString *)pwd Number:(NSString *)num andCallBack:(RMAFNRequestManagerCallBack)block{
    //218.240.30.6/drzw/index.php?com=com_appService&method=save&app_com=com_center&task=financeTospend&frm[money]=1&ID=test&PWD=202cb962ac59075b964b07152d234b70
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&frm[money]=%@",baseUrl,@"&method=save&app_com=com_center&task=financeTospend",user,pwd,num];
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

/**
 *  @method     会员之间转账
 */
+ (void)memberTransforWithUser:(NSString *)user Pwd:(NSString *)pwd ToOtherMember:(NSString *)other Number:(NSString *)num andCallBack:(RMAFNRequestManagerCallBack)block{
   //218.240.30.6/drzw/index.php?com=com_appService&method=save&app_com=com_center&task=memTomemfinance&frm[money]=1&frm[content_mobile]=18513217781&ID=test&PWD=202cb962ac59075b964b07152d234b70
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&frm[money]=%@&frm[content_mobile]=%@",baseUrl,@"&method=save&app_com=com_center&task=memTomemfinance",user,pwd,num,other];
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


/**
 *  @method     提现
 */
+ (void)memberWithdrawalWithUser:(NSString *)user Pwd:(NSString *)pwd Code:(NSString *)code Number:(NSString *)num andCallBack:(RMAFNRequestManagerCallBack)block{
    //218.240.30.6/drzw/index.php?com=com_appService&method=save&app_com=com_center&task=addmemCash&&frm[money]=1&content_code=798922&ID=18513217781&PWD=202cb962ac59075b964b07152d234b70
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&frm[money]=%@&content_code=%@",baseUrl,@"&method=save&app_com=com_center&task=addmemCash",user,pwd,num,code];
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

/**
 *  @method     提现发送验证码
 */
+ (void)withdrawalSendCode:(NSString *)mobile andCallBack:(RMAFNRequestManagerCallBack)block{
    //218.240.30.6/drzw/index.php?com=com_appService&method=save&app_com=com_passport&task=registerCode&ID=18513217784
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

/**
 *  @method     账单纪录
 */
+ (void)billRecordRequest:(NSString *)user Pwd:(NSString *)pwd page:(NSInteger)page andCallBack:(RMAFNRequestManagerCallBack)block{
    //218.240.30.6/drzw/index.php?com=com_appService&method=appSev&app_com=com_center&task=member_paylist&per=1&row=10&page=1&ID=test&PWD=202cb962ac59075b964b07152d234b70
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&page=%ld",baseUrl,@"&method=appSev&app_com=com_center&task=member_paylist&per=1&row=10",user,pwd,(long)page];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        NSMutableArray * Array = [[NSMutableArray alloc]init];
        NSArray * dataArray = OBJC_Nil([dic objectForKey:@"data"]);
        for(NSDictionary * dataDic in dataArray){
            RMPublicModel * model = [[RMPublicModel alloc]init];
            model.status = [[dic objectForKey:@"status"] boolValue];
            model.msg = [dic objectForKey:@"msg"];
            model.auto_id = [dataDic objectForKey:@"auto_id"];
            model.content_value = OBJC_Nil([dataDic objectForKey:@"content_value"]);
            model.content_status = OBJC_Nil([dataDic objectForKey:@"content_status"]);
            model.content_item = OBJC_Nil([dataDic objectForKey:@"content_item"]);
            [Array addObject:model];
        }
        if(block){
            block(nil,YES,Array);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(block){
            block(error,NO,RequestFailed);
        }
    }];
}

/**
 *  @method     系统消息
 */
+ (void)systemMessageWithUser:(NSString *)user Pwd:(NSString *)pwd page:(NSInteger)page andCallBack:(RMAFNRequestManagerCallBack)block{
    //218.240.30.6/drzw/index.php?com=com_appService&method=appSev&app_com=com_center&task=memberMessage&per=1&row=10&page=1&ID=18513217782&PWD=202cb962ac59075b964b07152d234b70
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&page=%ld",baseUrl,@"&method=appSev&app_com=com_center&task=memberMessage&per=1&row=10",user,pwd,(long)page];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        NSMutableArray * Array = [[NSMutableArray alloc]init];
        NSArray * dataArray = OBJC_Nil([dic objectForKey:@"data"]);
        for(NSDictionary * dataDic in dataArray){
            RMPublicModel * model = [[RMPublicModel alloc]init];
            model.status = [[dic objectForKey:@"status"] boolValue];
            model.msg = [dic objectForKey:@"msg"];
            model.auto_id = OBJC_Nil([dataDic objectForKey:@"auto_id"]);
            model.msg_title = OBJC_Nil([dataDic objectForKey:@"msg_title"]);
            model.msg_text = OBJC_Nil([dataDic objectForKey:@"msg_text"]);
            model.msg_read = OBJC_Nil([dataDic objectForKey:@"msg_read"]);
            model.create_time = OBJC_Nil([dataDic objectForKey:@"create_time"]);
            [Array addObject:model];
        }
        if(block){
            block(nil,YES,Array);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(block){
            block(error,NO,RequestFailed);
        }
    }];
}

/**
 *  @method     系统消息详情页
 */
+ (void)systemMessageDetailWithUser:(NSString *)user Pwd:(NSString *)pwd Auto_id:(NSString *)auto_id andCallBack:(RMAFNRequestManagerCallBack)block{
    //218.240.30.6/drzw/index.php?com=com_appService&method=appSev&app_com=com_center&task=memberMessageview&auto_id=1&ID=18513217782&PWD=202cb962ac59075b964b07152d234b70
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&auto_id=%@",baseUrl,@"&method=appSev&app_com=com_center&task=memberMessageview",user,pwd,auto_id];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        NSDictionary * dataDic = OBJC_Nil([dic objectForKey:@"data"]);
            RMPublicModel * model = [[RMPublicModel alloc]init];
            model.status = [[dic objectForKey:@"status"] boolValue];
            model.msg = [dic objectForKey:@"msg"];
            model.auto_id = OBJC_Nil([dataDic objectForKey:@"auto_id"]);
            model.msg_title = OBJC_Nil([dataDic objectForKey:@"msg_title"]);
            model.msg_text = OBJC_Nil([dataDic objectForKey:@"msg_text"]);
            model.msg_read = OBJC_Nil([dataDic objectForKey:@"msg_read"]);
            model.create_time = OBJC_Nil([dataDic objectForKey:@"create_time"]);
        if(block){
            block(nil,YES,model);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(block){
            block(error,NO,RequestFailed);
        }
    }];
}

/**
 *  @method     我的帖子
 */
+ (void)memberPostlistWithUser:(NSString *)user Pwd:(NSString *)pwd Page:(NSInteger)page andCallBack:(RMAFNRequestManagerCallBack)block{
   //218.240.30.6/drzw/index.php?com=com_appService&method=appSev&app_com=com_center&task=memberNote&per=1&row=10&page=1&ID=test&PWD=202cb962ac59075b964b07152d234b70
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&page=%ld",baseUrl,@"&method=appSev&app_com=com_center&task=memberNote&per=1&row=10",user,pwd,(long)page];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        NSMutableArray * Array = [[NSMutableArray alloc]init];
        NSArray * dataArray = OBJC_Nil([dic objectForKey:@"data"]);
        for(NSDictionary * dataDic in dataArray){
            RMPublicModel * model = [[RMPublicModel alloc]init];
            model.status = [[dic objectForKey:@"status"] boolValue];
            model.msg = [dic objectForKey:@"msg"];
            model.auto_id = OBJC_Nil([dataDic objectForKey:@"auto_id"]);
            model.content_name = OBJC_Nil([dataDic objectForKey:@"content_name"]);
            model.content_top = OBJC_Nil([dataDic objectForKey:@"content_top"]);
            model.content_collect = OBJC_Nil([dataDic objectForKey:@"content_collect"]);
            model.content_review = OBJC_Nil([dataDic objectForKey:@"content_review"]);
            model.content_class = OBJC_Nil([dataDic objectForKey:@"content_class"]);
            model.create_time = OBJC_Nil([dataDic objectForKey:@"create_time"]);
            for(NSDictionary * diction in OBJC_Nil([dataDic objectForKey:@"imgs"])){
                [model.imgs addObject:[diction objectForKey:@"content_img"]];
            }
            [Array addObject:model];
        }
        if(block){
            block(nil,YES,Array);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(block){
            block(error,NO,RequestFailed);
        }
    }];
}

/**
 *  @method     商家宝贝管理列表
 */
+ (void)corpBabyListWithUser:(NSString *)user Pwd:(NSString *)pwd Page:(NSInteger)page andCallBack:(RMAFNRequestManagerCallBack)block{
    //218.240.30.6/drzw/index.php?com=com_appService&method=appSev&app_com=com_ccenter&task=productList&per=1&row=10&page=1&ID=18513217782&PWD=202cb962ac59075b964b07152d234b70
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&page=%ld",baseUrl,@"&method=appSev&app_com=com_ccenter&task=productList&per=1&row=10",user,pwd,(long)page];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        NSMutableArray * Array = [[NSMutableArray alloc]init];
        NSArray * dataArray = OBJC_Nil([dic objectForKey:@"data"]);
        if([dataArray count]>0){
            for(NSDictionary * dataDic in dataArray){
                RMPublicModel * model = [[RMPublicModel alloc]init];
                model.status = [[dic objectForKey:@"status"] boolValue];
                model.msg = [dic objectForKey:@"msg"];
                model.auto_id = OBJC_Nil([dataDic objectForKey:@"auto_id"]);
                model.content_name = OBJC_Nil([dataDic objectForKey:@"content_name"]);
                model.content_price = OBJC_Nil([dataDic objectForKey:@"content_price"]);
                model.content_img = OBJC_Nil([dataDic objectForKey:@"content_img"]);
                model.is_shelf = OBJC_Nil([dataDic objectForKey:@"is_shelf"]);
                model.publish = OBJC_Nil([dataDic objectForKey:@"publish"]);
                
                [Array addObject:model];
            }
            if(block){
                block(nil,YES,Array);
            }

        }else{
            RMPublicModel * model = [[RMPublicModel alloc]init];
            model.status = [[dic objectForKey:@"status"] boolValue];
            model.msg = [dic objectForKey:@"msg"];
            
            if(block){
                block(nil,YES,model);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(block){
            block(error,NO,RequestFailed);
        }
    }];
}


/**
 *  @method     商家分类请求
 */
+ (void)corpbabyClassRequestWithUser:(NSString *)user Pwd:(NSString *)pwd andCallBack:(RMAFNRequestManagerCallBack)block{
    //218.240.30.6/drzw/index.php?com=com_appService&method=appSev&app_com=com_ccenter&task=memberClass&per=all&ID=demoker&PWD=e10adc3949ba59abbe56e057f20f883e
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&date=create_time&order=asc",baseUrl,@"&method=appSev&app_com=com_ccenter&task=memberClass&per=all",user,pwd];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        NSArray * dataArray = OBJC_Nil([dic objectForKey:@"data"]);
        NSMutableArray * array = [[NSMutableArray alloc]init];
        for(NSDictionary * dict in dataArray){
            RMPublicModel * model = [[RMPublicModel alloc] init];
            model.status = [[dict objectForKey:@"status"] boolValue];
            model.msg = [dict objectForKey:@"msg"];
            model.content_name = [dict objectForKey:@"content_name"];
            model.auto_id = [dict objectForKey:@"auto_id"];
            [array addObject:model];
        }
        if(block){
            block (nil,YES,array);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(block){
            block (error,NO,RequestFailed);
        }
    }];
    
}


/**
 *  @method     商家分类添加
 */
+ (void)corpbabyAddClassWithUser:(NSString *)user Pwd:(NSString *)pwd className:(NSString *)name andCallBack:(RMAFNRequestManagerCallBack)block{
    //218.240.30.6/drzw/index.php?com=com_appService&method=save&app_com=com_ccenter&task=addMemberClass&&frm[content_name]=123&ID=18513217782&PWD=e10adc3949ba59abbe56e057f20f883e
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&frm[content_name]=%@",baseUrl,@"&method=save&app_com=com_ccenter&task=addMemberClass",user,pwd,name];
   
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

/**
 *  @method     商家宝贝发布信息获取
 */
+ (void)babyPublishDataRequestWithUser:(NSString *)user Pwd:(NSString *)pwd Autoid:(NSString *)auto_id andCallBack:(RMAFNRequestManagerCallBack)block{
    //218.240.30.6/drzw/index.php?com=com_appService&method=appSev&app_com=com_ccenter&task=productView&auto_id=1&ID=18513217782&PWD=202cb962ac59075b964b07152d234b70
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&auto_id=%@",baseUrl,@"&method=appSev&app_com=com_ccenter&task=productView",user,pwd,auto_id];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        NSDictionary * dataDic = OBJC_Nil([dic objectForKey:@"data"]);
            RMPublicModel * model = [[RMPublicModel alloc]init];
            model.status = [[dic objectForKey:@"status"] boolValue];
            model.msg = [dic objectForKey:@"msg"];
            model.auto_id = OBJC_Nil([dataDic objectForKey:@"auto_id"]);
            model.content_name = OBJC_Nil([dataDic objectForKey:@"content_name"]);
            model.content_price = OBJC_Nil([dataDic objectForKey:@"content_price"]);
            model.content_img = OBJC_Nil([dataDic objectForKey:@"content_img"]);
            model.is_shelf = OBJC_Nil([dataDic objectForKey:@"is_shelf"]);
            model.publish = OBJC_Nil([dataDic objectForKey:@"publish"]);
            model.express_price = OBJC_Nil([dataDic objectForKey:@"express_price"]);
            model.content_express = OBJC_Nil([dataDic objectForKey:@"content_express"]);
            model.content_num = OBJC_Nil([dataDic objectForKey:@"content_num"]);
            model.member_name = OBJC_Nil([dataDic objectForKey:@"member_name"]);
            model.content_face = OBJC_Nil([dataDic objectForKey:@"content_face"]);
            model.is_sf = OBJC_Nil([dataDic objectForKey:@"is_sf"]);
            model.member_id = OBJC_Nil([dataDic objectForKey:@"member_id"]);
            model.content_desc = OBJC_Nil([dataDic objectForKey:@"content_desc"]);
            model.content_class = OBJC_Nil([dataDic objectForKey:@"content_class"]);
            model.member_class = OBJC_Nil([dataDic objectForKey:@"member_class"]);
            model.content_course = OBJC_Nil([dataDic objectForKey:@"content_course"]);
        
        for(NSDictionary * dict in OBJC_Nil([dataDic objectForKey:@"body"])){
            [model.body addObject:dict];
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

/**
 *  @method     商家宝贝发布
 */
+ (void)babyPublishWithUser:(NSString *)user Pwd:(NSString *)pwd Auto_id:(NSString *)auto_id newPhotoDic:(NSDictionary *)newPhotoDic modifyPhotoDic:(NSDictionary *)modifyPhotoDic otherDic:(NSDictionary *)otherDic andCallBack:(RMAFNRequestManagerCallBack)block {
    //218.240.30.6/drzw/index.php?com=com_appService&method=save&app_com=com_ccenter&task=updateProduct&frm[content_name]=123&frm[content_desc]=23123&frm[content_price]=23&frm[content_express]=23&frm[express_price]=23&frm[is_sf]=1&frm[content_num]=1&frm[content_class]=1&frm[content_course]=1000&frm[member_class]=,1,2,&&ID=18513217782&PWD=202cb962ac59075b964b07152d234b70
    NSLog(@"新添加的照片%@",newPhotoDic);
    NSLog(@"-------------------------------------------------------");
    NSLog(@"修改的图片%@",modifyPhotoDic);
    NSString * url = nil;
    if(auto_id == nil){
        url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@",baseUrl,@"&method=save&app_com=com_ccenter&task=updateProduct",user,pwd];
    }else{
        url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&auto_id=%@",baseUrl,@"&method=save&app_com=com_ccenter&task=updateProduct",user,pwd,auto_id];
    }
   
    [[RMHttpOperationShared sharedClient] POST:url parameters:otherDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for(NSString * key in [modifyPhotoDic allKeys]){
            [formData appendPartWithFileURL:[modifyPhotoDic objectForKey:key] name:[NSString stringWithFormat:@"frm[body][content_img][%@]",key] error:nil];
            NSLog(@"%@+++++++++",[NSString stringWithFormat:@"frm[body][auto_id][%@]",key]);
        }
        
        for(NSString * key in [newPhotoDic allKeys]){
            [formData appendPartWithFileURL:[newPhotoDic objectForKey:key] name:[NSString stringWithFormat:@"frm[body][content_img][%@]",key] error:nil];
            NSLog(@"%@==========%@",[NSString stringWithFormat:@"frm[body][content_img][%@]",key],[newPhotoDic objectForKey:key]);
        }
        
       
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

/**
 *  @method     宝贝上下架操作
 */
+ (void)babyShelfOperationWithUser:(NSString *)user Pwd:(NSString *)pwd upShelf:(BOOL)isUp Autoid:(NSString *)auto_id andCallBack:(RMAFNRequestManagerCallBack)block{
    //218.240.30.6/drzw/index.php?com=com_appService&method=save&app_com=com_ccenter&task=upproShelf&auto_id=1&ID=18513217782&PWD=202cb962ac59075b964b07152d234b70

    NSString * url = nil;
    if(isUp){
        url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&auto_id=%@",baseUrl,@"&method=save&app_com=com_ccenter&task=upproShelf",user,pwd,auto_id];
    }else{
        url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&auto_id=%@",baseUrl,@"&method=save&app_com=com_ccenter&task=downproShelf",user,pwd,auto_id];
    }
    
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


/**
 *  @method     我的收藏列表 收藏类型：1：帖子、2：店铺、3：宝贝
 */
+ (void)myCollectionRequestWithUser:(NSString *)user Pwd:(NSString *)pwd Type:(NSString *)type Page:(NSInteger)page andCallBack:(RMAFNRequestManagerCallBack)block{
    //218.240.30.6/drzw/index.php?com=com_appService&method=appSev&app_com=com_center&task=memberCollect&type=1&per=1&row=10&page=1&ID=test&PWD=202cb962ac59075b964b07152d234b70
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&page=%ld&type=%@",baseUrl,@"&method=appSev&app_com=com_center&task=memberCollect&per=1&row=10",user,pwd,(long)page,type];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        NSMutableArray * Array = [[NSMutableArray alloc]init];
        NSArray * dataArray = OBJC_Nil([dic objectForKey:@"data"]);
        for(NSDictionary * dataDic in dataArray){
            RMPublicModel * model = [[RMPublicModel alloc]init];
            model.status = [[dic objectForKey:@"status"] boolValue];
            model.msg = [dic objectForKey:@"msg"];
            
            if([type isEqualToString:@"1"]){//帖子
                NSDictionary * diction = OBJC([dataDic objectForKey:@"note"]);
                model.auto_id = OBJC_Nil([diction objectForKey:@"auto_id"]);
                model.content_name = OBJC_Nil([diction objectForKey:@"content_name"]);
                model.content_type = OBJC_Nil([diction objectForKey:@"content_type"]);
                model.content_class = OBJC_Nil([diction objectForKey:@"content_class"]);
                model.content_course = OBJC_Nil([diction objectForKey:@"content_course"]);
                
                model.content_collect = OBJC_Nil([diction objectForKey:@"content_collect"]);
                model.is_collect = OBJC_Nil([diction objectForKey:@"is_collect"]);
                model.content_review = OBJC_Nil([diction objectForKey:@"content_review"]);
                model.is_review = OBJC_Nil([diction objectForKey:@"is_review"]);
                model.member_name = OBJC_Nil([OBJC_Nil([diction objectForKey:@"member"]) objectForKey:@"member_name"]);
                model.content_face = OBJC_Nil([OBJC_Nil([diction objectForKey:@"member"]) objectForKey:@"content_face"]);
                model.content_gps = OBJC_Nil([OBJC_Nil([diction objectForKey:@"member"]) objectForKey:@"content_gps"]);
                
                for (NSDictionary * dict in OBJC_Nil([diction objectForKey:@"imgs"])){
                    [model.imgs addObject:dict];
                }
                
            }else if ([type isEqualToString:@"2"]){//店铺
                model.auto_id = OBJC_Nil([dataDic objectForKey:@"auto_id"]);
                model.member_id = OBJC_Nil([dataDic objectForKey:@"member_id"]);
                model.content_name = OBJC_Nil([OBJC_Nil([dataDic objectForKey:@"corp"]) objectForKey:@"content_name"]);
                model.content_face = OBJC_Nil([OBJC_Nil([dataDic objectForKey:@"corp"]) objectForKey:@"content_face"]);
            }else if ([type isEqualToString:@"3"]){//宝贝
                NSDictionary * diction = OBJC_Nil([dataDic objectForKey:@"product"]);
                model.auto_id = OBJC_Nil([diction objectForKey:@"auto_id"]);
                model.content_name = OBJC_Nil([diction objectForKey:@"member_id"]);
                model.content_price = OBJC_Nil([diction objectForKey:@"content_price"]) ;
                model.content_img = OBJC_Nil([diction objectForKey:@"content_img"]) ;
            }
            
            [Array addObject:model];
        }
        if(block){
            block(nil,YES,Array);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(block){
            block(error,NO,RequestFailed);
        }
    }];
}


/**
 *  @method     广告位置信息获取
 */
+ (void)corpAdvantageListRequestWithUser:(NSString *)user Pwd:(NSString *)pwd andCallBack:(RMAFNRequestManagerCallBack)block{
    //218.240.30.6/drzw/index.php?com=com_appService&method=appSev&app_com=com_ccenter&task=adlists&per=all&ID=18513217782&PWD=202cb962ac59075b964b07152d234b70
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@",baseUrl,@"&method=appSev&app_com=com_ccenter&task=adlists&per=all",user,pwd];
    [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        NSMutableArray * Array = [[NSMutableArray alloc]init];
        NSArray * dataArray = OBJC_Nil([OBJC_Nil([dic objectForKey:@"data"]) objectForKey:@"ads"]);
        for(NSDictionary * dataDic in dataArray){
            RMPublicModel * model = [[RMPublicModel alloc]init];
            model.status = [[dic objectForKey:@"status"] boolValue];
            model.msg = [dic objectForKey:@"msg"];
            model.auto_id = OBJC_Nil([dataDic objectForKey:@"auto_id"]);
            model.content_name = OBJC_Nil([dataDic objectForKey:@"content_name"]);
            model.content_price = OBJC_Nil([dataDic objectForKey:@"content_price"]);
            model.content_img = OBJC_Nil([dataDic objectForKey:@"content_img"]);
            model.num = [OBJC_Nil([dataDic objectForKey:@"num"]) integerValue];
            model.publish = OBJC_Nil([dataDic objectForKey:@"publish"]);
            model.balance = [[OBJC_Nil([dic objectForKey:@"data"]) objectForKey:@"balance"] doubleValue];
            [Array addObject:model];
        }
        if(block){
            block(nil,YES,Array);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(block){
            block(error,NO,RequestFailed);
        }
    }];
}

/**
 *  @method     广告位申请
 */
+ (void)corpAdvantageApplyWithUser:(NSString *)user Pwd:(NSString *)pwd Dic:(NSDictionary *)dic filePath:(NSURL *)filepath andCallBack:(RMAFNRequestManagerCallBack)block {
    //218.240.30.6/drzw/index.php?com=com_appService&method=save&app_com=com_ccenter&task=addAd&content_img=1&frm[position][]=1&frm[day][]=3&ID=18513217782&PWD=202cb962ac59075b964b07152d234b70
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@",baseUrl,@"&method=save&app_com=com_ccenter&task=addAd",user,pwd];

    [[RMHttpOperationShared sharedClient] POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileURL:filepath name:@"content_img" error:nil];
        NSLog(@"%@/n%@",formData,filepath);
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
///var/mobile/Containers/Data/Application/7DC6BD20-49C3-4676-8268-9EA38F5278E1/Documents/ilpCache/imagecache/content_img

/**
 *  @method     会员订单列表
 */
+ (void)myOrderListRequestWithUser:(NSString *)user Pwd:(NSString *)pwd isCorp:(BOOL)iscorp type:(NSString *)type Page:(NSInteger)page andCallBack:(RMAFNRequestManagerCallBack)block{
    //218.240.30.6/drzw/index.php?com=com_appService&method=appSev&app_com=com_pcenter&task=unorder&per=1&row=10&page=1&ID=test&PWD=202cb962ac59075b964b07152d234b70
    NSString * url = nil;
    if(iscorp){//商家
        url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&page=%ld&app_com=%@&task=%@",baseUrl,@"&method=appSev&per=1&row=10",user,pwd,(long)page,@"com_ccenter",type];
    }else{
        url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&page=%ld&app_com=%@&task=%@",baseUrl,@"&method=appSev&app_com=com_ccenter&task=productList&per=1&row=10",user,pwd,(long)page,@"com_pcenter",type];
    }
      [[RMHttpOperationShared sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        NSMutableArray * Array = [[NSMutableArray alloc]init];
        NSArray * dataArray = OBJC_Nil([dic objectForKey:@"data"]);
        for(NSDictionary * dataDic in dataArray){
            RMPublicModel * model = [[RMPublicModel alloc]init];
            model.status = [[dic objectForKey:@"status"] boolValue];
            model.msg = [dic objectForKey:@"msg"];
            model.auto_id = OBJC_Nil([dataDic objectForKey:@"auto_id"]);
            model.content_sn = OBJC_Nil([dataDic objectForKey:@"content_sn"]);
            model.content_status = OBJC_Nil([dataDic objectForKey:@"content_status"]);
            model.content_linkname = OBJC_Nil([dataDic objectForKey:@"content_linkname"]);
            model.content_address = OBJC_Nil([dataDic objectForKey:@"content_adress"]);
            model.content_mobile = OBJC_Nil([dataDic objectForKey:@"content_mobile"]);
            model.is_pay = OBJC_Nil([dataDic objectForKey:@"is_pay"]);//支付文字状态
            model.payment_id = OBJC_Nil([dataDic objectForKey:@"payment_id"]);
            model.content_total = OBJC_Nil([dataDic objectForKey:@"content_total"]);
            model.content_sn = OBJC_Nil([dataDic objectForKey:@"content_sn"]);
            model.content_realPay = OBJC_Nil([dataDic objectForKey:@"content_realPay"]);
            model.order_message = OBJC_Nil([dataDic objectForKey:@"order_message"]);
            model.corp_id = OBJC_Nil([dataDic objectForKey:@"content_id"]);
            model.corp = OBJC_Nil([dataDic objectForKey:@"corp"]);
            model.content_sn = OBJC_Nil([dataDic objectForKey:@"content_sn"]);
            model.mem = OBJC_Nil([dataDic objectForKey:@"mem"]);
            model.pros = OBJC_Nil([dataDic objectForKey:@"pros"]);
            model.is_status = OBJC_Nil([dataDic objectForKey:@"is_status"]);
            model.is_paystatus = OBJC_Nil([dataDic objectForKey:@"is_paystatus"]);
            model.create_time = OBJC_Nil([dataDic objectForKey:@"create_time"]);
            [Array addObject:model];
        }
        if(block){
            block(nil,YES,Array);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(block){
            block(error,NO,RequestFailed);
        }
    }];
}


/**
 *  用户会员取消或者确认收货
 */
+ (void)memberCancelOrSureOrderWithUser:(NSString *)user Pwd:(NSString *)pwd iscancel:(BOOL)iscancel orderId:(NSString *)orderid andCallBack:(RMAFNRequestManagerCallBack)block{
    //218.240.30.6/drzw/index.php?com=com_appService&method=save&app_com=com_pcenter&task=cancelOrder&orderid=3&ID=test&PWD=202cb962ac59075b964b07152d234b70
    NSString * url = nil;
    if(iscancel){//取消订单
        url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&orderid=%@",baseUrl,@"&method=save&app_com=com_pcenter&task=cancelOrder",user,pwd,orderid];
    }else{//确认收货
        url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&orderid=%@",baseUrl,@"&method=save&app_com=com_pcenter&task=orderDelivery",user,pwd,orderid];
    }
    
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

/**
 *  用户会员申请退货或者商家会员确认发货
 */
+ (void)memberReturnGoodsOrSureDeliveryWithUser:(NSString *)user Pwd:(NSString *)pwd isReturn:(BOOL)isreturn orderId:(NSString *)orderid expressName:(NSString *)expressname expressId:(NSString *)expressid andCallBack:(RMAFNRequestManagerCallBack)block{
    //218.240.30.6/drzw/index.php?com=com_appService&method=save&app_com=com_pcenter&task=saveReturnPro&auto_id=6&frm[express_name]=%E9%A1%BA%E4%B8%B0%E5%BF%AB%E9%80%92&frm[express_no]=1123&ID=test&PWD=202cb962ac59075b964b07152d234b70
    
    //218.240.30.6/drzw/index.php?com=com_appService&method=save&app_com=com_ccenter&task=orderDelivery&auto_id=4&frm[express_name]=%E9%A1%BA%E4%B8%B0%E5%BF%AB%E9%80%92&frm[express_no]=1123&&ID=18513217782&PWD=202cb962ac59075b964b07152d234b70
    
    
    NSString * url = nil;
    if(isreturn){//申请退货
        url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&auto_id=%@&frm[express_name]=%@&frm[express_no]=%@",baseUrl,@"&method=save&app_com=com_pcenter&task=saveReturnPro",user,pwd,orderid,expressname,expressid];
    }else{//商家确认发货
        url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&auto_id=%@&frm[express_name]=%@&frm[express_no]=%@",baseUrl,@"&method=save&app_com=com_ccenter&task=orderDelivery",user,pwd,orderid,expressname,expressid];
    }
    
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

/**
 *  商家准备备货，相当于商家会员接受这个订单
 */
+ (void)corpStockUpProductWithUser:(NSString *)user Pwd:(NSString *)pwd orderId:(NSString *)orderid andCallBack:(RMAFNRequestManagerCallBack)block{
    //218.240.30.6/drzw/index.php?com=com_appService&method=save&app_com=com_ccenter&task=changeStatus&orderid=4&ID=18513217782&PWD=202cb962ac59075b964b07152d234b70
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&orderid=%@",baseUrl,@"&method=save&app_com=com_ccenter&task=changeStatus",user,pwd,orderid];
    
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

/**
 *  商家会员签收退货
 */
+ (void)corpReturnSureWithUser:(NSString *)user Pwd:(NSString *)pwd orderId:(NSString *)orderid andCallBack:(RMAFNRequestManagerCallBack)block{
    //218.240.30.6/drzw/index.php?com=com_appService&method=save&app_com=com_ccenter&task=returnQs&orderid=6&ID=18513217782&PWD=202cb962ac59075b964b07152d234b70
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&orderid=%@",baseUrl,@"&method=save&app_com=com_ccenter&task=returnQs",user,pwd,orderid];
    
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

#pragma mark - 购物车库存验证
+ (void)valliateGoodsNumWithUser:(NSString *)user Pwd:(NSString *)pwd auto_id:(NSString *)auto_id Nums:(NSInteger)num andCallBack:(RMAFNRequestManagerCallBack)block{
    //218.240.30.6/drzw/index.php?com=com_appService&method=save&app_com=com_shop&task=addCart&plugin=com_shopProduct&num=1&auto_id=1
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&auto_id=%@&num=%ld",baseUrl,@"&method=save&app_com=com_shop&task=addCart&plugin=com_shopProduct",user,pwd,auto_id,(long)num];
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


#pragma mark - 提交订单接口
+ (void)commitOrderWithUser:(NSString *)user Pwd:(NSString *)pwd withDic:(NSDictionary *)dictionary andCallBack:(RMAFNRequestManagerCallBack)block{
     NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@",baseUrl,@"&method=save&app_com=com_pcenter&task=addOrder",user,pwd];
    [[RMHttpOperationShared sharedClient] POST:url parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

#pragma mark - 支付宝支付界面
+ (NSString *)alipayWithUser:(NSString *)user Pwd:(NSString *)pwd isDirectPurchase:(BOOL)isdirect Order_sn:(NSString *)order_sn{
     NSString * url = [NSString stringWithFormat:@"%@&order_sn=%@&ID=%@&PWD=%@",PayHttp,order_sn,user,pwd];
    return url;
}

@end
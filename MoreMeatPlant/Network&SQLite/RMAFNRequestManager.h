//
//  RMAFNRequestManager.h
//  RMVideo
//
//  Created by 润华联动 on 14-10-29.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMPublicModel.h"

typedef void (^RMAFNRequestManagerCallBack) (NSError * error, BOOL success, id object);

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
+ (void)getAdvertisingQueryWithType:(NSInteger)type callBack:(RMAFNRequestManagerCallBack)block;
/**
 *  @method     首页栏目
 */
+ (void)getHomeColumnsNumberCallBack:(RMAFNRequestManagerCallBack)block;

/**
 *  @method     植物分类 (家有鲜肉，播种育苗...)
 */
+ (void)getPlantClassificationWithxCallBack:(RMAFNRequestManagerCallBack)block;

/**
 *  @method     植物科目 (传值一：得 景天科，番杏科，仙人球... 传值二：得详细)
 *  @param      level       级别      1：一级：大全顶部分类，2:二级：侧滑分类
 */
+ (void)getPlantSubjectsListWithLevel:(NSInteger)level callBack:(RMAFNRequestManagerCallBack)block;

/**
 *  @method     News
 *  @param      pageCount       页数
 *  @param      optionid        类别 
 *      970（放毒区）971（一肉一拍）972（鲜肉市场）973（肉肉交换）977（新手教程）
 */
+ (void)getNewsWithOptionid:(NSInteger)optionid withPageCount:(NSInteger)pageCount callBack:(RMAFNRequestManagerCallBack)block;

/**
 *  @method     News    详情页
 *  @param      auto_id         新闻标识
 */
+ (void)getNewsDetailsWithAuto_id:(NSString *)auto_id callBack:(RMAFNRequestManagerCallBack)block;
/**
 *  @method     植物大全列表
 *  @param      pageCount       分页
 */
+ (void)getPlantDaqoListWithPageCount:(NSInteger)pageCount callBack:(RMAFNRequestManagerCallBack)block;

/**
 *  @method     植物大全详情页面
 *  @param      auto_id     植物标识
 */
- (void)getPlantDaqoDetailsWithAuto_id:(NSString *)auto_id;

/**
 *  @method     植物大全添加图片            未完成
 *  @param
 */
- (void)postPlantDaqoAddImage;

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
                                          withUserPassword:(NSString *)user_password;

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
                         callBack:(RMAFNRequestManagerCallBack)block;

/**
 *  @method     帖子最终
 *  @param      auto_id             标识
 *  @param      user_id             会员用户名
 *  @param      user_password       会员密码
 */
- (void)getPostsListDetailsWithAuto_id:(NSString *)auto_id
                           withUser_id:(NSString *)user_id
                     withUser_password:(NSString *)user_password;

/**
 *  @method     帖子评论列表
 *  @param      review_id       帖子标识
 *  @param      pageCount       页数
 */
- (void)getPostsCommentsListWithReview_id:(NSString *)review_id
                            withPageCount:(NSInteger)pageCount;

/**
 *  @method     帖子点赞       未完成
 */
- (void)PostPostsAddPraise;

/**
 *  @method     会员收藏
 *  @param
 */
- (void)postCollect;

/**
 *  @method     帖子评论
 */
- (void)postPostsAddComments;

/**
 *  @method     回复帖子评论
 */
- (void)postReplyToPostsComment;


/*************************************************************************/
/**
 *  @method     登录
 *  @param      user            用户名
 *  @param      pwd             密码 （md5编码之后的）
 */
+ (void)loginRequestWithUser:(NSString *)user Pwd:(NSString *)pwd andCallBack:(RMAFNRequestManagerCallBack)block;


+ (void)registerRequestWithUser:(NSString *)user Pwd:(NSString *)pwd Code:(NSString *)code Nick:(NSString *)nick Type:(NSString *)type Gps:(NSString *)gps andCallBack:(RMAFNRequestManagerCallBack)block;
+ (void)registerSendCodeWith:(NSString *)mobile andCallBack:(RMAFNRequestManagerCallBack)block;
+ (void)forgotPwdSendCodeWith:(NSString *)mobile andCallBack:(RMAFNRequestManagerCallBack)block;

+ (void)resetPwdRequestWithUser:(NSString *)user Pwd:(NSString *)pwd Code:(NSString *)code andCallBack:(RMAFNRequestManagerCallBack)block;

@end

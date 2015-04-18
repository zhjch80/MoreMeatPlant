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
+ (void)getAdvertisingQueryWithType:(NSInteger)type
                           callBack:(RMAFNRequestManagerCallBack)block;
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
+ (void)getPlantSubjectsListWithLevel:(NSInteger)level
                             callBack:(RMAFNRequestManagerCallBack)block;

/**
 *  @method     News
 *  @param      pageCount       页数
 *  @param      optionid        类别 
 *      970（放毒区）971（一肉一拍）972（鲜肉市场）973（肉肉交换）977（新手教程）
 */
+ (void)getNewsWithOptionid:(NSInteger)optionid
              withPageCount:(NSInteger)pageCount
                   callBack:(RMAFNRequestManagerCallBack)block;

/**
 *  @method     News    详情页
 *  @param      auto_id         新闻标识
 */
+ (void)getNewsDetailsWithAuto_id:(NSString *)auto_id
                         callBack:(RMAFNRequestManagerCallBack)block;
/**
 *  @method     植物大全列表
 *  @param      pageCount           分页
 *  @param      classification      植物科目
 */
+ (void)getPlantDaqoListWithSubPlantClassification:(NSString *)classification
                                     withPageCount:(NSInteger)pageCount
                                          callBack:(RMAFNRequestManagerCallBack)block;

/**
 *  @method     植物大全详情页面
 *  @param      auto_id     植物标识
 */
+ (void)getPlantDaqoDetailsWithAuto_id:(NSString *)auto_id
                              callBack:(RMAFNRequestManagerCallBack)block;

/**
 *  @method     植物大全添加图片
 *  @param      all_id          植物标识
 *  @param      content_img     图片路径字符串
 *  @param      user_id         会员用户名
 *  @param      user_password   会员密码
 */
+ (void)postPlantDaqoAddImageWithAll_id:(NSString *)all_id
                     withContent_img:(NSString *)content_img
                              withID:(NSString *)user_id
                             withPWD:(NSString *)user_password
                            callBack:(RMAFNRequestManagerCallBack)block;

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
                                          withUserPassword:(NSString *)user_password callBack:(RMAFNRequestManagerCallBack)block;

/**
 *  @method     帖子列表
 *  @param      postsType       帖子分类 1:防毒区、2:肉肉交换
 *  @param      plantType       植物分类
 *  @param      plantSubjects   植物科目
 *  @param      pageCount       页数
 *  @param      user_id         会员用户名
 *  @param      user_password   会员密码
 *  @param      member_id       会员标示
 */
+ (void)getPostsListWithPostsType:(NSString *)postsType
                    withPlantType:(NSString *)plantType
                withPlantSubjects:(NSString *)plantSubjects
                    withPageCount:(NSInteger)pageCount
                      withUser_id:(NSString *)user_id
                withUser_password:(NSString *)user_password
                     withMemberId:(NSString *)member_id
                         callBack:(RMAFNRequestManagerCallBack)block;

/**
 *  @method     帖子最终
 *  @param      auto_id             标识
 *  @param      user_id             会员用户名      不是必须
 *  @param      user_password       会员密码       不是必须
 */
+ (void)getPostsListDetailsWithAuto_id:(NSString *)auto_id
                           withUser_id:(NSString *)user_id
                     withUser_password:(NSString *)user_password callBack:(RMAFNRequestManagerCallBack)block;

/**
 *  @method     宝贝列表
 *  @param      plantClass      宝贝分类    1、为一肉一拍 2、鲜肉市场
 *  @param      plantCourse     植物科目
 *  @param      corp_id         商家标示
 *  @param      memberClass     商家分类标示
 *  @param      pageCount       分页
 */
+ (void)getBabyListWithPlantClassWith:(NSInteger)plantClass
                           withCourse:(NSString *)plantCourse
                       withMemerClass:(NSString *)memberClass
                           withCorpid:(NSString *)corp_id
                            withCount:(NSInteger)pageCount
                             callBack:(RMAFNRequestManagerCallBack)block;

/**
 *  @method     宝贝列表详情
 *  @param      auto_id         宝贝标识
 */
+ (void)getBabyListDetalisWithAuto_id:(NSString *)auto_id
                             callBack:(RMAFNRequestManagerCallBack)block;

/**
 *  @method     帖子评论列表
 *  @param      review_id       帖子标识
 *  @param      pageCount       页数
 */
+ (void)getPostsCommentsListWithReview_id:(NSString *)review_id
                            withPageCount:(NSInteger)pageCount
                                 callBack:(RMAFNRequestManagerCallBack)block;

/**
 *  @method     帖子点赞
 *  @param      auto_id             帖子标识
 *  @param      user_id             用户名
 *  @param      user_password       用户密码
 */
+ (void)getPostsAddPraiseWithAuto_id:(NSString *)auto_id
                               withID:(NSString *)user_id
                              withPWD:(NSString *)user_password
                             callBack:(RMAFNRequestManagerCallBack)block;

/**
 *  @method     会员收藏
 *  @param      collect_id          收藏的标识
 *  @param      content_type        收藏类型：1：帖子、2：店铺、3：宝贝
 *  @param      user_id             会员用户名
 *  @param      password            会员密码
 */
+ (void)getMembersCollectWithCollect_id:(NSString *)collect_id
                        withContent_type:(NSString *)content_type
                                  withID:(NSString *)user_id
                                 withPWD:(NSString *)user_password
                                callBack:(RMAFNRequestManagerCallBack)block;

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
                                 callBack:(RMAFNRequestManagerCallBack)block;

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
                                     callBack:(RMAFNRequestManagerCallBack)block;

/**
 *  @method     匿名提交升级建议
 *  @param      title
 *  @param      content
 */
+ (void)postAnonymousSubmissionsUpgradeSuggestionsWithContent_title:(NSString *)title
                                                   withContent_body:(NSString *)content
                                                           callBack:(RMAFNRequestManagerCallBack)block;

/**
 *  @method         放毒区详情举报帖子
 *  @param          user_id                 会员名
 *  @param          user_password           会员密码
 *  @param          note_id                 帖子标识
 *  @param          note_content            举报内容
 */
+ (void)getReleasePoisonDetailsToReportWithID:(NSString *)user_id
                                       withPWD:(NSString *)user_password
                                   wirhNote_id:(NSString *)note_id
                              withNote_content:(NSString *)note_content
                                      callBack:(RMAFNRequestManagerCallBack)block;

/*
 *  @method             发布帖子
 *  @param          auto_id             如果是编辑传 帖子标识字段,不传代表新建
 *  @param          content_name        帖子标题
 *  @param          content_type        帖子分类1：放毒区，2:肉肉交换
 *  @param          content_class       植物分类
 *  @param          content_course      植物科目
 *  @param          content_body        帖子内容文字,多个重复传此值
 *  @param          content_img         帖子内容图片,多个重复传此值
 *  @param          bodyAuto_id         帖子内容标识字段,不传代表新建，多个重复传此值
 *  @param          user_id             会员用户名
 *  @param          user_password       会员密码
 */
+ (void)postSendPostsWithAuto_id:(NSString *)auto_id
                 withContentName:(NSString *)content_name
                 withContentType:(NSString *)content_type
                withContentClass:(NSString *)content_class
               withContentCourse:(NSString *)content_course
                 withContentBody:(NSString *)content_body
                  withContentImg:(NSDictionary *)content_img
                 withBodyAuto_id:(NSString *)bodyAuto_id
                          withID:(NSString *)user_id
                         withPWD:(NSString *)user_password
                        callBack:(RMAFNRequestManagerCallBack)block;
    
/*************************************************************************/
/**
 *  @method     登录
 *  @param      user            用户名
 *  @param      pwd             密码 （md5编码之后的）
 */
+ (void)loginRequestWithUser:(NSString *)user Pwd:(NSString *)pwd Gps:(NSString *)gps andCallBack:(RMAFNRequestManagerCallBack)block;

/**
 *  注册
 *
 *  @param user  用户手机号
 *  @param pwd   密码
 *  @param code  验证码
 *  @param nick  昵称
 *  @param type  注册会员类型
 *  @param gps   位置信息，经纬度
 *  @param block 回调
 */
+ (void)registerRequestWithUser:(NSString *)user Pwd:(NSString *)pwd Code:(NSString *)code Nick:(NSString *)nick Type:(NSString *)type Gps:(NSString *)gps YPWD:(NSString *)ypwd andCallBack:(RMAFNRequestManagerCallBack)block;

/**
 *  注册发送验证码
 *
 *  @param mobile 手机号
 *  @param block  回调
 */
+ (void)registerSendCodeWith:(NSString *)mobile andCallBack:(RMAFNRequestManagerCallBack)block;

/**
 *  忘记密码发送验证码
 *
 *  @param mobile 手机号
 *  @param block  回调
 */
+ (void)forgotPwdSendCodeWith:(NSString *)mobile andCallBack:(RMAFNRequestManagerCallBack)block;

#pragma mark - 重设密码
/**
 *  重设密码
 *
 *  @param user  用户手机号
 *  @param pwd   新密码
 *  @param code  验证码
 *  @param block 回调处理
 */
+ (void)resetPwdRequestWithUser:(NSString *)user Pwd:(NSString *)pwd Code:(NSString *)code andCallBack:(RMAFNRequestManagerCallBack)block;

#pragma mark - 资料修改
/**
 *  资料修改（支付宝账户、签名修改）
 *
 *  @param user      用户手机号
 *  @param pwd       密码
 *  @param type      用户类型
 *  @param alipayno  支付宝账户名
 *  @param signature 签名
 *  @param dic 头像图片上传
 */
+ (void)myInfoModifyRequestWithUser:(NSString *)user Pwd:(NSString *)pwd Type:(NSString *)type AlipayNo:(NSString *)alipayno Signature:(NSString *)signature Dic:(NSDictionary *)dic andCallBack:(RMAFNRequestManagerCallBack)block;

/**
 *  获取个人信息
 *
 *  @param user 用户名（手机号）
 *  @param pwd  密码
 */
+ (void)myInfoRequestWithUser:(NSString *)user Pwd:(NSString *)pwd andCallBack:(RMAFNRequestManagerCallBack)block;;

/**
 *  修改密码
 *
 *  @param user    用户名
 *  @param pwd     密码
 *  @param newpass 新密码
 */
+ (void)passwordModifyWithUser:(NSString *)user Pwd:(NSString *)pwd NewPass:(NSString *)newpass andCallBack:(RMAFNRequestManagerCallBack)block;;

/**
 *  用户地址列表请求
 *
 *  @param user 用户名
 *  @param pwd  密码
 */
+ (void)addressRequestWithUser:(NSString *)user Pwd:(NSString *)pwd andCallBack:(RMAFNRequestManagerCallBack)block;;

/**
 *  地址详情
 *
 *  @param user    用户名
 *  @param pwd     密码
 *  @param auto_id 地址唯一标示auto_id
 */
+ (void)addressDetailRequestWithUser:(NSString *)user Pwd:(NSString *)pwd Autoid:(NSString *)auto_id andCallBack:(RMAFNRequestManagerCallBack)block;;

/**
 *  地址编辑或者新建
 *
 *  @param user    用户名
 *  @param pwd     密码
 *  @param auto_id    编辑还是新建？auto_id==nil,表示新建
 *  @param name    联系人姓名
 *  @param mobile  联系人手机
 *  @param address 联系人详细地址
 */
+ (void)addressEditOrNewPostWithUser:(NSString *)user Pwd:(NSString *)pwd Autoid:(NSString *)auto_id ContactName:(NSString *)name Mobile:(NSString *)mobile Address:(NSString *)address andCallBack:(RMAFNRequestManagerCallBack)block;

/**
 *  我的钱包信息
 *
 *  @param user 用户
 *  @param pwd  密码
 */
+ (void)mywalletInfoRequestWithUser:(NSString *)user Pwd:(NSString *)pwd andCallBack:(RMAFNRequestManagerCallBack)block;;

/**
 *  余额转花币
 *
 *  @param user 用户名
 *  @param pwd  密码
 *  @param num  数量
 */
+ (void)yu_eTurnHuabiWithUser:(NSString *)user Pwd:(NSString *)pwd Number:(NSString *)num andCallBack:(RMAFNRequestManagerCallBack)block;;

/**
 *  会员之间转账
 *
 *  @param user  用户名
 *  @param pwd   密码
 *  @param other 另外会员名
 */
+ (void)memberTransforWithUser:(NSString *)user Pwd:(NSString *)pwd ToOtherMember:(NSString *)other Number:(NSString *)num andCallBack:(RMAFNRequestManagerCallBack)block;

/**
 *  提现
 *
 *  @param user 用户名
 *  @param pwd  密码
 *  @param num  数量
 */
+ (void)memberWithdrawalWithUser:(NSString *)user Pwd:(NSString *)pwd Code:(NSString *)code Number:(NSString *)num andCallBack:(RMAFNRequestManagerCallBack)block;

/**
 *  提现发送验证码
 *
 *  @param mobile 手机
 *  @param block  回调
 */
+ (void)withdrawalSendCode:(NSString *)mobile andCallBack:(RMAFNRequestManagerCallBack)block;

/**
 *  账户
 *
 *  @param user  用户名
 *  @param pwd   密码
 *  @param page  页数
 *  @param block 回调
 */
+ (void)billRecordRequest:(NSString *)user Pwd:(NSString *)pwd page:(NSInteger)page andCallBack:(RMAFNRequestManagerCallBack)block;

/**
 *  系统消息
 *
 *  @param user  用户名
 *  @param pwd   密码
 *  @param page  页数
 *  @param block 回调
 */
+ (void)systemMessageWithUser:(NSString *)user Pwd:(NSString *)pwd page:(NSInteger)page andCallBack:(RMAFNRequestManagerCallBack)block;

/**
 *  系统消息
 *
 *  @param user    用户
 *  @param pwd     密码
 *  @param auto_id 唯一标示
 */
+ (void)systemMessageDetailWithUser:(NSString *)user Pwd:(NSString *)pwd Auto_id:(NSString *)auto_id andCallBack:(RMAFNRequestManagerCallBack)block;

/**
 *  我的主页（我的帖子列表）
 *
 *  @param user 用户
 *  @param pwd  密码
 *  @param page 页数
 */
+ (void)memberPostlistWithUser:(NSString *)user Pwd:(NSString *)pwd Page:(NSInteger)page andCallBack:(RMAFNRequestManagerCallBack)block;

/**
 *  用户会员取消或者确认收货
 *
 *  @param user     用户名
 *  @param pwd      密码
 *  @param iscancel 是否取消订单或者确认收货
 *  @param orderid  订单标示
 */
+ (void)memberCancelOrSureOrderWithUser:(NSString *)user Pwd:(NSString *)pwd iscancel:(BOOL)iscancel orderId:(NSString *)orderid andCallBack:(RMAFNRequestManagerCallBack)block;

/****************************公用*************************/

/**
 *  我的收藏
 *
 *  @param user 用户名
 *  @param pwd  密码
 *  @param type 收藏（宝贝、店铺、帖子）
 *  @param page 页数
 */
+ (void)myCollectionRequestWithUser:(NSString *)user Pwd:(NSString *)pwd Type:(NSString *)type Page:(NSInteger)page andCallBack:(RMAFNRequestManagerCallBack)block;

/**
 *  我的订单
 *
 *  @param user   用户名
 *  @param pwd    密码
 *  @param iscorp 是否是商家
 *  @param type   unorder (等待发货的订单) unpayorder（未支付的订单）onorder（已发货的订单）okorder（已完成的订单）returnorder(退货订单)
 *  @param page   页数
 *  @param block  回调
 */
+ (void)myOrderListRequestWithUser:(NSString *)user Pwd:(NSString *)pwd isCorp:(BOOL)iscorp type:(NSString *)type Page:(NSInteger)page andCallBack:(RMAFNRequestManagerCallBack)block;

/**
 *  用户会员申请退货或者商家会员确认发货
 *
 *  @param user     用户名
 *  @param pwd      密码
 *  @param isreturn 是否退货，或者确认发货
 *  @param orderid  订单产品标示
 *  @param expressname  快递名称
 *  @param expressid  快递编号
 *  @param block    回调
 */
+ (void)memberReturnGoodsOrSureDeliveryWithUser:(NSString *)user Pwd:(NSString *)pwd isReturn:(BOOL)isreturn orderId:(NSString *)orderid expressName:(NSString *)expressname expressId:(NSString *)expressid andCallBack:(RMAFNRequestManagerCallBack)block;

/****************************商家*************************/

/**
 *  商家宝贝列表
 *
 *  @param user  用户名
 *  @param pwd   密码
 *  @param page  页数
 *  @param block 回调
 */
+ (void)corpBabyListWithUser:(NSString *)user Pwd:(NSString *)pwd Page:(NSInteger)page andCallBack:(RMAFNRequestManagerCallBack)block;

/**
 *  商家会员分类请求
 *
 *  @param user  用户名
 *  @param pwd   密码
 *  @param block 回调
 */
+ (void)corpbabyClassRequestWithUser:(NSString *)user Pwd:(NSString *)pwd andCallBack:(RMAFNRequestManagerCallBack)block;

/**
 *  商家会员分类增加
 *
 *  @param user
 *  @param pwd
 *  @param name     添加的分类名称
 *  @param block 
 */
+ (void)corpbabyAddClassWithUser:(NSString *)user Pwd:(NSString *)pwd className:(NSString *)name andCallBack:(RMAFNRequestManagerCallBack)block;

/**
 *  商家会员宝贝编辑界面的数据请求
 *
 *  @param user    用户名
 *  @param pwd     密码
 *  @param auto_id 标示
 *  @param block   回调
 */
+ (void)babyPublishDataRequestWithUser:(NSString *)user Pwd:(NSString *)pwd Autoid:(NSString *)auto_id andCallBack:(RMAFNRequestManagerCallBack)block;



/**
 *  宝贝发布/编辑
 *
 *  @param user   用户名
 *  @param pwd    密码
 *  @param auto_id 宝贝标示，nil表示新发布，否则为编辑
 *  @param newPhotoDic       新发布的图片信息
 *  @param modifyPhotoDic    修改的图片信息
 *  @param otherDic          其他post信息
 *  @param block  回调
 */
+ (void)babyPublishWithUser:(NSString *)user Pwd:(NSString *)pwd Auto_id:(NSString *)auto_id newPhotoDic:(NSDictionary *)newPhotoDic modifyPhotoDic:(NSDictionary *)modifyPhotoDic otherDic:(NSDictionary *)otherDic andCallBack:(RMAFNRequestManagerCallBack)block;

/**
 *  宝贝上下架处理
 *
 *  @param user    用户名
 *  @param pwd     密码
 *  @param isUp    YES表示上架 NO表示下架
 *  @param auto_id 唯一标示
 *  @param block   回调
 */
+ (void)babyShelfOperationWithUser:(NSString *)user Pwd:(NSString *)pwd upShelf:(BOOL)isUp Autoid:(NSString *)auto_id andCallBack:(RMAFNRequestManagerCallBack)block;

/**
 *  广告位信息查询
 *
 *  @param user  用户名
 *  @param pwd   密码
 *  @param block 回调
 */
+ (void)corpAdvantageListRequestWithUser:(NSString *)user Pwd:(NSString *)pwd andCallBack:(RMAFNRequestManagerCallBack)block;

/**
 *  商家申请广告位
 *
 *  @param user  用户名
 *  @param pwd   密码
 *  @param dic   需要上传的信息
 *  @param filepath   图像的文件路径
 *  @param block 回调
 */
+ (void)corpAdvantageApplyWithUser:(NSString *)user Pwd:(NSString *)pwd Dic:(NSDictionary *)dic filePath:(NSURL *)filepath andCallBack:(RMAFNRequestManagerCallBack)block ;


/**
 *  商家准备备货，相当于商家会员接受这个订单
 *
 *  @param user    用户名
 *  @param pwd     密码
 *  @param orderid 订单标示
 *  @param block   回调
 */
+ (void)corpStockUpProductWithUser:(NSString *)user Pwd:(NSString *)pwd orderId:(NSString *)orderid andCallBack:(RMAFNRequestManagerCallBack)block;

/**
 *  商家会员签收退货
 *
 *  @param user    用户名
 *  @param pwd     密码
 *  @param orderid 退货清单标示
 *  @param block   回调
 */
+ (void)corpReturnSureWithUser:(NSString *)user Pwd:(NSString *)pwd orderId:(NSString *)orderid andCallBack:(RMAFNRequestManagerCallBack)block;

/**
 *  购物车库存验证接口
 *
 *  @param user
 *  @param pwd
 *  @param auto_id 宝贝id
 *  @param num     数量
 *  @param block   回调
 */
+ (void)valliateGoodsNumWithUser:(NSString *)user Pwd:(NSString *)pwd auto_id:(NSString *)auto_id Nums:(NSInteger)num andCallBack:(RMAFNRequestManagerCallBack)block;
//218.240.30.6/drzw/index.php?com=com_appService&method=save&app_com=com_pcenter&task=addOrder&auto_id=1,2&num=1,2&express=2,1&frm[payment_id]=1&frm[content_linkname]=1&frm[content_mobile]=15110511214&frm[content_address]=111111111111&&ID=test&PWD=e10adc3949ba59abbe56e057f20f883e
/**
 *  提交订单
 *
 *  @param user
 *  @param pwd
 *  @param dictionary 用户的地址等一系列信息，包括支付方式
 *  @param block
 */
+ (void)commitOrderWithUser:(NSString *)user Pwd:(NSString *)pwd withDic:(NSDictionary *)dictionary andCallBack:(RMAFNRequestManagerCallBack)block;

/**
 *  支付宝支付接口
 *
 *  @param user
 *  @param pwd
 *  @param isdirect 是否直接购买
 *  @param order_sn 订单号
 *  @param type 充值还是付款
 *  @param content_money 充值金额
 */
+ (NSString *)alipayWithUser:(NSString *)user Pwd:(NSString *)pwd content_type:(NSString *)type isDirectPurchase:(BOOL)isdirect Order_sn:(NSString *)order_sn content_money:(NSString *)content_money;

/**
 *  获取店铺主页头部信息
 *
 *  @param auto_id 商家会员唯一标示
 */
+ (void)getCorpHomeInfoWithAuto_id:(NSString *)auto_id andCallBack:(RMAFNRequestManagerCallBack)block;
/**
 *  获取我的帖子主页
 *
 *  @param auto_id 用户会员唯一标示
 */
+ (void)getUserHomeInfoWithAuto_id:(NSString *)auto_id andCallBack:(RMAFNRequestManagerCallBack)block;

/**
 *  获取物流信息
 *
 *  @param name 快递名称
 *  @param no   快递单号
 *
 *  @return url
 */
+ (NSString *)getWuliuUrlWithExpressName:(NSString *)name no:(NSString *)no;

/**
 *  获取附近店铺
 *
 */
+ (void)nearCorpRequestwithCoor:(NSString *)coor andCallBack:(RMAFNRequestManagerCallBack)block;
/**
 *  获取附近肉友
 *
 */
+ (void)nearMemberRequestwithCoor:(NSString *)coor andCallBack:(RMAFNRequestManagerCallBack)block;

/**
 *  关注某人
 *
 *  @param auto_id 某人标示
 *  @param block   回调
 */
+ (void)attentionFriendRequestWithUser:(NSString *)user Pwd:(NSString *)pwd withOtherId:(NSString *)auto_id andCallBack:(RMAFNRequestManagerCallBack)block;

@end

//
//  RMPublicModel.h
//  RMVideo
//
//  Created by 润华联动 on 14-10-30.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STDbHandle.h"              //数据库操作

@interface RMPublicModel : STDbObject
@property (nonatomic, assign) BOOL  status;
@property (nonatomic, copy) NSString * msg;

@property (nonatomic, copy) NSString * content_name;        //广告名称、植物大全名称、帖子标题
@property (nonatomic, copy) NSString * content_img;         //广告图片URL、植物大全图集图片、植物科目图片
@property (nonatomic, copy) NSString * content_title;
@property (nonatomic, copy) NSString * content_url;         //待补充 广告链接URL
@property (nonatomic, copy) NSString * modules_name;        //栏目名称、植物科目名称
@property (nonatomic, copy) NSString * modules_img;         //栏目图片URL、植物大全图片
@property (nonatomic, copy) NSString * content_num;         //栏目数量
@property (nonatomic, copy) NSString * auto_id;             //大全返回来的标识
@property (nonatomic, copy) NSString * content_bimg;        //植物大全详情页面最终图片
@property (nonatomic, copy) NSString * family_name;         //景天科
@property (nonatomic, copy) NSString * latin_name;          //拉丁文
@property (nonatomic, copy) NSString * content_plant1;      //种植（浇水）
@property (nonatomic, copy) NSString * content_plant2;      //种植（阳光）
@property (nonatomic, copy) NSString * content_breed;       //繁殖
@property (nonatomic, copy) NSString * content_desc;        //简介
@property (nonatomic, copy) NSString * auto_code;           //植物科目标识
@property (nonatomic, copy) NSArray * sub;           //二级分类
@property (nonatomic, copy) NSString * content_body;        //新闻内容
@property (nonatomic, copy) NSString * create_time;         //新闻发布时间
@property (nonatomic, copy) NSString * content_top;         //点赞数
@property (nonatomic, copy) NSString * content_collect;     //收藏数
@property (nonatomic, copy) NSString * content_review;      //评论数
@property (nonatomic, copy) NSString * content_class;       //植物分类
@property (nonatomic, copy) NSString * content_course;       //植物科目

@property (nonatomic, copy) NSString * member;              //会员信息，member_name:会员昵称,content_face:会员头像
@property (nonatomic, copy) NSMutableArray * imgs;                //列表图片数组，3种前台展示形式,根据图片数量判断
@property (nonatomic, copy) NSString * is_review;           //是否评论 ，如果不存在代表没评论，如果等于1代表评论了
@property (nonatomic, copy) NSString * is_top;              //是否点赞 ，如果不存在代表没点赞，如果等于1代表点赞了
@property (nonatomic, copy) NSString * is_collect;          //是否收藏 ，如果不存在代表没收藏，如果等于1代表收藏了
@property (nonatomic, copy) NSMutableArray * body;                //帖子内容按照顺序，有图片的展示图片，没图片的展示 内容
@property (nonatomic, copy) NSString * member_id;           //商家会员标识
@property (nonatomic, copy) NSString * auto_position;       //位置
@property (nonatomic, copy) NSString * change_img;          //已点击的状态
@property (nonatomic, copy) NSString * label;               //植物分类 （家有鲜肉，播种育苗...）
@property (nonatomic, copy) NSString * value;               //植物分类 对应的标识
@property (nonatomic, copy) NSString * view_link;           //链接


@property (nonatomic, copy) NSString * s_type;              //登录用户类型


@property (nonatomic, strong) NSString *contentMobile;      //会员手机号
@property (nonatomic, strong) NSString *levelId;            //商家店铺级别
@property (nonatomic, strong) NSString *contentAddress;     //商家地址
@property (nonatomic, strong) NSString *contentEmail;       //联系邮箱
@property (nonatomic, strong) NSString *contentContact;     //商家联系电话
@property (nonatomic, strong) NSString *contentUser;        //用户名
@property (nonatomic, assign) double balance;               //余额
@property (nonatomic, strong) NSString *zfbNo;              //支付宝账号
@property (nonatomic, assign) double spendmoney;            //花币余额
@property (nonatomic, strong) NSString *contentName;        //昵称
@property (nonatomic, strong) NSString *contentQm;          //签名
@property (nonatomic, strong) NSString *contentFace;        //会员头像
@property (nonatomic, strong) NSString *contentGps;         //会员位置
@property (nonatomic, strong) NSString *contentLinkname;    //商家负责人

@property (nonatomic, retain) NSString * content_value;     //收支金额
@property (nonatomic, retain) NSString * content_status;    //收支状态
@property (nonatomic, retain) NSString * content_item;      //具体内容

@property (nonatomic, retain) NSString * msg_title;     //消息标题
@property (nonatomic, retain) NSString * msg_text;      //消息内容
@property (nonatomic, retain) NSString * msg_read;      //读取状态

@property (nonatomic, retain) NSString * content_price;     //宝贝价格
@property (nonatomic, retain) NSString * is_shelf;      //宝贝上下架状态
@property (nonatomic, retain) NSString * publish;      //宝贝审核状态（1：已审核，0：未审核）已审核:在前台可以查询，下架宝贝  未审核:可以再会员中心编辑宝贝，申请上架

@property (nonatomic, retain) NSString * content_express;      //快递名称
@property (nonatomic, retain) NSString * express_price;      //快递费用
@property (nonatomic, retain) NSString * is_sf;      //是否使用顺丰快递，1：代表使用，0：代表不使用
@property (nonatomic, retain) NSString * member_class;      //会员默认分类，多个用“，”号隔开

@property (nonatomic, retain) NSString * content_face;      //会员头像
@property (nonatomic, retain) NSString * member_name;       //会员昵称

@property (nonatomic, retain) NSString * content_type;      //类型
@property (nonatomic, retain) NSString * content_gps;       //会员位置gps

@property (nonatomic, assign) NSInteger num;                //广告位数量/商品数量
@property (nonatomic, assign) NSInteger textField_value;    //申请广告位的天数
@property (nonatomic, copy) NSMutableDictionary * members;       //会员信息
@property (nonatomic, copy) NSString * content_grow;
@property (nonatomic, copy) NSString * create_user;
@property (nonatomic, copy) NSString * series;



@end

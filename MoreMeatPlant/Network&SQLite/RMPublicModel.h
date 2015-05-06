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
@property (nonatomic, copy) NSString * m_user;              //用户名

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
@property (nonatomic, retain) NSString *content_user;       //存放用户名

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
@property (nonatomic, copy) NSArray * returns;          //回复list

@property (nonatomic, retain) NSString * express;//提交订单，快递类型1，2，2，2，1
@property (nonatomic, retain) NSString * payment_id;//支付方式

@property (retain, nonatomic) NSString * content_linkname;
@property (retain, nonatomic) NSString * content_mobile;
@property (retain, nonatomic) NSString * content_address;

@property (retain, nonatomic) NSString * content_sn;    //订单编号
@property (retain, nonatomic) NSString * is_pay;        //支付状态
@property (retain, nonatomic) NSString * is_status;     //订单状态（0未处理1待发货2已
                                                        //发货3已签收4已取消5已完成）如果是退货清单（0已退货,等待商家确认1退货已完成）
@property (retain, nonatomic) NSString * is_comment;    //yes表示已经评论
@property (retain, nonatomic) NSString * is_return;     //yes表示已经退货
@property (retain, nonatomic) NSString * is_paystatus;  //支付状态
@property (retain, nonatomic) NSString * member_user;   //会员用户名
@property (retain, nonatomic) NSString * content_total; //订单金额
@property (retain, nonatomic) NSString * content_realPay;//实际支付,暂不用
@property (retain, nonatomic) NSString * express_no;    //快递单号
@property (retain, nonatomic) NSString * express_name;  //快递名称
@property (retain, nonatomic) NSString * expresspay;    //快递费用
@property (retain, nonatomic) NSDictionary * corp;      //店铺信息
@property (retain, nonatomic) NSString * corp_id;       //商家id
@property (retain, nonatomic) NSDictionary * mem;       //会员信息
@property (retain, nonatomic) NSArray * pros;    //商品信息
@property (retain, nonatomic) NSString * order_message;  //订单备注,暂不用

@property (retain, nonatomic) NSMutableArray * classs;  //商家店铺分类


@property (retain, nonatomic) NSString * content_x;//
@property (retain, nonatomic) NSString * content_y;

@property (retain, nonatomic) NSString * card_photo;//身份证
@property (retain, nonatomic) NSString * corp_photo;//店铺背景


@property (retain, nonatomic) NSString * is_redirect;//如果为1，提交订单直接跳转到支付宝接口，如果是0，直接跳转到会员订单列表

@property (retain, nonatomic) NSString * note_id;

@property (retain, nonatomic) NSString * comment_num;//评论级别1-4

@property (retain, nonatomic) NSString * order_id;
@end

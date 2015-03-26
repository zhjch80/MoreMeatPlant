//
//  RMPublicModel.h
//  RMVideo
//
//  Created by 润华联动 on 14-10-30.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STDbHandle.h"              //数据库操作

@interface RMPublicModel : STDbHandle
@property (nonatomic, copy) NSString * status;
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
@property (nonatomic, copy) NSString * member;              //会员信息，member_name:会员昵称,content_face:会员头像
@property (nonatomic, copy) NSString * imgs;                //列表图片数组，3种前台展示形式,根据图片数量判断
@property (nonatomic, copy) NSString * is_review;           //是否评论 ，如果不存在代表没评论，如果等于1代表评论了
@property (nonatomic, copy) NSString * is_top;              //是否点赞 ，如果不存在代表没点赞，如果等于1代表点赞了
@property (nonatomic, copy) NSString * is_collect;          //是否收藏 ，如果不存在代表没收藏，如果等于1代表收藏了
@property (nonatomic, copy) NSString * body;                //帖子内容按照顺序，有图片的展示图片，没图片的展示 内容
@property (nonatomic, copy) NSString * member_id;           //商家会员标识
@property (nonatomic, copy) NSString * auto_position;       //位置
@property (nonatomic, copy) NSString * change_img;          //已点击的状态







@end

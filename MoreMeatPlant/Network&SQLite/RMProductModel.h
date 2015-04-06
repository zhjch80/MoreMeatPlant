//
//  RMProductModel.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/4/5.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "STDbObject.h"

@interface RMProductModel : STDbObject
@property (retain, nonatomic) NSString * corp_name;
@property (retain, nonatomic) NSString * corp_id;
@property (retain, nonatomic) NSString * content_name;
@property (retain, nonatomic) NSString * content_img;
@property (retain, nonatomic) NSString * content_price;
@property (assign, nonatomic) NSInteger  content_num;
@property (retain, nonatomic) NSString * auto_id;
@property (retain, nonatomic) NSString * content_express;
@property (retain, nonatomic) NSString * express_price;
@property (retain, nonatomic) NSString * express;

@end

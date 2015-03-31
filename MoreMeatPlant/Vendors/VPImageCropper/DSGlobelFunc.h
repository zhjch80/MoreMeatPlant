//
//  DSGlobelFunc.h
//  FuTian
//
//  Created by apple on 13-1-29.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DSGlobelFunc : NSObject{
    NSMutableArray * homeData;
}

/**
	检查网络连接
	@returns 是否有可用的网络连接 YSE 有 NO 没有
 */
+ (BOOL) isConnectionAvailable;

/**
 检查网络连接
 @param view 提示信息显示的view
 @returns 是否有可用的网络连接 YSE 有 NO 没有
 */
+ (BOOL) isConnectionAvailable:(UIView *)view;

/**
	创建uuid
	@returns 返回uuid字符串
 */
+ (NSString *) gen_uuid;


+ (CAAnimation*)moveanimation:(UIView *)view startPoint:(CGPoint)startP stopPoint:(CGPoint)stopP durationTime:(double)durationTemp repeatCount:(float)repeatCountTemp;

+ (CAAnimation*)MoveInEntertainmentAnimation:(UIView *)view startPoint:(CGPoint)startP stopPoint:(CGPoint)stopP durationTime:(double)durationTemp repeatCount:(float)repeatCountTemp;

+ (BOOL)is51Up;


@end

//
//  DSGlobelFunc.m
//  FuTian
//
//  Created by apple on 13-1-29.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DSGlobelFunc.h"
//#import <SystemConfiguration/SystemConfiguration.h>
//#import <netdb.h>
//#import "FTBottomViewController.h"
//#import "Reachability.h"

#define REQUEST_TAG 101

@implementation DSGlobelFunc
//检查网络链接是否可用
//+ (BOOL) isConnectionAvailable {
//    BOOL isNet = NO;
//    Reachability * reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
//    switch ([reach currentReachabilityStatus]) {
//        case NotReachable:
//            //NSLog(@"没有网络");
//            isNet = NO;
//            break;
//        case ReachableViaWWAN:
//            //NSLog(@"3G");
//            isNet = YES;
//            break;
//        case ReachableViaWiFi:
//            //NSLog(@"WLAN");
//            isNet = YES;
//            break;
//        default:
//            break;
//    }
//    return isNet;
//}

+ (CAAnimation*)moveanimation:(UIView *)view startPoint:(CGPoint)startP stopPoint:(CGPoint)stopP durationTime:(double)durationTemp repeatCount:(float)repeatCountTemp{
    CAKeyframeAnimation* animation;
    animation = [CAKeyframeAnimation animation];
	CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil,startP.x,startP.y);
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity,stopP.x, stopP.y);
    view.center = CGPointMake(stopP.x,stopP.y);
    animation.path = path;
	CGPathRelease(path);
	animation.duration = durationTemp;     //持续事件
	animation.repeatCount = repeatCountTemp;     //重复次数
 	animation.calculationMode = @"paced";
	return animation;
}

+ (CAAnimation*)MoveInEntertainmentAnimation:(UIView *)view startPoint:(CGPoint)startP stopPoint:(CGPoint)stopP durationTime:(double)durationTemp repeatCount:(float)repeatCountTemp{
    CAKeyframeAnimation* animation;
    animation = [CAKeyframeAnimation animation];
	CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil,startP.x,startP.y);
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity,stopP.x, stopP.y+10);
    view.center = CGPointMake(stopP.x,stopP.y+10);
    animation.path = path;
	CGPathRelease(path);
	animation.duration = durationTemp;     //持续事件
	animation.repeatCount = repeatCountTemp;     //重复次数
 	animation.calculationMode = @"paced";
	return animation;
}

+ (BOOL) isConnectionAvailable:(UIView *)view{
    if ([self isConnectionAvailable]) {
        return YES;
    }else{
//        [[DSHUDManager sharedInstance] showInfo:NSLocalizedString(@"errnet", "") inView:view];
        return NO;
    }
}

+ (NSString *) gen_uuid{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    CFRelease(uuid_string_ref);
    return uuid;
}

+ (BOOL)is51Up{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.1) {
        return YES;
    }
    else {
        return NO;
    }
}

@end

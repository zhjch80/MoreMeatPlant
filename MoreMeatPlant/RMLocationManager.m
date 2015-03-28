//
//
//  LocationManager.m
//  BuyBuyring
//
//  Created by elongtian on 14-1-13.
//  Copyright (c) 2014年 易龙天. All rights reserved.
//

#import "RMLocationManager.h"

@implementation RMLocationManager

- (void)dealloc{
    _locService.delegate = nil;
}

- (id)init
{
    if(self = [super init])
    {
        
    }
    return self;
}

- (void)startLocation
{
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}
- (void)stopLocation{
    [_locService stopUserLocationService];
}
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    if(self.callback){
        _callback(userLocation);
    }
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

@end


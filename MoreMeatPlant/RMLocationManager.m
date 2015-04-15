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

- (void)ReverseGeoAction:(CLLocationCoordinate2D)coor{
    
    if(userSearch == nil)
    {
        userSearch = [[BMKGeoCodeSearch alloc]init];
        userSearch.delegate = self;
    }

    
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption =[[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = coor;
    //    reverseGeoCodeSearchOption.reverseGeoPoint = CLLocationCoordinate2DMake(25.09, 121.44);
    BOOL flag = [userSearch reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSLog(@"%@",result.address);
        if(self.gccallback){
            self.gccallback (result.address);
        }
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSLog(@"%@",result.address);
        if(self.gccallback){
            self.gccallback (result.address);
        }
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }

}

@end


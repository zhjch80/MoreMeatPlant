//
//  LocationManager.h
//
//
//  Created by elongtian on 14-1-13.
//  Copyright (c) 2014年 易龙天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"

typedef void (^RMLocationManagerCallBack) (BMKUserLocation *);
typedef void (^RMLocationManagerGCCallBack) (NSString *);

@interface RMLocationManager : NSObject<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>{
    BMKLocationService * _locService;
    BMKGeoCodeSearch * userSearch;
}

@property (copy, nonatomic)  RMLocationManagerCallBack callback;
@property (copy, nonatomic) RMLocationManagerGCCallBack gccallback;
- (void)startLocation;
- (void)stopLocation;
- (void)ReverseGeoAction:(CLLocationCoordinate2D)coor;
@end

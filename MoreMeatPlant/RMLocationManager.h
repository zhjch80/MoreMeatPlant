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

@interface RMLocationManager : NSObject<BMKLocationServiceDelegate>{
    BMKLocationService * _locService;
}

@property (copy, nonatomic)  RMLocationManagerCallBack callback;
- (void)startLocation;
- (void)stopLocation;
@end

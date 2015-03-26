//
//  LocationManager.h
//
//
//  Created by elongtian on 14-1-13.
//  Copyright (c) 2014年 易龙天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"

@interface RMLocationManager : NSObject<BMKLocationServiceDelegate>{
    BMKLocationService * _locService;
}

@property (assign, nonatomic) id delegate;
- (void)startLocation;
- (void)stopLocation;
@end

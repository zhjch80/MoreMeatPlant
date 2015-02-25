//
//  RMStickView.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StickDelegate <NSObject>

- (void)stickJumpDetailsWithOrder:(NSInteger)order;

@end

@interface RMStickView : UIView
@property (nonatomic, assign) id<StickDelegate>delegate;

- (void)loadStickViewWithTitle:(NSString *)title withOrder:(NSInteger)order;

@end

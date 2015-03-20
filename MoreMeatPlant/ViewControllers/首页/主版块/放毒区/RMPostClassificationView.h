//
//  RMPostClassificationView.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/20.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PostClassificationDelegate <NSObject>

@optional

- (void)selectedPostClassificationWithPlantType:(NSString *)type;

@end

@interface RMPostClassificationView : UIView
@property (nonatomic, assign) id<PostClassificationDelegate>delegate;

- (void)initWithPostClassificationView;

- (void)show;

- (void)dismiss;

@end

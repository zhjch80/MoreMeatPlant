//
//  RMPostMessageView.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PostMessageSelectedPlantDelegate <NSObject>

- (void)selectedPostMessageWithPlantType:(NSString *)type;

@end

@interface RMPostMessageView : UIView
@property (nonatomic, assign) id<PostMessageSelectedPlantDelegate>delegate;

- (void)initWithPostMessageView;

- (void)show;

- (void)dismiss;

@end

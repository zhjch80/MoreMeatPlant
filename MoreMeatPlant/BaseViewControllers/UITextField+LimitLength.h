//
//  UITextField+LimitLength.h
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-10.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (LimitLength)

/**
 *  使用时只要调用此方法，加上一个长度(int)，就可以实现了字数限制,汉字不可以
 *
 *  @param length
 */
- (void)limitTextLength:(int)length;

/**
 *  uitextField 抖动效果
 */
- (void)shake;

@end

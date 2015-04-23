//
//  RMLongPostFooterView.h
//  MoreMeatPlant
//
//  Created by mobei on 15/4/24.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseView.h"
#import "RMBaseButton.h"

@protocol LongPostFooterDelegate <NSObject>

/**
 *  @method 添加 文字或图片
 *  @param      section     哪一组
 *  @param      row         哪一行
 *  @param      type        类型 发文字 或者 发图片
 */
- (void)addSomeContentWithSection:(NSInteger)section
                          withRow:(NSInteger)row
                         withType:(NSInteger)type;

@end

@interface RMLongPostFooterView : RMBaseView
@property (nonatomic, assign) id <LongPostFooterDelegate>delegate;


@property (weak, nonatomic) IBOutlet RMBaseButton *addTextBtn;
@property (weak, nonatomic) IBOutlet RMBaseButton *addImgBtn;

    
@end

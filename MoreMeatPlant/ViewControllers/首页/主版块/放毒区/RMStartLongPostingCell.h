//
//  RMStartLongPostingCell.h
//  MoreMeatPlant
//
//  Created by mobei on 15/4/23.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StartLongPostingDelegate <NSObject>

- (void)editingContentWithTag:(NSInteger)tag;

@end

@interface RMStartLongPostingCell : UITableViewCell
@property (nonatomic, assign) id <StartLongPostingDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *editTitleDisplay;
@property (weak, nonatomic) IBOutlet UIButton *editTitleBtn;

/**
 * contentIdentifier 为 text 时为文字  image 时为图片 判断cell展示的是文字 还是图片
 */
@property (nonatomic, copy) NSString * contentIdentifier;

//cell 类型3为文字
@property (weak, nonatomic) IBOutlet UILabel *textContent;
@property (weak, nonatomic) IBOutlet UILabel *line_3;

//cell 类型4为图片
@property (weak, nonatomic) IBOutlet UIImageView *imageContent;

- (void)adjustsTextContentFrameWithText:(NSString *)text;
- (void)adjustsImageContentFrameWithImage:(UIImage *)image;

@end

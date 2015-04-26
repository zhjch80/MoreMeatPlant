//
//  RMEditContentViewController.h
//  MoreMeatPlant
//
//  Created by mobei on 15/4/23.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"

@protocol EditContentDelegate <NSObject>

/**
 *  @param      content                     编辑的内容
 *  @param      section                     组
 *  @param      row                         行
 *  @param      operationType               将要操作的类型（修改、删除、插入文字、插入图片、取消、添加标题、添加内容）
 *  @param      operationRow                操作的行数
*/
- (void)getEditContent:(NSString *)content
        withSectionTag:(NSInteger)section
            withRowTag:(NSInteger)row
     withOperationType:(NSString *)operationType
  withOperationCellRow:(NSInteger)operationRow;

@end

@interface RMEditContentViewController : RMBaseViewController
@property (nonatomic, assign) id <EditContentDelegate>delegate;
@property (nonatomic, copy) NSString * mTitle;        //标题

@property (nonatomic, assign) NSInteger rowTag;
@property (nonatomic, assign) NSInteger sectionTag;
@property (nonatomic, copy) NSString * text;                        //当前textfield的内容
@property (nonatomic, assign) NSInteger operationCellRow;           //修改的那一行
@property (nonatomic, copy) NSString * operationType;               //操作类型
@property (nonatomic, copy) NSString * operationStr;              //右按钮的文字

@end

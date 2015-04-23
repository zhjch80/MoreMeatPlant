//
//  RMEditContentViewController.h
//  MoreMeatPlant
//
//  Created by mobei on 15/4/23.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"

@protocol EditContentDelegate <NSObject>

- (void)getEditContent:(NSString *)content
        withSectionTag:(NSInteger)section
            withRowTag:(NSInteger)row;

@end

@interface RMEditContentViewController : RMBaseViewController
@property (nonatomic, assign) id <EditContentDelegate>delegate;
@property (nonatomic, copy) NSString * mTitle;        //标题

@property (nonatomic, assign) NSInteger rowTag;
@property (nonatomic, assign) NSInteger sectionTag;
@property (nonatomic, copy) NSString * text;            //当前textfield的内容 

@end

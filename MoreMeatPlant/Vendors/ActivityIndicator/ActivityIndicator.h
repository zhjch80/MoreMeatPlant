//
//  ActivityIndicator.h
//  Si Gema
//
//  Created by 易龙天 on 13-7-17.
//  Copyright (c) 2013年 易龙天. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import"ReSponSeImageV.h"
typedef enum {
    
    ActivityIndicatorDefault,//默认，
    
    ActivityIndicatorLogin//登录，注册，订单提交，背景透明
    
}ActivityIndicatorType;

@interface ActivityIndicator : UIView{
    

}

@property (nonatomic,retain) id delegate;
//@property (nonatomic,retain) SVProgressHUD * svprogress;
@property (nonatomic,assign) ActivityIndicatorType indicatorType;
- (id)initWithFrame:(CGRect)frame LabelText:(NSString *)Ltext withdelegate:(id)dele withType:(ActivityIndicatorType)type andAction:(SEL)action;
- (void)startAnimatingActivit;
- (void)abnormalButtonShow:(UIImage *)image text:(NSString *)text;
- (void)stopAnimationgActivit;
-(void)addImage:(UIImage *)image;
-(void)LoadSuccess;
-(void)LoadFailed;
- (void)changeBgFrame:(CGRect)rect;
- (void)NoResults;
- (void)activityHidden;
- (void)setIndicatorType:(ActivityIndicatorType)indicatorType;
@end

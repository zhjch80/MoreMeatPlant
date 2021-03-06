//
//  RMUserInfoEditViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/12.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"

typedef void (^RMUserInfoEditViewFinished) (RMPublicModel *);

@interface RMUserInfoEditViewController : RMBaseViewController

@property (retain, nonatomic) RMPublicModel * _model;
@property (weak, nonatomic) IBOutlet UITableView *mtableView;
@property (retain, nonatomic) UIImage * content_faceImg;
@property (retain, nonatomic) UIImage * cardImg;
@property (retain, nonatomic) UIImage * corpImg;
@property (copy, nonatomic) RMUserInfoEditViewFinished editFinished;

@end

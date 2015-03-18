//
//  RMBabyManageViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"
#import "RMBabyListViewController.h"
@interface RMBabyManageViewController : RMBaseViewController{
    RMBabyListViewController * all_Ctl;
    RMBabyListViewController * ware_Ctl;
    RMBabyListViewController * class_Ctl;
    
}
@property (weak, nonatomic) IBOutlet UIButton *all_baby_btn;
@property (weak, nonatomic) IBOutlet UIButton *warehouse_baby_btn;
@property (weak, nonatomic) IBOutlet UIButton *class_baby_btn;

@end

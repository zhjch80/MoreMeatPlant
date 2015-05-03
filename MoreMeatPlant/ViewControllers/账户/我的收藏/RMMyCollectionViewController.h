//
//  RMMyCollectionViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/15.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"
#import "RMPostCollectionViewController.h"
#import "RMPlantCollectionViewController.h"
#import "RMCorpCollectionViewController.h"
#import "RMDaquanCollectionViewController.h"
@interface RMMyCollectionViewController : RMBaseViewController{
    RMPostCollectionViewController * postCollectionController;
    RMPlantCollectionViewController * plantCollectionController;
    RMCorpCollectionViewController * corpCollectionController;
    RMDaquanCollectionViewController * daquanCollectionController;
    NSInteger current_index;
}
@property (weak, nonatomic) IBOutlet UIButton *plantBtn;
@property (weak, nonatomic) IBOutlet UIButton *postBtn;
@property (weak, nonatomic) IBOutlet UIButton *corpBtn;
@property (weak, nonatomic) IBOutlet UIView *operationView;
@property (weak, nonatomic) IBOutlet UIButton *daquan;

@end

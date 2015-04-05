//
//  RMPublishBabyViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"

@interface RMPublishBabyViewController : RMBaseViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UITextFieldDelegate,UITextViewDelegate>{
    NSMutableArray * classArray;
    NSMutableArray * courseArray;
    NSInteger img_tag;
    RMPublicModel * current_Model;
    NSMutableDictionary * modifyPhotoDic;//auto_id为key,path为value
    NSMutableDictionary * modifyImageDic;//tag-100为key,image为value
    NSMutableDictionary * newAddPhotoDic;//新增图片字典
    NSMutableDictionary * newAddImageDic;//新增图片显示字典，里面存的是image和key
    
}
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (retain, nonatomic) NSString * auto_id;

@end

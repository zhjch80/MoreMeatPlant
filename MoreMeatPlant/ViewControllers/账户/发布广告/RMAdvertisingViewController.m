//
//  RMAdvertisingViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/19.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMAdvertisingViewController.h"
#import "RMAdvertisingSectionTableViewCell.h"
#import "RMAdvertisingHeadTableViewCell.h"
#import "RMVPImageCropper.h"
#import "RMSectionFooterTableViewCell.h"
@interface RMAdvertisingViewController ()<RMVPImageCropperDelegate>

@end

@implementation RMAdvertisingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.view];
    [self setCustomNavTitle:@"发布广告"];
    
    
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];
    
    planteArray = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"",@"", nil];
    selectArray = [[NSMutableArray alloc]init];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [planteArray count]+3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        RMAdvertisingHeadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMAdvertisingHeadTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMAdvertisingHeadTableViewCell" owner:self options:nil] lastObject];
            
            [cell.publishBtn addTarget:self action:@selector(postImg:) forControlEvents:UIControlEventTouchDown];
        }
        return cell;
    }else if (indexPath.row == 1){
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.textLabel.text = @"发到的版块";
        cell.textLabel.font = FONT_1(14);
        return cell;
    }else if (indexPath.row == [planteArray count]+2){
        RMSectionFooterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMSectionFooterTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMSectionFooterTableViewCell" owner:self options:nil] lastObject];
            [cell.surePublish addTarget:self action:@selector(surePublishAction:) forControlEvents:UIControlEventTouchDown];
        }
        return cell;
    }
    else {
        RMAdvertisingSectionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMAdvertisingSectionTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMAdvertisingSectionTableViewCell" owner:self options:nil] lastObject];
            [cell.selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchDown];
            
            [cell.subBtn addTarget:self action:@selector(subAction:) forControlEvents:UIControlEventTouchDown];
            [cell.addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchDown];
        }
        cell.selectBtn.tag = indexPath.row*100;
        cell.subBtn.tag = indexPath.row*100+1;
        cell.addBtn.tag = indexPath.row*100+2;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 85;
    }else if (indexPath.row == 1){
        return 40;
    }else if (indexPath.row == [planteArray count]+2){
        return 81;
    }else{
        return 40;
    }
}

#pragma mark - 选择 100
- (void)selectAction:(UIButton *)sender{
    RMAdvertisingSectionTableViewCell * cell =  (RMAdvertisingSectionTableViewCell *)[_mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag/100 inSection:0]];
    for(NSNumber * number in selectArray){
        if(sender.tag/100 == [number integerValue]){
            [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"fbbb_no_select"] forState:UIControlStateNormal];
            [selectArray removeObject:number];
            return;
        }
    }
    [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"gwc_select"] forState:UIControlStateNormal];
    [selectArray addObject:[NSNumber numberWithInteger:sender.tag/100]];
}

#pragma mark - 减 101
- (void)subAction:(UIButton *)sender{

    RMAdvertisingSectionTableViewCell * cell =  (RMAdvertisingSectionTableViewCell *)[_mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag/100 inSection:0]];
    NSInteger num = [cell.numTextField.text integerValue];
    num--;
    if(num>0){
        cell.numTextField.text = [NSString stringWithFormat:@"%ld",num];
    }else{
        cell.numTextField.text = [NSString stringWithFormat:@"%ld",++num];
    }
    
}

#pragma mark - 加 102
- (void)addAction:(UIButton *)sender{
    RMAdvertisingSectionTableViewCell * cell =  (RMAdvertisingSectionTableViewCell *)[_mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag/100 inSection:0]];
    NSInteger num = [cell.numTextField.text integerValue];
    num++;
    cell.numTextField.text = [NSString stringWithFormat:@"%ld",num];
}

#pragma mark - 确认发布
- (void)surePublishAction:(UIButton *)sender{
    
}

- (void)postImg:(UIButton *)sender{
    [[RMVPImageCropper shareImageCropper] setCtl:self];
    [[RMVPImageCropper shareImageCropper] set_scale:0.14];
    [[RMVPImageCropper shareImageCropper] showActionSheet];
}


#pragma mark - RMimageCropperDelegate
- (void)RMimageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage{
    RMAdvertisingHeadTableViewCell * cell = (RMAdvertisingHeadTableViewCell*)[_mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.placeImgV setImage:editedImage];
}

- (void)RMimageCropperDidCancel:(VPImageCropperViewController *)cropperViewController{
    
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

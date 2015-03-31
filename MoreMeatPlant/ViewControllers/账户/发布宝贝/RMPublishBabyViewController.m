//
//  RMPublishBabyViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMPublishBabyViewController.h"
#import "RMPublishTitleTableViewCell.h"
#import "RMPublishPlateTableViewCell.h"
#import "RMPublishClassTableViewCell.h"
#import "RMPublishNumberTableViewCell.h"
#import "RMPublishPhotoTableViewCell.h"
#import "RMPublishSureTableViewCell.h"
#import "NSString+Addtion.h"
#import "RMVPImageCropper.h"
@interface RMPublishBabyViewController ()<RMVPImageCropperDelegate>

@end

@implementation RMPublishBabyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomNavTitle:@"发布宝贝"];
    
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];
    
    classArray = [[NSMutableArray alloc]init];
    classArray = [NSMutableArray arrayWithObjects:@"一肉一拍",@"进口肉肉",@"国产肉肉",@"特价肉肉", nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
    
        RMPublishTitleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMPublishTitleTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPublishTitleTableViewCell" owner:self options:nil] lastObject];
        }
    
        return cell;
        
    }else if(indexPath.row == 1){
        RMPublishPlateTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMPublishPlateTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPublishPlateTableViewCell" owner:self options:nil] lastObject];
        }
        return cell;
    }else if (indexPath.row == 2){
        RMPublishClassTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMPublishClassTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPublishClassTableViewCell" owner:self options:nil] lastObject];
            [cell createItem:classArray andCallBack:nil];
            [cell.addClassBtn addTarget:self action:@selector(addClassAction:) forControlEvents:UIControlEventTouchDown];
        }
        return cell;
    }else if (indexPath.row == 3){
        RMPublishNumberTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMPublishNumberTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPublishNumberTableViewCell" owner:self options:nil] lastObject];
        }
        return cell;
    }else if (indexPath.row == 4||indexPath.row == 5){
        RMPublishPhotoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMPublishPhotoTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPublishPhotoTableViewCell" owner:self options:nil] lastObject];
            [cell.picSelect1 addTarget:self action:@selector(selectFromPics:) forControlEvents:UIControlEventTouchDown];
            [cell.picSelect2 addTarget:self action:@selector(selectFromPics:) forControlEvents:UIControlEventTouchDown];
            [cell.picSelect3 addTarget:self action:@selector(selectFromPics:) forControlEvents:UIControlEventTouchDown];
            [cell.picSelect4 addTarget:self action:@selector(selectFromPics:) forControlEvents:UIControlEventTouchDown];
            [cell.picSelect5 addTarget:self action:@selector(selectFromPics:) forControlEvents:UIControlEventTouchDown];
            
            [cell.camera1 addTarget:self action:@selector(selectFromCamera:) forControlEvents:UIControlEventTouchDown];
            [cell.camera2 addTarget:self action:@selector(selectFromCamera:) forControlEvents:UIControlEventTouchDown];
            [cell.camera3 addTarget:self action:@selector(selectFromCamera:) forControlEvents:UIControlEventTouchDown];
            [cell.camera4 addTarget:self action:@selector(selectFromCamera:) forControlEvents:UIControlEventTouchDown];
            [cell.camera5 addTarget:self action:@selector(selectFromCamera:) forControlEvents:UIControlEventTouchDown];
            
        }
        cell.picSelect1.tag = indexPath.row*100+1;
        cell.picSelect2.tag = indexPath.row*100+2;
        cell.picSelect3.tag = indexPath.row*100+3;
        cell.picSelect4.tag = indexPath.row*100+4;
        cell.picSelect5.tag = indexPath.row*100+5;
        
        cell.camera1.tag = indexPath.row*200+1;
        cell.camera2.tag = indexPath.row*200+2;
        cell.camera3.tag = indexPath.row*200+3;
        cell.camera4.tag = indexPath.row*200+4;
        cell.camera5.tag = indexPath.row*200+5;
        
        cell.img1.tag = indexPath.row*300+1;
        cell.img2.tag = indexPath.row*300+2;
        cell.img3.tag = indexPath.row*300+3;
        cell.img4.tag = indexPath.row*300+4;
        cell.img5.tag = indexPath.row*300+5;
        
        return cell;
    }else if (indexPath.row == 5){
        RMPublishPhotoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMPublishPhotoTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPublishPhotoTableViewCell" owner:self options:nil] lastObject];
        }
        return cell;
    }else{
        RMPublishSureTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMPublishSureTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPublishSureTableViewCell" owner:self options:nil] lastObject];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 154;
    }else if(indexPath.row == 1){
        return 65;
    }else if (indexPath.row == 2){
        CGFloat x = 10;
        CGFloat y = 31;
        for(NSString * title in classArray){
            CGSize size = [title getcontentsizeWithfont:FONT_0(13) constrainedtosize:CGSizeMake(100, 20) linemode:NSLineBreakByCharWrapping];
            
            if(x+20+size.width+10*2>kScreenWidth){
                y+=20+5;
                x = 10;
            }
            x+= 10+20+size.width+10;
        }
        return y+31+20;
        
    }else if (indexPath.row == 3){
        return 44;
    }else if (indexPath.row == 4){
        return 129;
    }else if (indexPath.row == 5){
        return 129;
    }else{
        return 58;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

}

#pragma mark - 拍照
- (void)selectFromCamera:(UIButton *)sender{
    [[RMVPImageCropper shareImageCropper] setCtl:self];
    [[RMVPImageCropper shareImageCropper] set_scale:1.0];
    [[RMVPImageCropper shareImageCropper] openCamera];
    img_tag = (sender.tag/200)*300+sender.tag%200;
}
#pragma mark - 从相册选择图片
- (void)selectFromPics:(UIButton *)sender{
    [[RMVPImageCropper shareImageCropper] setCtl:self];
    [[RMVPImageCropper shareImageCropper] set_scale:1.0];
    [[RMVPImageCropper shareImageCropper] openPics];
    img_tag = (sender.tag/100)*300+sender.tag%100;
}

- (void)addClassAction:(id)sender{
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"输入要添加的分类名称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        NSLog(@"取消");
    }else{
        
         UITextField *tf=[alertView textFieldAtIndex:0];
        NSLog(@"添加:%@",tf.text);
        RMPublishClassTableViewCell * cell = (RMPublishClassTableViewCell *)[_mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        NSArray * arr = [NSArray arrayWithObjects:tf.text ,nil];
        [cell createItem:arr andCallBack:^{
            [classArray addObjectsFromArray:arr];
        }];
        
        [_mTableView reloadData];
    }
}

#pragma mark - RMimageCropperDelegate
- (void)RMimageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage{
    
    RMPublishPhotoTableViewCell * cell = (RMPublishPhotoTableViewCell *)[_mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:img_tag/300 inSection:0]];
    UIImageView * img = (UIImageView *)[cell.contentView viewWithTag:img_tag];
    [img setImage:editedImage];
}

- (void)RMimageCropperDidCancel:(VPImageCropperViewController *)cropperViewController{
    NSLog(@"发布宝贝取消选择图片");
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

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
#import "DaiDodgeKeyboard.h"
#import "NSString+Addtion.h"
@interface RMPublishBabyViewController ()

@end

@implementation RMPublishBabyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomNavTitle:@"发布宝贝"];
    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.mTableView];
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
        }
        cell.titles = classArray;
        [cell layoutSubviews];
        return cell;
    }else if (indexPath.row == 3){
        RMPublishNumberTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMPublishNumberTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPublishNumberTableViewCell" owner:self options:nil] lastObject];
        }
        return cell;
    }else if (indexPath.row == 4){
        RMPublishPhotoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMPublishPhotoTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPublishPhotoTableViewCell" owner:self options:nil] lastObject];
        }
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

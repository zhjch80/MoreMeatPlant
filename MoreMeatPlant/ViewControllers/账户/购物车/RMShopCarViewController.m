//
//  RMShopCarViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/9.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMShopCarViewController.h"
#import "RMShopCarGoodsTableViewCell.h"
#import "RMSopCarHeadTableViewCell.h"
#import "RMShopLeaveMsTableViewCell.h"
@interface RMShopCarViewController ()

@end

@implementation RMShopCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3+2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        RMSopCarHeadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMSopCarHeadTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMSopCarHeadTableViewCell" owner:self options:nil] lastObject];
        }
        return cell;
    }else if(indexPath.row == 4){
        RMShopLeaveMsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMShopLeaveMsTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMShopLeaveMsTableViewCell" owner:self options:nil] lastObject];
        }
        return cell;
    }else{
        RMShopCarGoodsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMShopCarGoodsTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMShopCarGoodsTableViewCell" owner:self options:nil] lastObject];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 30;
    }else if (indexPath.row == 4){
        return 106;
    }else{
        return 77;
    }
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

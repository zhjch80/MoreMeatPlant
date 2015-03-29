//
//  RMHadBabyListViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/20.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMHadBabyListViewController.h"
#import "RMOrderProTableViewCell.h"
#import "RMOrderHeadTableViewCell.h"
#import "RMHadbabyTableViewCell.h"
@interface RMHadBabyListViewController ()

@end

@implementation RMHadBabyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.mTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.row == 0){
        RMOrderHeadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMOrderHeadTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMOrderHeadTableViewCell" owner:self options:nil] lastObject];
        }
        return cell;
    }else if (indexPath.row == 3){
        RMHadbabyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMHadbabyTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMHadbabyTableViewCell" owner:self options:nil] lastObject];
        }
        return cell;
    }else{
        RMOrderProTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMOrderProTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMOrderProTableViewCell" owner:self options:nil] lastObject];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 30;
    }else if (indexPath.row == 3){
        return 193;
    }else{
        return 70;
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

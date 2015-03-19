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
#import "DaiDodgeKeyboard.h"
@interface RMAdvertisingViewController ()

@end

@implementation RMAdvertisingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.view];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        RMAdvertisingHeadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMAdvertisingHeadTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMAdvertisingHeadTableViewCell" owner:self options:nil] lastObject];
        }
        return cell;
    }else{
        RMAdvertisingSectionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMAdvertisingSectionTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMAdvertisingSectionTableViewCell" owner:self options:nil] lastObject];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 85;
    }else{
        return 251;
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

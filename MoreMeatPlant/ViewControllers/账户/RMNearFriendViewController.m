//
//  RMNearFriendViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/4.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMNearFriendViewController.h"
#import "RMNearFriendTableViewCell.h"
@interface RMNearFriendViewController ()

@end

@implementation RMNearFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomNavTitle:@"附近肉友"];
    
    [self initPlat];
}
#pragma mark - 初始化方法
- (void)initPlat{
    friendsArray = [[NSMutableArray alloc]init];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RMNearFriendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMNearFriendTableViewCell"];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RMNearFriendTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 103.f;
}

#pragma mark - 返回
- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    switch (sender.tag) {
        case 1:{
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 2:{
            
            break;
        }
            
        default:
            break;
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

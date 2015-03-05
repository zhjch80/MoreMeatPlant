//
//  RMSysMessageViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/4.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMSysMessageViewController.h"
#import "RMSysMessageTableViewCell.h"
@interface RMSysMessageViewController ()

@end

@implementation RMSysMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setCustomNavTitle:@"系统消息"];
    [self initPlat];
}

- (void)initPlat{
    self.view.backgroundColor = [UIColor lightGrayColor];
    messageArray = [[NSMutableArray alloc]init];
    _mainTableView.opaque = NO;
    _mainTableView.backgroundColor = [_mainTableView.backgroundColor colorWithAlphaComponent:0.6];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row%2 == 0){
        RMSysMessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMSysMessageTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMSysMessageTableViewCell" owner:self options:nil] lastObject];
        }
        return cell;
    }
    else{
        UITableViewCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row%2 == 0){
        return 44;
    }
    else{
        return 10.f;
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

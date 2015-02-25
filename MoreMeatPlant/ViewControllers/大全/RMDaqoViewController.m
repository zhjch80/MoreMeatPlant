//
//  RMDaqoViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/13.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMDaqoViewController.h"
#import "RMPlantTypeView.h"
#import "RMDaqoCell.h"
#import "RMDaqoDetailsViewController.h"

@interface RMDaqoViewController ()<UITableViewDataSource, UITableViewDelegate, SelectedPlantTypeMethodDelegate,DaqpSelectedPlantTypeDelegate>
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, strong) UITableView * mTableView;

@end

@implementation RMDaqoViewController
@synthesize mTableView, dataArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomNavTitle:@"全部肉肉(950)"];
    dataArr = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", nil];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.64 green:0.64 blue:0.64 alpha:1];
    
    RMPlantTypeView * plantType = [[RMPlantTypeView alloc] init];
    plantType.frame = CGRectMake(0, 64, kScreenWidth, kScreenWidth/7);
    plantType.delegate = self;
    [plantType loadPlantType];
    [self.view addSubview:plantType];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, plantType.frame.size.height + 64, kScreenWidth, kScreenHeight - plantType.frame.size.height - 64 - 49 ) style:UITableViewStylePlain];
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mTableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([dataArr count]%3 == 0){
        return [dataArr count] / 3;
    }else if ([dataArr count]%3 == 1){
        return ([dataArr count] + 2) / 3;
    }else {
        return ([dataArr count] + 1) / 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifierStr = @"DaqoidentifierStr";
    RMDaqoCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RMDaqoCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
    }
    cell.leftTitle.text = @"雪莲";
    cell.leftImg.identifierString = cell.leftTitle.text;
    
    cell.centerTitle.text = @"桃美人";
    cell.centerImg.identifierString = cell.centerTitle.text;

    cell.rightTitle.text = @"绿熊";
    cell.rightImg.identifierString = cell.rightTitle.text;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 132.0;
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    switch (sender.tag) {
        case 1:{
            
            break;
        }
        case 2:{
            
            break;
        }
            
        default:
            break;
    }
}

- (void)selectedPlantWithType:(NSString *)type {
    NSLog(@"type:%@",type);
}

- (void)daqoSelectedPlantTypeMethod:(RMImageView *)image {
    NSLog(@"image type:%@",image.identifierString);
    RMDaqoDetailsViewController * daqoDetailsCtl = [[RMDaqoDetailsViewController alloc] init];
    [self.navigationController pushViewController:daqoDetailsCtl animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

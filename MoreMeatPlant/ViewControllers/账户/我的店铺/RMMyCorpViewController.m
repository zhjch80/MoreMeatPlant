//
//  RMMyCorpViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/15.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMMyCorpViewController.h"
#import "RMCorpClassesButton.h"
#import "RMPlantWithSaleDetailsViewController.h"
#import "RMBottomView.h"
@interface RMMyCorpViewController ()<BottomDelegate>{
    RMBottomView * bottomView;
}

@end

@implementation RMMyCorpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setCustomNavTitle:@"我的店铺"];
    
    
    
    _corp_headImgV.layer.cornerRadius = 5;
    _corp_headImgV.clipsToBounds = YES;
    
    bottomView = [[RMBottomView alloc] init];
    bottomView.delegate = self;
    bottomView.frame = CGRectMake(0, kScreenHeight-40, kScreenWidth, 40);
    [bottomView loadBottomWithImageArr:[NSArray arrayWithObjects:@"img_class", @"img_up", @"img_buy", @"img_moreChat", nil]];
    [self.view addSubview:bottomView];
    
    NSArray * titles = [NSArray arrayWithObjects:@"全部宝贝",@"一肉一拍",@"进口肉肉",@"老桩专区", nil];
    float width = (kScreenWidth-10*2-3)/4.0;
    for(NSInteger i = 0; i<4; i ++ ){
        RMCorpClassesButton * btn = [[RMCorpClassesButton alloc]initWithFrame:CGRectMake(10+(width+1)*(i%4), 0, width, 40)];
        btn.tag = 100+i;
        btn.classesNameL.text = [titles objectAtIndex:i];
        btn.callback = ^(RMCorpClassesButton *sender){
        
            switch (sender.tag-100) {
                case 0:{
                
                }
                    break;
                case 1:{
                    
                }
                    break;
                case 2:{
                    
                }
                    break;
                case 3:{
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        };
        
        
        [_classesView addSubview:btn];
        
        
        if(i == 3){
            return;
        }else{
            UIImageView * img_line = [[UIImageView alloc]initWithFrame:CGRectMake(btn.frame.origin.x+btn.frame.size.width,btn.frame.origin.y+1 , 1, btn.frame.size.height-2)];
            img_line.backgroundColor = UIColorFromRGB(0xadadad);
            [img_line setImage:[UIImage imageNamed:@""]];
            
            [_classesView addSubview:img_line];
        }
    }
    
}

#pragma mark - bottomViewDelegate

- (void)bottomMethodWithTag:(NSInteger)tag {
    switch (tag) {
        case 1:{
            
            break;
        }
        case 2:{
            
            break;
        }
        case 3:{
            
            break;
        }
        case 4:{
            
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RMPlantWithSaleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMPlantWithSaleCell"];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPlantWithSaleCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
        cell.delegate = self;
    }
    cell.leftPrice.text = @" ¥560";
    cell.centerPrice.text = @" ¥240";
    cell.rightPrice.text = @" ¥360";
    
    cell.leftName.text = @" 极品雪莲";
    cell.centerName.text = @" 桃美人";
    cell.rightName.text = @" 极品亚美奶酪";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150.0;
}

- (void)jumpPlantDetailsWithImage:(RMImageView *)image{
    RMPlantWithSaleDetailsViewController * plantWithSaleDetailsCtl = [[RMPlantWithSaleDetailsViewController alloc] init];
    [self.navigationController pushViewController:plantWithSaleDetailsCtl animated:YES];
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

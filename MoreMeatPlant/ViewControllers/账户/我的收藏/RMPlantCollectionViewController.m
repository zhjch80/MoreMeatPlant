//
//  RMPlantCollectionViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/15.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMPlantCollectionViewController.h"
#import "RefreshControl.h"
#import "CustomRefreshView.h"
#import "UIViewController+HUD.h"
#import "RMPlantWithSaleCell.h"
#import "RMPlantWithSaleDetailsViewController.h"
@interface RMPlantCollectionViewController ()<RefreshControlDelegate,JumpPlantDetailsDelegate>{
    NSInteger pageCount;
    BOOL isRefresh;
    BOOL isLoadComplete;
}
@property (nonatomic, strong) RefreshControl * refreshControl;


@end

@implementation RMPlantCollectionViewController
@synthesize dataArr;
@synthesize refreshControl;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mainTableView.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
    dataArr = [[NSMutableArray alloc] init];
    
    refreshControl=[[RefreshControl alloc] initWithScrollView:_mainTableView delegate:self];
    refreshControl.topEnabled = YES;
    refreshControl.bottomEnabled = YES;
    [refreshControl registerClassForTopView:[CustomRefreshView class]];
    pageCount = 1;
    isRefresh = YES;
    
    [self requestDataWithPageCount];

}

#pragma mark -

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
    static NSString * identifierStr = @"plantWithSaleIdentifier";
    RMPlantWithSaleCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (!cell){
        if (IS_IPHONE_6p_SCREEN){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPlantWithSaleCell_6p" owner:self options:nil] lastObject];
        }else if (IS_IPHONE_6_SCREEN){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPlantWithSaleCell_6" owner:self options:nil] lastObject];
        }else{
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMPlantWithSaleCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
        cell.delegate = self;
    }
    
    if(indexPath.row*3 < dataArr.count){
        cell.leftPrice.hidden = NO;
        cell.leftImg.hidden = NO;
        cell.leftName.hidden = NO;
        RMPublicModel *model = [dataArr objectAtIndex:indexPath.row*3];
        NSString * _price = [NSString stringWithFormat:@"¥%@",model.content_price];
        NSMutableAttributedString *oneAttributeStr = [[NSMutableAttributedString alloc]initWithString:_price];
        [oneAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, 1)];
        cell.leftPrice.attributedText = oneAttributeStr;
        cell.leftName.text = model.content_name;
        cell.leftImg.identifierString = model.auto_id;
        [cell.leftImg sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:nil];
    }else{
        cell.leftPrice.hidden = YES;
        cell.leftImg.hidden = YES;
        cell.leftName.hidden = YES;
    }
    if(indexPath.row*3+1 < dataArr.count){
        cell.centerPrice.hidden = NO;
        cell.centerImg.hidden = NO;
        cell.centerName.hidden = NO;
        RMPublicModel *model = [dataArr objectAtIndex:indexPath.row*3+1];
        NSString * _price = [NSString stringWithFormat:@"¥%@",model.content_price];
        NSMutableAttributedString *oneAttributeStr = [[NSMutableAttributedString alloc]initWithString:_price];
        [oneAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, 1)];
        cell.centerPrice.attributedText = oneAttributeStr;
        cell.centerName.text = model.content_name;
        cell.centerImg.identifierString = model.auto_id;
        [cell.centerImg sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:nil];
    }else{
        cell.centerPrice.hidden = YES;
        cell.centerImg.hidden = YES;
        cell.centerName.hidden = YES;
    }
    if(indexPath.row*3+2 < dataArr.count){
        cell.rightPrice.hidden = NO;
        cell.rightImg.hidden = NO;
        cell.rightName.hidden = NO;
        RMPublicModel *model = [dataArr objectAtIndex:indexPath.row*3+2];
        NSString * _price = [NSString stringWithFormat:@"¥%@",model.content_price];
        NSMutableAttributedString *oneAttributeStr = [[NSMutableAttributedString alloc]initWithString:_price];
        [oneAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, 1)];
        cell.rightPrice.attributedText = oneAttributeStr;
        cell.rightName.text = model.content_name;
        cell.rightImg.identifierString = model.auto_id;
        [cell.rightImg sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:nil];
    }else{
        cell.rightPrice.hidden = YES;
        cell.rightImg.hidden = YES;
        cell.rightName.hidden = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)jumpPlantDetailsWithImage:(RMImageView *)image {
    if(self.detailcall_back){
        self.detailcall_back (image.identifierString);
    }
}

#pragma mark 刷新代理

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction {
    if (direction == RefreshDirectionTop) { //下拉刷新
        pageCount = 1;
        isRefresh = YES;
        isLoadComplete = NO;
        [self requestDataWithPageCount];
    }else if(direction == RefreshDirectionBottom) { //上拉加载
        if (isLoadComplete){
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.44 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self showHint:@"没有更多肉肉啦"];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
            });
        }else{
            pageCount ++;
            isRefresh = NO;
        [self requestDataWithPageCount];
        }
        
    }
}

- (void)requestDataWithPageCount{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager myCollectionRequestWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] Type:@"3" Page:pageCount andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success){
            if(pageCount == 1){
                [dataArr removeAllObjects];
                [dataArr addObjectsFromArray:object];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
                if([object count] == 0){
                    [self showHint:@"暂无收藏"];                    
                    
                }
            }else{
                [dataArr addObjectsFromArray:object];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
                if([object count] == 0){
                    [self showHint:@"没有更多收藏了"];
                    pageCount--;
                }
            }
            
            
        }else{
                    [self showHint:object];
        }
        
        [_mainTableView reloadData];
    }];

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

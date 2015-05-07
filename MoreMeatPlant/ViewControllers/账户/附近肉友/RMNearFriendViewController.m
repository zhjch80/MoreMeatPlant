//
//  RMNearFriendViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/4.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMNearFriendViewController.h"
#import "RMNearFriendTableViewCell.h"
#import "RMMyHomeViewController.h"
#import "RMDaqoCell.h"
#import "RMMyCorpViewController.h"
@interface RMNearFriendViewController ()<RefreshControlDelegate,DaqpSelectedPlantTypeDelegate>{
    NSInteger pageCount;
    BOOL isRefresh;
    BOOL isLoadComplete;
}
@property (nonatomic, strong) RefreshControl * refreshControl;

@end

@implementation RMNearFriendViewController
@synthesize refreshControl;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomNavTitle:@"附近肉友"];
    
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];
    
    refreshControl=[[RefreshControl alloc] initWithScrollView:_mainTableView delegate:self];
    refreshControl.topEnabled = YES;
    refreshControl.bottomEnabled = YES;
    [refreshControl registerClassForTopView:[RefreshView class]];
    pageCount = 1;
    isRefresh = YES;
    
    
    [self initPlat];
    
    [self requestNearMember];
}
#pragma mark - 初始化方法
- (void)initPlat{
    friendsArray = [[NSMutableArray alloc]init];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([friendsArray count]%3 == 0){
        return [friendsArray count] / 3;
    }else if ([friendsArray count]%3 == 1){
        return ([friendsArray count] + 2) / 3;
    }else {
        return ([friendsArray count] + 1) / 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifierStr = @"DaqoidentifierStr";
    RMDaqoCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (!cell){
        if (IS_IPHONE_6p_SCREEN){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMDaqoCell_6p" owner:self options:nil] lastObject];
        }else if (IS_IPHONE_6_SCREEN){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMDaqoCell_6" owner:self options:nil] lastObject];
        }else{
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMDaqoCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
    }
    
    cell.leftImg.contentMode = UIViewContentModeScaleToFill;
    cell.rightImg.contentMode = UIViewContentModeScaleToFill;
    cell.centerImg.contentMode = UIViewContentModeScaleToFill;
    
    if(indexPath.row*3 < friendsArray.count){
        RMPublicModel *model = [friendsArray objectAtIndex:indexPath.row*3];
        cell.leftTitle.text = model.content_name;
        [cell.leftImg sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:nil];
        cell.leftImg.identifierString = model.auto_id;
        cell.leftImg.content_type = model.content_type;
    }else{
        cell.leftTitle.hidden = YES;
        cell.leftImg.hidden = YES;
    }
    if(indexPath.row*3+1 < friendsArray.count){
        RMPublicModel *model = [friendsArray objectAtIndex:indexPath.row*3+1];
        cell.centerTitle.text = model.content_name;
        [cell.centerImg sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:nil];
        cell.centerImg.identifierString = model.auto_id;
        cell.centerImg.content_type = model.content_type;
    }else{
        cell.centerTitle.hidden = YES;
        cell.centerImg.hidden = YES;
    }
    if(indexPath.row*3+2 < friendsArray.count){
        RMPublicModel *model = [friendsArray objectAtIndex:indexPath.row*3+2];
        cell.rightTitle.text = model.content_name;
        [cell.rightImg sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:nil];
        cell.rightImg.identifierString = model.auto_id;
        cell.rightImg.content_type = model.content_type;
    }else{
        cell.rightTitle.hidden = YES;
        cell.rightImg.hidden = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)daqoSelectedPlantTypeMethod:(RMImageView *)image{
    if([image.content_type intValue] == 1){//普通用户
        RMMyHomeViewController * home = [[RMMyHomeViewController alloc]initWithNibName:@"RMMyHomeViewController" bundle:nil];
        home.auto_id = image.identifierString;
        [self.navigationController pushViewController:home animated:YES];
    }else{
        RMMyCorpViewController * corp = [[RMMyCorpViewController alloc]initWithNibName:@"RMMyCorpViewController" bundle:nil];
        corp.auto_id = image.identifierString;
        [self.navigationController pushViewController:corp animated:YES];
    }
   
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

- (void)requestNearMember{
    NSLog(@"%@",[[RMUserLoginInfoManager loginmanager] coorStr]);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager nearMemberRequestwithCoor:[[RMUserLoginInfoManager loginmanager] coorStr] page:pageCount andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success){
            if([object isKindOfClass:[RMPublicModel class]]){//模型类
                RMPublicModel * model = object;
                if(model.status){
                    if(pageCount == 1){
                        [refreshControl finishRefreshingDirection:RefreshDirectionTop];
                    }else{
                        [self showHint:@"没有更多肉友啦！"];
                        [refreshControl finishRefreshingDirection:RefreshDirectionBottom];
                    }
                }else{
                    [self showHint:model.msg];
                }
            }else{//数组
                [friendsArray addObjectsFromArray:object];
                if(pageCount == 1){
                    [refreshControl finishRefreshingDirection:RefreshDirectionTop];
                }else{
                    [refreshControl finishRefreshingDirection:RefreshDirectionBottom];
                }
            }
        }else{
            [self showHint:object];
        }
        [_mainTableView reloadData];
    }];
}

#pragma mark 刷新代理
- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction {
    if (direction == RefreshDirectionTop) { //下拉刷新
        pageCount = 1;
            [self requestNearMember];
        [friendsArray removeAllObjects];
    }else if(direction == RefreshDirectionBottom) { //上拉加载
       
            pageCount ++;
            [self requestNearMember];
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

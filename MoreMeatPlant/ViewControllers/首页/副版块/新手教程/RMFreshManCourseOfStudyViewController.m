//
//  RMFreshManCourseOfStudyViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/16.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMFreshManCourseOfStudyViewController.h"
#import "RefreshControl.h"
#import "CustomRefreshView.h"
#import "RMBaseWebViewController.h"

@interface RMFreshManCourseOfStudyViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshControlDelegate>{
    BOOL isFirstAppear;
    BOOL isRefresh;
    NSInteger pageCount;
    BOOL isLoadComplete;
}
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, strong) RefreshControl * refreshControl;

@end

@implementation RMFreshManCourseOfStudyViewController
@synthesize mTableView, dataArr, refreshControl;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (isFirstAppear){
        [self requestNewsListWithPageCount:1];
        isFirstAppear = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomNavTitle:@"新手教程"];
    
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];

    dataArr = [[NSMutableArray alloc] init];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mTableView];
    mTableView.tableFooterView = nil;
    mTableView.tableFooterView = [[UIView alloc] init];
    
    refreshControl=[[RefreshControl alloc] initWithScrollView:mTableView delegate:self];
    refreshControl.topEnabled = YES;
    refreshControl.bottomEnabled = YES;
    [refreshControl registerClassForTopView:[CustomRefreshView class]];
    
    pageCount = 1;
    isRefresh = YES;
    isFirstAppear = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifierStr = @"freshManCourseOfStudyIdentifier";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
    }
    RMPublicModel * model = [dataArr objectAtIndex:indexPath.row];

    cell.textLabel.text = model.content_name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RMPublicModel * model = [dataArr objectAtIndex:indexPath.row];
    RMBaseWebViewController * baseWebView = [[RMBaseWebViewController alloc] init];
    [baseWebView loadRequestWithUrl:model.view_link withTitle:model.content_name];
    [self.navigationController pushViewController:baseWebView animated:YES];
}

#pragma mark -

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

#pragma mark - 数据请求

- (void)requestNewsListWithPageCount:(NSInteger)pc {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getNewsWithOptionid:977 withPageCount:pc callBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"error:%@",error);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return ;
        }
        
        if (success){
            if (self.refreshControl.refreshingDirection == RefreshingDirectionTop) {
                [dataArr removeAllObjects];
                for (NSInteger i=0; i<[[object objectForKey:@"data"] count]; i++) {
                    RMPublicModel * model = [[RMPublicModel alloc] init];
                    model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                    model.content_img = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_img"]);
                    model.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_name"]);
                    model.view_link = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"view_link"]);
                    [dataArr addObject:model];
                }
                [mTableView reloadData];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
            }else if(self.refreshControl.refreshingDirection==RefreshingDirectionBottom) {
                if ([[object objectForKey:@"data"] count] == 0){
                    [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    isLoadComplete = YES;
                    return;
                }
                for (NSInteger i=0; i<[[object objectForKey:@"data"] count]; i++) {
                    RMPublicModel * model = [[RMPublicModel alloc] init];
                    model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                    model.content_img = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_img"]);
                    model.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_name"]);
                    [dataArr addObject:model];
                }
                [mTableView reloadData];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
            }
            
            if (isRefresh){
                [dataArr removeAllObjects];
                for (NSInteger i=0; i<[[object objectForKey:@"data"] count]; i++) {
                    RMPublicModel * model = [[RMPublicModel alloc] init];
                    model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                    model.content_img = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_img"]);
                    model.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_name"]);
                    model.view_link = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"view_link"]);
                    [dataArr addObject:model];
                }
                [mTableView reloadData];
            }

            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

#pragma mark 刷新代理

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction {
    if (direction == RefreshDirectionTop) { //下拉刷新
        pageCount = 1;
        isRefresh = YES;
        isLoadComplete = NO;
        [self requestNewsListWithPageCount:1];
    }else if(direction == RefreshDirectionBottom) { //上拉加载
        if (isLoadComplete){
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.44 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self showHint:@"没有更多教程啦"];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
            });
        }else{
            pageCount ++;
            isRefresh = NO;
            [self requestNewsListWithPageCount:pageCount];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

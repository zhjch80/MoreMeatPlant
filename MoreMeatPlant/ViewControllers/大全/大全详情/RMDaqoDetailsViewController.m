//
//  RMDaqoDetailsViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/17.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMDaqoDetailsViewController.h"
#import "DKLiveBlurView.h"
#import "RMDaqoDetailsCell.h"
#import "RMBottomView.h"

#define kDKTableViewMainBackgroundImageFileName @"DaQuanBackground.jpg"
#define kDKTableViewDefaultCellHeight 50.0f
#define kDKTableViewDefaultContentInset ([UIScreen mainScreen].bounds.size.height - kDKTableViewDefaultCellHeight)

@interface RMDaqoDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,DaqoDetailsDelegate,UIScrollViewDelegate>{
    BOOL isScrollLoadComplete;      //      第一次完全加载完成
    BOOL isBottomState;             //      底部状态栏的状态
    
}
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, strong) DKLiveBlurView *liveBlur;
@property (nonatomic, strong) RMBottomView * bottomView;

@end

@implementation RMDaqoDetailsViewController
@synthesize mTableView, dataArr, liveBlur, bottomView;

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [liveBlur removeScrollViewObserver];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setHideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    
    dataArr = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", nil];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) style:UITableViewStylePlain];
    
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.dataSource = self;
    mTableView.delegate = self;
    mTableView.showsVerticalScrollIndicator = NO;
    mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mTableView.separatorColor = [UIColor clearColor];
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.rowHeight = kDKTableViewDefaultCellHeight;
    
    liveBlur = [[DKLiveBlurView alloc] initWithFrame: self.view.bounds];
    
    liveBlur.originalImage = [UIImage imageNamed:@"testBG.jpg"];
    liveBlur.scrollView = mTableView;
    liveBlur.isGlassEffectOn = YES;
    
    mTableView.backgroundView = liveBlur;
    mTableView.contentInset = UIEdgeInsetsMake(kDKTableViewDefaultContentInset, 0, 0, 0);
    
    [self.view addSubview:mTableView];
    
//TODO:修改
    bottomView = [[RMBottomView alloc] init];
    bottomView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 40);
    [bottomView loadReleasePoisonBottom];
    [self.view addSubview:bottomView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0){
        static NSString *cellIdentifier = @"DaqoDetailsCellIdentifier_1";
        RMDaqoDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMDaqoDetailsCell_1" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.delegate = self;
        }
        return cell;
    }else if (indexPath.row == 1){
        static NSString *cellIdentifier = @"DaqoDetailsCellIdentifier_2";
        RMDaqoDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMDaqoDetailsCell_2" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.delegate = self;
        }
        return cell;
    }else{
        static NSString *cellIdentifier = @"DaqoDetailsCellIdentifier_3";
        RMDaqoDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMDaqoDetailsCell_3" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.delegate = self;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0){
        return 60.0;
    }else if (indexPath.row == 1){
        return 180.0f;
    }else{
        return 450.0f;
    }
}

- (void)daqoqMethodWithTag:(NSInteger)tag {
    switch (tag) {
        case 101:{
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
            
        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat widthHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat height = widthHeight-kDKTableViewDefaultCellHeight+mTableView.contentOffset.y;

    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    RMDaqoDetailsCell *cell = (RMDaqoDetailsCell *)[mTableView cellForRowAtIndexPath:indexPath];

    if (widthHeight-kDKTableViewDefaultCellHeight+mTableView.contentOffset.y > kDKTableViewDefaultCellHeight/2){
        cell.backupBtn.hidden = YES;
    }else{
        cell.backupBtn.hidden = NO;
    }
    
    if (!isScrollLoadComplete){
        isScrollLoadComplete = !isScrollLoadComplete;
    }else{
        if ((mTableView.contentSize.height - kDKTableViewDefaultCellHeight) - height > 20 && (mTableView.contentSize.height - kDKTableViewDefaultCellHeight) - height > 0){
            [UIView animateWithDuration:0.3 animations:^{
                bottomView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 40);
            } completion:^(BOOL finished) {
                
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                bottomView.frame = CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40);
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

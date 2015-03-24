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
#import "XHImageViewer.h"
#import "XHBottomToolBar.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "RMDaqoDetailsFooterView.h"

#define kDKTableViewMainBackgroundImageFileName @"DaQuanBackground.jpg"
#define kDKTableViewDefaultCellHeight 50.0f
#define kDKTableViewDefaultContentInset ([UIScreen mainScreen].bounds.size.height - kDKTableViewDefaultCellHeight)

@interface RMDaqoDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,DaqoDetailsDelegate,BottomDelegate,XHImageViewerDelegate>{
    BOOL isScrollLoadComplete;      //      第一次完全加载完成
    BOOL isBottomState;             //      底部状态栏的状态
    
}
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) DKLiveBlurView *liveBlur;
@property (nonatomic, strong) RMBottomView * bottomView;
@property (nonatomic, strong) XHImageViewer *imageViewer;
@property (nonatomic, strong) NSMutableArray * imageViewArr;
@property (nonatomic, strong) XHBottomToolBar * bottomToolBar;

@end

@implementation RMDaqoDetailsViewController
@synthesize mTableView, liveBlur, bottomView, imageViewer, imageViewArr;

- (void)shareButtonClicked:(UIButton *)sender {
    UIImage *currentImage = [imageViewer currentImage];
    if (currentImage) {
        UIImageWriteToSavedPhotosAlbum(currentImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败\n请到 设置/隐私/照片 中设置 允许访问" ;
    }else{
        msg = @"保存图片成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}


- (XHBottomToolBar *)bottomToolBar {
    if (!_bottomToolBar) {
        _bottomToolBar = [[XHBottomToolBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
        _bottomToolBar.likeButton.hidden = YES;
        _bottomToolBar.shareButton.center = CGPointMake(kScreenWidth/2, 44/2);
        [_bottomToolBar.shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomToolBar;
}

- (UIView *)customBottomToolBarOfImageViewer:(XHImageViewer *)imageViewer {
    return self.bottomToolBar;
}

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
    imageViewArr = [[NSMutableArray alloc] init];

    [self setHideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    
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
    
    bottomView = [[RMBottomView alloc] init];
    bottomView.delegate = self;
    bottomView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 40);
    [bottomView loadBottomWithImageArr:[NSArray arrayWithObjects:@"img_backup", @"img_collectiom", @"img_buy", @"img_share", nil]];
    [self.view addSubview:bottomView];
    
    [self loadTableFooterView];
}

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

- (void)loadTableFooterView {
    RMDaqoDetailsFooterView * tableFooterView = [[[NSBundle mainBundle] loadNibNamed:@"RMDaqoDetailsFooterView" owner:nil options:nil] objectAtIndex:0];
    for (NSInteger i=0; i<2; i++) {
        for (NSInteger j=0; j<5; j++) {
            RMImageView * atlasImg = [[RMImageView alloc] init];
            atlasImg.image = [UIImage imageNamed:@"test_1.jpg"];
            [atlasImg addTarget:self WithSelector:@selector(imageZoomMethodWithImage:)];
            atlasImg.frame = CGRectMake(15 + j*60, 220 + i*60, 50, 50);
            [tableFooterView addSubview:atlasImg];
            [imageViewArr addObject:atlasImg];
        }
    }

    mTableView.tableFooterView = tableFooterView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"DaqoDetailsCellIdentifier";
    RMDaqoDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RMDaqoDetailsCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

#pragma mark - DaqoDetailsDelegate

- (void)imageZoomMethodWithImage:(RMImageView *)image {
    imageViewer = [[XHImageViewer alloc]
                   initWithImageViewerWillDismissWithSelectedViewBlock:
                   ^(XHImageViewer *imageViewer, UIImageView *selectedView) {
                       NSInteger index = [imageViewArr indexOfObject:selectedView];
                       NSLog(@"willDismissBlock index : %ld", (long)index);
                   }
                   didDismissWithSelectedViewBlock:^(XHImageViewer *imageViewer,
                                                     UIImageView *selectedView) {
                       NSInteger index = [imageViewArr indexOfObject:selectedView];
                       NSLog(@"didDismissBlock index : %ld", (long)index);
                   }
                   didChangeToImageViewBlock:^(XHImageViewer *imageViewer,
                                               UIImageView *selectedView) {
                       NSInteger index = [imageViewArr indexOfObject:selectedView];
                       NSLog(@"change:%ld",index);
                       
                   }];
    imageViewer.delegate = self;
    imageViewer.disableTouchDismiss = NO;
    [imageViewer showWithImageViews:imageViewArr selectedView:(RMImageView *)image];
    
    NSInteger index = [imageViewArr indexOfObject:(RMImageView *)image];
    NSLog(@"select:%ld",index);
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

#pragma mark -

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

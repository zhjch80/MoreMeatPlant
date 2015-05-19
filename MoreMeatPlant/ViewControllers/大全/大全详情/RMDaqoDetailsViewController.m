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
#import "RMCommentsView.h"
#import "FileUtil.h"
#import "UIView+Effects.h"
#import "RMShopCarViewController.h"

#define kDKTableViewMainBackgroundImageFileName @"DaQuanBackground.jpg"
#define kDKTableViewDefaultCellHeight 50.0f
#define kDKTableViewDefaultContentInset ([UIScreen mainScreen].bounds.size.height - kDKTableViewDefaultCellHeight)

@interface RMDaqoDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,DaqoDetailsDelegate,BottomDelegate,XHImageViewerDelegate,DaqoDetailsFooterDelegate,CommentsViewDelegate>{
    BOOL isScrollLoadComplete;      //      第一次完全加载完成
    BOOL isBottomState;             //      底部状态栏的状态
    BOOL isFistViewDidAppear;
    BOOL isTakingPictures;          //是否在选取图片
    
    BOOL isBlur;                    //是否已经添加毛玻璃
    RKNotificationHub * car_badge;
}
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) DKLiveBlurView *liveBlur;
@property (nonatomic, strong) RMBottomView * bottomView;
@property (nonatomic, strong) XHImageViewer *imageViewer;
@property (nonatomic, strong) NSMutableArray * imageViewArr;
@property (nonatomic, strong) XHBottomToolBar * bottomToolBar;
@property (nonatomic, strong) RMPublicModel * dataModel;
@property (nonatomic, strong) UIView * bgBlurView;

@end

@implementation RMDaqoDetailsViewController
@synthesize mTableView, liveBlur, bottomView, imageViewer, imageViewArr, dataModel, bgBlurView;

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
    if (!isTakingPictures){
        [liveBlur removeScrollViewObserver];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    [car_badge setCount:[[self queryShopCarNumber] intValue]];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!isFistViewDidAppear){
        [self requestDetails];
        isFistViewDidAppear = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[RMDaqoDetailsViewController class]];
    
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[RMDaqoDetailsViewController class]];
    
    imageViewArr = [[NSMutableArray alloc] init];

    [self setHideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.dataSource = self;
    mTableView.delegate = self;
    mTableView.showsVerticalScrollIndicator = NO;
//    mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mTableView.separatorColor = [UIColor clearColor];
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.rowHeight = kDKTableViewDefaultCellHeight;
    
    liveBlur = [[DKLiveBlurView alloc] initWithFrame: CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    liveBlur.contentMode = UIViewContentModeCenter;
    //    liveBlur.originalImage = [UIImage imageNamed:@"testBG.jpg"];
    liveBlur.scrollView = mTableView;
    liveBlur.isGlassEffectOn = YES;
    liveBlur.backgroundColor = [UIColor blackColor];
    mTableView.backgroundView = liveBlur;
    mTableView.contentInset = UIEdgeInsetsMake(kDKTableViewDefaultContentInset, 0, 0, 0);
    
    [self.view addSubview:mTableView];
    
//    bgBlurView =  [[UIView alloc] init];
//    bgBlurView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
//    bgBlurView.userInteractionEnabled = YES;
//    [self.view addSubview:bgBlurView];
    
    bottomView = [[RMBottomView alloc] init];
    bottomView.delegate = self;
    bottomView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 40);
    [bottomView loadBottomWithImageArr:[NSArray arrayWithObjects:@"img_backup", @"img_collectiom", @"img_buy", nil]];
    [self.view addSubview:bottomView];

    isFistViewDidAppear = NO;
    
    
    UIButton * car_btn = (UIButton *)[bottomView viewWithTag:2];
    car_badge = [[RKNotificationHub alloc]initWithView:car_btn];
    [car_badge scaleCircleSizeBy:0.5];
    [car_badge setCount:[[self queryShopCarNumber] intValue]];
    
}

- (void)bottomMethodWithTag:(NSInteger)tag {
    switch (tag) {
        case 0:{
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 1:{
            if (![[RMUserLoginInfoManager loginmanager] state]){
                NSLog(@"去登录...");
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，请先登录!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                [alert show];
                return;
            }
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [RMAFNRequestManager getMembersCollectWithCollect_id:dataModel.auto_id withContent_type:@"4" withID:[RMUserLoginInfoManager loginmanager].user withPWD:[RMUserLoginInfoManager loginmanager].pwd callBack:^(NSError *error, BOOL success, id object) {
                if (error){
                    NSLog(@"error:%@",error);
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    return ;
                }
                
                if (success){
                    [self showHint:[object objectForKey:@"msg"]];
                    UIButton * btn = (UIButton *)[bottomView viewWithTag:1];
                    [btn setBackgroundImage:LOADIMAGE(@"img_asced", kImageTypePNG) forState:UIControlStateNormal];
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                }else{
                    [self showHint:[object objectForKey:@"msg"]];
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                }
            }];
            
            break;
        }
        case 2:{
            NSLog(@"购买");
            if(![[RMUserLoginInfoManager loginmanager] state]){
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，请先登录!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                [alert show];
                return;
            }
            RMShopCarViewController * shop = [[RMShopCarViewController alloc]initWithNibName:@"RMShopCarViewController" bundle:nil];
            [self.navigationController pushViewController:shop animated:YES];
            break;
        }
            
        default:
            break;
    }
}

- (void)loadTableFooterView {
    CGFloat offsetY = 0;
    
    offsetY = [UtilityFunc boundingRectWithSize:CGSizeMake(kScreenWidth - 20, 0) font:[UIFont systemFontOfSize:15.0f] text:dataModel.content_desc].height - 100;
    
    offsetY = (offsetY < 0 ? 0 : offsetY);
    
    RMDaqoDetailsFooterView * tableFooterView = [[[NSBundle mainBundle] loadNibNamed:@"RMDaqoDetailsFooterView" owner:nil options:nil] objectAtIndex:0];
    tableFooterView.delegate = self;
    tableFooterView.backgroundColor = [UIColor clearColor];
    [tableFooterView.addImageBtn.layer setCornerRadius:5.0];
    [tableFooterView.addedAndCorrectedBtn.layer setCornerRadius:5.0];
    
    tableFooterView.frame = CGRectMake(tableFooterView.frame.origin.x, tableFooterView.frame.origin.y, tableFooterView.frame.size.width, tableFooterView.frame.size.height + offsetY);
    
    tableFooterView.chineseName.frame = CGRectMake(tableFooterView.chineseName.frame.origin.x, tableFooterView.chineseName.frame.origin.y, kScreenWidth - 16, 28);
    
    tableFooterView.englishName.frame = CGRectMake(tableFooterView.englishName.frame.origin.x, tableFooterView.englishName.frame.origin.y, kScreenWidth - 16, 28);

    tableFooterView.intro.frame = CGRectMake(tableFooterView.intro.frame.origin.x, tableFooterView.intro.frame.origin.y, kScreenWidth - 20, tableFooterView.intro.frame.size.height + offsetY);
    
    tableFooterView.lineOne.frame = CGRectMake(tableFooterView.lineOne.frame.origin.x, tableFooterView.lineOne.frame.origin.y, kScreenWidth - 20, tableFooterView.lineOne.frame.size.height);
    tableFooterView.lineOne.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"baidian"]];

    tableFooterView.lineTwo.frame = CGRectMake(tableFooterView.lineTwo.frame.origin.x, tableFooterView.lineTwo.frame.origin.y + offsetY, kScreenWidth - 20, tableFooterView.lineTwo.frame.size.height);
    tableFooterView.lineTwo.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"baidian"]];

    tableFooterView.atlas.frame = CGRectMake(tableFooterView.atlas.frame.origin.x, tableFooterView.atlas.frame.origin.y + offsetY, kScreenWidth - 10, tableFooterView.atlas.frame.size.height);
    
    for (NSInteger i=0; i<10; i++){
        UIImageView * image = (UIImageView *)[tableFooterView viewWithTag:501+i];
        image.frame = CGRectMake(image.frame.origin.x, image.frame.origin.y + offsetY, image.frame.size.width, image.frame.size.height);
    }
    
    tableFooterView.planting.frame = CGRectMake(tableFooterView.planting.frame.origin.x, tableFooterView.planting.frame.origin.y + offsetY, kScreenWidth - 10, tableFooterView.planting.frame.size.height);
    
    tableFooterView.lineThree.frame = CGRectMake(tableFooterView.lineThree.frame.origin.x, tableFooterView.lineThree.frame.origin.y + offsetY, kScreenWidth - 20, tableFooterView.lineThree.frame.size.height);
    tableFooterView.lineThree.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"baidian"]];
    
    tableFooterView.lineFour.frame = CGRectMake(tableFooterView.lineFour.frame.origin.x, tableFooterView.lineFour.frame.origin.y + offsetY, kScreenWidth - 20, tableFooterView.lineFour.frame.size.height);
    tableFooterView.lineFour.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"baidian"]];

    tableFooterView.breeding.frame = CGRectMake(tableFooterView.breeding.frame.origin.x, tableFooterView.breeding.frame.origin.y + offsetY, kScreenWidth - 10, tableFooterView.breeding.frame.size.height);
    
    tableFooterView.breedingContent.frame = CGRectMake(tableFooterView.breedingContent.frame.origin.x, tableFooterView.breedingContent.frame.origin.y + offsetY, kScreenWidth - 10, tableFooterView.breedingContent.frame.size.height);
    
    tableFooterView.addImageBtn.frame = CGRectMake(tableFooterView.addImageBtn.frame.origin.x, tableFooterView.addImageBtn.frame.origin.y + offsetY, tableFooterView.addImageBtn.frame.size.width, tableFooterView.addImageBtn.frame.size.height);
    tableFooterView.addImageBtn.center = CGPointMake(kScreenWidth/4, tableFooterView.addImageBtn.center.y);

    tableFooterView.addedAndCorrectedBtn.frame = CGRectMake(tableFooterView.addedAndCorrectedBtn.frame.origin.x, tableFooterView.addedAndCorrectedBtn.frame.origin.y + offsetY, tableFooterView.addedAndCorrectedBtn.frame.size.width, tableFooterView.addedAndCorrectedBtn.frame.size.height);
    tableFooterView.addedAndCorrectedBtn.center = CGPointMake(kScreenWidth/4 * 3, tableFooterView.addedAndCorrectedBtn.center.y);
    
    tableFooterView.chineseName.text = dataModel.family_name;
    tableFooterView.englishName.text = [NSString stringWithFormat:@"拉丁文: %@",dataModel.latin_name];
    
    tableFooterView.intro.text = dataModel.content_desc;
    
    NSInteger count = 0;
    for (NSInteger i=0; i<2; i++) {
        for (NSInteger j=0; j<5; j++) {
            if (count >= dataModel.imgs.count){
                break;
            }else{
                RMImageView * atlasImg = [[RMImageView alloc] init];
                [atlasImg sd_setImageWithURL:[NSURL URLWithString:[[dataModel.imgs objectAtIndex:count] objectForKey:@"content_img"]] placeholderImage:nil];
                [atlasImg addTarget:self withSelector:@selector(imageZoomMethodWithImage:)];
                atlasImg.frame = CGRectMake(15 + j*60, 220 + i*60 + offsetY, 50, 50);
                [tableFooterView addSubview:atlasImg];
                [imageViewArr addObject:atlasImg];
                count ++;
            }
        }
    }
    
    UIImageView * leftCenterImg = (UIImageView *)[tableFooterView viewWithTag:503];
    leftCenterImg.center = CGPointMake(kScreenWidth/4, leftCenterImg.center.y);
    
    UIImageView * rightCenterImg = (UIImageView *)[tableFooterView viewWithTag:508];
    rightCenterImg.center = CGPointMake(kScreenWidth/4 * 3, rightCenterImg.center.y);
    
    for (NSInteger i=0; i<5; i++) {
        UIImageView * image = (UIImageView *)[tableFooterView viewWithTag:501+i];
        if (i == 0){
            image.center = CGPointMake(leftCenterImg.frame.origin.x - 30, image.center.y);
        }
        
        if (i == 1){
            image.center = CGPointMake(leftCenterImg.frame.origin.x - 10, image.center.y);
        }
        
        if (i == 3){
            image.center = CGPointMake(leftCenterImg.frame.origin.x + 25, image.center.y);
        }
        
        if (i == 4){
            image.center = CGPointMake(leftCenterImg.frame.origin.x + 42, image.center.y);
        }
        
        if (i >= dataModel.content_plant1.integerValue){
            image.image = [UIImage imageNamed:@"img_yushui_empty"];
        }else{
            image.image = [UIImage imageNamed:@"img_yushui_full"];
        }
    }
    
    for (NSInteger i=0; i<5; i++) {
        UIImageView * image = (UIImageView *)[tableFooterView viewWithTag:506+i];
        if (i == 0){
            image.center = CGPointMake(rightCenterImg.frame.origin.x - 35, image.center.y);
        }
        
        if (i == 1){
            image.center = CGPointMake(rightCenterImg.frame.origin.x - 12, image.center.y);
        }
        
        if (i == 3){
            image.center = CGPointMake(rightCenterImg.frame.origin.x + 32, image.center.y);
        }
        
        if (i == 4){
            image.center = CGPointMake(rightCenterImg.frame.origin.x + 55, image.center.y);
        }
        
        if (i >= dataModel.content_plant2.integerValue){
            image.image = [UIImage imageNamed:@"img_sun_empty"];
        }else{
            image.image = [UIImage imageNamed:@"img_sun_full"];
        }
    }
    
    tableFooterView.breedingContent.text = dataModel.content_breed;
    
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
    cell.plantName.text = dataModel.content_name;
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
//                       NSInteger index = [imageViewArr indexOfObject:selectedView];
//                       NSLog(@"change:%ld",index);
                       
                   }];
    imageViewer.delegate = self;
    imageViewer.disableTouchDismiss = NO;
    [imageViewer showWithImageViews:imageViewArr selectedView:(RMImageView *)image];
    
//    NSInteger index = [imageViewArr indexOfObject:(RMImageView *)image];
//    NSLog(@"select:%ld",index);
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

- (void)footerBtnMethodWithTag:(NSInteger)tag {
    if (![[RMUserLoginInfoManager loginmanager] state]){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，请先登录!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
        return;
    }
    
    switch (tag) {
        case 1:{
            isTakingPictures = YES;
            UIActionSheet *sheet = nil;
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
            }else{
                sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
            }
            [sheet showInView:self.view];
            break;
        }
        case 2:{
            RMCommentsView * commentsView = [[RMCommentsView alloc] init];
            commentsView.delegate = self;
            commentsView.backgroundColor = [UIColor clearColor];
            commentsView.requestType = 5;
            commentsView.code = dataModel.auto_id;
            commentsView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            [commentsView loadCommentsViewWithReceiver:[NSString stringWithFormat:@"  补充:%@",@"补充说明"] withImage:nil];
            [self.view addSubview:commentsView];
            break;
        }
            
        default:
            break;
    }
}

- (void)commentMethodWithType:(NSInteger)type withError:(NSError *)error withState:(BOOL)success withObject:(id)object withImage:(RMImageView *)image {
    if (error){
        NSLog(@"%@",error);
        [self showHint:@"提交失败！"];
        return;
    }
    
    if (success){
        [self showHint:[object objectForKey:@"msg"]];
    }else{
        [self showHint:[object objectForKey:@"msg"]];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSUInteger sourceType = 0;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:{
                // 相机
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            }
            case 1:{
                // 相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            }
            case 2:{
                // 取消
                return;
            }
        }
    } else {
        if (buttonIndex == 1) {
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    isTakingPictures = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    
//    NSData *data = UIImageJPEGRepresentation(image, 0.5);
//    
//    [self saveImage:[UIImage imageWithData:data] withName:@"uploadSingleImage.jpg"];
//    
//    NSString *path = [[FileUtil getCachePathFor:@"uploadImageCache"] stringByAppendingPathComponent:@"uploadSingleImage.jpg"];
//
//    [self requestAddImageViewWithImgPath:path];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    isTakingPictures = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    
    //获得用户编辑过的图片
    UIImage* image = [info objectForKey: @"UIImagePickerControllerEditedImage"];
//    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];

    NSData *data = UIImageJPEGRepresentation(image, 0.5);
 
    [self saveImage:[UIImage imageWithData:data] withName:@"uploadSingleImage.jpg"];
    
    NSString *path = [[FileUtil getCachePathFor:@"uploadImageCache"] stringByAppendingPathComponent:@"uploadSingleImage.jpg"];
    
    [self requestAddImageViewWithImgPath:path];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    isTakingPictures = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName {
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *path = [[FileUtil getCachePathFor:@"uploadImageCache"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:path atomically:NO];
}

#pragma mark -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat widthHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat height = widthHeight-kDKTableViewDefaultCellHeight+mTableView.contentOffset.y;

    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    RMDaqoDetailsCell *cell = (RMDaqoDetailsCell *)[mTableView cellForRowAtIndexPath:indexPath];

    if (widthHeight-kDKTableViewDefaultCellHeight+mTableView.contentOffset.y > kDKTableViewDefaultCellHeight/2){
        cell.backupBtn.hidden = YES;
        if (isBlur){
            
        }else{
            [liveBlur blur];
            isBlur = YES;
        }
    }else{
        cell.backupBtn.hidden = NO;
        if (isBlur){
            [liveBlur unBlur];
            isBlur = NO;
        }else{
            
        }
    }
    
    liveBlur.backgroundColor = [UIColor blackColor];

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

#pragma mark - 请求数据

/** 
 *  @param      详情
 */
- (void)requestDetails {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString * user = nil;
    NSString * pwd = nil;
    if([[RMUserLoginInfoManager loginmanager] state]){
        user = [[RMUserLoginInfoManager loginmanager] user];
        pwd = [[RMUserLoginInfoManager loginmanager] pwd];
    }else{
    
    }
    
    [RMAFNRequestManager getPlantDaqoDetailsWithAuto_id:self.auto_id withUser:user Pwd:pwd callBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"error:%@",error);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return ;
        }
        
        if (success){
            NSLog(@"object:%@",object);
            
            if ([(NSArray *)[[object objectForKey:@"data"] objectForKey:@"data"] count] == 0){
                [self showHint:@"数据返回异常"];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                return;
            }
            
            dataModel = [[RMPublicModel alloc] init];
            dataModel.auto_id = OBJC([[[[object objectForKey:@"data"] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"auto_id"]);
            dataModel.content_name = OBJC([[[[object objectForKey:@"data"] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"content_name"]);
            dataModel.content_course = OBJC([[[[object objectForKey:@"data"] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"content_course"]);
            dataModel.content_grow = OBJC([[[[object objectForKey:@"data"] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"content_grow"]);
            dataModel.content_grow = OBJC([[[[object objectForKey:@"data"] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"content_grow"]);
            dataModel.content_img = OBJC([[[[object objectForKey:@"data"] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"content_img"]);
            dataModel.content_bimg = OBJC([[[[object objectForKey:@"data"] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"content_bimg"]);
            dataModel.family_name = OBJC([[[[object objectForKey:@"data"] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"family_name"]);
            dataModel.latin_name = OBJC([[[[object objectForKey:@"data"] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"latin_name"]);
            dataModel.content_desc = OBJC([[[[object objectForKey:@"data"] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"content_desc"]);
            dataModel.content_plant1 = OBJC([[[[object objectForKey:@"data"] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"content_plant1"]);
            dataModel.content_plant2 = OBJC([[[[object objectForKey:@"data"] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"content_plant2"]);
            dataModel.content_breed = OBJC([[[[object objectForKey:@"data"] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"content_breed"]);
            dataModel.is_collect = OBJC([[[[object objectForKey:@"data"] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"is_collect"]);

            dataModel.imgs = [[object objectForKey:@"data"] objectForKey:@"img"];
            
            if ([dataModel.is_collect isEqualToString:@"1"]){
                UIButton * btn = (UIButton *)[bottomView viewWithTag:1];
                [btn setBackgroundImage:LOADIMAGE(@"img_asced", kImageTypePNG) forState:UIControlStateNormal];
            }
            
            [liveBlur sd_setImageWithURL:[NSURL URLWithString:dataModel.content_bimg]];
            
            [mTableView reloadData];
            
            [self loadTableFooterView];

            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

/**
 *   @method     添加图片
 */
- (void)requestAddImageViewWithImgPath:(NSString *)imgPath {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager postPlantDaqoAddImageWithAll_id:dataModel.auto_id withContent_img:imgPath withID:[RMUserLoginInfoManager loginmanager].user withPWD:[RMUserLoginInfoManager loginmanager].pwd callBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"error:%@",error);
            [self showHint:@"添加失败，请重新添加"];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return ;
        }
        
        if (success){
            [self showHint:[object objectForKey:@"msg"]];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }else{
            [self showHint:[object objectForKey:@"msg"]];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

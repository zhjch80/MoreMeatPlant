//
//  RMPostCollectionViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/15.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMPostCollectionViewController.h"
#import "RMReleasePoisonDetailsViewController.h"
#import "RefreshControl.h"
#import "CustomRefreshView.h"
#import "UIViewController+HUD.h"

@interface RMPostCollectionViewController ()<RefreshControlDelegate>{
    NSInteger pageCount;
    BOOL isRefresh;
    BOOL isLoadComplete;
}
@property (nonatomic, strong) RefreshControl * refreshControl;


@end

@implementation RMPostCollectionViewController
@synthesize dataArr;
@synthesize refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    dataArr = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"", nil];
    
    refreshControl=[[RefreshControl alloc] initWithScrollView:_mainTableView delegate:self];
    refreshControl.topEnabled = YES;
    refreshControl.bottomEnabled = YES;
    [refreshControl registerClassForTopView:[CustomRefreshView class]];
    pageCount = 1;
    isRefresh = YES;
}
#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row%3==0){
        static NSString * identifierStr = @"releasePoisonIdentifier";
        RMReleasePoisonCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
        
        if (!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonCell_1" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
            cell.delegate = self;
        }
        
        cell.plantTitle.text = @"未读 家有鲜肉 刚入的罗密欧，美不？";
        NSMutableAttributedString *oneAttributeStr = [[NSMutableAttributedString alloc]initWithString:@"未读 家有鲜肉 刚入的罗密欧，美不？"];
        [oneAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.31 blue:0.4 alpha:1] range:NSMakeRange(0, 2)];
        [oneAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0.62 blue:0.59 alpha:1] range:NSMakeRange(3, 4)];
        cell.plantTitle.attributedText = oneAttributeStr;
        
        cell.likeImg.image = LOADIMAGE(@"img_asc", kImageTypePNG);
        cell.chatImg.image = LOADIMAGE(@"img_chat", kImageTypePNG);
        cell.praiseImg.image = LOADIMAGE(@"img_zan", kImageTypePNG);
        
        cell.userName.text = @"Lucy 10分钟前";
        cell.likeTitle.text = @"99+";
        cell.chatTitle.text = @"99+";
        cell.praiseTitle.text = @"99+";
        return cell;
    }else if (indexPath.row%3 == 1){
        static NSString * identifierStr = @"releasePoisonIdentifier";
        RMReleasePoisonCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
        
        if (!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonCell_2" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
            cell.delegate = self;
        }
        
        cell.plantTitle.text = @"已读 家有鲜肉 刚入的罗密欧，美不？";
        NSMutableAttributedString *oneAttributeStr = [[NSMutableAttributedString alloc]initWithString:@"已读 家有鲜肉 刚入的罗密欧，美不？"];
        [oneAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.59 green:0.59 blue:0.59 alpha:1] range:NSMakeRange(0, 2)];
        [oneAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0.62 blue:0.59 alpha:1] range:NSMakeRange(3, 4)];
        cell.plantTitle.attributedText = oneAttributeStr;
        
        cell.likeImg.image = LOADIMAGE(@"img_asc", kImageTypePNG);
        cell.chatImg.image = LOADIMAGE(@"img_chat", kImageTypePNG);
        cell.praiseImg.image = LOADIMAGE(@"img_zan", kImageTypePNG);
        
        cell.userName.text = @"Lucy 10分钟前";
        cell.likeTitle.text = @"99+";
        cell.chatTitle.text = @"99+";
        cell.praiseTitle.text = @"99+";
        return cell;
    }else{
        static NSString * identifierStr = @"releasePoisonIdentifier";
        RMReleasePoisonCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
        
        if (!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonCell_3" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
            cell.delegate = self;
        }
        
        cell.plantTitle.text = @"未读 家有鲜肉 刚入的罗密欧，美不？";
        NSMutableAttributedString *oneAttributeStr = [[NSMutableAttributedString alloc]initWithString:@"未读 家有鲜肉 刚入的罗密欧，美不？"];
        [oneAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.31 blue:0.4 alpha:1] range:NSMakeRange(0, 2)];
        [oneAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0.62 blue:0.59 alpha:1] range:NSMakeRange(3, 4)];
        cell.plantTitle.attributedText = oneAttributeStr;
        
        cell.likeImg.image = LOADIMAGE(@"img_asc", kImageTypePNG);
        cell.chatImg.image = LOADIMAGE(@"img_chat", kImageTypePNG);
        cell.praiseImg.image = LOADIMAGE(@"img_zan", kImageTypePNG);
        
        cell.userName.text = @"Lucy 10分钟前";
        cell.likeTitle.text = @"99+";
        cell.chatTitle.text = @"99+";
        cell.praiseTitle.text = @"99+";
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180.0;
}

#pragma mark - 添加喜欢 赞 评论

- (void)addLikeWithImage:(RMImageView *)image {
    NSLog(@"添加喜欢");
}

- (void)addChatWithImage:(RMImageView *)image {
    NSLog(@"添加评论");
}

- (void)addPraiseWithImage:(RMImageView *)image {
    NSLog(@"添加赞");
}

#pragma mark - 帖子详情

- (void)jumpPostDetailsWithImage:(RMImageView *)image {
    RMReleasePoisonDetailsViewController * releasePoisonDetailsCtl = [[RMReleasePoisonDetailsViewController alloc] init];
    [self.navigationController pushViewController:releasePoisonDetailsCtl animated:YES];
}

#pragma mark 刷新代理

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction {
    if (direction == RefreshDirectionTop) { //下拉刷新
        pageCount = 1;
        isRefresh = YES;
        isLoadComplete = NO;
        //        [self requestDataWithPageCount:1];
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
            //            [self requestDataWithPageCount:pageCount];
        }
        
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

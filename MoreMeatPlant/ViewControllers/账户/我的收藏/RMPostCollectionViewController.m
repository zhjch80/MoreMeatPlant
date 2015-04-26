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
#import "RefreshView.h"
#import "UIViewController+HUD.h"
#import "NSString+TimeInterval.h"

@interface RMPostCollectionViewController ()<RefreshControlDelegate>{
    NSInteger pageCount;
}
@property (nonatomic, strong) RefreshControl * refreshControl;


@end

@implementation RMPostCollectionViewController
@synthesize dataArr;
@synthesize refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    dataArr = [[NSMutableArray alloc] init];
    
    self.mainTableView.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
    
    refreshControl=[[RefreshControl alloc] initWithScrollView:_mainTableView delegate:self];
    refreshControl.topEnabled = YES;
    refreshControl.bottomEnabled = YES;
    [refreshControl registerClassForTopView:[RefreshView class]];
    pageCount = 1;
    
    [self requestListWithPageCount];
}
#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self loadIndexPath:indexPath withTableView:tableView];
}

- (UITableViewCell *)loadIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView {
    RMPublicModel * model = [dataArr objectAtIndex:indexPath.row];
    NSInteger value = 0;
    if ([model.imgs isKindOfClass:[NSNull class]]){
        value = 0;
    }else{
        value = [model.imgs count];
    }
    
    if (value >= 3){
        static NSString * identifierStr = @"releasePoisonIdentifier_2";
        RMReleasePoisonCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
        
        if (!cell){
            if (IS_IPHONE_6p_SCREEN){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonCell_2_6p" owner:self options:nil] lastObject];
            }else if (IS_IPHONE_6_SCREEN){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonCell_2_6" owner:self options:nil] lastObject];
            }else{
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonCell_2" owner:self options:nil] lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
            cell.delegate = self;
        }
        
        cell.plantTitle.text = [NSString  stringWithFormat:@"已读 %@ %@",model.content_class,model.content_name];
        NSMutableAttributedString *oneAttributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString  stringWithFormat:@"已读 %@ %@",model.content_class,model.content_name]];
        [oneAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.59 green:0.59 blue:0.59 alpha:1] range:NSMakeRange(0, 2)];
        [oneAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0.62 blue:0.59 alpha:1] range:NSMakeRange(3, 4)];
        cell.plantTitle.attributedText = oneAttributeStr;
        [cell.userHeadImg sd_setImageWithURL:[NSURL URLWithString:model.content_face] placeholderImage:nil];
        
        NSString * _name;
        if ([model.member_name length] > 5){
            _name = [model.member_name substringToIndex:5];
            _name = [NSString stringWithFormat:@"%@...",_name];
        }else{
            _name = model.member_name;
        }
        
        cell.userName.text = [NSString stringWithFormat:@"%@ %@",_name,[[NSString stringWithFormat:@"%@:00",model.create_time] intervalSinceNow]];
        
        [cell.leftTwoImg sd_setImageWithURL:[NSURL URLWithString:[[model.imgs objectAtIndex:0] objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"img_default.jpg"]];
        [cell.rightUpTwoImg sd_setImageWithURL:[NSURL URLWithString:[[model.imgs objectAtIndex:1] objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"img_default.jpg"]];
        [cell.rightDownTwoImg sd_setImageWithURL:[NSURL URLWithString:[[model.imgs objectAtIndex:2] objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"img_default.jpg"]];
        
        cell.leftTwoImg.identifierString = model.auto_id;
        cell.rightUpTwoImg.identifierString = model.auto_id;
        cell.rightDownTwoImg.identifierString = model.auto_id;
        
        cell.likeImg.identifierString = model.auto_id;
        cell.likeImg.indexPath = indexPath;
        cell.chatImg.identifierString = model.auto_id;
        cell.chatImg.indexPath = indexPath;
        cell.praiseImg.identifierString = model.auto_id;
        cell.praiseImg.indexPath = indexPath;
        
        if (model.is_collect){
            cell.likeImg.image = LOADIMAGE(@"img_asced", kImageTypePNG);
        }else{
            cell.likeImg.image = LOADIMAGE(@"img_asc", kImageTypePNG);
        }
        cell.chatImg.image = LOADIMAGE(@"img_chat", kImageTypePNG);
        if (model.is_top){
            cell.praiseImg.image = LOADIMAGE(@"img_zaned", kImageTypePNG);
        }else{
            cell.praiseImg.image = LOADIMAGE(@"img_zan", kImageTypePNG);
        }
        
        cell.likeTitle.text = [self getLargeNumbersToSpecificStr:model.content_collect];
        cell.chatTitle.text = [self getLargeNumbersToSpecificStr:model.content_review];
        cell.praiseTitle.text = [self getLargeNumbersToSpecificStr:model.content_top];
        return cell;
    }else if (value == 2){
        static NSString * identifierStr = @"releasePoisonIdentifier_1";
        RMReleasePoisonCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
        
        if (!cell){
            if (IS_IPHONE_6p_SCREEN){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonCell_1_6p" owner:self options:nil] lastObject];
            }else if (IS_IPHONE_6_SCREEN){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonCell_1_6" owner:self options:nil] lastObject];
            }else{
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonCell_1" owner:self options:nil] lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
            cell.delegate = self;
        }
        
        cell.plantTitle.text = [NSString  stringWithFormat:@"已读 %@ %@",model.content_class,model.content_name];
        NSMutableAttributedString *oneAttributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString  stringWithFormat:@"已读 %@ %@",model.content_class,model.content_name]];
        [oneAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.31 blue:0.4 alpha:1] range:NSMakeRange(0, 2)];
        [oneAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0.62 blue:0.59 alpha:1] range:NSMakeRange(3, 4)];
        cell.plantTitle.attributedText = oneAttributeStr;
        [cell.userHeadImg sd_setImageWithURL:[NSURL URLWithString:model.content_face] placeholderImage:nil];
        
        NSString * _name;
        if ([model.member_name length] > 5){
            _name = [model.member_name substringToIndex:5];
            _name = [NSString stringWithFormat:@"%@...",_name];
        }else{
            _name = model.member_name;
        }
        
        cell.userName.text = [NSString stringWithFormat:@"%@ %@",_name,[[NSString stringWithFormat:@"%@:00",model.create_time] intervalSinceNow]];
        
        [cell.leftImg sd_setImageWithURL:[NSURL URLWithString:[[model.imgs objectAtIndex:0] objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"img_default.jpg"]];
        [cell.rightImg sd_setImageWithURL:[NSURL URLWithString:[[model.imgs objectAtIndex:1] objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"img_default.jpg"]];
        
        cell.leftImg.identifierString = model.auto_id;
        cell.rightImg.identifierString = model.auto_id;
        cell.likeImg.identifierString = model.auto_id;
        cell.likeImg.indexPath = indexPath;
        cell.chatImg.identifierString = model.auto_id;
        cell.chatImg.indexPath = indexPath;
        cell.praiseImg.identifierString = model.auto_id;
        cell.praiseImg.indexPath = indexPath;
        
        if (model.is_collect){
            cell.likeImg.image = LOADIMAGE(@"img_asced", kImageTypePNG);
        }else{
            cell.likeImg.image = LOADIMAGE(@"img_asc", kImageTypePNG);
        }
        cell.chatImg.image = LOADIMAGE(@"img_chat", kImageTypePNG);
        if (model.is_top){
            cell.praiseImg.image = LOADIMAGE(@"img_zaned", kImageTypePNG);
        }else{
            cell.praiseImg.image = LOADIMAGE(@"img_zan", kImageTypePNG);
        }
        
        cell.likeTitle.text = [self getLargeNumbersToSpecificStr:model.content_collect];
        cell.chatTitle.text = [self getLargeNumbersToSpecificStr:model.content_review];
        cell.praiseTitle.text = [self getLargeNumbersToSpecificStr:model.content_top];
        return cell;
    } else {
        static NSString * identifierStr = @"releasePoisonIdentifier_3";
        RMReleasePoisonCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
        
        if (!cell){
            if (IS_IPHONE_6p_SCREEN){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonCell_3_6p" owner:self options:nil] lastObject];
            }else if (IS_IPHONE_6_SCREEN){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonCell_3_6" owner:self options:nil] lastObject];
            }else{
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonCell_3" owner:self options:nil] lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
            cell.delegate = self;
        }
        
        cell.plantTitle.text = [NSString  stringWithFormat:@"已读 %@ %@",model.content_class,model.content_name];
        NSMutableAttributedString *oneAttributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString  stringWithFormat:@"已读 %@ %@",model.content_class,model.content_name]];
        [oneAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.31 blue:0.4 alpha:1] range:NSMakeRange(0, 2)];
        [oneAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0.62 blue:0.59 alpha:1] range:NSMakeRange(3, 4)];
        cell.plantTitle.attributedText = oneAttributeStr;
        [cell.userHeadImg sd_setImageWithURL:[NSURL URLWithString:model.content_face] placeholderImage:nil];
        
        NSString * _name;
        if ([model.member_name length] > 5){
            _name = [model.member_name  substringToIndex:5];
            _name = [NSString stringWithFormat:@"%@...",_name];
        }else{
            _name = model.member_name;
        }
        
        cell.userName.text = [NSString stringWithFormat:@"%@ %@",_name,[[NSString stringWithFormat:@"%@:00",model.create_time] intervalSinceNow]];
        
        
        if ([model.imgs isKindOfClass:[NSNull class]]){
            cell.threeImg.image = [UIImage imageNamed:@"img_default.jpg"];
        }else{
            if ([model.imgs count] == 0){
                cell.threeImg.image = [UIImage imageNamed:@"img_default.jpg"];
            }else{
                [cell.threeImg sd_setImageWithURL:[NSURL URLWithString:[[model.imgs objectAtIndex:0] objectForKey:@"content_img"]] placeholderImage:nil];
            }
        }
        
        cell.threeImg.identifierString = model.auto_id;
        cell.likeImg.identifierString = model.auto_id;
        cell.likeImg.indexPath = indexPath;
        cell.chatImg.identifierString = model.auto_id;
        cell.chatImg.indexPath = indexPath;
        cell.praiseImg.identifierString = model.auto_id;
        cell.praiseImg.indexPath = indexPath;
        
        if (model.is_collect){
            cell.likeImg.image = LOADIMAGE(@"img_asced", kImageTypePNG);
        }else{
            cell.likeImg.image = LOADIMAGE(@"img_asc", kImageTypePNG);
        }
        cell.chatImg.image = LOADIMAGE(@"img_chat", kImageTypePNG);
        if (model.is_top){
            cell.praiseImg.image = LOADIMAGE(@"img_zaned", kImageTypePNG);
        }else{
            cell.praiseImg.image = LOADIMAGE(@"img_zan", kImageTypePNG);
        }
        
        cell.likeTitle.text = [self getLargeNumbersToSpecificStr:model.content_collect];
        cell.chatTitle.text = [self getLargeNumbersToSpecificStr:model.content_review];
        cell.praiseTitle.text = [self getLargeNumbersToSpecificStr:model.content_top];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
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
    if(self.detailcall_back){
        _detailcall_back (image.identifierString);
    }
}

#pragma mark 刷新代理

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction {
    if (direction == RefreshDirectionTop) { //下拉刷新
            pageCount = 1;
            [self requestListWithPageCount];
    }else if(direction == RefreshDirectionBottom) { //上拉加载
            pageCount ++;
            [self requestListWithPageCount];
    }
}


/**
 *  请求List数据
 */
- (void)requestListWithPageCount {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager myCollectionRequestWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] Type:@"1" Page:pageCount andCallBack:^(NSError *error, BOOL success, id object) {
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



#pragma mark - 工具

- (NSString *)getLargeNumbersToSpecificStr:(NSString *)str {
    if (str.length >= 3){
        return @"99+";
    }else{
        return str;
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

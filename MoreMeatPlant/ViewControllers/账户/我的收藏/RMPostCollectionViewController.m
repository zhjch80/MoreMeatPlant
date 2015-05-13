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
#import "RMCommentsView.h"

@interface RMPostCollectionViewController ()<RefreshControlDelegate,CommentsViewDelegate>{
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
    
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[RMPostCollectionViewController class]];

    
    dataArr = [[NSMutableArray alloc] init];
    
    self.mainTableView.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
    
    refreshControl=[[RefreshControl alloc] initWithScrollView:_mainTableView delegate:self];
    refreshControl.topEnabled = YES;
    refreshControl.bottomEnabled = YES;
    [refreshControl registerClassForTopView:[RefreshView class]];
    pageCount = 1;
    
    NSLog(@"%@",self.view);
    
    [self requestListWithPageCount];
    
    NSLog(@"%@",self.view);
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

#pragma mark - 添加收藏 赞 评论

- (void)addLikeWithImage:(RMImageView *)image {
    if (![RMUserLoginInfoManager loginmanager].state){
        NSLog(@"去登录.....");
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，请先登录!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getMembersCollectWithCollect_id:image.identifierString withContent_type:@"1" withID:[RMUserLoginInfoManager loginmanager].user withPWD:[RMUserLoginInfoManager loginmanager].pwd callBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"error:%@",error);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return ;
        }
        
        if (success){
            [self showHint:[object objectForKey:@"msg"]];
            //做UI收藏操作
            RMReleasePoisonCell * cell = (RMReleasePoisonCell *)[_mainTableView cellForRowAtIndexPath:image.indexPath];
            cell.likeImg.image = [UIImage imageNamed:@"img_asced"];
            
            NSString * num = cell.likeTitle.text;
            NSRange range = [num rangeOfString:@"+"];
            if (range.location != NSNotFound){
                for (NSInteger i=0; i<[dataArr count]; i++) {
                    RMPublicModel * model = [dataArr objectAtIndex:i];
                    if ([model.auto_id isEqualToString:image.identifierString]){
                        [dataArr removeObjectAtIndex:i];
                        
                        RMPublicModel * newModel = [[RMPublicModel alloc] init];
                        newModel.auto_id = model.auto_id;
                        newModel.content_name = model.content_name;
                        newModel.content_type = model.content_type;
                        newModel.content_class = model.content_class;
                        newModel.content_course = model.content_course;
                        newModel.content_top = model.content_top;
                        newModel.content_collect = @"99+";
                        newModel.content_review = model.content_review;
                        newModel.create_time = model.create_time;
                        newModel.is_top = model.is_top;
                        newModel.is_collect = @"1";
                        newModel.is_review =  model.is_review;
                        newModel.imgs = model.imgs;
                        newModel.members = model.members;
                        [dataArr insertObject:newModel atIndex:i];
                        break;
                    }else{
                        continue;
                    }
                }
            }else{
                NSInteger _num = num.integerValue;
                _num ++;
                cell.likeTitle.text = [self getLargeNumbersToSpecificStr:[NSString stringWithFormat:@"%ld",(long)_num]];
                
                for (NSInteger i=0; i<[dataArr count]; i++) {
                    RMPublicModel * model = [dataArr objectAtIndex:i];
                    if ([model.auto_id isEqualToString:image.identifierString]){
                        [dataArr removeObjectAtIndex:i];
                        
                        RMPublicModel * newModel = [[RMPublicModel alloc] init];
                        newModel.auto_id = model.auto_id;
                        newModel.content_name = model.content_name;
                        newModel.content_type = model.content_type;
                        newModel.content_class = model.content_class;
                        newModel.content_course = model.content_course;
                        newModel.content_top = model.content_top;
                        newModel.content_collect = [self getLargeNumbersToSpecificStr:[NSString stringWithFormat:@"%ld",(long)_num]];
                        newModel.content_review = model.content_review;
                        newModel.create_time = model.create_time;
                        newModel.is_top = model.is_top;
                        newModel.is_collect = @"1";
                        newModel.is_review =  model.is_review;
                        newModel.imgs = model.imgs;
                        newModel.members = model.members;
                        [dataArr insertObject:newModel atIndex:i];
                        break;
                    }else{
                        continue;
                    }
                }
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }else{
            //不做UI收藏操作
            [self showHint:[object objectForKey:@"msg"]];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

- (void)addChatWithImage:(RMImageView *)image {
    if (![RMUserLoginInfoManager loginmanager].state){
        NSLog(@"去登录.....");
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，请先登录!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
        return;
    }
    
    for (NSInteger i=0; i<[dataArr count]; i++){
        RMPublicModel * model = [dataArr objectAtIndex:i];
        if ([model.auto_id isEqualToString:image.identifierString]){
            RMCommentsView * commentsView = [[RMCommentsView alloc] init];
            commentsView.delegate = self;
            commentsView.backgroundColor = [UIColor clearColor];
            commentsView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            commentsView.requestType = kRMReleasePoisonListComment;
            commentsView.code = image.identifierString;
            [commentsView loadCommentsViewWithReceiver:[NSString stringWithFormat:@"  评论:%@",[model.members objectForKey:@"member_name"]] withImage:image];
            [self.view addSubview:commentsView];
            break;
        }
    }
}

- (void)commentMethodWithType:(NSInteger)type withError:(NSError *)error withState:(BOOL)success withObject:(id)object withImage:(RMImageView *)image {
    if (error){
        NSLog(@"errot%@",error);
        [self showHint:@"帖子评论失败！"];
        return;
    }
    
    if (success){
        //做UI上的数据处理
        RMReleasePoisonCell * cell = (RMReleasePoisonCell *)[_mainTableView cellForRowAtIndexPath:image.indexPath];
        NSString * num = cell.chatTitle.text;
        
        NSRange range = [num rangeOfString:@"+"];
        if (range.location != NSNotFound){
            for (NSInteger i=0; i<[dataArr count]; i++) {
                RMPublicModel * model = [dataArr objectAtIndex:i];
                if ([model.auto_id isEqualToString:image.identifierString]){
                    [dataArr removeObjectAtIndex:i];
                    
                    RMPublicModel * newModel = [[RMPublicModel alloc] init];
                    newModel.auto_id = model.auto_id;
                    newModel.content_name = model.content_name;
                    newModel.content_type = model.content_type;
                    newModel.content_class = model.content_class;
                    newModel.content_course = model.content_course;
                    newModel.content_top = model.content_top;
                    newModel.content_collect = model.content_collect;
                    newModel.content_review = @"99+";
                    newModel.create_time = model.create_time;
                    newModel.is_top = model.is_top;
                    newModel.is_collect = model.is_collect;
                    newModel.is_review =  @"1";
                    newModel.imgs = model.imgs;
                    newModel.members = model.members;
                    [dataArr insertObject:newModel atIndex:i];
                    break;
                }else{
                    continue;
                }
            }
        }else{
            NSInteger _num = num.integerValue;
            _num ++;
            cell.chatTitle.text = [self getLargeNumbersToSpecificStr:[NSString stringWithFormat:@"%ld",(long)_num]];
            
            for (NSInteger i=0; i<[dataArr count]; i++) {
                RMPublicModel * model = [dataArr objectAtIndex:i];
                if ([model.auto_id isEqualToString:image.identifierString]){
                    [dataArr removeObjectAtIndex:i];
                    
                    RMPublicModel * newModel = [[RMPublicModel alloc] init];
                    newModel.auto_id = model.auto_id;
                    newModel.content_name = model.content_name;
                    newModel.content_type = model.content_type;
                    newModel.content_class = model.content_class;
                    newModel.content_course = model.content_course;
                    newModel.content_top = model.content_top;
                    newModel.content_collect = model.content_collect;
                    newModel.content_review = [self getLargeNumbersToSpecificStr:[NSString stringWithFormat:@"%ld",(long)_num]];
                    newModel.create_time = model.create_time;
                    newModel.is_top = model.is_top;
                    newModel.is_collect = model.is_collect;
                    newModel.is_review =  @"1";
                    newModel.imgs = model.imgs;
                    newModel.members = model.members;
                    [dataArr insertObject:newModel atIndex:i];
                    break;
                }else{
                    continue;
                }
            }
        }
        
        [self showHint:[object objectForKey:@"msg"]];
    }else{
        //不做UI上的数据处理
        [self showHint:[object objectForKey:@"msg"]];
    }
}


- (void)addPraiseWithImage:(RMImageView *)image {
    if (![RMUserLoginInfoManager loginmanager].state){
        NSLog(@"去登录.....");
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，请先登录!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getPostsAddPraiseWithAuto_id:image.identifierString withID:[RMUserLoginInfoManager loginmanager].user withPWD:[RMUserLoginInfoManager loginmanager].pwd callBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"error:%@",error);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return ;
        }
        
        if (success){
            //做UI收藏操作
            RMReleasePoisonCell * cell = (RMReleasePoisonCell *)[_mainTableView cellForRowAtIndexPath:image.indexPath];
            cell.praiseImg.image = [UIImage imageNamed:@"img_zaned"];
            
            NSString * num = cell.praiseTitle.text;
            NSRange range = [num rangeOfString:@"+"];
            if (range.location != NSNotFound){
                for (NSInteger i=0; i<[dataArr count]; i++) {
                    RMPublicModel * model = [dataArr objectAtIndex:i];
                    if ([model.auto_id isEqualToString:image.identifierString]){
                        [dataArr removeObjectAtIndex:i];
                        
                        RMPublicModel * newModel = [[RMPublicModel alloc] init];
                        newModel.auto_id = model.auto_id;
                        newModel.content_name = model.content_name;
                        newModel.content_type = model.content_type;
                        newModel.content_class = model.content_class;
                        newModel.content_course = model.content_course;
                        newModel.content_top = @"99+";
                        newModel.content_collect = model.content_collect;
                        newModel.content_review = model.content_review;
                        newModel.create_time = model.create_time;
                        newModel.is_top = @"1";
                        newModel.is_collect = model.is_collect;
                        newModel.is_review =  model.is_review;
                        newModel.imgs = model.imgs;
                        newModel.members = model.members;
                        [dataArr insertObject:newModel atIndex:i];
                        break;
                    }else{
                        continue;
                    }
                }
            }else{
                NSInteger _num = num.integerValue;
                _num ++;
                cell.praiseTitle.text = [self getLargeNumbersToSpecificStr:[NSString stringWithFormat:@"%ld",(long)_num]];
                
                for (NSInteger i=0; i<[dataArr count]; i++) {
                    RMPublicModel * model = [dataArr objectAtIndex:i];
                    if ([model.auto_id isEqualToString:image.identifierString]){
                        [dataArr removeObjectAtIndex:i];
                        
                        RMPublicModel * newModel = [[RMPublicModel alloc] init];
                        newModel.auto_id = model.auto_id;
                        newModel.content_name = model.content_name;
                        newModel.content_type = model.content_type;
                        newModel.content_class = model.content_class;
                        newModel.content_course = model.content_course;
                        newModel.content_top = [self getLargeNumbersToSpecificStr:[NSString stringWithFormat:@"%ld",(long)_num]];
                        newModel.content_collect = model.content_collect;
                        newModel.content_review = model.content_review;
                        newModel.create_time = model.create_time;
                        newModel.is_top = @"1";
                        newModel.is_collect = model.is_collect;
                        newModel.is_review =  model.is_review;
                        newModel.imgs = model.imgs;
                        newModel.members = model.members;
                        [dataArr insertObject:newModel atIndex:i];
                        break;
                    }else{
                        continue;
                    }
                }
            }
            
            [self showHint:[object objectForKey:@"msg"]];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }else{
            //不做UI收藏操作
            [self showHint:[object objectForKey:@"msg"]];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
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
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if(self.startRequest){
        self.startRequest();
    }
    [RMAFNRequestManager myCollectionRequestWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] Type:@"1" Page:pageCount andCallBack:^(NSError *error, BOOL success, id object) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(self.finishedRequest){
            self.finishedRequest ();
        }
        if(success){
            if(pageCount == 1){
                [dataArr removeAllObjects];
                [dataArr addObjectsFromArray:object];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
                if([(NSArray *)object count] == 0){
                    [self showHint:@"暂无收藏"];                    
                    
                }
            }else{
                [dataArr addObjectsFromArray:object];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
                if([(NSArray *)object count] == 0){
                    [self showHint:@"没有更多收藏了"];
                    pageCount--;
                }
            }
            
            NSLog(@"%@",self.view);
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

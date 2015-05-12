//
//  RMMyHomeViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/15.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMMyHomeViewController.h"
#import "RMReleasePoisonDetailsViewController.h"
#import "KxMenu.h"
#import "NSString+TimeInterval.h"
#import "RMHomeHeadView.h"
#import "AppDelegate.h"
#import "RMPlantWithSaleViewController.h"
#import "RMFreshPlantMarketViewController.h"
#import "RMCommentsView.h"

#import "ChatViewController.h"
@interface RMMyHomeViewController ()<RefreshControlDelegate,CommentsViewDelegate>{
    NSInteger pageCount;
    BOOL isRefresh;
    BOOL isLoadComplete;
    RMPublicModel * _model;
    RMHomeHeadView * headView;
    JSBadgeView * chat_badge;
    CGFloat OneCellHeight;
}
@property (nonatomic, strong) RefreshControl * refreshControl;


@end

@implementation RMMyHomeViewController
@synthesize dataArr;
@synthesize refreshControl;

- (void)viewWillAppear:(BOOL)animated{
    badge.badgeText = [self queryInfoNumber];
    chat_badge.badgeText = [self queryInfoNumber];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[RMMyHomeViewController class]];
    self.mainTableView.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
    
    
    OneCellHeight = kScreenWidth/11.0*5.0;
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];
    
    headView = [[[NSBundle mainBundle] loadNibNamed:@"RMHomeHeadView" owner:self options:nil] lastObject];
    headView.content_img.layer.cornerRadius = 5;
    headView.content_img.clipsToBounds = YES;
    
    [headView.attentionHeBtn addTarget:self action:@selector(attentionHeBtnAction:) forControlEvents:UIControlEventTouchDown];
    [headView.sendPrivateMsgBtn addTarget:self action:@selector(sendPrivateMsgBtnAction:) forControlEvents:UIControlEventTouchDown];
    
    
    _model = [[RMPublicModel alloc]init];
    
    refreshControl=[[RefreshControl alloc] initWithScrollView:_mainTableView delegate:self];
    refreshControl.topEnabled = YES;
    refreshControl.bottomEnabled = YES;
    [refreshControl registerClassForTopView:[RefreshView class]];
    pageCount = 1;
    isRefresh = YES;
    
    dataArr = [[NSMutableArray alloc] init];
    
    if (self.auto_id == nil){
        self.auto_id = [[RMUserLoginInfoManager loginmanager] s_id];
        self.titleName = @"我的帖子";
        headView.sendPrivateMsgBtn.hidden = YES;
        headView.attentionHeBtn.hidden = YES;
        
    }else{
        self.titleName = @"肉友主页";
    }
    [self setCustomNavTitle:self.titleName];
    [self loadBottomView];
}

- (void)loadBottomView {
    bottomView = [[RMBottomView alloc] init];
    bottomView.delegate = self;
    bottomView.frame = CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40);
    [bottomView loadBottomWithImageArr:[NSArray arrayWithObjects:@"img_backup", @"img_up", @"img_moreChat", nil]];
    [self.view addSubview:bottomView];
    
    
    UIButton * btn = (UIButton *)[bottomView viewWithTag:2];
    badge = [[JSBadgeView alloc]initWithParentView:btn alignment:JSBadgeViewAlignmentTopRight];
    badge.badgeBackgroundColor = UIColorFromRGB(0xe21a54);
    badge.badgeTextFont = FONT(12.0);
    badge.badgeText = [self queryInfoNumber];
    [self requestMemberInfo];
}

- (void)requestMemberInfo{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getUserHomeInfoWithAuto_id:self.auto_id andCallBack:^(NSError *error, BOOL success, id object) {
        RMPublicModel * model = object;
        _model = model;
        if(success && model.status){
            [headView.content_img sd_setImageWithURL:[NSURL URLWithString:model.content_face] placeholderImage:[UIImage imageNamed:@"nophote"]];
            headView.content_name.text = model.content_name;
            headView.content_signature.text = Str_Objc(model.contentQm, @"什么也没写...");
            headView.city.text = model.content_gps;
//            self.yu_e.text = [NSString stringWithFormat:@"余额:%.0f",model.spendmoney];
            headView.hua_bi.text = [NSString stringWithFormat:@"花币:%.0f",model.spendmoney];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            [self requestListWithPageCount];
        }else{
            [self showHint:object];
        }
    }];
}


#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 1;
    }else{
        return [dataArr count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self loadIndexPath:indexPath withTableView:tableView];
}

- (UITableViewCell *)loadIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView {
    if(indexPath.section == 0){
        return headView;
    }else{
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
                if (IS_IPHONE_6_SCREEN){
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonCell_2_6" owner:self options:nil] lastObject];
                }else if (IS_IPHONE_6p_SCREEN){
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonCell_2_6p" owner:self options:nil] lastObject];
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
            [cell.userHeadImg sd_setImageWithURL:[NSURL URLWithString:[model.members objectForKey:@"content_face"]] placeholderImage:nil];
            
            NSString * _name;
            if ([[model.members objectForKey:@"member_name"] length] > 5){
                _name = [[model.members objectForKey:@"member_name"] substringToIndex:5];
                _name = [NSString stringWithFormat:@"%@...",_name];
            }else{
                _name = [model.members objectForKey:@"member_name"];
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
            
            if ([model.is_collect isEqualToString:@"1"]){
                cell.likeImg.image = [UIImage imageNamed:@"img_asced.png"];
            }else{
                cell.likeImg.image = [UIImage imageNamed:@"img_asc"];
            }
            
            cell.chatImg.image = LOADIMAGE(@"img_chat", kImageTypePNG);
            
            if ([model.is_top isEqualToString:@"1"]){
                cell.praiseImg.image = [UIImage imageNamed:@"img_zaned"];
            }else{
                cell.praiseImg.image = [UIImage imageNamed:@"img_zan"];
            }
            
            cell.likeTitle.text = [self getLargeNumbersToSpecificStr:model.content_collect];
            cell.chatTitle.text = [self getLargeNumbersToSpecificStr:model.content_review];
            cell.praiseTitle.text = [self getLargeNumbersToSpecificStr:model.content_top];
            return cell;
        }else if (value == 2){
            static NSString * identifierStr = @"releasePoisonIdentifier_1";
            
            RMReleasePoisonCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
            
            if (!cell){
                if (IS_IPHONE_6_SCREEN){
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonCell_1_6" owner:self options:nil] lastObject];
                }else if (IS_IPHONE_6p_SCREEN){
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"RMReleasePoisonCell_1_6p" owner:self options:nil] lastObject];
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
            [cell.userHeadImg sd_setImageWithURL:[NSURL URLWithString:[model.members objectForKey:@"content_face"]] placeholderImage:nil];
            
            NSString * _name;
            if ([[model.members objectForKey:@"member_name"] length] > 5){
                _name = [[model.members objectForKey:@"member_name"] substringToIndex:5];
                _name = [NSString stringWithFormat:@"%@...",_name];
            }else{
                _name = [model.members objectForKey:@"member_name"];
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
            
            if ([model.is_collect isEqualToString:@"1"]){
                cell.likeImg.image = [UIImage imageNamed:@"img_asced"];
            }else{
                cell.likeImg.image = [UIImage imageNamed:@"img_asc"];
            }
            
            cell.chatImg.image = LOADIMAGE(@"img_chat", kImageTypePNG);
            
            if ([model.is_top isEqualToString:@"1"]){
                cell.praiseImg.image = [UIImage imageNamed:@"img_zaned"];
            }else{
                cell.praiseImg.image = [UIImage imageNamed:@"img_zan"];
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
            [cell.userHeadImg sd_setImageWithURL:[NSURL URLWithString:[model.members objectForKey:@"content_face"]] placeholderImage:nil];
            
            NSString * _name;
            if ([[model.members objectForKey:@"member_name"] length] > 5){
                _name = [[model.members objectForKey:@"member_name"] substringToIndex:5];
                _name = [NSString stringWithFormat:@"%@...",_name];
            }else{
                _name = [model.members objectForKey:@"member_name"];
            }
            
            cell.userName.text = [NSString stringWithFormat:@"%@ %@",_name,[[NSString stringWithFormat:@"%@:00",model.create_time] intervalSinceNow]];
            
            if ([model.imgs isKindOfClass:[NSNull class]]){
                cell.threeImg.image = [UIImage imageNamed:@"img_default.jpg"];
            }else{
                [cell.threeImg sd_setImageWithURL:[NSURL URLWithString:[[model.imgs objectAtIndex:0] objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"img_default.jpg"]];
            }
            
            cell.threeImg.identifierString = model.auto_id;
            cell.likeImg.identifierString = model.auto_id;
            cell.likeImg.indexPath = indexPath;
            cell.chatImg.identifierString = model.auto_id;
            cell.chatImg.indexPath = indexPath;
            cell.praiseImg.identifierString = model.auto_id;
            cell.praiseImg.indexPath = indexPath;
            
            if ([model.is_collect isEqualToString:@"1"]){
                cell.likeImg.image = [UIImage imageNamed:@"img_asced"];
            }else{
                cell.likeImg.image = [UIImage imageNamed:@"img_asc"];
            }
            
            cell.chatImg.image = LOADIMAGE(@"img_chat", kImageTypePNG);
            
            if ([model.is_top isEqualToString:@"1"]){
                cell.praiseImg.image = [UIImage imageNamed:@"img_zaned"];
            }else{
                cell.praiseImg.image = [UIImage imageNamed:@"img_zan"];
            }
            
            cell.likeTitle.text = [self getLargeNumbersToSpecificStr:model.content_collect];
            cell.chatTitle.text = [self getLargeNumbersToSpecificStr:model.content_review];
            cell.praiseTitle.text = [self getLargeNumbersToSpecificStr:model.content_top];
            return cell;
        }

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        return OneCellHeight;
    }else{
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
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


#pragma mark - 关注／发私信
- (void)attentionHeBtnAction:(UIButton *)sender{
    if(![[RMUserLoginInfoManager loginmanager] state]){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，请先登录！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager attentionFriendRequestWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] withOtherId:self.auto_id andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success){
            RMPublicModel * model = object;
            if(model.status){
                
            }else{
                
            }
            [self showHint:model.msg];
        }else{
            [self showHint:object];
        }
    }];
}

- (void)sendPrivateMsgBtnAction:(UIButton *)sender{
    if(![[RMUserLoginInfoManager loginmanager] state]){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，请先登录！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
        return;
    }
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    AppDelegate * dele = [[UIApplication sharedApplication] delegate];
//    [dele tabSelectController:3];
//    [dele.talkMoreCtl._chatListVC jumpToChatView:_model.content_user];
    ChatViewController * chat = [[ChatViewController alloc]initWithChatter:_model.content_user isGroup:NO];
    chat.title = _model.content_user;
    [self.navigationController pushViewController:chat animated:YES];
}

#pragma mark - 帖子详情

- (void)jumpPostDetailsWithImage:(RMImageView *)image {
//    if(self.detailcall_back){
//        _detailcall_back (image.identifierString);
//    }
    RMReleasePoisonDetailsViewController * releasePoisonDetailsCtl = [[RMReleasePoisonDetailsViewController alloc] init];
    releasePoisonDetailsCtl.auto_id = image.identifierString;
    [self.navigationController pushViewController:releasePoisonDetailsCtl animated:YES];
}

/**
 *  请求List数据
 */
- (void)requestListWithPageCount {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getPostsListWithPostsType:@"1" withPlantType:nil withPlantSubjects:nil withPageCount:pageCount withUser_id:OBJC([RMUserLoginInfoManager loginmanager].user) withUser_password:OBJC([RMUserLoginInfoManager loginmanager].pwd) withMemberId:self.auto_id callBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"error:%@",error);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return ;
        }
        
        if (success){
            if (self.refreshControl.refreshingDirection == RefreshingDirectionTop) {
                [dataArr removeAllObjects];
                for (NSInteger i=0; i<[[object objectForKey:@"data"] count]; i++){
                    RMPublicModel * model = [[RMPublicModel alloc] init];
                    model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                    model.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_name"]);
                    model.content_type = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_type"]);
                    model.content_class = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_class"]);
                    model.content_course = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_course"]);
                    model.content_top = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_top"]);
                    model.content_collect = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_collect"]);
                    model.content_review = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_review"]);
                    model.create_time = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"create_time"]);
                    model.is_top = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"is_top"]);
                    model.is_collect = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"is_collect"]);
                    model.is_review =  OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"is_review"]);
                    model.imgs = [[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"imgs"];
                    model.members = [[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"member"];
                    [dataArr addObject:model];
                }
                [_mainTableView reloadData];
                
                [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
            }else if(self.refreshControl.refreshingDirection==RefreshingDirectionBottom) {
                if ([[object objectForKey:@"data"] count] == 0){
                    [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    isLoadComplete = YES;
                    return;
                }
                for (NSInteger i=0; i<[[object objectForKey:@"data"] count]; i++){
                    RMPublicModel * model = [[RMPublicModel alloc] init];
                    model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                    model.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_name"]);
                    model.content_type = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_type"]);
                    model.content_class = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_class"]);
                    model.content_course = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_course"]);
                    model.content_top = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_top"]);
                    model.content_collect = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_collect"]);
                    model.content_review = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_review"]);
                    model.create_time = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"create_time"]);
                    model.is_top = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"is_top"]);
                    model.is_collect = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"is_collect"]);
                    model.is_review =  OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"is_review"]);
                    model.imgs = [[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"imgs"];
                    model.members = [[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"member"];
                    [dataArr addObject:model];
                }
                [_mainTableView reloadData];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
            }
            
            if (isRefresh){
                [dataArr removeAllObjects];
                for (NSInteger i=0; i<[[object objectForKey:@"data"] count]; i++){
                    RMPublicModel * model = [[RMPublicModel alloc] init];
                    model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                    model.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_name"]);
                    model.content_type = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_type"]);
                    model.content_class = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_class"]);
                    model.content_course = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_course"]);
                    model.content_top = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_top"]);
                    model.content_collect = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_collect"]);
                    model.content_review = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_review"]);
                    model.create_time = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"create_time"]);
                    model.imgs = [[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"imgs"];
                    model.members = [[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"member"];
                    model.is_top = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"is_top"]);
                    model.is_collect = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"is_collect"]);
                    model.is_review =  OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"is_review"]);
                    [dataArr addObject:model];
                }
                
                [_mainTableView reloadData];
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
        [self requestListWithPageCount];
    }else if(direction == RefreshDirectionBottom) { //上拉加载
        if (isLoadComplete){
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.44 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self showHint:@"没有更多帖子啦"];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
            });
        }else{
            pageCount ++;
            isRefresh = NO;
            [self requestListWithPageCount];
        }
    }
}

#pragma mark - 工具

- (NSString *)getLargeNumbersToSpecificStr:(NSString *)str {
    if (str.length >= 3){
        return @"99+";
    }else{
        return str;
    }
}


#pragma mark - 底部栏回调方法

- (void)bottomMethodWithTag:(NSInteger)tag {
    switch (tag) {
        case 0:{
            //返回
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 1:{
            //滚到置顶
            [_mainTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            break;
        }
        case 2:{
            if(![[RMUserLoginInfoManager loginmanager] state]){
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，请先登录！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                [alert show];
                return;
            }
            //多聊
            NSLog(@"多聊");
            KxMenuItem * item1 = [KxMenuItem menuItem:@"多聊消息" image:nil target:self action:@selector(menuSelected:) index:100];
            item1.foreColor = UIColorFromRGB(0x585858);
            KxMenuItem * item2 = [KxMenuItem menuItem:@"一物一拍" image:nil target:self action:@selector(menuSelected:) index:101];
            item2.foreColor = UIColorFromRGB(0x585858);
            KxMenuItem * item3 = [KxMenuItem menuItem:@"鲜肉市场" image:nil target:self action:@selector(menuSelected:) index:101];
            item3.foreColor = UIColorFromRGB(0x585858);
            NSArray * arr = [[NSArray alloc]initWithObjects:item1,item2,item3, nil];
            
            [KxMenu setTintColor:[UIColor whiteColor]];
            UIButton * btn = (UIButton *)[bottomView viewWithTag:2];
            [KxMenu showMenuInView:self.view fromRect:CGRectMake(btn.frame.origin.x, bottomView.frame.origin.y, 100, 100) menuItems:arr];

            for(UIView * v in self.view.subviews){
                if([v isKindOfClass:[KxMenuOverlay class]]){
                    KxMenuView * menuView = (KxMenuView *)[v.subviews lastObject];
                    UIView * targetView = [menuView viewWithTag:100];
                    
                    UILabel * targetlabel = (UILabel *)[targetView viewWithTag:1];
                    chat_badge = [[JSBadgeView alloc]initWithParentView:targetlabel alignment:JSBadgeViewAlignmentCenterRight];
                    chat_badge.badgeBackgroundColor = UIColorFromRGB(0xe21a54);
                    chat_badge.badgeTextFont = FONT(12.0);
                    chat_badge.badgeText = [self queryInfoNumber];
                    break;
                }
            }            break;
        }
            
        default:
            break;
    }
}

#pragma mark - 菜单选择
- (void)menuSelected:(id)sender{
    KxMenuItem * item = (KxMenuItem *)sender;
    switch (item.tag-100) {
        case 0:
        {
            if(![[RMUserLoginInfoManager loginmanager] state]){
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，请先登录！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                [alert show];
                return;
            }
            [self.navigationController popToRootViewControllerAnimated:NO];
            AppDelegate * dele = [[UIApplication sharedApplication] delegate];
            [dele tabSelectController:3];
        }
            break;
        case 1:
        {
            RMPlantWithSaleViewController * plante = [[RMPlantWithSaleViewController alloc]init];
            [plante setCustomNavTitle:@"一肉一拍"];
            [self.navigationController pushViewController:plante animated:YES];
        }
            break;
        case 2:
        {
            RMFreshPlantMarketViewController * plante = [[RMFreshPlantMarketViewController alloc]init];
            [plante setCustomNavTitle:@"鲜肉市场"];
            [self.navigationController pushViewController:plante animated:YES];
        }
            break;
        default:
            break;
    }

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

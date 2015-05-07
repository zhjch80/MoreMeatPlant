//
//  RMSearchViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMSearchViewController.h"
#import "RMDaqoCell.h"
#import "UITextField+LimitLength.h"
#import "RefreshControl.h"
#import "RefreshView.h"
#import "RMReleasePoisonCell.h"
#import "NSString+TimeInterval.h"
#import "RMCommentsView.h"
#import "RMReleasePoisonDetailsViewController.h"
#import "RMPlantWithSaleDetailsViewController.h"
#import "RMDaqoDetailsViewController.h"

@interface RMSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,DaqpSelectedPlantTypeDelegate,RefreshControlDelegate,PostDetatilsDelegate,CommentsViewDelegate>{
    BOOL isHideKeyboard;
    
    BOOL isFirstViewDidAppear;
    BOOL isRefresh;
    NSInteger pageCount;
    BOOL isLoadComplete;
    
    NSInteger classValue;           //宝贝搜索时 传的参数  根据从不同页面进入而不同
}
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, retain) RefreshControl * refreshControl;

@end

@implementation RMSearchViewController
@synthesize mTextField, mTableView, dataArr, refreshControl;

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.mTextField resignFirstResponder];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([self.searchWhere isEqualToString:@"一肉一拍"] || [self.searchWhere isEqualToString:@"放毒区"]){
        classValue = 1;
    }else if ([self.searchWhere isEqualToString:@"鲜肉市场"] || [self.searchWhere isEqualToString:@"肉肉交换"]){
        classValue = 2;
    }
    
    [self.mTextField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setHideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[RMSearchViewController class]];
    
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[RMSearchViewController class]];

    dataArr = [[NSMutableArray alloc] init];
    mTextField.delegate = self;
    [mTextField.layer setCornerRadius:8.0f];
    mTextField.returnKeyType = UIReturnKeySearch;
    [mTextField limitTextLength:20];
    
    [self.view addSubview:mTableView];
    
    mTableView.tableFooterView = [[UIView alloc] init];
    
    refreshControl=[[RefreshControl alloc] initWithScrollView:mTableView delegate:self];
    refreshControl.topEnabled = YES;
    refreshControl.bottomEnabled = YES;
    [refreshControl registerClassForTopView:[RefreshView class]];
    
    pageCount = 1;
    isRefresh = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.searchType isEqualToString:@"帖子"]){
        return [dataArr count];
    }else{
        if ([dataArr count]%3 == 0){
            return [dataArr count] / 3;
        }else if ([dataArr count]%3 == 1){
            return ([dataArr count] + 2) / 3;
        }else {
            return ([dataArr count] + 1) / 3;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.searchType isEqualToString:@"帖子"]){
        return [self loadPostsIndexPath:indexPath withTableView:tableView];
    }else{//宝贝 或者 大全
        return [self loadBabyIndexPath:indexPath withTableView:tableView];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark - 帖子 list

- (UITableViewCell *)loadPostsIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView {
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
            if (model.imgs.count == 0){
                cell.threeImg.image = [UIImage imageNamed:@"img_default.jpg"];
            }else{
                [cell.threeImg sd_setImageWithURL:[NSURL URLWithString:[[model.imgs objectAtIndex:0] objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"img_default.jpg"]];
            }
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

#pragma mark - 宝贝 list 或者 大全list

- (UITableViewCell *)loadBabyIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView {
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
    
    if(indexPath.row*3 < dataArr.count){
        RMPublicModel *model = [dataArr objectAtIndex:indexPath.row*3];
        cell.leftTitle.text = model.content_name;
        [cell.leftImg sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:nil];
        cell.leftImg.identifierString = model.auto_id;
    }else{
        cell.leftTitle.hidden = YES;
        cell.leftImg.hidden = YES;
    }
    if(indexPath.row*3+1 < dataArr.count){
        RMPublicModel *model = [dataArr objectAtIndex:indexPath.row*3+1];
        cell.centerTitle.text = model.content_name;
        [cell.centerImg sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:nil];
        cell.centerImg.identifierString = model.auto_id;
    }else{
        cell.centerTitle.hidden = YES;
        cell.centerImg.hidden = YES;
    }
    if(indexPath.row*3+2 < dataArr.count){
        RMPublicModel *model = [dataArr objectAtIndex:indexPath.row*3+2];
        cell.rightTitle.text = model.content_name;
        [cell.rightImg sd_setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:nil];
        cell.rightImg.identifierString = model.auto_id;
    }else{
        cell.rightTitle.hidden = YES;
        cell.rightImg.hidden = YES;
    }
    return cell;
}

#pragma mark - 帖子代理方法

- (void)jumpPostDetailsWithImage:(RMImageView *)image {
    RMReleasePoisonDetailsViewController * releasePoisonDetailsCtl = [[RMReleasePoisonDetailsViewController alloc] init];
    releasePoisonDetailsCtl.auto_id = image.identifierString;
    [self.navigationController pushViewController:releasePoisonDetailsCtl animated:YES];
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
            RMReleasePoisonCell * cell = (RMReleasePoisonCell *)[mTableView cellForRowAtIndexPath:image.indexPath];
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
        RMReleasePoisonCell * cell = (RMReleasePoisonCell *)[mTableView cellForRowAtIndexPath:image.indexPath];
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
            RMReleasePoisonCell * cell = (RMReleasePoisonCell *)[mTableView cellForRowAtIndexPath:image.indexPath];
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

#pragma mark - 宝贝详情代理方法 或者 大全详情代理方法

- (void)daqoSelectedPlantTypeMethod:(RMImageView *)image {
    if ([self.searchType isEqualToString:@"宝贝"]){
        RMPlantWithSaleDetailsViewController * plantWithSaleDetailsCtl = [[RMPlantWithSaleDetailsViewController alloc] init];
        plantWithSaleDetailsCtl.auto_id = image.identifierString;
        plantWithSaleDetailsCtl.mTitle = @"一肉一拍";
        [self.navigationController pushViewController:plantWithSaleDetailsCtl animated:YES];
    }else{
        RMDaqoDetailsViewController * daqoDetailsCtl = [[RMDaqoDetailsViewController alloc] init];
        daqoDetailsCtl.auto_id = image.identifierString;
        [self.navigationController pushViewController:daqoDetailsCtl animated:YES];
    }
}

#pragma mark -

- (void)keyboardWillShow:(NSNotification *)noti {
}

- (void)keyboardDidShow:(NSNotification *)noti {
}

- (void)keyboardWillHide:(NSNotification *)noti {
}

- (void)keyboardDidHide:(NSNotification *)noti {

}

/**
 *   搜索入口一
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([[self trim:textField.text] isEqualToString:@""]){
        [self.mTextField resignFirstResponder];
        [self showHint:@"输入内容不能为空"];
        return NO;
    }
    
    if ([self.searchType isEqualToString:@"帖子"]){
        [self requestPostsSearchWithKeyWord:[textField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withType:[NSString stringWithFormat:@"%ld",(long)classValue] withPageCount:1];
    }else if ([self.searchType isEqualToString:@"宝贝"]){
        [self requestBabySearchWithKeyWord:[mTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withClass:[NSString stringWithFormat:@"%ld",(long)classValue] withPageCount:1];
    }else {
        [self requetDaqoSearchWithKeyWord:[mTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withPageCount:1 withGrow:@"" withCourse:@""];
    }
    return YES;
}

/**
 *   搜索入口二
 */
- (IBAction)searchClick:(UIButton *)sender {
    
    if ([[self trim:mTextField.text] isEqualToString:@""]){
        [self.mTextField resignFirstResponder];
        [self showHint:@"输入内容不能为空"];
        return ;
    }
    
    if ([self.searchType isEqualToString:@"帖子"]){
        [self requestPostsSearchWithKeyWord:[mTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withType:[NSString stringWithFormat:@"%ld",(long)classValue] withPageCount:1];
    }else if ([self.searchType isEqualToString:@"宝贝"]){
        [self requestBabySearchWithKeyWord:[mTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withClass:[NSString stringWithFormat:@"%ld",(long)classValue] withPageCount:1];
    }else {
        [self requetDaqoSearchWithKeyWord:[mTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withPageCount:1 withGrow:@"" withCourse:@""];
    }
}

#pragma mark -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [mTextField resignFirstResponder];
}

- (IBAction)buttonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 请求数据

/**
 *  @method     帖子搜索
 *  搜索时 不用传植物分类  和  植物科目
 */
- (void)requestPostsSearchWithKeyWord:(NSString *)key withType:(NSString *)typeValue withPageCount:(NSInteger)pg {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getPostsSearchWithrPlantClass:@"" withPlantCourse:@"" withType:typeValue withPageCount:pg withID:[RMUserLoginInfoManager loginmanager].user withPWD:[RMUserLoginInfoManager loginmanager].pwd withKeyword:key callBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"%@",error);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return ;
        }
        
        if (success){
            
            if ([[object objectForKey:@"data"] count] == 0){
                [self showHint:@"没有搜索到相关内容"];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                return ;
            }
            
            if (self.refreshControl.refreshingDirection == RefreshingDirectionTop) {
                [dataArr removeAllObjects];
                for (NSInteger i=0; i<[[object objectForKey:@"data"] count]; i++){
                    RMPublicModel * model = [[RMPublicModel alloc] init];
                    model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                    model.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_name"]);
                    model.content_type = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_type"]);
                    model.content_class = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_class"]);
                    model.content_course = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_course"]);
                    model.create_time = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"create_time"]);
                    model.member_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"member_id"]);
                    model.content_top = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_top"]);
                    model.content_collect = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_collect"]);
                    model.content_review = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_review"]);
                    model.imgs = [[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"imgs"];
                    model.members = [[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"member"];
                    
                    //没有登录 这三个字段没有给
                    model.is_top = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"is_top"]);
                    model.is_collect = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"is_collect"]);
                    model.is_review =  OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"is_review"]);
                    
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
                for (NSInteger i=0; i<[[object objectForKey:@"data"] count]; i++){
                    RMPublicModel * model = [[RMPublicModel alloc] init];
                    model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                    model.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_name"]);
                    model.content_type = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_type"]);
                    model.content_class = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_class"]);
                    model.content_course = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_course"]);
                    model.create_time = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"create_time"]);
                    model.member_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"member_id"]);
                    model.content_top = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_top"]);
                    model.content_collect = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_collect"]);
                    model.content_review = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_review"]);
                    model.imgs = [[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"imgs"];
                    model.members = [[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"member"];
                    
                    //没有登录 这三个字段没有给
                    model.is_top = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"is_top"]);
                    model.is_collect = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"is_collect"]);
                    model.is_review =  OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"is_review"]);
                    [dataArr addObject:model];
                }
                [mTableView reloadData];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
                
            }
            
            if (isRefresh){
                
                if ([[object objectForKey:@"data"] count] == 0){
                    [self showHint:@"没有搜索到相关内容"];
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    return ;
                }
                
                [dataArr removeAllObjects];
                for (NSInteger i=0; i<[[object objectForKey:@"data"] count]; i++) {
                    RMPublicModel * model = [[RMPublicModel alloc] init];
                    model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                    model.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_name"]);
                    model.content_type = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_type"]);
                    model.content_class = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_class"]);
                    model.content_course = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_course"]);
                    model.create_time = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"create_time"]);
                    model.member_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"member_id"]);
                    model.content_top = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_top"]);
                    model.content_collect = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_collect"]);
                    model.content_review = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_review"]);
                    model.imgs = [[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"imgs"];
                    model.members = [[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"member"];
                    
                    //没有登录 这三个字段没有给
                    model.is_top = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"is_top"]);
                    model.is_collect = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"is_collect"]);
                    model.is_review =  OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"is_review"]);
                    [dataArr addObject:model];
                }
                [mTableView reloadData];
            }
            [self.view endEditing:YES];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

/**
 *      @method     宝贝搜索  class 为1 为一肉一拍  2为鲜肉市场
 *      搜索时   不用传植物科目
 */
- (void)requestBabySearchWithKeyWord:(NSString *)key withClass:(NSString *)class withPageCount:(NSInteger)pg {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getBabysSearchWithrBabyClass:class withPlantCourse:@"" withPageCount:1 withKeyword:key callBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"error:%@",error);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return ;
        }
        
        if (success){
            
            if ([[object objectForKey:@"data"] count] == 0){
                [self showHint:@"没有搜索到相关内容"];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                return ;
            }
            
            if (self.refreshControl.refreshingDirection == RefreshingDirectionTop) {
                [dataArr removeAllObjects];
                for (NSInteger i=0; i<[[object objectForKey:@"data"] count]; i++) {
                    RMPublicModel * model = [[RMPublicModel alloc] init];
                    model.content_img = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_img"]);
                    model.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_name"]);
                    model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
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
                    model.content_img = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_img"]);
                    model.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_name"]);
                    model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                    [dataArr addObject:model];
                }
                [mTableView reloadData];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
            }
            
            if (isRefresh){
                
                if ([[object objectForKey:@"data"] count] == 0){
                    [self showHint:@"没有搜索到相关内容"];
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    return ;
                }
                
                [dataArr removeAllObjects];
                for (NSInteger i=0; i<[[object objectForKey:@"data"] count]; i++) {
                    RMPublicModel * model = [[RMPublicModel alloc] init];
                    model.content_img = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_img"]);
                    model.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_name"]);
                    model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                    [dataArr addObject:model];
                }
                [mTableView reloadData];
            }
            [self.view endEditing:YES];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

/**
 *  @method     植物大全搜索
 */
- (void)requetDaqoSearchWithKeyWord:(NSString *)key
                      withPageCount:(NSInteger)pg
                           withGrow:(NSString *)grow
                         withCourse:(NSString *)course {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager getDaqoSearchWithKeyWord:key withPageCount:pg callBack:^(NSError *error, BOOL success, id object) {
        if (error){
            NSLog(@"error:%@",error);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return ;
        }
        
        if (success){
            if ([[object objectForKey:@"data"] count] == 0){
                [self showHint:@"没有搜索到相关内容"];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                return ;
            }

            if (self.refreshControl.refreshingDirection == RefreshingDirectionTop) {
                [dataArr removeAllObjects];
                for (NSInteger i=0; i<[[object objectForKey:@"data"] count]; i++) {
                    RMPublicModel * model = [[RMPublicModel alloc] init];
                    model.content_img = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_img"]);
                    model.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_name"]);
                    model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
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
                    model.content_img = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_img"]);
                    model.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_name"]);
                    model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                    [dataArr addObject:model];
                }
                [mTableView reloadData];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
            }
            
            if (isRefresh){
                
                if ([[object objectForKey:@"data"] count] == 0){
                    [self showHint:@"没有搜索到相关内容"];
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    return ;
                }
                
                [dataArr removeAllObjects];
                for (NSInteger i=0; i<[[object objectForKey:@"data"] count]; i++) {
                    RMPublicModel * model = [[RMPublicModel alloc] init];
                    model.content_img = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_img"]);
                    model.content_name = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"content_name"]);
                    model.auto_id = OBJC([[[object objectForKey:@"data"] objectAtIndex:i] objectForKey:@"auto_id"]);
                    [dataArr addObject:model];
                }
                [mTableView reloadData];
            }
            
            [self.view endEditing:YES];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

#pragma mark 刷新代理

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction {
    
    if ([[self trim:mTextField.text] isEqualToString:@""]){
        [self showHint:@"输入内容不能为空"];
        [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
        [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
        return ;
    }
    
    if (direction == RefreshDirectionTop) { //下拉刷新
        pageCount = 1;
        isRefresh = YES;
        isLoadComplete = NO;
        if ([self.searchType isEqualToString:@"帖子"]){
            [self requestPostsSearchWithKeyWord:[mTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withType:[NSString stringWithFormat:@"%ld",(long)classValue] withPageCount:1];
        }else if ([self.searchType isEqualToString:@"宝贝"]){
            [self requestBabySearchWithKeyWord:[self.mTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withClass:[NSString stringWithFormat:@"%ld",(long)classValue] withPageCount:1];
        }else{
            [self requetDaqoSearchWithKeyWord:[mTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withPageCount:1 withGrow:@"" withCourse:@""];
        }
    }else if(direction == RefreshDirectionBottom) { //上拉加载
        if (isLoadComplete){
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.44 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self showHint:@"没有更多搜索结果啦"];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
            });
        }else{
            pageCount ++;
            isRefresh = NO;
            if ([self.searchType isEqualToString:@"帖子"]){
                [self requestPostsSearchWithKeyWord:[mTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withType:[NSString stringWithFormat:@"%ld",(long)classValue] withPageCount:pageCount];
            }else if ([self.searchType isEqualToString:@"宝贝"]){
                [self requestBabySearchWithKeyWord:[self.mTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withClass:[NSString stringWithFormat:@"%ld",(long)classValue] withPageCount:pageCount];
            }else{
                [self requetDaqoSearchWithKeyWord:[mTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withPageCount:pageCount withGrow:@"" withCourse:@""];
            }
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

//校对字符串是否为空
- (NSString *)trim:(NSString *)str {
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end

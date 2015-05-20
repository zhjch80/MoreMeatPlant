//
//  RMMoreChatViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/4/15.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMMoreChatViewController.h"

#import "UIViewController+HUD.h"

#import "ApplyViewController.h"
#import "CallSessionViewController.h"
#import "EMCallManagerDelegate.h"
#import "CallSessionViewController.h"
#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "UIAlertView+Expland.h"
//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;

@interface RMMoreChatViewController () <UIAlertViewDelegate, IChatManagerDelegate, ICallManagerDelegate>
{
    // 存放所有要显示的子控制器
    NSMutableDictionary *_allChilds;
    CallSessionViewController *_callController;
    UISegmentedControl * _segmentControl;
    UIBarButtonItem *_addFriendItem;
    NSArray * classNames;
    BOOL transiting;
    
    UINavigationController * nav1;
    UINavigationController * nav2;
    
}

@property (strong, nonatomic) NSDate *lastPlaySoundDate;
@property (retain, nonatomic) UINavigationController * currentController;
@end

@implementation RMMoreChatViewController
@synthesize _chatListVC,_contactsVC,currentController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    
    if(![[RMUserLoginInfoManager loginmanager] state]){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录，请先去登录!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alert show];
        
        [alert handlerClickedButton:^(UIAlertView *alertView, NSInteger btnIndex) {
            AppDelegate * dele = [[UIApplication sharedApplication] delegate];
            [dele tabSelectController:2];
        }];
    }else{
            AppDelegate * dele = [[UIApplication sharedApplication] delegate];
            [dele queryInfoNumber];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setCustomNavTitle:@""];
    //if 使tabBarController中管理的viewControllers都符合 UIRectEdgeNone
//    if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
//    self.tabBarController.tabBar.hidden = YES;
    
    
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[RMMoreChatViewController class]];
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[RMMoreChatViewController class]];
    //获取未读消息数，此时并没有把self注册为SDK的delegate，读取出的未读数是上次退出程序时的
    [self didUnreadMessagesCountChanged];
#warning 把self注册为SDK的delegate
    [self registerNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUntreatedApplyCount) name:@"setupUntreatedApplyCount" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callOutWithChatter:) name:@"callOutWithChatter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callControllerClose:) name:@"callControllerClose" object:nil];
    
    [self setupSubviews];

    
    
    
    _segmentControl = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"消息",@"好友", nil]];
    _segmentControl.frame = CGRectMake(0, 20, 120, 30);
    _segmentControl.center = CGPointMake(kScreenWidth/2, 20+44/2);
    [_segmentControl addTarget:self action:@selector(segmentControlChanged:) forControlEvents:UIControlEventValueChanged];
    
    _segmentControl.selectedSegmentIndex = 0;

    [self.view addSubview: _segmentControl];
    
    [self setupUnreadMessageCount];
    [self setupUntreatedApplyCount];
    
}

- (void)selectController:(NSInteger)index{
    if(index == 0){
        _chatListVC.view.hidden = NO;
        _contactsVC.view.hidden = YES;
    }else{
        _contactsVC.view.hidden = NO;
        _chatListVC.view.hidden = YES;
    }
}

- (void)segmentControlChanged:(UISegmentedControl *)sender{
    if(sender.selectedSegmentIndex == 0){
        [self selectController:0];
    }else{
        [self selectController:1];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [self unregisterNotifications];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 99) {
        if (buttonIndex != [alertView cancelButtonIndex]) {
            [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
                [[ApplyViewController shareController] clear];
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
            } onQueue:nil];
        }
    }
    else if (alertView.tag == 100) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    } else if (alertView.tag == 101) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
}

#pragma mark - private

-(void)registerNotifications
{
    [self unregisterNotifications];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [[EMSDKFull sharedInstance].callManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EMSDKFull sharedInstance].callManager removeDelegate:self];
}

- (void)setupSubviews
{
    _chatListVC = [[ChatListViewController alloc] init];
    _chatListVC.delegate = self;
    _chatListVC.view.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49);
    [_chatListVC networkChanged:_connectionState];
    
    
    _contactsVC = [[ContactsViewController alloc] init];
    _contactsVC.view.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49);
    _contactsVC.delegate = self;
    
    NSLog(@"%@\n%@",self.view,_contactsVC.view);
    
    [self.view addSubview:_chatListVC.view];
    [self.view addSubview:_contactsVC.view];
    _contactsVC.view.hidden = YES;
}

// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    if (_chatListVC) {
        if (unreadCount > 0) {
            _chatListVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
        }else{
            _chatListVC.tabBarItem.badgeValue = nil;
        }
    }
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}

//返回未读消息数目
- (NSInteger)UnreadMessageCount{
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    return unreadCount;
}

- (void)setupUntreatedApplyCount
{
    NSInteger unreadCount = [[[ApplyViewController shareController] dataSource] count];
    if (_contactsVC) {
        if (unreadCount > 0) {
            _contactsVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
        }else{
            _contactsVC.tabBarItem.badgeValue = nil;
        }
    }
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    [_chatListVC networkChanged:connectionState];
}

- (void)callOutWithChatter:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[NSString class]]) {
        NSString *chatter = (NSString *)object;
        
        if (_callController == nil) {
            EMError *error = nil;
            EMCallSession *callSession = [[EMSDKFull sharedInstance].callManager asyncCallAudioWithChatter:chatter timeout:50 error:&error];
            
            if (callSession) {
                [[EMSDKFull sharedInstance].callManager removeDelegate:self];
                _callController = [[CallSessionViewController alloc] initCallOutWithSession:callSession];
                [self presentViewController:_callController animated:YES completion:nil];
            }
            else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"错误") message:error.description delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"好的") otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
        else{
            [self showHint:@"正在通话中"];
        }
    }
}

- (void)callControllerClose:(NSNotification *)notification
{
    [[EMSDKFull sharedInstance].callManager addDelegate:self delegateQueue:nil];
    _callController = nil;
}

#pragma mark - IChatManagerDelegate 消息变化

- (void)didUpdateConversationList:(NSArray *)conversationList
{
    [_chatListVC refreshDataSource];
}

// 未读消息数量变化回调
-(void)didUnreadMessagesCountChanged
{
    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineMessages:(NSArray *)offlineMessages
{
    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineCmdMessages:(NSArray *)offlineCmdMessages
{
    
}

- (BOOL)needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EaseMob sharedInstance].chatManager ignoredGroupIds];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    
    return ret;
}

// 收到消息回调
-(void)didReceiveMessage:(EMMessage *)message
{
    BOOL needShowNotification = message.isGroup ? [self needShowNotification:message.conversationChatter] : YES;
    if (needShowNotification) {
#if !TARGET_IPHONE_SIMULATOR
        
        BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
        if (!isAppActivity) {
            [self showNotificationWithMessage:message];
        }else {
            [self playSoundAndVibration];
        }
#endif
    }
}

-(void)didReceiveCmdMessage:(EMMessage *)message
{
    [self showHint:NSLocalizedString(@"receiveCmd", @"收到一条的cmd消息")];
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EaseMob sharedInstance].deviceManager asyncPlayNewMessageSound];
    // 收到消息时，震动
    [[EaseMob sharedInstance].deviceManager asyncPlayVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == ePushNotificationDisplayStyle_messageSummary) {
        id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
        NSString *messageStr = nil;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Text:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case eMessageBodyType_Image:
            {
                messageStr = NSLocalizedString(@"message.image", @"图片");
            }
                break;
            case eMessageBodyType_Location:
            {
                messageStr = NSLocalizedString(@"message.location", @"位置");
            }
                break;
            case eMessageBodyType_Voice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"语音");
            }
                break;
            case eMessageBodyType_Video:{
                messageStr = NSLocalizedString(@"message.vidio", @"视频");
            }
                break;
            default:
                break;
        }
        
        NSString *title = message.from;
        if (message.isGroup) {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:message.conversationChatter]) {
                    title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, group.groupSubject];
                    break;
                }
            }
        }
        
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = NSLocalizedString(@"receiveMessage", @"你有一条新消息");
    }
    
#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction = NSLocalizedString(@"open", @"打开");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    //    UIApplication *application = [UIApplication sharedApplication];
    //    application.applicationIconBadgeNumber += 1;
}

#pragma mark - IChatManagerDelegate 登陆回调（主要用于监听自动登录是否成功）

- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    if (error) {
        NSString *hintText = NSLocalizedString(@"reconnection.retry", @"登录失败，请重新登录!");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"提示")
                                                            message:hintText
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"reconnection.wait", @"继续等待")
                                                  otherButtonTitles:NSLocalizedString(@"logout", @"登出"),
                                  nil];
        alertView.tag = 99;
        [alertView show];
        [_chatListVC isConnect:NO];
    }
}

#pragma mark - IChatManagerDelegate 好友变化

- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message
{
#if !TARGET_IPHONE_SIMULATOR
    [self playSoundAndVibration];
    
    BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
    if (!isAppActivity) {
        //发送本地推送
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date]; //触发通知的时间
        notification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"friend.somebodyAddWithName", @"%@ 想要添加你为好友"), username];
        notification.alertAction = NSLocalizedString(@"open", @"打开");
        notification.timeZone = [NSTimeZone defaultTimeZone];
    }
#endif
    
    [_contactsVC reloadApplyView];
}

- (void)didUpdateBuddyList:(NSArray *)buddyList
            changedBuddies:(NSArray *)changedBuddies
                     isAdd:(BOOL)isAdd
{
    [_contactsVC reloadDataSource];
}

- (void)didRemovedByBuddy:(NSString *)username
{
    [[EaseMob sharedInstance].chatManager removeConversationByChatter:username deleteMessages:YES append2Chat:YES];
    [_chatListVC refreshDataSource];
    [_contactsVC reloadDataSource];
}

- (void)didAcceptedByBuddy:(NSString *)username
{
    [_contactsVC reloadDataSource];
}

- (void)didRejectedByBuddy:(NSString *)username
{
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"friend.beRefusedToAdd", @"你被'%@'拒绝了"), username];
    TTAlertNoTitle(message);
}

- (void)didAcceptBuddySucceed:(NSString *)username
{
    [_contactsVC reloadDataSource];
}

#pragma mark - IChatManagerDelegate 群组变化

- (void)didReceiveGroupInvitationFrom:(NSString *)groupId
                              inviter:(NSString *)username
                              message:(NSString *)message
{
#if !TARGET_IPHONE_SIMULATOR
    [self playSoundAndVibration];
#endif
    
    [_contactsVC reloadGroupView];
}

//接收到入群申请
- (void)didReceiveApplyToJoinGroup:(NSString *)groupId
                         groupname:(NSString *)groupname
                     applyUsername:(NSString *)username
                            reason:(NSString *)reason
                             error:(EMError *)error
{
    if (!error) {
#if !TARGET_IPHONE_SIMULATOR
        [self playSoundAndVibration];
#endif
        
        [_contactsVC reloadGroupView];
    }
}

- (void)didReceiveGroupRejectFrom:(NSString *)groupId
                          invitee:(NSString *)username
                           reason:(NSString *)reason
{
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"friend.beRefusedToAdd", @"你被'%@'无情的拒绝了"), username];
    TTAlertNoTitle(message);
}


- (void)didReceiveAcceptApplyToJoinGroup:(NSString *)groupId
                               groupname:(NSString *)groupname
{
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"group.agreedToJoin", @"同意你加入 \'%@\'"), groupname];
    [self showHint:message];
}

#pragma mark - IChatManagerDelegate 登录状态变化

- (void)didLoginFromOtherDevice
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"提示") message:NSLocalizedString(@"loginAtOtherDevice", @"您的帐号已经在其他设备上登录了") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"好的") otherButtonTitles:nil, nil];
        alertView.tag = 100;
        [alertView show];
        
    } onQueue:nil];
}

- (void)didRemovedFromServer
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"提示") message:NSLocalizedString(@"loginUserRemoveFromServer", @"您的帐号被管理员删除了") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        alertView.tag = 101;
        [alertView show];
    } onQueue:nil];
}

//- (void)didConnectionStateChanged:(EMConnectionState)connectionState
//{
//    [_chatListVC networkChanged:connectionState];
//}

#pragma mark - 自动登录回调

- (void)willAutoReconnect{
    [self hideHud];
    [self showHint:NSLocalizedString(@"reconnection.ongoing", @"重新连接中...")];
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error{
    [self hideHud];
    if (error) {
        [self showHint:NSLocalizedString(@"reconnection.fail", @"连接失败, 稍后将继续连接")];
    }else{
        [self showHint:NSLocalizedString(@"reconnection.success", @"重连成功！")];
    }
}

#pragma mark - ICallManagerDelegate

- (void)callSessionStatusChanged:(EMCallSession *)callSession changeReason:(EMCallStatusChangedReason)reason error:(EMError *)error
{
    if (callSession.status == eCallSessionStatusConnected)
    {
        if (_callController == nil) {
            _callController = [[CallSessionViewController alloc] initCallInWithSession:callSession];
            [self presentViewController:_callController animated:YES completion:nil];
        }
    }
}

#pragma mark - public

- (void)jumpToChatList
{
    if(_chatListVC)
    {
        [self.navigationController popToViewController:self animated:NO];
        _segmentControl.selectedSegmentIndex = 0;
        [self segmentControlChanged:_segmentControl];
    }
}

@end


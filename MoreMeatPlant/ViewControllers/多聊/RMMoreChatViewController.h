//
//  RMMoreChatViewController.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/4/15.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"
#import "EMChatManagerUtilDelegate.h"
#import "ChatListViewController.h"
#import "ContactsViewController.h"


@interface RMMoreChatViewController : UITabBarController
{
    EMConnectionState _connectionState;
}
@property (retain, nonatomic) ChatListViewController *_chatListVC;
@property (retain, nonatomic) ContactsViewController *_contactsVC;

- (void)jumpToChatList;

- (void)setupUntreatedApplyCount;

- (void)networkChanged:(EMConnectionState)connectionState;
@end

//
//  ELShareClient.m
//  SevenStars
//
//  Created by elongtian on 14-6-30.
//  Copyright (c) 2014年 madongkai. All rights reserved.
//

#import "RMShareClient.h"

#define APPID @"1234567890"

@implementation RMShareClient
- (id)init {
    self = [super init];
    if(self)
    {
        
    }
    return self;
    
}

- (void)share:(NSDictionary *)dic {
    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeSinaWeibo, ShareTypeTencentWeibo,ShareTypeQQSpace,ShareTypeSMS,ShareTypeCopy,ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeQQ,ShareTypeWeixiFav, nil];
    
    //创建分享内容
    //http://itunes.apple.com/lookup?id=888941676
    //http://dj.7-hotel.com/file/upload/2014/06/21/1403868351.jpg
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:[dic objectForKey:@"image"] ofType:@"jpg"];
//    id<ISSContent> publishContent = [ShareSDK content:@"七星酒店网凝结两大品牌体系，高端优质的品牌宣传与市场最低价的团体预订，形成组合拳，并充分利用资源整合及高效传播的优势，突显酒店服务特色，将B2B与B2C进行完美整合，引领奢华人士享受品质生活。"
//                                       defaultContent:@"七星酒店网—总有你想要的低价星级酒店产品。"
//                                                image:[ShareSDK pngImageWithImage:[UIImage imageNamed:@"Icon_180x180"]]
//                                                title:[dic objectForKey:@"我来分享"]
//                                                  url:@"http://itunes.apple.com/lookup?id=888941676"
//                                          description:NSLocalizedString(@"TEXT_TEST_MSG", @"我在七星酒店网")
//                                            mediaType:SSPublishContentMediaTypeNews];
    
    //创建分享内容
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Icon_180x180" ofType:@"png"];
    //
    NSString * down_url = [NSString stringWithFormat:@"七星酒店网—总有你想要的低价星级酒店产品。https://itunes.apple.com/cn/app/id%@", APPID];
    id<ISSContent> publishContent = [ShareSDK content:down_url
                                       defaultContent:@""
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"七星酒店网"
                                                  url:[NSString stringWithFormat:@"itunes.apple.com/cn/app/id%@", APPID]
                                          description:down_url
                                            mediaType:SSPublishContentMediaTypeNews];

    
    
    //创建容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:nil arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    [authOptions setPowerByHidden:YES];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    appdelegate = [[UIApplication sharedApplication] delegate];
    
    //显示分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                          oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                           qqButtonHidden:NO
                                                    wxSessionButtonHidden:NO
                                                   wxTimelineButtonHidden:NO
                                                     showKeyboardOnAppear:NO
                                                        shareViewDelegate:appdelegate.viewdelegate
                                                      friendsViewDelegate:appdelegate.viewdelegate
                                                    picViewerViewDelegate:nil]
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if(self.sharebtnClicked)
                                {
                                    self.sharebtnClicked(type, state, statusInfo, error, end);
                                }
                            }];
    
    
}
@end

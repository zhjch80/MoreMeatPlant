//
//  Harpy.m
//  Harpy
//
//  Created by Arthur Ariel Sabintsev on 11/14/12.
//  Copyright (c) 2012 Arthur Ariel Sabintsev. All rights reserved.
//

#import "Harpy.h"

#define kHarpyCurrentVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey]

@interface Harpy ()

+ (void)showAlertWithAppStoreVersion:(NSString*)appStoreVersion;

@end

@implementation Harpy
#pragma mark - Public Methods

+ (void)checkVersion{
    
    // Asynchronously query iTunes AppStore for publically available version
    NSString *storeString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", kHarpyAppID];
    NSLog(@"%@",storeString);
    NSURL *storeURL = [NSURL URLWithString:storeString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:storeURL];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if ( [data length] > 0 && !error ) { // Success
            
            NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // All versions that have been uploaded to the AppStore
                NSArray *versionsInAppStore = [[appData valueForKey:@"results"] valueForKey:@"version"];
                
                if ( ![versionsInAppStore count] ) { // No versions of app in AppStore
                    
                    return;
                    
                } else {
                    
                    NSString *currentAppStoreVersion = [versionsInAppStore objectAtIndex:0];
                    NSLog(@"%@",currentAppStoreVersion);
                    
                    if ([kHarpyCurrentVersion compare:currentAppStoreVersion options:NSNumericSearch] == NSOrderedAscending) {
		                 
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"isCheck" object:nil];
                       
                         [Harpy showAlertWithAppStoreVersion:currentAppStoreVersion];
                    }
                    else {
                        
                        // Current installed version is the newest public version or newer

                        
                        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"您使用的已经是最新版本了！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        
                        [alertView show];

//                    CLBCustomAlertView * alertview = [[CLBCustomAlertView alloc] initWithTitle:@"升级提示" message:@"当前已为最新版本，敬请期待" leftButtonTitle:@"知道了" leftActionBlock:^(CLBCustomAlertView *view) {
//                        [view dismiss];
//                    } rightButtonTitle:nil rightActionBlock:^(CLBCustomAlertView *view) {
//                        
//                        
//                    }];

//                        [alertview show];
                        
                    }
                    
                }
                
            });
        }
        
    }];
}
#pragma mark - Private Methods
+ (void)showAlertWithAppStoreVersion:(NSString *)currentAppStoreVersion
{
    
    //NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    NSString *appName = aPPName;
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"更新提醒" message:[NSString stringWithFormat:@"亲，%@有新版本了！快升级到全新的%@吧！", appName, currentAppStoreVersion] delegate:self cancelButtonTitle:nil otherButtonTitles:@"稍后",@"马上更新", nil];

    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
    
    }else{
        NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", kHarpyAppID];
        NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
        [[UIApplication sharedApplication] openURL:iTunesURL];
    }
}

+ (void)home_checkVersion
{
    NSString *storeString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", kHarpyAppID];
    NSLog(@"%@",storeString);
    NSURL *storeURL = [NSURL URLWithString:storeString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:storeURL];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if ( [data length] > 0 && !error ) { // Success
            
            NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // All versions that have been uploaded to the AppStore
                NSArray *versionsInAppStore = [[appData valueForKey:@"results"] valueForKey:@"version"];
                
                if ( ![versionsInAppStore count] ) { // No versions of app in AppStore
                    
                    return;
                    
                } else {
                    
                    NSString *currentAppStoreVersion = [versionsInAppStore objectAtIndex:0];
                    
                    if ([kHarpyCurrentVersion compare:currentAppStoreVersion options:NSNumericSearch] == NSOrderedAscending) {
                        
                        [Harpy showAlertWithAppStoreVersion:currentAppStoreVersion];
                    }
                    else {
                        
                       
                        
                    }
                    
                }
                
            });
        }
        
    }];
}


@end

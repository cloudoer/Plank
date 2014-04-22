//
//  AppDelegate.m
//  Plank
//
//  Created by zhoulong on 14-4-14.
//  Copyright (c) 2014年 zhoulong. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "NSUtil.h"

#define UMENG_KEY @"534e44d256240bef0801bc59"
#define HANDLE_OPEN_URL(DEVICEID) [NSString stringWithFormat:@"http://plank.tijian8.cn/main.html?devId=%@",DEVICEID]
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UMSocialData setAppKey:UMENG_KEY];
    [UMSocialWechatHandler setWXAppId:@"wxf2b49cb0ce6b9ef4" url:HANDLE_OPEN_URL([NSUtil theUUID])];
    [AVOSCloud setApplicationId:@"zsjv9jidzlgkjbo13sdiagsvevpvj0f0z1s278s5rm6vt8kx"
                      clientKey:@"vrvg3c3xjuvk79u6v9wvrz8otc3iml16uka5aq61b27h6gdg"];   
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}
@end

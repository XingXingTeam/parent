//
//  AppDelegate.m
//  xingxingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/1/13.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define ktUrl  @"ed3e8ddd8194"
#define qqUrl  @"1105134342"
#define sinaUrl @"2875286507"
#define qqK     @"IiXKfiJvKBiGjOOc"
#define wxUrl   @"wx7c4249886c93e20e"
#define sinaK   @"d26a462ef16055e1a9010a1d5489b3a6"
#define wxS     @"e452142ebe813f5dfab564a95b2ccc02"
#define sinaS   @"http://sns.whalecloud.com/sina2/callback"

#define UmengAppKey @"56d4096e67e58ef29300147c"
#define WXAPPID @"wx0133249557f0fa1b"
#define WXAPPsecret @"e452142ebe813f5dfab564a95b2ccc02"
#define WXUrl @"http://www.xingxingedu.cn/"

#import "AppDelegate.h"
#import "LandingpageViewController.h"
#import "SettingPersonInfoViewController.h"
#import "SchoolInfoViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "BeeCloud.h"
#import "JPUSHService.h"
#import "StoreHomePageViewController.h"
#import "AddAddressViewController.h"
#import "ClassRoomHomePageViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import "BMKMapViewController.h"
#import "CommentsRootTabbarViewController.h"
#import "ClassRoomSearchViewController.h"
#import "CommentInfoViewController.h"
#import "RootTabbarViewController.h"
#import "CoreUMeng.h"
#import "HomepageViewController.h"
#import "LoginViewController.h"
#import "ClassRoomOrderViewController.h"
#import "SchoolInfoViewController.h"
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialAlipayShareHandler.h"
#import "APOpenAPIObject.h"
#import "FirstLaunchViewController.h"

#import"PayMannerViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    BOOL isNotFirstLauch = [[NSUserDefaults standardUserDefaults] boolForKey:kAppFirstLoadKey];
    if (isNotFirstLauch) {
        
        LandingpageViewController *login=[[LandingpageViewController alloc]init];
        //ceshi        
        UINavigationController *navi=[[UINavigationController alloc]initWithRootViewController:login];
        self.window.rootViewController=navi;
        
    }
    else{
        isNotFirstLauch = !isNotFirstLauch;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kAppFirstLoadKey];
        FirstLaunchViewController *login =[[FirstLaunchViewController alloc]init];
        UINavigationController *navi=[[UINavigationController alloc]initWithRootViewController:login];
        self.window.rootViewController=navi;
        
    }
    
    [self.window makeKeyAndVisible];
    
    
    //初始化应用，appKey和appSecret从后台申请得
    [SMSSDK registerApp:@"ec9c9a472b8c"
             withSecret:@"7930e91cbd30596d903c06e5613635db"];

    
    /**
     *  keenteam，请移步到登录keen_team.com进行应用注册，
     */
    [ShareSDK registerApp:ktUrl activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
                                                @(SSDKPlatformTypeWechat),
                                                @(SSDKPlatformTypeQQ)] onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType) {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
         switch (platformType) {
             case SSDKPlatformTypeSinaWeibo:
                 [appInfo SSDKSetupSinaWeiboByAppKey:sinaUrl   appSecret:sinaK
                redirectUri:sinaS                   authType:SSDKAuthTypeBoth];
                 break;
                 
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:wxUrl
                                         appSecret:wxS];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:qqUrl
                appKey:qqK                          authType:SSDKAuthTypeBoth];
                 break;
                 
             default:
                 break;
         }
     }];
    
    
    //分享
    //设置AppKey
    [CoreUMeng umengSetAppKey:UmengAppKey];
    //集成新浪
    [CoreUMeng umengSetSinaSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    //集成微信
    [CoreUMeng umengSetWXAppId:WXAPPID appSecret:WXAPPsecret url:WXUrl];
    //集成QQ
    [CoreUMeng umengSetQQAppId:@"100424468" appSecret:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.qq.com/"];
    

    //支付
    [BeeCloud initWithAppID:@"70db8dc5-25e9-4080-a941-c828ec122c34" andAppSecret:@"333597a1-557a-4363-91f8-16daf51e1f0b"];
    [BeeCloud initWeChatPay:@"wx7c4249886c93e20e"];
//    [BeeCloud setSandboxMode:YES];
    
    //初始化融云相关
    [self initRongClould];
    
    
    //本地通知
    
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    
    //JPush
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel apsForProduction:isProduction];

    return YES;
}

-(void)initRongClould{
    // 初始化 SDK，传入 AppKey
    self.friendsArray = [[NSMutableArray alloc]init];
    self.groupsArray = [[NSMutableArray alloc]init];
    [[RCIM sharedRCIM] initWithAppKey:@"4z3hlwrv3t0dt"];
    //设置用户信息提供者为 [RCDataManager shareManager]
    [RCIM sharedRCIM].userInfoDataSource = [RCDataManager shareManager];
    //设置群组信息提供者为 [RCDataManager shareManager]
    [RCIM sharedRCIM].groupInfoDataSource = [RCDataManager shareManager];
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
     // return  [UMSocialSnsService handleOpenURL:url];
    return  [CoreUMeng umengHandleOpenURL:url];
}

//为保证从支付宝，微信返回本应用，须绑定openUrl. 用于iOS9之前版本
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if (![BeeCloud handleOpenUrl:url]) {
        //handle其他类型的url
        
    }
    return YES;
}

//iOS9之后apple官方建议使用此方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    if (![BeeCloud handleOpenUrl:url]) {
        //handle其他类型的url
        return  [CoreUMeng umengHandleOpenURL:url];
    }
    return YES;
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    // Register to receive notifications.
//    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    
}
#endif

// 获取苹果推送权限成功。
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 设置 deviceToken。
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
   
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
  
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"今天是你的生日，生日快乐！" message:notification.alertBody delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
 
    // 角标清0
     application.applicationIconBadgeNumber = 0;
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSLog(@"社区强制退出，已有%@秒",[defaults objectForKey:@"communityTime"]);
    
    //视频监控
         [defaults objectForKey:@"time"];

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
//    NSInteger ToatalunreadMsgCount = (NSInteger)[[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_GROUP),@(ConversationType_CHATROOM)]];
//    [UIApplication sharedApplication].applicationIconBadgeNumber = ToatalunreadMsgCount;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSLog(@"社区强制退出，已有%@秒",[defaults objectForKey:@"communityTime"]);
    
    //  //视频监控
       [defaults objectForKey:@"time"];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


+ (AppDelegate* )shareAppDelegate {
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSLog(@"社区强制退出，已有%@秒",[defaults objectForKey:@"communityTime"]);
    
    //  //视频监控
    [defaults objectForKey:@"time"];
    
}





@end
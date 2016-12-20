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
//#define ktUrl  @"ed3e8ddd8194"
//#define qqUrl  @"1105134342"
//#define sinaUrl @"2875286507"
//#define qqK     @"IiXKfiJvKBiGjOOc"
//#define wxUrl   @"wx7c4249886c93e20e"
//#define sinaK   @"d26a462ef16055e1a9010a1d5489b3a6"
//#define wxS     @"e452142ebe813f5dfab564a95b2ccc02"
#define sinaS   @"http://sns.whalecloud.com/sina2/callback"
//
//#define UmengAppKey @"57c01a13f43e48118e000e55"
//
//#define WXAPPID @"wx0133249557f0fa1b"
//#define WXAPPsecret @"e452142ebe813f5dfab564a95b2ccc02"
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
#import "StoreHomePageViewController.h"
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
#import "XXETabBarViewController.h"
#import "XXEUserInfo.h"
#import "XXEStarImageViewController.h"


//Mark - mxw
#define JPushAppKey @"26acc9ecd08e6e81d26c5279"
#define kIsProduction NO //0 (默认值)表示采用的是开发证书，1 表示采用生产证书发布应用
//极光推送
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import <AudioToolbox/AudioToolbox.h>
#import "ServiceManager.h"
#import "UpdatePopView.h"
#import "WithoutCloseUpdatePopView.h"
//MARK - 当前系统版本号 规定为三位数整数 如: 1.0.0 为100
static int currentVersion = 100;


//#import"PayMannerViewController.h"
@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //初始化应用，appKey和appSecret从后台申请得
    [SMSSDK registerApp:@"ec9c9a472b8c"
             withSecret:@"7930e91cbd30596d903c06e5613635db"];

    [self setUMSDK];
    
    //支付
    [BeeCloud initWithAppID:@"70db8dc5-25e9-4080-a941-c828ec122c34" andAppSecret:@"333597a1-557a-4363-91f8-16daf51e1f0b"];
    [BeeCloud initWeChatPay:@"wx7c4249886c93e20e"];
    //    [BeeCloud setSandboxMode:YES];
    
    //初始化融云相关
    [self initRongClould];
    
    //初始化APNs
    [self initAPNs];
    
    //初始化JPush
    [self initJPushWith:launchOptions];
    
    NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    self.userInfo = remoteNotification;
    
    [self toMainAPP];
    [self loadStarView];
    [self showUpdatePopView];
    /**
     *  keenteam，请移步到登录keen_team.com进行应用注册，
     */
//    [ShareSDK registerApp:ktUrl activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
//                                                @(SSDKPlatformTypeWechat),
//                                                @(SSDKPlatformTypeQQ)] onImport:^(SSDKPlatformType platformType)
//     {
//         switch (platformType) {
//             case SSDKPlatformTypeWechat:
//                 [ShareSDKConnector connectWeChat:[WXApi class]];
//                 break;
//             case SSDKPlatformTypeQQ:
//                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
//                 break;
//             case SSDKPlatformTypeSinaWeibo:
//                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
//                 break;
//             default:
//                 break;
//         }
//     } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
//         switch (platformType) {
//             case SSDKPlatformTypeSinaWeibo:
//                 [appInfo SSDKSetupSinaWeiboByAppKey:sinaUrl   appSecret:sinaK
//                redirectUri:sinaS                   authType:SSDKAuthTypeBoth];
//                 break;
//                 
//             case SSDKPlatformTypeWechat:
//                 [appInfo SSDKSetupWeChatByAppId:wxUrl
//                                         appSecret:wxS];
//                 break;
//             case SSDKPlatformTypeQQ:
//                 [appInfo SSDKSetupQQByAppId:qqUrl
//                appKey:qqK                          authType:SSDKAuthTypeBoth];
//                 break;
//                 
//             default:
//                 break;
//         }
//     }];
    
    
    //分享
    //设置AppKey
//    [CoreUMeng umengSetAppKey:UMSocialAppKey];
//    //集成新浪
//    [CoreUMeng umengSetSinaSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
//    //集成微信
//    [CoreUMeng umengSetWXAppId:WXAPPID appSecret:WXAPPsecret url:WXUrl];
//    //集成QQ
//    [CoreUMeng umengSetQQAppId:@"100424468" appSecret:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.qq.com/"];
    
    
    //本地通知
    
//    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];

    return YES;
}

- (void)setUMSDK {
    [UMSocialData setAppKey:UMSocialAppKey];
    [UMSocialData openLog:YES];
    //微信
    [UMSocialWechatHandler setWXAppId:WeChatAppId appSecret:WeChatAppSecret url:WXUrl];
    //新浪
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:SinaWebAppKey RedirectURL:sinaS];
    
//    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:SinaWebAppKey secret:SinaWebAppSecret RedirectURL:@"https://api.weibo.com/oauth2/default.html"];
    //QQ空间
    [UMSocialQQHandler setQQWithAppId:QQAppId appKey:QQAppSecret url:@"http://www.umeng.com/social"];
    //设置没有客户端的情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    
    //隐藏没有安装的APP图标
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatTimeline,UMShareToWechatSession]];
}

// 添加初始化APNs代码
- (void)initAPNs {
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
}

// 初始化JPush代码
- (void)initJPushWith:(NSDictionary *)launchOptions {
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    //    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppKey channel:@" " apsForProduction:kIsProduction];
}

- (void) toMainAPP {
    UIViewController *initViewController = [[UIViewController alloc] init];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    LandingpageViewController *login=[[LandingpageViewController alloc]init];
//    XXENavigationViewController *navi = [[XXENavigationViewController alloc] initWithRootViewController:loginVC];
//    XXETabBarControllerConfig *tarVC = [[XXETabBarControllerConfig alloc] init];
    
    if ([XXEUserInfo user].login) {
        // 设置窗口的根控制器
        initViewController = [[XXETabBarViewController alloc] init];
    }else {
        
        initViewController = login;
    }
    
    self.window.rootViewController = initViewController;
}

//MARK: - 版本更新提示框
- (void)showUpdatePopView {
    
    [[ServiceManager sharedInstance] requestWithURLString:CheckoutVersionURL parameters:nil type:HttpRequestTypeGet success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            [GlobalVariable shareInstance].appStoreURL = responseObject[@"data"][@"url"];
            NSString *appStoreURL = responseObject[@"data"][@"url"];
            int nowVersion = [responseObject[@"data"][@"now_version"] intValue];
            int allowVersion = [responseObject[@"data"][@"allow_version"] intValue];// 支持最低版本号
            
            if (currentVersion < nowVersion) {//更新
                if (currentVersion < allowVersion) {//强制更新
                    [self mustJumpToAppStoreWithNowVerson:nowVersion appStoreURL:appStoreURL];
                    return;
                }
                [self jumpToAppStoreWithNowVerson:nowVersion appStoreURL:appStoreURL];
            }else if (currentVersion > nowVersion){ //苹果审核中
                //code...
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}

//MARK: - 强制跳转AppStore
- (void)mustJumpToAppStoreWithNowVerson:(int)nowVersion appStoreURL:(NSString*)appStoreURL {
    NSString *versionText = [NSString stringWithFormat:@"%d", nowVersion];
    WithoutCloseUpdatePopView *withoutClosePopView = [WithoutCloseUpdatePopView convenicenWithTitle:versionText];
    [self.window addSubview:withoutClosePopView];
    //button点击方法
    //    __weak typeof (UpdatePopView) *weakPopView = popView;
    [withoutClosePopView clickUpdateBtn:^{
        NSURL * url = [NSURL URLWithString:appStoreURL];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
        else
        {
            NSLog(@"can not open");
        }
    }];
}

//MARK: - 跳转AppStore
- (void)jumpToAppStoreWithNowVerson:(int)nowVersion appStoreURL:(NSString*)appStoreURL {
    NSString *versionText = [NSString stringWithFormat:@"%d", nowVersion];
    UpdatePopView *popView = [UpdatePopView convenicenWithTitle:versionText];
    [self.window addSubview:popView];
    //button点击方法
    //    __weak typeof (UpdatePopView) *weakPopView = popView;
    [popView clickUpdateBtn:^{
        NSURL * url = [NSURL URLWithString:appStoreURL];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
        else
        {
            NSLog(@"can not open");
        }
    }];
}

#pragma mark - 加入启动图片
- (void)loadStarView {
    NSUserDefaults *first = [NSUserDefaults standardUserDefaults];
    NSString *isFirst = [first objectForKey:@"isFirst"];
    if (!isFirst) {
        [self setupControllers];
        [first setObject:@"firstEnterApp" forKey:@"isFirst"];
    }
}

- (void)setupControllers
{
    XXEStarImageViewController *starImageViewController = [[XXEStarImageViewController alloc]init];
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.rootViewController = starImageViewController;
    [self.window makeKeyAndVisible];
    
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


/**
 这里处理新浪微博SSO授权之后的跳转回来,和微信分享完成后跳转回来
 */
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation
{
    
    if (![BeeCloud handleOpenUrl:url]) {
        //handle其他类型的url
        NSLog(@"打开支付宝!");
        return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
        
    }
    return YES;
    
}


//iOS9之后apple官方建议使用此方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    if (![BeeCloud handleOpenUrl:url]) {
        //handle其他类型的url
        
        NSLog(@"打开支付宝!===== ");
        return  [UMSocialSnsService handleOpenURL:url];
    }
    return YES;
}



/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台,再返回来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    [UMSocialSnsService applicationDidBecomeActive];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

//- (void)applicationWillTerminate:(UIApplication *)application {
//    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//}

//-(void)initRongClould{
//    // 初始化 SDK，传入 AppKey
//    self.friendsArray = [[NSMutableArray alloc]init];
//    self.groupsArray = [[NSMutableArray alloc]init];
//    [[RCIM sharedRCIM] initWithAppKey:MyRongCloudAppKey];
//    //设置用户信息提供者为 [RCDataManager shareManager]
//    [RCIM sharedRCIM].userInfoDataSource = [XXERCDataManager shareManager];
//    //设置群组信息提供者为 [RCDataManager shareManager]
//    [RCIM sharedRCIM].groupInfoDataSource = [XXERCDataManager shareManager];
//    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
//}

+ (AppDelegate* )shareAppDelegate {
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

/*
 * 推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}



- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
    
    [JPUSHService registerDeviceToken:deviceToken];
    
    if ([XXEUserInfo user].login){
        [JPUSHService setAlias:[XXEUserInfo user].xid callbackSelector:nil object:nil];
        NSLog(@"%@", [XXEUserInfo user].xid);
    }
    
    //    [JPUSHService re];
}

// 实现注册APNs失败接口
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        AudioServicesPlayAlertSound(1007);
        //        [self saveFMDBWithUserInfo:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        //判断是否从后台进入
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isActiveStatus"] isEqualToString:@"NO"]) { //不是从后台进入
            
        }else {
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isActiveStatus"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        AudioServicesPlayAlertSound(1007);
        //        [self saveFMDBWithUserInfo:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    if ([userInfo[@"aps"][@"sound"] isEqualToString:@"default"]) {
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kChatNotification object:nil userInfo:userInfo];
            AudioServicesPlayAlertSound(1007);
        }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kChatRemoteNotification object:nil userInfo:userInfo];
        }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kChatRemoteNotification object:nil userInfo:userInfo];
        }
    }else {
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kSystemMessage object:nil userInfo:userInfo];
            AudioServicesPlayAlertSound(1007);
        }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kRemoteNotification object:nil userInfo:userInfo];
        }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kRemoteNotification object:nil userInfo:userInfo];
        }
    }
    //
    //    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
    //        [[NSNotificationCenter defaultCenter] postNotificationName:kSystemMessage object:nil userInfo:userInfo];
    //        AudioServicesPlayAlertSound(1007);
    //    }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
    //        [[NSNotificationCenter defaultCenter] postNotificationName:kRemoteNotification object:nil userInfo:userInfo];
    //    }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
    //        [[NSNotificationCenter defaultCenter] postNotificationName:kRemoteNotification object:nil userInfo:userInfo];
    //    }
    
    
    
    //    [self saveFMDBWithUserInfo:userInfo];
    
    
    //订阅展示视图消息，将直接打开某个分支视图
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentView:) name:@"PresentView" object:nil];
    //    //弹出消息框提示用户有订阅通知消息。主要用于用户在使用应用时，弹出提示框
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNotification:) name:@"Notification" object:nil];
}

//- (void)saveFMDBWithUserInfo:(NSDictionary *)userInfo {
//    [JPUSHService setBadge:0];
//    [[FMDBManager shareDataBase] createSystemMsgListTable];
//    
//    SysMsgModel *model = [[SysMsgModel alloc] init];
//    model.alert = userInfo[@"aps"][@"alert"];
//    model.sound = userInfo[@"aps"][@"sound"];
//    model.badge = userInfo[@"aps"][@"badge"];
//    model.type = userInfo[@"type"];
//    model.notice_id = userInfo[@"notice_id"];
//    [[FMDBManager shareDataBase] insertWithSysmodel:model];
//    
//    NSLog(@"%@",[[FMDBManager shareDataBase] selectedSysmodel]);
//}


//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//     // return  [UMSocialSnsService handleOpenURL:url];
//    return  [CoreUMeng umengHandleOpenURL:url];
//}
//
////为保证从支付宝，微信返回本应用，须绑定openUrl. 用于iOS9之前版本
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    if (![BeeCloud handleOpenUrl:url]) {
//        //handle其他类型的url
//        
//    }
//    return YES;
//}
//
////iOS9之后apple官方建议使用此方法
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
//    if (![BeeCloud handleOpenUrl:url]) {
//        //handle其他类型的url
//        return  [CoreUMeng umengHandleOpenURL:url];
//    }
//    return YES;
//}
//
//#ifdef __IPHONE_8_0
//- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
//{
//    // Register to receive notifications.
////    [application registerForRemoteNotifications];
//}
//
//- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
//{
//    
//}
//#endif
//
//// 获取苹果推送权限成功。
//-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
//{
//    // 设置 deviceToken。
//    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
//    [JPUSHService registerDeviceToken:deviceToken];
//}
//- (void)application:(UIApplication *)application
//didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    [JPUSHService handleRemoteNotification:userInfo];
//   
//}
//
//- (void)application:(UIApplication *)application
//didReceiveRemoteNotification:(NSDictionary *)userInfo
//fetchCompletionHandler:
//(void (^)(UIBackgroundFetchResult))completionHandler {
//    [JPUSHService handleRemoteNotification:userInfo];
//  
//    
//    completionHandler(UIBackgroundFetchResultNewData);
//}
//
//- (void)application:(UIApplication *)application
//didReceiveLocalNotification:(UILocalNotification *)notification {
//    
//    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"今天是你的生日，生日快乐！" message:notification.alertBody delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
// 
//    // 角标清0
//     application.applicationIconBadgeNumber = 0;
//}
//- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    
//    //Optional
//    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
//}
//
//
//- (void)applicationWillResignActive:(UIApplication *)application {
//    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//  
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
////    NSLog(@"社区强制退出，已有%@秒",[defaults objectForKey:@"communityTime"]);
//    
//    //视频监控
//         [defaults objectForKey:@"time"];
//
//}
//
//- (void)applicationDidEnterBackground:(UIApplication *)application {
////    NSInteger ToatalunreadMsgCount = (NSInteger)[[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_GROUP),@(ConversationType_CHATROOM)]];
////    [UIApplication sharedApplication].applicationIconBadgeNumber = ToatalunreadMsgCount;
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
////    NSLog(@"社区强制退出，已有%@秒",[defaults objectForKey:@"communityTime"]);
//    
//    //  //视频监控
//       [defaults objectForKey:@"time"];
//}
//
//- (void)applicationWillEnterForeground:(UIApplication *)application {
//  // [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//    
//}
//
//- (void)applicationDidBecomeActive:(UIApplication *)application {
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//}
//
//
//+ (AppDelegate* )shareAppDelegate {
//    return (AppDelegate*)[UIApplication sharedApplication].delegate;
//}
//
//
//- (void)applicationWillTerminate:(UIApplication *)application {
//    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
////    NSLog(@"社区强制退出，已有%@秒",[defaults objectForKey:@"communityTime"]);
//    
//    //  //视频监控
//    [defaults objectForKey:@"time"];
//    
//}
//
//



@end

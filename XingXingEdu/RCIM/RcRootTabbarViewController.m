//
//  RcRootTabbarViewController.m
//  RCIM
//
//  Created by codeDing on 16/2/26.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "RcRootTabbarViewController.h"
#import "FriendsListViewController.h"
#import "MyCenterViewController.h"
#import "WMConversationListViewController.h"
#import "GroupListViewController.h"
#import "DiscussionViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "RCUserInfo+Addition.h"
#import "AppDelegate.h"
#import "FriendCell.h"
#import "UIImageView+WebCache.h"

@interface RcRootTabbarViewController (){
    NSString *token;
    NSString *userId;
    NSString *userNickName;
    NSString *userPortraitUri;
    
    
    int loginCount;
}

@end

@implementation RcRootTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRongCloud];
    
    [self setContent];
    
}


- (void)setRongCloud{
    /*
     kkkk dict:{
     msg = Success!登录成功!,
     data = {
     account = 15026511452,
     user_head_img = http://www.xingxingedu.cn/Public/app_upload/head_img/2016/07/04/20160704141256_6865.png,
     nickname = 大熊猫2,
     user_type = 1,
     user_id = 2,
     token = lJELO79GiykHxvqdSxvKcJQEwCVP7+PYbY08BpzgYl48DKZh/HyFQH3WEkDs8QQy/DibEI+T5ZwHAuk3NAfi1Hij3+TGVQ+r,
     xid = 18886064,
     login_times = 2
     },
     code = 1
     }
     
     */
    if ([DEFAULTS objectForKey:@"RCUserToken"] == nil) {
        token = @"lJELO79GiykHxvqdSxvKcJQEwCVP7+PYbY08BpzgYl48DKZh/HyFQH3WEkDs8QQy/DibEI+T5ZwHAuk3NAfi1Hij3+TGVQ+r";
        
        userId = @"18886064";
        
        userNickName = @"大熊猫2";
        
        userPortraitUri = @"http://www.xingxingedu.cn/Public/app_upload/head_img/2016/07/04/20160704141256_6865.png";
        
    }else{
        
        token = [DEFAULTS objectForKey:@"RCUserToken"];
        userId = [DEFAULTS objectForKey:@"RCUserId"];
        userNickName = [DEFAULTS objectForKey:@"RCUserNickName"];
        userPortraitUri = [DEFAULTS objectForKey:@"RCUserPortraitUri"];
        
    }

    
    RCUserInfo *_currentUserInfo =
    [[RCUserInfo alloc] initWithUserId:userId
                                  name:userNickName
                              portrait:userPortraitUri];
    [RCIM sharedRCIM].currentUserInfo = _currentUserInfo;
    
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        //        //登陆成功。当前登录的用户ID：18884982
        
//        [[RCIM sharedRCIM] refreshUserInfoCache:[RCIM sharedRCIM].currentUserInfo withUserId:userId];
        
        [[RCDataManager shareManager] loginRongCloudWithUserInfo:[[RCUserInfo alloc] initWithUserId:userId name:userNickName portrait:userPortraitUri QQ:nil sex:nil] withToken:token];
        
    } error:^(RCConnectErrorCode status) {
        //
        
//        NSLog(@"登陆的错误码为:%ld", status);
        
    } tokenIncorrect:^{
        
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
        
    }];
    
    
}


- (void)setContent{
    
    WMConversationListViewController *wmConversationListVC = [[WMConversationListViewController alloc]init];
    wmConversationListVC.title = @"会话列表";
    UINavigationController *converNav = [[UINavigationController alloc]initWithRootViewController:wmConversationListVC];
    UITabBarItem *converListItem = [[UITabBarItem alloc]initWithTitle:@"会话列表" image:[UIImage imageNamed:@"rcim2.png"] selectedImage:[[UIImage imageNamed:@"rcim2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    wmConversationListVC.tabBarItem = converListItem;
    [wmConversationListVC.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"rcim2.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"rcim2.png"]];
    
    
    FriendsListViewController *FriendsListVC = [[FriendsListViewController alloc]init];
    FriendsListVC.title = @"好友列表";
    UINavigationController *friendsListNav = [[UINavigationController alloc]initWithRootViewController:FriendsListVC];
    
    UITabBarItem *friendsListItem = [[UITabBarItem alloc]initWithTitle:@"好友列表" image:[UIImage imageNamed:@"rcim1.png"] selectedImage:[[UIImage imageNamed:@"rcim1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    FriendsListVC.tabBarItem = friendsListItem;
    [FriendsListVC.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"rcim1.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"rcim1.png"]];
    
    
    //    GroupListViewController *groupVC = [[GroupListViewController alloc]init];
    //    groupVC.title = @"班级群";
    //    UINavigationController *groupNav = [[UINavigationController alloc]initWithRootViewController:groupVC];
    //
    //    UITabBarItem *groupItem = [[UITabBarItem alloc]initWithTitle:@"班级群" image:[UIImage imageNamed:@"tab2_unselected"] selectedImage:[[UIImage imageNamed:@"tab2_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //    groupNav.tabBarItem = groupItem;
    //    [groupNav.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab2_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab2_unselected"]];
    //
    //
    //    DiscussionViewController *discussionVC = [[DiscussionViewController alloc]init];
    //    discussionVC.title = @"讨论组";
    //    UINavigationController *discussionNav = [[UINavigationController alloc]initWithRootViewController:discussionVC];
    //
    //    UITabBarItem *discussionItem = [[UITabBarItem alloc]initWithTitle:@"讨论组" image:[UIImage imageNamed:@"tab3_unselected"] selectedImage:[[UIImage imageNamed:@"tab3_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //    discussionNav.tabBarItem = discussionItem;
    //    [discussionNav.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab3_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab3_unselected"]];
    //
    //
    //    MyCenterViewController *personCenterVC = [[MyCenterViewController alloc]init];
    //    personCenterVC.title = @"个人主页";
    //    UINavigationController *personCenterNav = [[UINavigationController alloc]initWithRootViewController:personCenterVC];
    //
    //    UITabBarItem *personalPageItem = [[UITabBarItem alloc]initWithTitle:@"个人主页" image:[UIImage imageNamed:@"tab4_unselected"] selectedImage:[[UIImage imageNamed:@"tab4_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //    personCenterVC.tabBarItem = personalPageItem;
    //    [personCenterVC.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab4_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab4_unselected"]];
    
    
    self.viewControllers = @[FriendsListVC,wmConversationListVC];
    self.tabBar.backgroundColor =[UIColor whiteColor];
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<8.0) {
        [[UITabBarItem appearance] setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          UIColorFromRGB(0, 170, 42), NSForegroundColorAttributeName, nil]
                                                 forState:UIControlStateHighlighted];
    }else
    {
        [self.tabBar setTintColor:UIColorFromRGB(0, 170, 42)];
        
        
    }
    
    
}




@end

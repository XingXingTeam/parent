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
#import "KxMenu.h"
#import "RCAddFriendViewController.h"

@interface RcRootTabbarViewController (){
    NSString *token;
    NSString *userId;
    NSString *userNickName;
    NSString *userPortraitUri;
    NSMutableArray *friendsArray;
    
    int loginCount;
}

@end

@implementation RcRootTabbarViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self fetchNetData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightBarBtn];
}

- (void)setRightBarBtn {
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
    [rightButton setImage:[UIImage imageNamed:@"rcim3.png"]forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(showMenu:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
//     self.tabBarController.navigationItem.rightBarButtonItem= rightItem;
}

- (void)fetchNetData{
    
    /*
     【聊天--好友列表】
     
     接口:
     http://www.xingxingedu.cn/Global/friend_list
     
     传参:
     */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/friend_list";
    
    //请求参数
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    NSDictionary *pragm = @{   @"appkey":APPKEY,
                               @"backtype":BACKTYPE,
                               @"xid":parameterXid,
                               @"user_id":parameterUser_Id,
                               @"user_type":USER_TYPE,
                               };
    
    [WZYHttpTool post:urlStr params:pragm success:^(id responseObj) {
        
        friendsArray = [[NSMutableArray alloc] init];
        NSArray *dataSource = responseObj[@"data"];
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            for (NSDictionary *dic in dataSource) {
                
                //                0 :表示 自己 头像 ，需要添加 前缀
                //                1 :表示 第三方 头像 ，不需要 添加 前缀
                //判断是否是第三方头像
                NSString * head_img;
                if([[NSString stringWithFormat:@"%@",dic[@"head_img_type"]]isEqualToString:@"0"]){
                    head_img=[picURL stringByAppendingString:dic[@"head_img"]];
                }else{
                    head_img=dic[@"head_img"];
                }
                
                RCUserInfo *aUserInfo =[[RCUserInfo alloc]initWithUserId:dic[@"xid"] name:dic[@"nickname"] portrait:head_img QQ:nil sex:nil];
                
                [friendsArray addObject:aUserInfo];
                
            }
            
        }else{
            
            
            
        }
        
        [AppDelegate shareAppDelegate].friendsArray = friendsArray;
        [self setRongCloud];
        
        [self setContent];
        //        NSLog(@"[AppDelegate shareAppDelegate].friendsArray======%@", [AppDelegate shareAppDelegate].friendsArray);
    } failure:^(NSError *error) {
        //
        [self setRongCloud];
        
        [self setContent];
    }];
    
}

- (void)setRongCloud{
    
    token = [XXEUserInfo user].token;
    
    userId = [XXEUserInfo user].user_id;
    
    userNickName = [XXEUserInfo user].nickname;
    
    userPortraitUri = [XXEUserInfo user].user_head_img;

    RCUserInfo *_currentUserInfo =
    [[RCUserInfo alloc] initWithUserId:userId
                                  name:userNickName
                              portrait:userPortraitUri];
    [RCIM sharedRCIM].currentUserInfo = _currentUserInfo;

    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
//        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        //        //登陆成功。当前登录的用户ID：18884982

        //        [[RCIM sharedRCIM] refreshUserInfoCache:[RCIM sharedRCIM].currentUserInfo withUserId:userId];

//        [[RCDataManager shareManager] loginRongCloudWithUserInfo:[[RCUserInfo alloc] initWithUserId:userId name:userNickName portrait:userPortraitUri QQ:nil sex:nil] withToken:token];

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
//    UINavigationController *converNav = [[UINavigationController alloc]initWithRootViewController:wmConversationListVC];
    UITabBarItem *converListItem = [[UITabBarItem alloc]initWithTitle:@"会话列表" image:[UIImage imageNamed:@"rcim2.png"] selectedImage:[[UIImage imageNamed:@"rcim2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    wmConversationListVC.tabBarItem = converListItem;
//    [wmConversationListVC.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"rcim2.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"rcim2.png"]];

    
    
    FriendsListViewController *FriendsListVC = [[FriendsListViewController alloc]init];
    FriendsListVC.title = @"好友列表";
//    UINavigationController *friendsListNav = [[UINavigationController alloc]initWithRootViewController:FriendsListVC];
    
    UITabBarItem *friendsListItem = [[UITabBarItem alloc]initWithTitle:@"好友列表" image:[UIImage imageNamed:@"rcim1.png"] selectedImage:[[UIImage imageNamed:@"rcim1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    FriendsListVC.tabBarItem = friendsListItem;
//    [FriendsListVC.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"rcim1.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"rcim1.png"]];
    
    
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
    
    
    self.viewControllers = @[wmConversationListVC,FriendsListVC];
    self.tabBar.backgroundColor =[UIColor whiteColor];
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<8.0) {
        [[UITabBarItem appearance] setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          UIColorFromHex(0x00AA28), NSForegroundColorAttributeName, nil]
                                                 forState:UIControlStateHighlighted];
    }else
    {
        [self.tabBar setTintColor:UIColorFromHex(0x00AA28)];
        
        
    }
    
}


#pragma mark - 加号 (发起群聊、添加好友)//////////////////////////////
/**
 *  加号 (发起群聊、添加好友)
 */
-(void)showMenu:(UIButton *)button{
    
    NSArray *menuItems =
    @[
      
      //      [KxMenuItem menuItem:@"发起群聊"
      //                     image:[UIImage imageNamed:@"faqiqunliao"]
      //                    target:self
      //                    action:@selector(pushGroupChat:)],
      
      [KxMenuItem menuItem:@"添加好友"
                     image:[UIImage imageNamed:@"tianjiahaoyou"]
                    target:self
                    action:@selector(pushAddFriend:)],
      //
      //      [KxMenuItem menuItem:@"通讯录"
      //                     image:[UIImage imageNamed:@"contact_icon"]
      //                    target:self
      //                    action:@selector(pushAddressBook:)],
      //
      //      [KxMenuItem menuItem:@"公众账号"
      //                     image:[UIImage imageNamed:@"public_account"]
      //                    target:self
      //                    action:@selector(pushPublicService:)],
      //
      //      [KxMenuItem menuItem:@"添加公众号"
      //                     image:[UIImage imageNamed:@"add_public_account"]
      //                    target:self
      //                    action:@selector(pushAddPublicService:)],
      ];
    
    CGRect targetFrame = self.navigationItem.rightBarButtonItem.customView.frame;
    targetFrame.origin.y = targetFrame.origin.y + 15;
    [KxMenu showMenuInView:self.navigationController.navigationBar.superview
                  fromRect:targetFrame
                 menuItems:menuItems];
}

//发起群聊
- (void)pushGroupChat:(UIButton *)button{
    NSLog(@"--------发起群聊----------");
    
}


//添加 好友
- (void)pushAddFriend:(UIButton *)button{
    
    NSLog(@"-------- 添加 好友-------");
    //[RCAddFriendViewController alloc]
    RCAddFriendViewController *RCAddFriendVC = [[RCAddFriendViewController alloc] init];
    [self.navigationController pushViewController:RCAddFriendVC animated:YES];
}


@end

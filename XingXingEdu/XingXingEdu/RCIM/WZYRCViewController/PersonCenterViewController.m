//
//  PersonCenterViewController.m
//  RCIM
//
//  Created by codeDing on 16/3/26.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "WMConversationViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "HHControl.h"
#import "RCAddFriendViewController.h"
#import "SVProgressHUD.h"
//#import "UserViewController.h"
#import  "XXEFriendMyCircleViewController.h"
#import "ReportPicViewController.h"


@interface PersonCenterViewController (){

    UIButton *chatButton;
    UIButton *seeFriendCirileButton;
    UIButton *blackButton;
    UIButton *reportButton;
    UIButton *deleteButton;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
}


@end

@implementation PersonCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.showUserInfo==nil) {
        self.showUserInfo = [RCIM sharedRCIM].currentUserInfo;
    }
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }

    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);

    [self createContent];
    
    
}

- (void)createContent{

     //创建 头像 ,名称 ,xid
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, kWidth, 80)];
    
    bgView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:bgView];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:self.showUserInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"DefaultHeader"]];
    [bgView addSubview:iconImageView];
    
    UILabel *nameLabel = [HHControl createLabelWithFrame:CGRectMake(100, 20, 150, 20) Font:14.0 Text:self.showUserInfo.name];
    [bgView addSubview:nameLabel];
    
    UILabel *xidLabel = [HHControl createLabelWithFrame:CGRectMake(100, 50, 200, 20) Font:14.0 Text:[NSString stringWithFormat:@"xid: %@", self.showUserInfo.userId]];
    xidLabel.textColor = [UIColor lightGrayColor];
    [bgView addSubview:xidLabel];
    
    
    //创建 button   按钮big650x84@2x
    
    //650  84
    CGFloat buttonWidth = 325.0 * kWidth / 375;
    CGFloat buttonHeight = 42.0 * kWidth / 375;
    /**
    私聊
     */
    chatButton = [HHControl createButtonWithFrame:CGRectMake((kWidth - buttonWidth) / 2, bgView.frame.origin.y + bgView.frame.size.height + 50, buttonWidth, buttonHeight) backGruondImageName:@"按钮big650x84" Target:self Action:@selector(chatButttonClick:) Title:@"私   聊"];
    [chatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:chatButton];
    
    /**
     圈子
     */
    seeFriendCirileButton = [HHControl createButtonWithFrame:CGRectMake((kWidth - buttonWidth) / 2, chatButton.frame.origin.y + chatButton.frame.size.height + 20 * kWidth / 375, buttonWidth, buttonHeight) backGruondImageName:@"按钮big650x84" Target:self Action:@selector(seeFriendCirileButtonClick:) Title:@"查看圈子"];
    [seeFriendCirileButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:seeFriendCirileButton];
    
    /**
     拉黑
     */
    blackButton = [HHControl createButtonWithFrame:CGRectMake((kWidth - buttonWidth) / 2, seeFriendCirileButton.frame.origin.y + seeFriendCirileButton.frame.size.height + 20 * kWidth / 375, buttonWidth, buttonHeight) backGruondImageName:@"按钮big650x84" Target:self Action:@selector(blackButtonClick:) Title:@"拉   黑"];
    [blackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:blackButton];
    
    /**
     举报
     */
   reportButton  = [HHControl createButtonWithFrame:CGRectMake((kWidth - buttonWidth) / 2, blackButton.frame.origin.y + blackButton.frame.size.height + 20 * kWidth / 375, buttonWidth, buttonHeight) backGruondImageName:@"按钮big650x84" Target:self Action:@selector(reportButtonClick:) Title:@"举   报"];
    [reportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:reportButton];
    
    /**
     删除
     */
    deleteButton = [HHControl createButtonWithFrame:CGRectMake((kWidth - buttonWidth) / 2, reportButton.frame.origin.y + reportButton.frame.size.height + 20 * kWidth / 375, buttonWidth, buttonHeight) backGruondImageName:@"按钮big650x84" Target:self Action:@selector(deleteButtonClick:) Title:@"删   除"];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:deleteButton];
    

}

#pragma mark ********** 聊天 按钮 先判断 身份 **********
- (void)chatButttonClick:(UIButton *)button{
    
//    NSLog(@"userInfo == %@", _showUserInfo);
    [self judgePosition];

}


#pragma Mark========== 判断身份 ========
- (void)judgePosition{
    /*
     【聊天--发起聊天(获取双方token)]
     接口类型:2
     接口:
     http://www.xingxingedu.cn/Global/chat_token
     传参:
     other_xid	//对方xid
     
     ★其他结果需提醒用户
     code:5	//对方不在你的好友名单中,不能发起聊天,是否要添加好友?(触发添加好友请求接口)
     code:6	//对方设置了不接受您的消息!无法发起聊天!
     code:7	//你不在对方的好友名单中,是否要添加好友?
     code:8 //你在对方的黑名单中,无法发起聊天!
     */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/chat_token";
    
    NSString *otherXid = _showUserInfo.userId;
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE,
                             @"other_xid":otherXid
                             };
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
        NSLog(@"%@", responseObj);
        
        if ([responseObj[@"code"] integerValue] == 1) {
            //开始聊天
            [self startChart];
        }else if ([responseObj[@"code"] integerValue] == 5){
            
            [SVProgressHUD showInfoWithStatus:@"不是好友,不能发起聊天!"];
            //添加好友
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //请求 添加 好友
            [self addFriendRequest];
            });

        }else if ([responseObj[@"code"] integerValue] == 6){
            [SVProgressHUD showInfoWithStatus:@"对方设置了不接受您的消息!无法发起聊天!"];
        }else if ([responseObj[@"code"] integerValue] == 7){
            [SVProgressHUD showInfoWithStatus:@"你不在对方的好友名单中,不能发起聊天!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //请求 添加 好友
            [self addFriendRequest];
            });
        }else if ([responseObj[@"code"] integerValue] == 8){
            [SVProgressHUD showInfoWithStatus:@"你在对方的黑名单中,无法发起聊天!"];
        }
        
        
    } failure:^(NSError *error) {
        //
        [SVProgressHUD showErrorWithStatus:@"获取数据失败!"];
    }];
    

}

#pragma Mark %%%%%%%%%%%%%%%% //请求 添加 好友 %%%%%%%%%%%%%%%%%
- (void)addFriendRequest{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加好友" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        //
        textField.placeholder = @"申请备注";
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
        [self requestAddFriend];
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)requestAddFriend{
    /*
     【聊天--发起添加好友请求】
     接口类型:2
     接口:
     http://www.xingxingedu.cn/Global/action_friend_request
     传参:
     other_xid	//对方xid  (测试可用xid: 18886390,18886391,18886393(允许任何人通过),18886378(已是好友),18886177(在对方黑名单中))
     
     //         ★其他结果需提醒用户
     //         code:4	//不能请求自己
     //         code:5	//已经是好友了(不能对好友发起请求)
     //         code:6	//对方在我的黑名单中,无法发起请求!
     //         code:7	//您已经在对方黑名单中,无法发起请求!
     //         code:8	//不能重复对同一个人发起请求!
     //         code:9	//对方已同意,可以直接聊天了 (对方设置了任何人请求直接通过)
     //         code:10	//添加成功 (单方面删除好友,又添加好友)
     */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/action_friend_request";
    
    NSString *otherXid = _showUserInfo.userId;
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE,
                             @"other_xid":otherXid
                             };
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
//        NSLog(@"%@", responseObj);
        if ([responseObj[@"code"] integerValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"请求发送成功!"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else if ([responseObj[@"code"] integerValue] == 4){
            [SVProgressHUD showInfoWithStatus:@"不能请求自己!"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });

        }else if ([responseObj[@"code"] integerValue] == 5){
            [SVProgressHUD showInfoWithStatus:@"对方已经是您的好友!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });

        }else if ([responseObj[@"code"] integerValue] == 6){
            [SVProgressHUD showInfoWithStatus:@"对方在您的黑名单中,无法发起请求!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });

        }else if ([responseObj[@"code"] integerValue] == 7){
            [SVProgressHUD showInfoWithStatus:@"您已经在对方黑名单中,无法发起请求!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });

        }else if ([responseObj[@"code"] integerValue] == 8){
            [SVProgressHUD showInfoWithStatus:@"不能重复对同一个人发起请求!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });

        }else if ([responseObj[@"code"] integerValue] == 9){
            [SVProgressHUD showInfoWithStatus:@"对方已同意,可以直接聊天了(对方设置了任何人请求直接通过)"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });

        }else if ([responseObj[@"code"] integerValue] == 10){
            [SVProgressHUD showInfoWithStatus:@"添加成功!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }

        
    } failure:^(NSError *error) {
        //
        [SVProgressHUD showErrorWithStatus:@"获取数据失败!"];
    }];
    
}




#pragma mark ========== 开始聊天 ============
- (void)startChart{

    if (self.showUserInfo) {
        WMConversationViewController *_conversationVC = [[WMConversationViewController alloc]init];
        _conversationVC.conversationType = ConversationType_PRIVATE;
        
        _conversationVC.targetId = self.showUserInfo.userId;
        _conversationVC.title = [NSString stringWithFormat:@"%@",self.showUserInfo.name];
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }else{
        WMConversationViewController *_conversationVC = [[WMConversationViewController alloc]init];
        _conversationVC.conversationType = ConversationType_PRIVATE;
        _conversationVC.targetId = [RCIM sharedRCIM].currentUserInfo.userId;
        _conversationVC.title = [NSString stringWithFormat:@"%@",[RCIM sharedRCIM].currentUserInfo.name];
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }

}

#pragma mark ======= 查看朋友圈 =============
- (void)seeFriendCirileButtonClick:(UIButton *)button{
    XXEFriendMyCircleViewController *myCircleVc = [[XXEFriendMyCircleViewController alloc] init];
    myCircleVc.otherXid = self.showUserInfo.userId;
    myCircleVc.friendCirccleRefreshBlock = ^(){
    };
    myCircleVc.rootChat = @"my";
    [self.navigationController pushViewController:myCircleVc animated:YES];
//        ViewController *viewVC = [[ViewController alloc]init];
//        [self.navigationController pushViewController:viewVC animated:YES
//         ];

}

- (void)blackButtonClick:(UIButton *)button{

        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定将好友加入黑名单？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    
        UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //加入 黑名单
            [self addToBlackList];
        }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    

}

- (void)addToBlackList{
    /*
     【黑名单--拉黑(融云也拉黑)】
     接口类型:2
     接口:
     http://www.xingxingedu.cn/Global/user_add_black
     传参:
     other_xid	//对方xid (家人,班级通讯录,陌生人都可以拉黑)
     */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/user_add_black";
    
    //请求参数
    NSString *otherXid = self.showUserInfo.userId;
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"other_xid":otherXid};
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            [SVProgressHUD showInfoWithStatus:@"拉黑成功!"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else if ([codeStr isEqualToString:@"4"]) {
            [SVProgressHUD showInfoWithStatus:@"此人已在黑名单中!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [SVProgressHUD showInfoWithStatus:@"拉黑失败!"];
        }
        
    } failure:^(NSError *error) {
        //
        [SVProgressHUD showInfoWithStatus:@"数据请求失败!"];
    }];
}


- (void)reportButtonClick:(UIButton *)button{

    ReportPicViewController * vc=[[ReportPicViewController alloc]init];
    vc.other_xidStr = self.showUserInfo.userId;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)deleteButtonClick:(UIButton *)button{

        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定删除好友？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    
        UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //删除 好友
            [self deleteFriend];
        }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];

}

- (void)deleteFriend{
    /*
     【聊天--删除好友】
     接口类型:2
     接口:
     http://www.xingxingedu.cn/Global/delete_friend
     传参:
     other_xid	//好友xid
     */
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/delete_friend";
    
    //请求参数
    NSString *otherXid = self.showUserInfo.userId;
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"other_xid":otherXid};
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            [SVProgressHUD showInfoWithStatus:@"删除成功!"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [SVProgressHUD showInfoWithStatus:@"删除失败!"];
        }
        
    } failure:^(NSError *error) {
        //
        [SVProgressHUD showInfoWithStatus:@"数据请求失败!"];
    }];

    
}



@end

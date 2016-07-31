





//
//  WZYRCAddFriendDetialInfoViewController.m
//  XingXingEdu
//
//  Created by Mac on 16/7/15.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "WZYRCAddFriendDetialInfoViewController.h"

@interface WZYRCAddFriendDetialInfoViewController ()

@end

@implementation WZYRCAddFriendDetialInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    
    [self settingContent];
    
}


- (void)settingContent{

    _iconImageView.layer.cornerRadius = 40;
    _iconImageView.layer.masksToBounds = YES;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_iconStr] placeholderImage:[UIImage imageNamed:@"人物头像172x172"]];
    
    _nicknameLabel.text = _nicknameStr;

    [_addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)addButtonClick{
/*
 【聊天--发起添加好友请求】
 
 接口:
 http://www.xingxingedu.cn/Global/action_friend_request
 
 传参:
	other_xid	//对方xid  (测试可用xid: 18886390,18886391,18886393(允许任何人通过),18886378(已是好友),18886177(在对方黑名单中))
 
 返回值案例:
 
 Array
 (
 [code] => 1
 [msg] => Success!
 [data] => 请求成功,等待对方同意!
 )
 
 ★其他结果需提醒用户
 code:4	//不能请求自己
 code:5	//已经是好友了(不能对好友发起请求)
 code:6	//对方在我的黑名单中,无法发起请求!
 code:7	//您已经在对方黑名单中,无法发起请求!
 code:8	//不能重复对同一个人发起请求!
 code:9	//对方已同意,可以直接聊天了 (对方设置了任何人请求直接通过)
 */
//    NSLog(@"添加到联系人");
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/action_friend_request";
    
    //请求参数  无
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":XID, @"user_id":USER_ID, @"user_type":USER_TYPE, @"other_xid":_xidStr};

//    NSLog(@"%@", params);
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
//        NSLog(@"搜索 人  返回值%@", responseObj);
        
        NSString *str = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
        
        if ([str isEqualToString:@"1"]) {
            
            [SVProgressHUD showInfoWithStatus:@"请求成功,等待对方同意!"];
            
        }else if ([str isEqualToString:@"4"]) {
            [SVProgressHUD showInfoWithStatus:@"不能请求自己!"];
            
        }else if ([str isEqualToString:@"5"]){
        
            [SVProgressHUD showInfoWithStatus:@"已经是好友了(不能对好友发起请求)!"];
            
        }else if ([str isEqualToString:@"6"]){
            
            [SVProgressHUD showInfoWithStatus:@"对方在我的黑名单中,无法发起请求!"];
            
        }else if ([str isEqualToString:@"7"]){
            
            [SVProgressHUD showInfoWithStatus:@"您已经在对方黑名单中,无法发起请求!"];
            
        }else if ([str isEqualToString:@"8"]){
            
            [SVProgressHUD showInfoWithStatus:@"不能重复对同一个人发起请求!"];
            
        }else if ([str isEqualToString:@"9"]){
            
            [SVProgressHUD showInfoWithStatus:@"对方已同意,可以直接聊天了!"];
            
        }
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];


}

@end

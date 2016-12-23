//
//  LookNearUserTableViewController.m
//  XingXingEdu
//
//  Created by codeDing on 16/5/16.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "LookNearUserTableViewController.h"
#import "FriendCell.h"
@interface LookNearUserTableViewController (){
    NSMutableArray *userArray;
    
    NSInteger page;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@end

@implementation LookNearUserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    page = 0;
    
    
    [self fetchNetData];
    
    UINib *nib = [UINib nibWithNibName:@"FriendCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
}

- (void)fetchNetData{
    /*
     【聊天--附近用户列表】
     
     接口:
     http://www.xingxingedu.cn/Global/search_nearby_user
     
     传参:
     page	//页码,用于加载,不传值系统默认1
     */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/search_nearby_user";

    NSString *pageStr = [NSString stringWithFormat:@"%ld", page];
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE ,@"page":pageStr};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        
        userArray = [[NSMutableArray alloc] init];
        
//            NSLog(@"5555555555%@", responseObj);
        /*
         {
         distance = 0,
         id = 1,
         nickname = 伟,
         head_img_type = 0,
         xid = 18884982,
         sex = 男,
         head_img = app_upload/head_img/2016/06/22/20160622132859_6950.png
         }
         */
        
        //@[@"teacher1.jpg",@"张三",@"男",@"1.2km"]
        
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
                
                NSArray *itemArray = [[NSArray alloc] init];
                
                itemArray = @[head_img, dic[@"nickname"], dic[@"sex"], dic[@"distance"], dic[@"id"], dic[@"xid"]];
                
                [userArray addObject:itemArray];
                
            }
        }else{
            
            
        }
        
        [self.tableView  reloadData];
        
    } failure:^(NSError *error) {
        //
        
        NSLog(@"%@", error);
    }];
    
    
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return userArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil){
        cell=[[FriendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }    
    
    NSArray * tmp=userArray[indexPath.row];
    
    //头像
    [cell.portraitImageView sd_setImageWithURL:[NSURL URLWithString:tmp[0]] placeholderImage:[UIImage imageNamed:@"人物头像172x172"]];
    //    cell.portraitImageView.image=[UIImage imageNamed:tmp[0]];
    
    cell.portraitImageView.layer.cornerRadius = cell.portraitImageView.size.width / 2;
    cell.portraitImageView.layer.masksToBounds = YES;
    
    //昵称
    cell.userNameLabel.text=tmp[1];
    
    //性别
    cell.sexLabel.text=tmp[2];
    
    //距离
    cell.QQLabel.text= [NSString stringWithFormat:@"%@km", tmp[3]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"添加好友" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {

        textField.placeholder=@"申请备注";
    }];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self requestAddFriend:indexPath];

    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];

}


- (void)requestAddFriend:(NSIndexPath *)path{
    /*
     【聊天--发起添加好友请求】
     接口类型:2
     接口:
     http://www.xingxingedu.cn/Global/action_friend_request
     传参:
     other_xid	//对方xid  (测试可用xid: 18886390,18886391,18886393(允许任何人通过),18886378(已是好友),18886177(在对方黑名单中))
     */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/action_friend_request";
    NSArray * tmp=userArray[path.row];
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"other_xid":tmp[5]};
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //        NSLog(@"%@", responseObj);
        /*
         ★其他结果需提醒用户
         code:4	//不能请求自己
         code:5	//已经是好友了(不能对好友发起请求)
         code:6	//对方在我的黑名单中,无法发起请求!
         code:7	//您已经在对方黑名单中,无法发起请求!
         code:8	//不能重复对同一个人发起请求!
         code:9	//对方已同意,可以直接聊天了 (对方设置了任何人请求直接通过)
         */
        
        NSString *codeStr = [NSString stringWithFormat:@"%@",responseObj[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            [SVProgressHUD showSuccessWithStatus:@"请求发送成功!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else if ([codeStr isEqualToString:@"4"]) {
            [SVProgressHUD showInfoWithStatus:@"不能请求自己!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else if ([codeStr isEqualToString:@"5"]) {
            [SVProgressHUD showInfoWithStatus:@"对方已经是您的好友!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else if ([codeStr isEqualToString:@"6"]) {
            [SVProgressHUD showInfoWithStatus:@"对方在您的黑名单中,无法发起请求!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else if ([codeStr isEqualToString:@"7"]) {
            [SVProgressHUD showInfoWithStatus:@"您已经在对方黑名单中,无法发起请求!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else if ([codeStr isEqualToString:@"8"]) {
            [SVProgressHUD showInfoWithStatus:@"不能重复对同一个人发起请求!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else if ([codeStr isEqualToString:@"9"]) {
            [SVProgressHUD showInfoWithStatus:@"对方已同意,可以直接聊天了!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [SVProgressHUD showErrorWithStatus:@"请求发送失败!"];
        }

    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
        [SVProgressHUD showErrorWithStatus:@"获取数据失败!"];
    }];


}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


@end

//
//  MyHeadViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/1/31.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "MyHeadViewController.h"
#import "MyInfomationViewController.h"
#import "HHControl.h"
#import "XXEFriendMyCircleViewController.h"
#import "ClassRoomOrderViewController.h"
#import "HFStretchableTableHeaderView.h"
#import "SaveInfoViewController.h"
#import "PWRViewController.h"
#import "MyHeadInfoCell.h"
#import "RcRootTabbarViewController.h"
//黑名单
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "PrivacySettingViewController.h"
#import "MyBlackListViewController.h"
#import "shezhiViewController.h"
#import "MainViewController.h"
#import "FriendsListViewController.h"
#import "WMConversationListViewController.h"
@interface MyHeadViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UIImageView *icon;
    UITableView *_tableView;
    //
    
    NSMutableArray *titleArray;
    //
    NSArray *headArr;
    //
    NSDictionary *myselfInfoDict;
    
    //
    UIImageView *imageView;
    //用户名
    UILabel *nameLbl;
    
    //等级
    UILabel *lvLabel;
    //添加性别
    UIImageView *manimage;
    //文字
    UILabel *titleLbl;
    
    YSProgressView *ysView;
    CGFloat imageViewBottom;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
}
@end
//
@implementation MyHeadViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0, 170, 42)];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self loadNewData];

}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden =NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    headArr =[NSArray arrayWithObjects:@"我的资料40x40",@"我的订单40x48",@"我的好友40x44",@"我的聊天40x40",@"我的收藏40x40",@"我的圈子40x40",@"我的黑名单40x40",@"系统设置40x40",@"隐私设置40x40",nil];
    
    titleArray = [NSMutableArray arrayWithObjects:@"我的资料",@"我的订单",@"我的好友",@"我的聊天",@"我的收藏",@"我的圈子",@"我的黑名单",@"系统设置",@"隐私设置",nil];
    myselfInfoDict = [[NSDictionary alloc] init];

//    NSLog(@"数据库 存储的电话:%@", [XXEUserInfo user].account);

    [self createContent];

    [self createTableView];
}

- (void)createContent{
    imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 150 * kWidth / 375)];
    imageView.image = [UIImage imageNamed:@"banner"];
    imageView.userInteractionEnabled =YES;
    [self.view addSubview:imageView];

    nameLbl =[HHControl createLabelWithFrame:CGRectMake(150 * kWidth / 375, 42 * kWidth / 375, 150 * kWidth / 375, 20 * kWidth / 375 ) Font:18 * kWidth / 375 Text:@""];
    nameLbl.textColor =UIColorFromRGB(255, 255, 255);
    [imageView addSubview:nameLbl];
    
    
    // 等级
    lvLabel = [HHControl createLabelWithFrame:CGRectMake(250 * kWidth / 375, 43 * kWidth / 375, 40 * kWidth / 375, 18 * kWidth / 375) Font:12 * kWidth / 375 Text:@""];
    lvLabel.textColor = UIColorFromRGB(3, 169, 244);
    lvLabel.textAlignment = NSTextAlignmentCenter;
    lvLabel.backgroundColor = [UIColor whiteColor];
    lvLabel.layer.cornerRadius = 5;
    lvLabel.layer.masksToBounds = YES;
    [imageView addSubview:lvLabel];
    
    icon = [[UIImageView alloc] initWithFrame:CGRectMake(30 * kWidth / 375, 30 * kWidth / 375, 100 * kWidth / 375,100 * kWidth / 375)];
    
    icon.layer.cornerRadius =50 * kWidth / 375;
    icon.layer.masksToBounds =YES;
    [imageView addSubview:icon];
    icon.userInteractionEnabled =YES;
    manimage = [[UIImageView alloc]initWithFrame:CGRectMake(40 * kWidth / 375, 75 * kWidth / 375, 20 * kWidth / 375, 20 * kWidth / 375)];
    [icon addSubview:manimage];
    
    titleLbl =[HHControl createLabelWithFrame:CGRectMake(150 * kWidth / 375, 80 * kWidth / 375, 220 * kWidth / 375, 20 * kWidth / 375) Font:14 * kWidth / 375 Text:@""];
    titleLbl.textColor =UIColorFromRGB(255, 255, 255);
    titleLbl.numberOfLines =0;
    [imageView addSubview:titleLbl];
    
    //滚动条
    ysView = [[YSProgressView alloc] initWithFrame:CGRectMake(150 * kWidth / 375, 120 * kWidth / 375, 200 * kWidth / 375, 10 * kWidth / 375)];
    ysView.progressHeight = 2;
    ysView.progressTintColor = [UIColor colorWithRed:0.0 / 255 green:0.0 / 255 blue:0.0 / 255 alpha:0.5];
    ysView.trackTintColor = [UIColor whiteColor];
    
    
    [imageView addSubview:ysView];

}

- (void)loadNewData{

   NSString * urlStr = @"http://www.xingxingedu.cn/Parent/my_personal_center";
//    NSLog(@"xid %@ ----  user_id  %@", parameterXid, parameterUser_Id);
    
    NSDictionary *pragm = @{   @"appkey":APPKEY,
                               @"backtype":BACKTYPE,
                               @"xid":parameterXid,
                               @"user_id":parameterUser_Id,
                               @"user_type":USER_TYPE,
                               };
//    NSLog(@"pragm == %@", pragm);
    [WZYHttpTool post:urlStr params:pragm success:^(id responseObj) {
//        NSLog(@"responseObj **** %@", responseObj);
        if([[NSString stringWithFormat:@"%@",responseObj[@"code"]]isEqualToString:@"1"] )
        {
            myselfInfoDict = responseObj[@"data"];
            
        }
        //更新 数据
        [self updateHeaderInfo];
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@", error);
        [SVProgressHUD showErrorWithStatus:@"获取数据失败!"];
        
    }];

}
- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 150 * kWidth / 375 + 64, kWidth, kHeight - 150 * kWidth / 375 - 70) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    [self.view addSubview:_tableView];

}

- (void)updateHeaderInfo{
    //姓名
    nameLbl.text = myselfInfoDict[@"nickname"];
    //等级
    lvLabel.text = [NSString stringWithFormat:@"LV%@", myselfInfoDict[@"lv"]];
    //头像
    /*
     0 :表示 自己 头像 ，需要添加 前缀
     1 :表示 第三方 头像 ，不需要 添加 前缀
     //判断是否是第三方头像
     */
    NSString *headImage;
    if ([myselfInfoDict[@"head_img_type"] integerValue] == 0) {
        headImage = [NSString stringWithFormat:@"%@%@", picURL, myselfInfoDict[@"head_img"]];
    }else if ([myselfInfoDict[@"head_img_type"] integerValue] ==1){
        headImage = [NSString stringWithFormat:@"%@", myselfInfoDict[@"head_img"]];
    }
    
    [icon sd_setImageWithURL:[NSURL URLWithString:headImage] placeholderImage:[UIImage imageNamed:@"人物头像172x172"]];
    //性别  sex 男/女
    if ([myselfInfoDict[@"sex"] isEqualToString:@"男"]) {
        manimage.image = [UIImage imageNamed:@"男"];
    }else if ([myselfInfoDict[@"sex"] isEqualToString:@"女"]){
        manimage.image = [UIImage imageNamed:@"女"];
    }

    //文字
    titleLbl.text = [NSString stringWithFormat:@"还差%ld星币升级到%ld级会员",[myselfInfoDict[@"coin_total"] integerValue]-[myselfInfoDict[@"next_grade_coin"] integerValue], [myselfInfoDict[@"lv"] integerValue]+1];
    
    //滚动条
    float b =  [myselfInfoDict[@"coin_total"] floatValue]/[myselfInfoDict[@"next_grade_coin"] floatValue];
    ysView.progressValue = b * ysView.frame.size.width;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 43;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [headArr count];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
       static  NSString *cellID=@"cellID";
    MyHeadInfoCell *cell =(MyHeadInfoCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        NSArray *nib =[[NSBundle mainBundle]loadNibNamed:@"MyHeadInfoCell" owner:[MyHeadInfoCell class] options:nil];
        cell =(MyHeadInfoCell*)[nib objectAtIndex:0];
    }
      cell.nameLbl.text = titleArray[indexPath.row];
      cell.headImagV.image = [UIImage imageNamed:headArr[indexPath.row]];
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.000001;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([XXEUserInfo user].login) {
        // 0@"我的资料",1@"我的订单",2@"我的收藏",3@"我的好友",4@"我的聊天",5@"我的圈子",@"我的黑名单"
        if (indexPath.row ==0) {
            //我的资料
            MyInfomationViewController *myInfomationVC =[[MyInfomationViewController alloc]init];
            myInfomationVC.hidesBottomBarWhenPushed =YES;
            myInfomationVC.lvString = [NSString stringWithFormat:@"LV%@",myselfInfoDict[@"lv"]];
            [self.navigationController pushViewController:myInfomationVC animated:YES];
            
        }
        else if (indexPath.row ==1){
            //我的订单
            ClassRoomOrderViewController *classRoomVC =[[ClassRoomOrderViewController alloc]init];
            classRoomVC.hidesBottomBarWhenPushed =YES;
            [self.navigationController pushViewController:classRoomVC animated:YES];
            
        }
        else if (indexPath.row ==2){
            //我的好友
            FriendsListViewController *rcRootVC =[[FriendsListViewController alloc]init];
            rcRootVC.hidesBottomBarWhenPushed =YES;
            [self.navigationController pushViewController:rcRootVC animated:YES];
            
            
        }
        else if (indexPath.row ==3){
            // 我的聊天
            WMConversationListViewController *rcRootVC =[[WMConversationListViewController alloc]init];
            rcRootVC.hidesBottomBarWhenPushed =YES;
            rcRootVC.isShowNetworkIndicatorView =NO;
            [self.navigationController pushViewController:rcRootVC animated:YES];
            
            
        }
        else if (indexPath.row ==4){
            //收藏
            
            MainViewController *mainVC =[[MainViewController alloc]init];
            mainVC.hidesBottomBarWhenPushed =YES;
            [self.navigationController pushViewController:mainVC animated:YES];
            
            
        }
        else if (indexPath.row ==5){
            //我的圈子
            XXEFriendMyCircleViewController *viewVC = [XXEFriendMyCircleViewController new];
            viewVC.otherXid = parameterXid;
            viewVC.rootChat = @"my";
            viewVC.hidesBottomBarWhenPushed =YES;
            [self.navigationController pushViewController:viewVC animated:NO];
            
        }
        else if (indexPath.row ==6){
            //我的黑名单
            MyBlackListViewController *myblacklistVC =[[MyBlackListViewController alloc]init];
            myblacklistVC.hidesBottomBarWhenPushed =YES;
            [self.navigationController pushViewController:myblacklistVC animated:YES];
            
        }
        else if (indexPath.row ==7){
            //系统设置
            shezhiViewController *myblacklistVC =[[shezhiViewController alloc]init];
            myblacklistVC.hidesBottomBarWhenPushed =YES;
            [self.navigationController pushViewController:myblacklistVC animated:YES];
            
        }
        else if (indexPath.row ==8){
            //隐私设置
            PrivacySettingViewController *myblacklistVC =[[PrivacySettingViewController alloc]init];
            myblacklistVC.hidesBottomBarWhenPushed =YES;
            [self.navigationController pushViewController:myblacklistVC animated:YES];
            
        }
        else{
            
            
        }
  
        
    }else{
        [SVProgressHUD showInfoWithStatus:@"请用账号登录后查看"];
    }
    
    
}




@end

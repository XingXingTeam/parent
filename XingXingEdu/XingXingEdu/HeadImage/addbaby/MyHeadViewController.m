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
     UIImageView *headPortraitView;
    UITableView *_tableView;
    NSMutableArray *dataArray;
    NSMutableArray *detailArray;
    UIImageView *imageView;
    NSArray *headArr;
    NSString *urlStr;
    NSString *coin_total;
    NSString *head_img;
    NSString *lv;
    NSString *next_grade_coin;
    NSString *nickname;
    NSString *head_img_type;
    
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
    
    dataArray = [[NSMutableArray alloc]init];
    detailArray = [[NSMutableArray alloc]init];
    headArr =[NSArray arrayWithObjects:@"我的资料40x40",@"我的订单40x48",@"我的好友40x44",@"我的聊天40x40",@"我的收藏40x40",@"我的圈子40x40",@"我的黑名单40x40",@"系统设置40x40",@"隐私设置40x40",nil];
    [dataArray addObject:headArr];
    
    NSArray *arr = [NSArray arrayWithObjects:@"我的资料",@"我的订单",@"我的好友",@"我的聊天",@"我的收藏",@"我的圈子",@"我的黑名单",@"系统设置",@"隐私设置",nil];
    
    [dataArray addObject:arr];
    
    
//    NSLog(@"999999999");
    
    imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 150 * kWidth / 375)];
    imageView.image = [UIImage imageNamed:@"banner"];
    //    _tableView.tableHeaderView =imageView;
    imageView.userInteractionEnabled =YES;
    [self.view addSubview:imageView];
    
    imageViewBottom = imageView.frame.origin.y + imageView.frame.size.height;
    
    
    [self createTableView];

}
- (void)loadNewData{

    urlStr = @"http://www.xingxingedu.cn/Parent/my_personal_center";
//    NSLog(@"xid %@ ----  user_id  %@", parameterXid, parameterUser_Id);
    
    NSDictionary *pragm = @{   @"appkey":APPKEY,
                               @"backtype":BACKTYPE,
                               @"xid":parameterXid,
                               @"user_id":parameterUser_Id,
                               @"user_type":USER_TYPE,
                               };
    
    
    [WZYHttpTool post:urlStr params:pragm success:^(id responseObj) {

        
        if([[NSString stringWithFormat:@"%@",responseObj[@"code"]]isEqualToString:@"1"] )
        {
            
            NSDictionary *dict =responseObj[@"data"];

            coin_total = dict[@"coin_total"];

            //head_img_type] => 0	//关系人头像类型,0代表用户上传的头像,1代表第三方头像,区别在于url头部
          
            if([[NSString stringWithFormat:@"%@",dict[@"head_img_type"]]isEqualToString:@"0"]){
                head_img=[picURL stringByAppendingString:dict[@"head_img"]];
            }else{
                head_img=dict[@"head_img"];
            }

            lv = dict[@"lv"];
            next_grade_coin = dict[@"next_grade_coin"];
            nickname = dict[@"nickname"];
            
        }
        [self initUI];
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@", error);
        [SVProgressHUD showWithStatus:@"获取数据失败!"];
        
    }];

}
- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, imageViewBottom, kWidth, kHeight - imageViewBottom) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    [self.view addSubview:_tableView];

}
- (void)initUI{

    //用户名
    UILabel *nameLbl =[HHControl createLabelWithFrame:CGRectMake(150 * kWidth / 375, 42 * kWidth / 375, 150 * kWidth / 375, 20 * kWidth / 375 ) Font:18 * kWidth / 375 Text:nickname];
    nameLbl.textColor =UIColorFromRGB(255, 255, 255);
    [imageView addSubview:nameLbl];
    
    
    // 等级
    NSString *lvString = [NSString stringWithFormat:@"LV%@", lv];
    UILabel *lvLabel = [HHControl createLabelWithFrame:CGRectMake(250 * kWidth / 375, 43 * kWidth / 375, 40 * kWidth / 375, 18 * kWidth / 375) Font:12 * kWidth / 375 Text:lvString];
    lvLabel.textColor = UIColorFromRGB(3, 169, 244);
    lvLabel.textAlignment = NSTextAlignmentCenter;
    lvLabel.backgroundColor = [UIColor whiteColor];
    lvLabel.layer.cornerRadius = 5;
    lvLabel.layer.masksToBounds = YES;
    [imageView addSubview:lvLabel];
    
    icon = [[UIImageView alloc] initWithFrame:CGRectMake(30 * kWidth / 375, 30 * kWidth / 375, 100 * kWidth / 375,100 * kWidth / 375)];
//    NSLog(@"11  aaaaa  -- %@", head_img);
    
    [icon sd_setImageWithURL:[NSURL URLWithString:head_img] placeholderImage:[UIImage imageNamed:@"人物头像172x172"]];

    icon.layer.cornerRadius =50 * kWidth / 375;
    icon.layer.masksToBounds =YES;
    [imageView addSubview:icon];
    icon.userInteractionEnabled =YES;
    //添加性别
    UIImageView *manimage = [[UIImageView alloc]initWithFrame:CGRectMake(40 * kWidth / 375, 75 * kWidth / 375, 20 * kWidth / 375, 20 * kWidth / 375)];
    manimage.image = [UIImage imageNamed:@"man"];
    [icon addSubview:manimage];
    
    //文字
    UILabel *titleLbl =[HHControl createLabelWithFrame:CGRectMake(150 * kWidth / 375, 80 * kWidth / 375, 220 * kWidth / 375, 20 * kWidth / 375) Font:14 * kWidth / 375 Text:[NSString stringWithFormat:@"还差%ld星币升级到%ld级会员",[next_grade_coin integerValue]-[coin_total integerValue], [lv integerValue]+1]];
    titleLbl.textColor =UIColorFromRGB(255, 255, 255);
    titleLbl.numberOfLines =0;
    [imageView addSubview:titleLbl];
    
    //滚动条
    ysView = [[YSProgressView alloc] initWithFrame:CGRectMake(150 * kWidth / 375, 120 * kWidth / 375, 200 * kWidth / 375, 10 * kWidth / 375)];
    ysView.progressHeight = 2;
    ysView.progressTintColor = [UIColor colorWithRed:0.0 / 255 green:0.0 / 255 blue:0.0 / 255 alpha:0.5];
    ysView.trackTintColor = [UIColor whiteColor];
    float b =  [coin_total floatValue]/[next_grade_coin floatValue];
    ysView.progressValue = b * ysView.frame.size.width;
    
    [imageView addSubview:ysView];
    
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
      cell.nameLbl.text =dataArray[1][indexPath.row];
      cell.headImagV.image = [UIImage imageNamed:dataArray[0][indexPath.row]];
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
            myInfomationVC.lvString = [NSString stringWithFormat:@"LV%@", lv];
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

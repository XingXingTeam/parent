//
//  shezhiViewController.m
//  Homepage
//
//  Created by super on 16/1/19.
//  Copyright © 2016年 Edu. All rights reserved.
//
#define KPATA @"SettingCell"
#import "SettingCell.h"
#import "shezhiViewController.h"
#import "HHControl.h"
#import "feedbackViewController.h"
#import "aboutusViewController.h"
#import "LandingpageViewController.h"
#import "CoreUMeng.h"
#import "AboutMainViewController.h"
#import "ProbromBackViewController.h"
#import "FGGImageCacheCleaner.h"
#import "MBProgressHUD.h"
@interface shezhiViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *dataArr;
    UIImageView *background;
    UIButton *aboutusBtn;
    UIButton *hereBtn;
    MBProgressHUD *HUD;
    
}

@property (nonatomic,retain)UILabel *remindLabel;
@property (nonatomic,retain)UILabel *promptLabel;
@property (nonatomic,retain)UILabel *wifiLabel;

@property (nonatomic,retain)UISwitch *remSwitch;
@property (nonatomic,retain)UISwitch *promSwitch;
@property (nonatomic,retain)UISwitch *wifiSwitch;

//@property (nonatomic,retain)UIButton *consultBtn;
@property (nonatomic,retain)UIButton *appBtn;
@property (nonatomic,retain)UIButton *shareBtn;
@property (nonatomic,retain)UIButton *removeBtn;
@property (nonatomic,retain)UIButton *exitBtn;
@property (nonatomic,retain)UIButton *feedbackBtn;
//@property (nonatomic,retain)UIButton *aboutusBtn;
@property (nonatomic,retain) NSArray *files;
@end

@implementation shezhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"系统设置";
    //self.view.backgroundColor = UIColorFromRGB(245, 245, 245);
    [self createTableView];
}
- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;
     _tableView.separatorStyle =UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
    dataArr =[[NSMutableArray alloc]init];
    NSArray *arr =@[@"消息提醒",@"消息提醒音",@"非WIFI网络播放提醒",@"关于我们",@"分享",@"去app评分",@"清楚缓存",@"反馈问题送猩币"];
    [dataArr addObjectsFromArray:arr];

}
- (void)passWord{




}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArr.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingCell *cell =(SettingCell*)[tableView dequeueReusableCellWithIdentifier:KPATA];
    if (!cell) {
        NSArray *nib =[[NSBundle mainBundle] loadNibNamed:KPATA owner:[SettingCell class] options:nil];
        cell =(SettingCell*)[nib objectAtIndex:0];
    }
  
    if (indexPath.row>2) {
        cell.switchBtn.hidden =YES;
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
      cell.titleLbl.text =dataArr[indexPath.row];
    }
    else if (indexPath.row<=2){
          cell.accessoryType =UITableViewCellAccessoryNone;
         cell.titleLbl.text =dataArr[indexPath.row];
    }
  
  
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.row);
    [self  performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
    switch (indexPath.row) {
        case 0:
        {
        
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            NSLog(@"关于我们");
            AboutMainViewController *aboutMainVC =[[AboutMainViewController alloc]init];
            [self.navigationController pushViewController:aboutMainVC animated:YES];
            
        }
            break;
        case 4:
        {
             NSLog(@"分享");
         [CoreUmengShare show:self text:@"为了孩子的未来,这里有你想要的一切,快点点击下载吧！https://itunes.apple.com/cn/app/jie-dian-qian-zhuan-ye-ban/id1112373854?mt=8&v0=WWW-GCCN-ITSTOP100-FREEAPPS&l=&ign-mpt=uo%3D4" image:[UIImage imageNamed:@"猩猩教室.png"]];
            
            
            
        }
            break;
        case 5:
        {
              NSLog(@"去app评分");
        }
            break;
        case 6:
        {
              NSLog(@"清楚缓存");
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"清空缓存数据" message:@"确认清空猩猩教室本地的缓存数据?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag=2;
            [alert show];
            
        }
            break;
        case 7:
        {
              NSLog(@"反馈问题送猩币");
            ProbromBackViewController *probromBackVC =[[ProbromBackViewController alloc]init];
            [self.navigationController pushViewController:probromBackVC animated:YES];
        }
            break;
        default:
            break;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        if (alertView.tag==2) {
        
            HUD =[[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:HUD];
            
            HUD.dimBackground =YES;
            HUD.labelText =@"正在清除缓存中...";
            [HUD showAnimated:YES whileExecutingBlock:^{
                
            [[FGGImageCacheCleaner currentCleaner] clearImageCache];
                sleep(2);
                HUD.labelText =@"清除成功!";
            } completionBlock:^{
                [HUD removeFromSuperview];
                HUD =nil;
               
            }];
            
        }
    }

}
- (void)deselect{

    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////创建摁钮
//-(void)createButton
//{
////    //咨询客服摁钮
////    UIButton *consultBtn=[HHControl createButtonWithFrame:CGRectMake(150, 80, 100, 30) backGruondImageName:nil Target:self Action:@selector(onclickconsult:) Title:@"咨询客服"];
////    [consultBtn setBackgroundColor: [UIColor colorWithWhite:(255,255,255) alpha:1]];
////    consultBtn.userInteractionEnabled = YES;
////    [self.view addSubview:consultBtn];
//    
//    //去APP评分摁钮
//    UIButton *appBtn = [HHControl createButtonWithFrame:CGRectMake(8, 300, 100, 100) backGruondImageName:nil Target:self Action:@selector(onClickapp:) Title:@"去app评分"];
//        appBtn.userInteractionEnabled = YES;
//    [self.view addSubview:appBtn];
//    
//    //关于我们
//    aboutusBtn =[HHControl createButtonWithFrame:CGRectMake(5, 50, 100, 100) backGruondImageName:nil Target:self Action:@selector(onClickaboutus:) Title:@"关于我们"];
//        aboutusBtn.userInteractionEnabled = YES;
//    [self.view addSubview:aboutusBtn];
//
//    
//    //分享摁钮
//    UIButton *shareBtn = [HHControl createButtonWithFrame:CGRectMake(7, 280, 100 , 50) backGruondImageName:nil Target:self Action:@selector(onclickshare:) Title:@"分享           "];
//        shareBtn.userInteractionEnabled = YES;
//    [self.view addSubview:shareBtn];
//    
//    //清除缓存摁钮
//    UIButton *removeBtn = [HHControl createButtonWithFrame:CGRectMake(7, 380, 100, 50) backGruondImageName:nil Target:self Action:@selector(onClickremove:) Title:@"清除缓存  "];
//  
////    removeBtn.backgroundColor = [UIColor yellowColor];
//   
//
//    
//      removeBtn.userInteractionEnabled = YES;
//    [self.view addSubview:removeBtn];
//    
//    
//    
//    //退出登录摁钮
//    UIButton *exitBtn = [HHControl createButtonWithFrame:CGRectMake(10, 450, 100, 100) backGruondImageName:nil Target:self Action:@selector(onClickexit:) Title:@"退出登录  "];
//        exitBtn.userInteractionEnabled = YES;
//    [self.view addSubview:exitBtn];
//    
////    //反馈问题摁钮
////    UIButton *feedbackBtn = [HHControl createButtonWithFrame:CGRectMake(6, 430, 100, 50) backGruondImageName:nil Target:self Action:@selector(feedbackBtn:) Title:@"反馈问题"];
////    [feedbackBtn setTitle:@"反馈问题" forState:UIControlStateNormal];
////    [feedbackBtn setTitle:@"猩猩教室" forState:UIControlStateHighlighted];
////    feedbackBtn.userInteractionEnabled = YES;
////    [self.view addSubview:feedbackBtn];
//    //点击这里
//    hereBtn = [HHControl createButtonWithFrame:CGRectMake(6, 430, 150,50) backGruondImageName:@"123" Target:self Action:@selector(onclickhere:) Title:@"反馈问题送猩币"];
//    hereBtn.userInteractionEnabled = YES;
//    [self.view addSubview:hereBtn];
//    
//}
//-(void)onclickhere:(UIButton *)Btn
//{
//    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"新用户回馈" message:@"尊敬的用户：给您带来极致便利的用户体验是猩猩教室的至高目标。为了持续不断的接近这一目标，我们高度重视收集您在使用过程中遇到的问题或者建议。感谢您将自己所遇见的问题或者意见反馈给我们。您的反馈被采纳后，我们将赠送您500猩币。" delegate:self cancelButtonTitle:@"去反馈问题" otherButtonTitles: nil];
//    myAlertView.tag = 1;
//    [myAlertView show];
//    
//
//}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (alertView.tag == 1) {
//       feedbackViewController *forVC = [[feedbackViewController alloc]init];
//        [self.navigationController pushViewController:forVC animated:YES];
//    }
//}
////APP分享
//- (void)onClickapp:(UIButton*)Btn
//{
//    
//}
////分享
//-(void) onclickshare:(UIButton*)Btn
//{
//     [CoreUmengShare show:self text:@"猩猩教室" image:[UIImage imageNamed:@"store2.jpg"]];
//}
////清除缓存
//-(void)onClickremove:(UIButton*)Btn
//{
//   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//       NSString*cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)objectAtIndex:0];
//       NSArray *files =[[NSFileManager defaultManager]subpathsAtPath:cachPath];
//       NSLog(@"files:%ld",[files count]);
//       for (NSString *p in files ) {
//           NSError *error;
//           NSString *path = [cachPath stringByAppendingPathComponent:p];
//           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
//               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
//           }
//       }
////       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
//   });
//    NSLog(@"清理成功");
//    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"清除成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//    
//    [myAlertView show];
//
//}
//
//
//
//
////退出登录按钮
//-(void)onClickexit:(UIButton*)Btn
//{
//    LandingpageViewController*forVC= [[LandingpageViewController alloc]init];
//    [self.navigationController pushViewController:forVC animated:YES];
//}
////关于我们
//-(void)onClickaboutus:(UIButton*)Btn
//{
//  
//    aboutusViewController * forVC = [[aboutusViewController alloc]init];
//    [self.navigationController pushViewController:forVC animated:YES];
//}
//
//
//
//////反馈
////-(void)feedbackBtn:(UIButton*)Btn
////{
////    
////
////    feedbackViewController * forVC=[[feedbackViewController alloc]init];
////    [self.navigationController pushViewController:forVC animated:YES];
////}
//
//-(void)createSwitch
//{
//    //消息提醒Switch
//    UISwitch *remSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(300, 135, 100, 100)];
//    remSwitch.on =NO;
//    [self.view addSubview:remSwitch];
//    [remSwitch addTarget:self action:@selector(remSwitch:) forControlEvents:UIControlEventValueChanged];
//    
//    //消息提醒音Switch
//    UISwitch *promSwith = [[UISwitch alloc]initWithFrame:CGRectMake(300, 185, 100, 100)];
//    promSwith.on = NO;
//    [self.view addSubview:promSwith];
//    [remSwitch addTarget:self action:@selector(promSwitch:) forControlEvents:UIControlEventValueChanged];
//    
//    //非Wi-Fi网络播放提醒Switch
//    UISwitch *wifiSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(300, 235, 100, 100)];
//    wifiSwitch.on = NO;
//    [remSwitch addTarget:self action:@selector(wifiSwitch:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:wifiSwitch];
//
//    
//    
////    UIButton *exitBtn = [HHControl createButtonWithFrame:CGRectMake(10, 400, 100, 100) backGruondImageName:nil Target:self Action:@selector(onClickexit:) Title:@"退出登录"];
////    exitBtn.userInteractionEnabled = YES;
////    [self.view addSubview:exitBtn];
//
//
//}
//
////Switch
//- (void)remSwitch:(UISwitch*)sende{
//    if (sende.isOn) {
//        NSLog(@"关闭提醒");
//    }
//    else{
//        NSLog(@"打开提醒");
//    }
//}
//-(void)promSwitch:(UISwitch *)sender{
//    if (sender.isOn) {
//        NSLog(@"提醒音打开");
//        
//    }
//    else{
//        NSLog(@"提醒音关闭");
//    }
//}
//-(void)wifiSwitch:(UISwitch *)sen{
//    if (sen.isOn) {
//        NSLog(@"wifi提醒关掉");
//    }
//    else{
//        NSLog(@"Wi-Fi提醒打开");
//    }
//}
//-(void)createTextView
//{
//    feedbackTextView =[[UITextView alloc]initWithFrame:CGRectMake(100, 490, 250, 150)];
//    
//   [consultBtn setBackgroundColor: [UIColor colorWithWhite:(255,255,255) alpha:1]];
//    [self.view addSubview:feedbackTextView];
//}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//+(UILabel *)createLabelWithFrame:(CGRect )frame Font:(int)font Text:(NSString *)text;

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.0000000000001;

}



@end

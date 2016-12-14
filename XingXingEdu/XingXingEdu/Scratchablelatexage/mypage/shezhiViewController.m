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
#import "LandingpageViewController.h"
#import "CoreUMeng.h"
//关于我们
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
    self.view.backgroundColor = UIColorFromRGB(229 , 232, 233);
    
    dataArr =[[NSMutableArray alloc]init];
    NSArray *arr =@[@"消息提醒",@"消息提醒音",@"非WIFI网络播放提醒",@"关于我们",@"分享",@"去app评分",@"清楚缓存",@"反馈问题送猩币"];
    [dataArr addObjectsFromArray:arr];
    
    [self createTableView];
    
    
}
- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;
//     _tableView.separatorStyle =UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
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
        //@"消息提醒"
            
        }
            break;
        case 1:
        {
            //@"消息提醒音"
            
        }
            break;
        case 2:
        {
          //@"非WIFI网络播放提醒"
            
        }
            break;
        case 3:
        {
//            NSLog(@"关于我们");
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
//              NSLog(@"清除缓存");
            [self createAlertView];
            
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

- (void)createAlertView{
    //清除缓存计算缓存大小
    // 获取要清除缓存的路径
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    // 调用folderSizeAtPath方法计算缓存路径下的文件size
    CGFloat fileSize = [self folderSizeAtPath:cachPath];
    NSString *str = [NSString stringWithFormat:@"缓存%.1fM", fileSize];
    //    NSLog(@"%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES));
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str message:@"确定清除数据缓存?"delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            //取消
            break;
            
        case 1:
        {
            [self clearCacheFlies];
            
        }
            break;
    }
}

//二、计算缓存cache文件夹下文件大小。
//单个文件的大小
- (CGFloat)fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if([manager fileExistsAtPath:filePath]){
        return[[manager attributesOfItemAtPath:filePath error:nil]fileSize];
    }
    return 0;
    
}


//遍历文件夹获得文件夹大小，返回多少M
- (float) folderSizeAtPath:(NSString*) folderPath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    if(![manager fileExistsAtPath:folderPath])
        return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString* fileName;
    
    long long folderSize =0;
    
    while((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);//得到缓存大小M
    
}

//一、清理缓存cache文件夹，删除文件方法
-(void)clearCacheFlies
{
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    //        NSLog(@"files :%ld",[files count]);
    for (NSString *p in files) {
        NSError *error;
        NSString *path = [cachPath stringByAppendingPathComponent:p];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            // 删除缓存
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
//        NSLog(@"清理成功！");
    }
    [SVProgressHUD showSuccessWithStatus:@"清除成功!"];
    
}



- (void)deselect{

    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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
//Switch
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


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.0000000000001;

}



@end

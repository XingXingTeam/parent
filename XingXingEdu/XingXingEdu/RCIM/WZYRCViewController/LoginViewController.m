//
//  LoginViewController.m
//  RCIM
//
//  Created by codeDing on 16/2/26.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "LoginViewController.h"
#import "RCUserInfo+Addition.h"
#import "AppDelegate.h"
#import "FriendCell.h"
#import "UIImageView+WebCache.h"
#import "RcRootTabbarViewController.h"

@interface LoginViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *dataSource;
}
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation LoginViewController

-(void)alreadyLogin:(NSNotification *)notice{
//    [self presentViewController:[AppDelegate shareAppDelegate].tabbarVC animated:YES completion:^{
//    }];
    
    NSLog(@"聊天界面 登录 成功!");
    
    [self.navigationController pushViewController:[AppDelegate shareAppDelegate].tabbarVC animated:YES];
//    [self.navigationController pushViewController:[RcRootTabbarViewController alloc] animated:YES];
}
-(void)initLoacalTestData{
    dataSource = [[NSMutableArray alloc]init];
    
    for (NSInteger i = 1; i<3; i++) {
        
        
        if(i==1){
//            RCUserInfo *aUserInfo =[[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"user%ld",i] name:@"user1" portrait:@"http://img0.pconline.com.cn/pconline/bizi/desktop/1506/Sm2.jpg" QQ:@"1" sex:@"男"];
//            [dataSource addObject:aUserInfo];
RCUserInfo *aUserInfo =[[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"user%ld",(long)i] name:@"user2" portrait:@"http://img0.pconline.com.cn/pconline/bizi/desktop/1506/Sm4.jpg" QQ:@"2" sex:@"女"];
                        [dataSource addObject:aUserInfo];
                    }

            
        }
//        else if (i==2) {
//            RCUserInfo *aUserInfo =[[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"user%ld",i] name:@"user2" portrait:@"http://img0.pconline.com.cn/pconline/bizi/desktop/1506/Sm4.jpg" QQ:@"2" sex:@"女"];
//            [dataSource addObject:aUserInfo];
//        }
//    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [[RCIM sharedRCIM] connectWithToken:MyRongCloudToken success:^(NSString *userId) {
//        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
//    } error:^(RCConnectErrorCode status) {
//        NSLog(@"登陆的错误码为:%ld", status);
//    } tokenIncorrect:^{
//        //token过期或者不正确。
//        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
//        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
//        NSLog(@"token错误");
//    }];

    [self initLoacalTestData];
    [self.table registerNib:[UINib nibWithNibName:@"FriendCell" bundle:nil] forCellReuseIdentifier:@"FriendCell"];
    self.title = @"登录";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alreadyLogin:) name:@"alreadyLogin" object:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 98;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendCell  *cell = (FriendCell *)[tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
    
    RCUserInfo *aUserInfo = dataSource[indexPath.row];
    [cell.portraitImageView sd_setImageWithURL:[NSURL URLWithString:aUserInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"DefaultHeader"]];
    cell.userNameLabel.text = aUserInfo.name;
    cell.QQLabel.text = aUserInfo.QQ;
    cell.sexLabel.text = aUserInfo.sex;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RCUserInfo *aUserInfo = dataSource[indexPath.row];
    NSString *token;
//    if([aUserInfo.userId isEqualToString:@"user1"]){
//        token = @"VxQZ2KOI2M5OZa87HWGujZQEwCVP7+PYbY08BpzgYl7HHOO/IsSIp5eI1a4k3Jwi55DL/6fJPJi0oxFIba7W5w==";
//    }else if ([aUserInfo.userId isEqualToString:@"user2"]) {
//        token = @"9plJfFcIxUnNdLNnL6qF4JQEwCVP7+PYbY08BpzgYl7HHOO/IsSIp8KjW1VK8ANf3MI/vkFG0R5VTDqWPWcyKQ==";
//
//    }
    token = @"uhV3Sl8IYP29sCxjQktF3ZQEwCVP7+PYbY08BpzgYl6j5pJMblXFeNNXoeVaSN5Gqv4wcRoLHnAHAuk3NAfi1Hij3+TGVQ+r";
    [[RCDataManager shareManager] loginRongCloudWithUserInfo:[[RCUserInfo alloc]initWithUserId:aUserInfo.userId name:aUserInfo.name portrait:aUserInfo.portraitUri QQ:aUserInfo.QQ sex:aUserInfo.sex] withToken:token];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    
}

@end

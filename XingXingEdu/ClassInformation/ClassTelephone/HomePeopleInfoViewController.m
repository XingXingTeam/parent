//
//  HomePeopleInfoViewController.m
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/2/3.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "HomePeopleInfoViewController.h"
#import "ReportPicViewController.h"
#import "AuditSetViewController.h"
#import "MBProgressHUD.h"
#import "HHControl.h"
#import "ViewController.h"
// UM
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "CoreUMeng.h"
#import "WMConversationViewController.h"
@interface HomePeopleInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>
{
    UIImageView *headbgimageview;
    UIImageView *headimageview;
    UITableView *_tableView;
    NSMutableArray *dataArray;
    NSArray *bookArr;
    UIButton *saveBtn;
    MBProgressHUD *HUDH;
}
@end

@implementation HomePeopleInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = UIColorFromRGB(196, 213, 255);
    
    self.title = @"详细资料";
   
    [self createAuditBar];
   
    [self createTableView];
     [self createHeadImage];
    [self createTools];
    [self saveBtn];
}
- (void)saveBtn{
    saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(250, 110, 40, 40)];
    saveBtn.layer.cornerRadius =5;
    saveBtn.layer.masksToBounds =YES;
    [saveBtn setBackgroundColor:[UIColor orangeColor]];
    [saveBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [headbgimageview addSubview:saveBtn];
    [saveBtn addTarget:self action:@selector(shareB:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}
- (void)shareB:(UIButton*)shareBtn{
    HUDH =[[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:HUDH];
    
    if (saveBtn.selected ==NO) {
        shareBtn.selected=YES;
        saveBtn=shareBtn;
        [saveBtn setBackgroundColor:[UIColor redColor]];
        HUDH.dimBackground =YES;
        HUDH.labelText =@"已收藏";
        [HUDH showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [HUDH removeFromSuperview];
            HUDH =nil;
        }];
    }
    else{
        shareBtn.selected=NO;
        saveBtn=shareBtn;
        HUDH.dimBackground =YES;
        [saveBtn setBackgroundColor:[UIColor orangeColor]];
        HUDH.labelText =@"取消收藏";
        [HUDH showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [HUDH removeFromSuperview];
            HUDH =nil;
        }];
    }
    
    
}

- (void)createTools{
    UIButton *shareBtn = [HHControl createButtonWithFrame:CGRectMake(0, kHeight-37, kWidth/4, 37) backGruondImageName:nil Target:self Action:@selector(shareBtn:) Title:@"发起聊天"];
    shareBtn.backgroundColor =UIColorFromRGB(248, 144, 34);
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [shareBtn setTintColor:[UIColor whiteColor]];
    shareBtn.layer.cornerRadius = 5.0f;
    [self.view addSubview:shareBtn];
    
    UIButton *lookBtn = [HHControl createButtonWithFrame:CGRectMake(kWidth/4,kHeight-37,kWidth/4, 37) backGruondImageName:nil Target:self Action:@selector(lookBtn:) Title:@"查看圈子"];
    lookBtn.backgroundColor =UIColorFromRGB(248, 144, 34);
    lookBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [lookBtn setTintColor:[UIColor whiteColor]];
    lookBtn.layer.cornerRadius = 5.0f;
    [self.view addSubview:lookBtn];
    
    UIButton *chatBtn = [HHControl createButtonWithFrame:CGRectMake(kWidth/2, kHeight-37, kWidth/4, 37) backGruondImageName:nil Target:self Action:@selector(firendBtn:) Title:@"分享给好友"];
    chatBtn.backgroundColor =UIColorFromRGB(248, 144, 34);
    chatBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [chatBtn setTintColor:[UIColor whiteColor]];
    chatBtn.layer.cornerRadius = 5.0f;
    [self.view addSubview:chatBtn];
    
    
    UIButton *reportBtn = [HHControl createButtonWithFrame:CGRectMake(kWidth*3/4, kHeight-37, kWidth/4, 37) backGruondImageName:nil Target:self Action:@selector(chatBtn:) Title:@"举报"];
    reportBtn.backgroundColor =UIColorFromRGB(248, 144, 34);
    reportBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [reportBtn setTintColor:[UIColor whiteColor]];
    reportBtn.layer.cornerRadius = 5.0f;
    [self.view addSubview:reportBtn];

}
- (void)shareBtn:(UIButton*)btn{
    
    WMConversationViewController *personVC =[[WMConversationViewController alloc]init];
    personVC.conversationType = ConversationType_PRIVATE;
    personVC.targetId = [RCIM sharedRCIM].currentUserInfo.userId;
    personVC.title =@"KT";
    [self.navigationController pushViewController:personVC animated:YES];
}
- (void)lookBtn:(UIButton*)btn{
    ViewController *viewVC =[[ViewController alloc]init];
    [self.navigationController pushViewController:viewVC animated:YES];
    
}
- (void)firendBtn:(UIButton*)btn{
    
   [CoreUmengShare show:self text:@"为了孩子的未来,这里有你想要的一切,快点点击下载吧！https://itunes.apple.com/cn/app/jie-dian-qian-zhuan-ye-ban/id1112373854?mt=8&v0=WWW-GCCN-ITSTOP100-FREEAPPS&l=&ign-mpt=uo%3D4" image:[UIImage imageNamed:@"猩猩教室.png"]];
}
- (BOOL)isDirectShareInIconActionSheet{
    return YES;
}
- (void)chatBtn:(UIButton*)btn{
        NSLog(@"report");
    ReportPicViewController *reportVC =[[ReportPicViewController alloc]init];
    [self.navigationController pushViewController:reportVC animated:NO];
    
}
- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    [self.view addSubview:_tableView];
    headbgimageview = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, kWidth, 200)];
    headbgimageview.image = [UIImage imageNamed:@"note_bg.png"];
    headbgimageview.tag=10;
    headbgimageview.userInteractionEnabled =YES;
    headbgimageview.contentMode = UIViewContentModeScaleAspectFill;
    _tableView.tableHeaderView =headbgimageview;
    headimageview = [[UIImageView alloc] initWithFrame:CGRectMake(130, 40, 108, 105)];
    headimageview.image = [UIImage imageNamed:self.imagStr];
    
    headimageview.contentMode = UIViewContentModeScaleAspectFill;
    headimageview.layer.masksToBounds = YES;
    headimageview.layer.cornerRadius = 50;
    [headbgimageview addSubview:headimageview];
    [self addManImage];
    
    UILabel *grageLbl =[HHControl createLabelWithFrame:CGRectMake(headimageview.frame.origin.x+28,headimageview.frame.origin.y+105 ,57, 20) Font:12 Text:@"等级: LV5"];
    grageLbl.backgroundColor = [UIColor orangeColor];
    [headbgimageview addSubview:grageLbl];
    
    
    UILabel *scoreLbl =[HHControl createLabelWithFrame:CGRectMake(headimageview.frame.origin.x+60,headimageview.frame.origin.y+105 ,57, 20) Font:12 Text:@""];
    scoreLbl.backgroundColor = [UIColor clearColor];
    [headbgimageview addSubview:scoreLbl];
    
    dataArray = [[NSMutableArray alloc]init];
    NSArray *arr1 =[[NSArray alloc]initWithObjects:@"昵称:",@"姓名:",@"与宝贝关系:",@"电话号码:",@"邮箱:",@"QQ:",nil];
    bookArr =[[NSArray alloc]initWithObjects:@"小灰灰",@"宝贝妈妈",@"宝妈",@"18824767232",@"keen_team@163.com",@"812144991",nil];
 
    [dataArray addObject:arr1];
    

}
- (void)addManImage{
    UIImageView *manimage = [[UIImageView alloc]initWithFrame:CGRectMake(45, 80, 20, 20)];
    manimage.image = [UIImage imageNamed:@"man"];
    [headimageview addSubview:manimage];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [dataArray[section] count];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
static NSString *cellID =@"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    if (indexPath.section==0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",dataArray[indexPath.section] [indexPath.row],bookArr[indexPath.row]];
    }
    else{
    cell.textLabel.text = [NSString stringWithFormat:@"%@",dataArray[indexPath.section] [indexPath.row]];
       
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
- (void)createAuditBar{
    UIBarButtonItem *rightBtn =[[UIBarButtonItem alloc]initWithTitle:@"权限设置" style:UIBarButtonItemStylePlain target:self action:@selector(clickBtn:)];
    [self.navigationItem  setRightBarButtonItem:rightBtn];

}

- (void)clickBtn:(UIBarButtonItem*)btn{
    AuditSetViewController *auditSetVC =[[AuditSetViewController alloc]init];
    [self.navigationController pushViewController:auditSetVC animated:YES];
    
}
- (void)createHeadImage{
  

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

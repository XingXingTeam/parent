//
//  OtherPeopleViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/2/4.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "OtherPeopleViewController.h"
#import "AuditSetViewController.h"
#import "OthePeopleCell.h"
#import "ReportPicViewController.h"
#import "HHControl.h"
// UM
#import "CoreUMeng.h"
#import "SVProgressHUD.h"
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "APOpenAPI.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "XXEFriendMyCircleViewController.h"
#import "WMConversationViewController.h"


@interface OtherPeopleViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>
{
    UITableView *_tableView;
    NSMutableArray *dataArray;
    NSMutableArray *detailArray;
    NSMutableArray *headArray;
    UIImageView *icon;
    NSString *iconStr;
    UIView *headerView;
    
    UIImageView *imageView;
    UIButton *rightBtn;
    MBProgressHUD *HUDH;

    //下个等级 星币
    NSString *next_grade_coinStr;
    //现有 星币
    NSString *coin_totalStr;
    //等级
    NSString *lvStr;
    //性别
    UIImage *sexPic;
    
    //滚动条
    YSProgressView *ysView;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@end

@implementation OtherPeopleViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        dataArray = [[NSMutableArray alloc]initWithObjects:@"昵称:",@"姓名:",@"关系:",@"电话号码:",@"邮箱:",@"权限设置",nil];
//        detailArray = [[NSMutableArray alloc]init];
        headArray = [[NSMutableArray alloc]initWithObjects:@"昵称40x44",@"姓名40x40",@"关系40x46",@"联系方式40x40",@"邮箱40x40",@"设置40x40", nil];
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated{
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
    
    self.title =@"家人";
    // Do any additional setup after loading the view.
     self.view.backgroundColor = UIColorFromRGB(255,163, 195);
    
    [self fetchNetData];
    
    [self createTableView];
    
//    [self createHeadView];
    
    [self createRightBar];
    
    [self createToolBar];
    
}

- (void)fetchNetData{

    /*
     【家人详情页】
     用于:
     1.首页长按孩子出现的家长,查看家长详情
     2.班级通讯录孩子名下的家长,查看家长详情
     接口:
     http://www.xingxingedu.cn/Parent/parent_detail
     传参:
     baby_id		//孩子id
     parent_id	//家人id
     */
        //路径
        NSString *urlStr = @"http://www.xingxingedu.cn/Parent/parent_detail";

        NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"baby_id": _babyIdStr , @"parent_id":_familyIdStr};
        [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
            //
//            NSLog(@" 家人 详情 --  %@", responseObj);
            if ([[NSString stringWithFormat:@"%@", [responseObj objectForKey:@"code"]] isEqualToString:@"1"]) {
                NSDictionary *dic = responseObj[@"data"];
                
                //昵称
                NSString *nicknameStr = dic[@"nickname"];
                
                //姓名
                NSString *tnameStr = dic[@"tname"];
                
                //关系
                NSString *relationStr = dic[@"relation"];
                
                //电话号码
                NSString *phoneStr = dic[@"phone"];
                
                //邮箱
                NSString *emailStr = dic[@"email"];
        
               //权限设置
                NSString *powerStr = @"";
                
                detailArray = [[NSMutableArray alloc] initWithObjects:nicknameStr, tnameStr, relationStr, phoneStr, emailStr, powerStr, nil];
        
               //头像
                NSString * head_img;
                if([[NSString stringWithFormat:@"%@",dic[@"head_img_type"]]isEqualToString:@"0"]){
                    head_img=[picURL stringByAppendingString:dic[@"head_img"]];
                }else{
                    head_img=dic[@"head_img"];
                }
               
                iconStr = head_img;
                
                //下等级 星币数
                next_grade_coinStr = dic[@"next_grade_coin"];
                
                //现有 星币数
                coin_totalStr = dic[@"coin_total"];
                
                //现在 等级
                lvStr = dic[@"lv"];
                
                //性别
                if ([dic[@"sex"] isEqualToString:@"男"]) {
                    sexPic = [UIImage imageNamed:@"男"];
                }else if ([dic[@"sex"] isEqualToString:@"女"]){
                    sexPic = [UIImage imageNamed:@"女"];
                }
                
                //家人 Xid
                _familyXidStr = dic[@"xid"];
                
                /*
                 [cheeck_collect] => 1		//是否收藏过 1:收藏过  2:未收藏过
                 */
                
                
                if ([dic[@"cheeck_collect"] integerValue] == 1) {
                    _isCollected = YES;
                    _saveImage = [UIImage imageNamed:@"收藏(H)icon44x44"];
                    
                }else if([dic[@"cheeck_collect"] integerValue] == 2){
                    _isCollected = NO;
                    _saveImage = [UIImage imageNamed:@"收藏icon44x44"];
                }
                [rightBtn setBackgroundImage:_saveImage forState:UIControlStateNormal];
            
            }else{
            
            }
            
            [_tableView reloadData];
            
        } failure:^(NSError *error) {
            //
            NSLog(@"%@", error);
        }];
}


- (void)createTableView{

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    [self.view addSubview:_tableView];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 150 * kWidth / 375;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID =@"cellID";
    OthePeopleCell *cell = (OthePeopleCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        NSArray *nib =[[NSBundle mainBundle] loadNibNamed:@"OthePeopleCell" owner:[OthePeopleCell class] options:nil];
        cell =(OthePeopleCell*)[nib objectAtIndex:0];
    }
    
    cell.nameLbl.text =dataArray[indexPath.row];
    cell.detailLbl.text =detailArray[indexPath.row];
    cell.headImagV.image =[UIImage imageNamed:headArray[indexPath.row]];
    if (indexPath.row == 5) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//权限设置
    if (indexPath.row ==5) {
        AuditSetViewController *auditSetVC =[[AuditSetViewController alloc]init];
        auditSetVC.XIDStr = _familyXidStr;
        [self.navigationController pushViewController:auditSetVC animated:YES];
  
    }

}

//上海

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    headerView = [HHControl createViewWithFrame:CGRectMake(0, 0, kWidth, 150 * kWidth / 375)];
    
    imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 150 * kWidth / 375)];
    imageView.image = [UIImage imageNamed:@"banner"];
//    _tableView.tableHeaderView =imageView;
    imageView.userInteractionEnabled =YES;
    [headerView addSubview:imageView];
    
//    NSLog(@"iconStr ===  %@", iconStr);
    icon = [[UIImageView alloc] init];
    [icon sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@"人物头像172x172"]];
    
    [icon setFrame:CGRectMake(30, 30, 86,86)];
    icon.layer.cornerRadius =43;
    icon.layer.masksToBounds =YES;
    [headerView addSubview:icon];
    icon.userInteractionEnabled =YES;
    
    //添加性别
    UIImageView *manimage = [[UIImageView alloc]initWithFrame:CGRectMake(35, 60, 20, 20)];
    //    manimage.image = [UIImage imageNamed:@"man"];
    manimage.image = sexPic;
    [icon addSubview:manimage];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [button setFrame:CGRectMake(icon.frame.origin.x+50 ,icon.frame.size.width+icon.frame.origin.y+10 , 80, 30)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //用户名
    
    UILabel *nameLbl =[HHControl createLabelWithFrame:CGRectMake(150, 40, 50, 20) Font:18 Text:nil];
    nameLbl.text = detailArray[1];
//    nameLbl.backgroundColor = [UIColor whiteColor];
    nameLbl.textAlignment = NSTextAlignmentLeft;
    nameLbl.textColor =UIColorFromRGB(255, 255, 255);
    [headerView addSubview:nameLbl];
    
    //等级
    
    NSString *lvString = [NSString stringWithFormat:@"LV%@", lvStr];
    UILabel *lvLabel = [HHControl createLabelWithFrame:CGRectMake(200, 42, 30, 15) Font:12 Text:lvString];
    lvLabel.textColor = UIColorFromRGB(3, 169, 244);
    lvLabel.textAlignment = NSTextAlignmentCenter;
    lvLabel.backgroundColor = [UIColor whiteColor];
    lvLabel.layer.cornerRadius = 5;
    lvLabel.layer.masksToBounds = YES;
    [headerView addSubview:lvLabel];
    
    //等级  星币 差距
    UILabel *titleLbl =[HHControl createLabelWithFrame:CGRectMake(150 * kWidth / 375, 80 * kWidth / 375, 220 * kWidth / 375, 20 * kWidth / 375) Font:14 * kWidth / 375 Text:[NSString stringWithFormat:@"还差%ld星币升级到%ld级会员",[next_grade_coinStr integerValue]-[coin_totalStr integerValue], [lvStr integerValue]+1]];
    titleLbl.textColor =UIColorFromRGB(255, 255, 255);
    titleLbl.numberOfLines =0;
    [headerView addSubview:titleLbl];

    //滚动条
    ysView = [[YSProgressView alloc] initWithFrame:CGRectMake(150 * kWidth / 375, 120 * kWidth / 375, 200 * kWidth / 375, 10 * kWidth / 375)];
    ysView.progressHeight = 2;
    ysView.progressTintColor = [UIColor colorWithRed:0.0 / 255 green:0.0 / 255 blue:0.0 / 255 alpha:0.5];
    ysView.trackTintColor = [UIColor whiteColor];
    float b =  [coin_totalStr floatValue]/[next_grade_coinStr floatValue];
    ysView.progressValue = b * ysView.frame.size.width;
    [headerView addSubview:ysView];

    return headerView;
}



- (void)createToolBar{
    
    CGFloat Width = kWidth / 4;
    
    
    
    UIImageView *imageV= [[UIImageView alloc]initWithFrame:CGRectMake(0, kHeight-44, kWidth, 44)];
    imageV.backgroundColor = UIColorFromRGB(255, 255, 255 );
    [self.view addSubview:imageV];
    imageV.userInteractionEnabled =YES;
    
    UIButton *chartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chartButton.frame = CGRectMake(0, 5, Width, 24);

    [chartButton setImage:[UIImage imageNamed:@"发起聊天icon48x48"] forState:UIControlStateNormal];
    [chartButton setImage:[UIImage imageNamed:@"发起聊天(H)icon48x48"] forState:UIControlStateHighlighted];
    [chartButton addTarget:self action:@selector(chartBtn:) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:chartButton];
//
    UILabel *chartLbl =[HHControl createLabelWithFrame:CGRectMake(0, 30, Width, 14) Font:8 Text:@"发起聊天"];
    chartLbl.textAlignment = NSTextAlignmentCenter;
    [imageV addSubview:chartLbl];

//    
    UIButton *seeBtn = [[UIButton alloc]initWithFrame:CGRectMake(Width, 5, Width, 24)];
    [seeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [seeBtn setTitle:@"" forState:UIControlStateNormal];
    [seeBtn setImage:[UIImage imageNamed:@"查看我的圈子icon48x48"] forState:UIControlStateNormal];
    [seeBtn setImage:[UIImage imageNamed:@"查看我的圈子(H)icon48x48"] forState:UIControlStateHighlighted];
    [seeBtn addTarget:self action:@selector(lookBtn:) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:seeBtn];

    UILabel *seeLbl =[HHControl createLabelWithFrame:CGRectMake(Width, 30, Width, 14) Font:8 Text:@"查看圈子"];
    seeLbl.textAlignment = NSTextAlignmentCenter;
    [imageV addSubview:seeLbl];
    
    //分享
    UIButton * shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(Width * 2, 5, Width, 24)];
    [shareBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [shareBtn setTitle:@"" forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"分享icon48x48"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"分享(H)icon48x48"] forState:UIControlStateHighlighted];
    [imageV addSubview:shareBtn];
    [shareBtn addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *shareLbl =[HHControl createLabelWithFrame:CGRectMake(Width * 2, 30, Width, 14) Font:8 Text:@"分享"];
    shareLbl.textAlignment = NSTextAlignmentCenter;
    [imageV addSubview:shareLbl];
    
    
    UIButton *reportBtn = [[UIButton alloc]initWithFrame:CGRectMake(Width * 3, 5, Width, 24)];
    [reportBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [reportBtn setTitle:@"" forState:UIControlStateNormal];
    [reportBtn setImage:[UIImage imageNamed:@"举报icon48x48"] forState:UIControlStateNormal];
    [reportBtn setImage:[UIImage imageNamed:@"举报(H)icon48x48"] forState:UIControlStateHighlighted];
    [imageV addSubview:reportBtn];
    [reportBtn addTarget:self action:@selector(reportBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *reportLbl =[HHControl createLabelWithFrame:CGRectMake(Width * 3, 30, Width, 14) Font:8 Text:@"举报"];
    reportLbl.textAlignment = NSTextAlignmentCenter;
    [imageV addSubview:reportLbl];
    
}


- (void)chartBtn:(UIButton *)btn{

//    NSLog(@"发起聊天");
    
    NSString * userId = [XXEUserInfo user].user_id;
    
    NSString * userNickName = [XXEUserInfo user].nickname;
    
    NSString * userPortraitUri = [XXEUserInfo user].user_head_img;
    
    RCUserInfo *_currentUserInfo =
    [[RCUserInfo alloc] initWithUserId:userId
                                  name:userNickName
                              portrait:userPortraitUri];
    [RCIM sharedRCIM].currentUserInfo = _currentUserInfo;
    
    WMConversationViewController *vc = [[WMConversationViewController alloc] init];
    
    vc.conversationType = ConversationType_PRIVATE;
    vc.targetId = _familyXidStr;
    vc.title = detailArray[1];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)shareButtonClick:(UIButton*)btn{
    
    NSLog(@"分享");
    
    //分享给好友
    //    [UMSocialSnsService  presentSnsIconSheetView:self appKey:@"56d4096e67e58ef29300147c" shareText:@"keenteam" shareImage:[UIImage imageNamed:@"11111.png"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToQzone,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToSina,UMShareToQQ,nil] delegate:self];
    [CoreUmengShare show:self text:@"为了孩子的未来,这里有你想要的一切,快点点击下载吧！https://itunes.apple.com/cn/app/jie-dian-qian-zhuan-ye-ban/id1112373854?mt=8&v0=WWW-GCCN-ITSTOP100-FREEAPPS&l=&ign-mpt=uo%3D4" image:[UIImage imageNamed:@"猩猩教室.png"]];
}
- (void)lookBtn:(UIButton*)btn{
    
    NSLog(@"圈子");
    
    XXEFriendMyCircleViewController *viewVC =[[XXEFriendMyCircleViewController alloc]init];
    [self.navigationController pushViewController:viewVC animated:YES];
}
//举报
- (void)reportBtn:(UIButton*)btn{
    
    NSLog(@"举报");
    
    ReportPicViewController *reportVC =[[ReportPicViewController alloc]init];
    reportVC.other_xidStr = _familyXidStr;
    
    [self.navigationController pushViewController:reportVC animated:YES];
    
}
- (void)createRightBar{
    
    //设置 navigationBar 右边 收藏
    rightBtn = [HHControl createButtonWithFrame:CGRectMake(kWidth - 100, 0, 22, 22) backGruondImageName:nil Target:self Action:@selector(right:) Title:nil];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
- (void)right:(UIButton*)sender{
    
    if (_isCollected== NO) {
        
        [self collectArticle];
        
    }
    else  if (_isCollected== YES) {
        [self deleteCollectArticle];
        
    }
    
}

//收藏机构
- (void)collectArticle
{
    /*
     【收藏】通用于各种收藏
     接口:
     http://www.xingxingedu.cn/Global/collect
     传参:
     collect_id	//收藏id (如果是收藏用户,这里是xid)
     collect_type	//收藏品种类型	1:商品  2:点评  3:用户  4:课程  5:学校  6:花朵
     */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/collect";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"collect_id":_familyXidStr,
                           @"collect_type":@"3",
                           
                           };
    //    NSLog(@"%@",dict);
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             [SVProgressHUD showSuccessWithStatus:@"收藏成功"];

             [rightBtn setBackgroundImage:[UIImage imageNamed:@"commentInfo10"] forState:UIControlStateNormal];
             
             _isCollected=!_isCollected;
             
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
     }];
}

//取消收藏老师
- (void)deleteCollectArticle
{
    /*
     【删除/取消收藏】通用于各种收藏
     接口:
     http://www.xingxingedu.cn/Global/deleteCollect
     传参:
     collect_id	//收藏id (如果是收藏用户,这里是xid)
     collect_type	//收藏品种类型	1:商品  2:点评  3:用户  4:课程  5:学校  6:花朵 7:图片
     */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/deleteCollect";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];

    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"collect_id":_familyXidStr,
                           @"collect_type":@"3",
                           
                           };
    //    NSLog(@"%@",dict);
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] ){
             [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];
             
             [rightBtn setBackgroundImage:[UIImage imageNamed:@"commentInfo9"] forState:UIControlStateNormal];
             
             _isCollected=!_isCollected;
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}


@end

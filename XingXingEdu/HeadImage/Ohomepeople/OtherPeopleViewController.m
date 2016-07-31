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
#import "ViewController.h"

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
    
        //请求参数
    
        NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":XID, @"user_id":USER_ID, @"user_type":USER_TYPE, @"baby_id": _babyIdStr , @"parent_id":_familyIdStr};
        [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
            //
//            NSLog(@" 家人 详情 --  %@", responseObj);
    //@"昵称:",@"姓名:",@"关系:",@"电话号码:",@"邮箱:",@"权限设置"
    /*
     家人 详情 --  {
     msg = Success!,
     data = {
     id = 3,
     phone = 15026511454,
     tname = 顾曾,
     head_img = http://www.xingxingedu.cn/Public/images/team/dingmengyuan.jpg,
     head_img_type = 1,
     sex = 男,
     next_grade_coin = 1000,
     lv = 2,
     token = Pa587uORspsUpPgKLN1KgFEmr1pNAb7OGJ9kaMOBk7LKyUXBViBO5MsWeKiqhcCPSk+qBDeEQbxKoz64SvtqbkhCPMlpGanE,
     relation = 爷爷,
     coin_total = 100,
     nickname = 飘吧少年,
     email = ,
     xid = 18886144
     },
     code = 1
     }
     */
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
    return 150;
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
    
    headerView = [HHControl createViewWithFrame:CGRectMake(0, 0, kWidth, 150)];
    
    imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 150)];
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
    int a = [next_grade_coinStr intValue];
    int b = [coin_totalStr intValue];
    int c = a - b;
    int d = [lvStr intValue] + 1;
    
    NSString *titleStr = [NSString stringWithFormat:@"还差%d星币升级到%d级会员  %d/%d", c, d, b, a];
    UILabel *titleLbl =[HHControl createLabelWithFrame:CGRectMake(150, 70, 200, 35) Font:12 Text:titleStr];
    titleLbl.numberOfLines = 0;
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.text = titleStr;
    
    titleLbl.textColor = [UIColor whiteColor];
    
    [headerView addSubview:titleLbl];
    
    //滚动条
    UISlider *slide =[[UISlider alloc]initWithFrame:CGRectMake(150, 110, 150, 10)];
    slide.maximumTrackTintColor =UIColorFromRGB(220, 220, 220);
    slide.minimumTrackTintColor =UIColorFromRGB(255, 255, 255);
    slide.thumbTintColor =[UIColor clearColor];
    slide.minimumValue =0.0;
    slide.maximumValue =100;

    if (a != 0) {
        slide.value = b / a * 100;
    }else{
        slide.value = 0.4 * 100 ;
    }
    
    [headerView addSubview:slide];

    return headerView;
}



- (void)createToolBar{
    
    UIImageView *imageV= [[UIImageView alloc]initWithFrame:CGRectMake(0, kHeight-44, kWidth, 44)];
    imageV.backgroundColor = UIColorFromRGB(255, 255, 255 );
    [self.view addSubview:imageV];
    imageV.userInteractionEnabled =YES;
    
    UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(25, 5, 24, 24)];
    [shareBtn setTitle:@"" forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"发起聊天icon48x48"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"发起聊天(H)icon48x48"] forState:UIControlStateHighlighted];
    [shareBtn addTarget:self action:@selector(shareBtn:) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:shareBtn];
    
    UILabel *shareLbl =[HHControl createLabelWithFrame:CGRectMake(30, 30, 20, 14) Font:8 Text:@"发起聊天"];
    [imageV addSubview:shareLbl];
    
    
    UIButton *seeBtn = [[UIButton alloc]initWithFrame:CGRectMake(118, 5, 24, 24)];
    [seeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [seeBtn setTitle:@"" forState:UIControlStateNormal];
    [seeBtn setImage:[UIImage imageNamed:@"查看我的圈子icon48x48"] forState:UIControlStateNormal];
    [seeBtn setImage:[UIImage imageNamed:@"查看我的圈子(H)icon48x48"] forState:UIControlStateHighlighted];
    [seeBtn addTarget:self action:@selector(lookBtn:) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:seeBtn];
    
    UILabel *downLbl =[HHControl createLabelWithFrame:CGRectMake(123, 30, 20, 14) Font:8 Text:@"查看圈子"];
    [imageV addSubview:downLbl];
    
    
    UIButton * saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(212, 5, 24, 24)];
    [saveBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [saveBtn setTitle:@"" forState:UIControlStateNormal];
    [saveBtn setImage:[UIImage imageNamed:@"分享icon48x48"] forState:UIControlStateNormal];
    [saveBtn setImage:[UIImage imageNamed:@"分享(H)icon48x48"] forState:UIControlStateHighlighted];
    [imageV addSubview:saveBtn];
    [saveBtn addTarget:self action:@selector(firendBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *saveLbl =[HHControl createLabelWithFrame:CGRectMake(217, 30, 20, 14) Font:8 Text:@"分享"];
    [imageV addSubview:saveLbl];
    
    
    UIButton *reportBtn = [[UIButton alloc]initWithFrame:CGRectMake(305, 5, 24, 24)];
    [reportBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [reportBtn setTitle:@"" forState:UIControlStateNormal];
    [reportBtn setImage:[UIImage imageNamed:@"举报icon48x48"] forState:UIControlStateNormal];
    [reportBtn setImage:[UIImage imageNamed:@"举报(H)icon48x48"] forState:UIControlStateHighlighted];
    [imageV addSubview:reportBtn];
    [reportBtn addTarget:self action:@selector(chatBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *reportLbl =[HHControl createLabelWithFrame:CGRectMake(310, 30, 20, 14) Font:8 Text:@"举报"];
    [imageV addSubview:reportLbl];
    
}
- (void)firendBtn:(UIButton*)btn{
    //分享给好友
    //    [UMSocialSnsService  presentSnsIconSheetView:self appKey:@"56d4096e67e58ef29300147c" shareText:@"keenteam" shareImage:[UIImage imageNamed:@"11111.png"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToQzone,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToSina,UMShareToQQ,nil] delegate:self];
    [CoreUmengShare show:self text:@"为了孩子的未来,这里有你想要的一切,快点点击下载吧！https://itunes.apple.com/cn/app/jie-dian-qian-zhuan-ye-ban/id1112373854?mt=8&v0=WWW-GCCN-ITSTOP100-FREEAPPS&l=&ign-mpt=uo%3D4" image:[UIImage imageNamed:@"猩猩教室.png"]];
    
    
}
- (void)shareBtn:(UIButton*)btn{
    
    
}
- (void)lookBtn:(UIButton*)btn{
    ViewController *viewVC =[[ViewController alloc]init];
    [self.navigationController pushViewController:viewVC animated:YES];
}
//举报
- (void)chatBtn:(UIButton*)btn{
    
    ReportPicViewController *reportVC =[[ReportPicViewController alloc]init];
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
                           @"xid":XID,
                           @"user_id":USER_ID,
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
    
    NSDictionary *dict = @{@"appkey":@"U3k8Dgj7e934bh5Y",
                           @"backtype":@"json",
                           @"xid":@"18884982",
                           @"user_id":@"1",
                           @"user_type":@"1",
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

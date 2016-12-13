//
//  IntroductionViewController.m
//  XingXingEdu
//
//  Created by Mac on 16/5/9.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "IntroductionViewController.h"
#import "DetailCell.h"
#import "HHControl.h"
#import "AlbumViewController.h"
#import "StarRemarkViewController.h"
#import "SchoolVideoViewController.h"
#import "SchoolIntroductionDetailViewController.h"

#import "WZYHttpTool.h"


#define DETAIL @"DetailCell"
#define kScreenWidth self.view.frame.size.width
#define kScreenHeight self.view.frame.size.height
#define Space 10

@interface IntroductionViewController ()<UITableViewDataSource, UITableViewDelegate>
{

    NSString *parameterXid;
    NSString *parameterUser_Id;
}


@property (nonatomic) NSMutableArray *pictureArray;
@property (nonatomic) NSMutableArray *titleArray;
@property (nonatomic) NSMutableArray *contentArray;
//@property (nonatomic) NSArray *pictureWallArray;

@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIImageView *backgroundImageView;
@property (nonatomic) UIImageView *iconImageView;
@property (nonatomic) UIView *lineView;
@property (nonatomic, strong) MBProgressHUD *HUDSave;

@property (nonatomic) UIButton *saveButton;


//LOGO  图标
@property (nonatomic ,copy) NSString *logoIconStr;
//学校名称
@property (nonatomic, copy) NSString *schoolNameStr;
//评分
@property (nonatomic, copy) NSString *score_num;
//浏览
@property (nonatomic, copy) NSString *read_num;
//收藏
@property (nonatomic, copy) NSString *collect_num;
 //简介
@property (nonatomic, copy) NSString *introduction;
//相册
@property (nonatomic) NSMutableArray *school_pic_groupArray;
//视频
@property (nonatomic) NSMutableArray *school_video_groupArray;
//视频 标题
@property (nonatomic) NSMutableArray *school_video_group_titleArray;
//视频 时间
@property (nonatomic) NSMutableArray *school_video_group_timeArray;
//视频 URL
@property (nonatomic) NSMutableArray *school_video_group_urlArray;
//机构 是否 收藏
@property (nonatomic) BOOL isCollected;

@property (nonatomic, copy) NSString *schoolIdStr;

@property (nonatomic, strong) UIImage *saveImage;


@end

@implementation IntroductionViewController

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    

    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    [self fetchNetData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.pictureArray =[[NSMutableArray alloc]initWithObjects:@"资质40x40@2x.png", @"特色40x40@2x.png", @"注册教师40x40@2x.png", @"注册学生40x40@2x.png", @"联系方式40x40@2x.png", @"QQ40x40@2x.png", @"邮箱40x40@2x.png",  @"简介40x44@2x.png", @"相册@2x.png", @"playIcon40x40", nil];
     self.titleArray =[[NSMutableArray alloc]initWithObjects:@"资质:",@"特点:",@"注册教师:", @"注册学生:", @"联系方式:", @"联系QQ:", @"邮箱:", @"简介:", @"相册:", @"视频:",  nil];

    _school_pic_groupArray = [[NSMutableArray alloc] init];
    _school_video_groupArray = [[NSMutableArray alloc] init];
    _school_video_group_titleArray = [[NSMutableArray alloc] init];
    _school_video_group_timeArray = [[NSMutableArray alloc] init];
    _school_video_group_urlArray = [[NSMutableArray alloc] init];

    //设置 navgiationBar
    [self setNavgiationBar];
    
    //获取数据
//    [self fetchNetData];
    
    [self.view addSubview:self.tableView];
    
}


- (void)setNavgiationBar{

    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0, 170, 42)];
    self.navigationController.navigationBar.translucent = NO;
    
    //1、设置 navigationBar 左边 返回
    UIImage *backImage = [UIImage imageNamed:@"首页90x38"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage: backImage  style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    
    //    2、设置 navigationBar 标题 颜色
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    //3、设置 navigationBar 右边 收藏
    _saveButton = [HHControl createButtonWithFrame:CGRectMake(kScreenWidth - 100, 0, 22, 22) backGruondImageName:nil Target:self Action:@selector(collectbtn:) Title:nil];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_saveButton];
    self.navigationItem.rightBarButtonItem = rightItem;

}


- (void)fetchNetData{
    /*
     接口:
     http://www.xingxingedu.cn/Global/xkt_school_detail
     传参:
     school_id		//学校id
     */
    
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/xkt_school_detail";
    
    //获取学校id数组
    NSString *schoolIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"SCHOOL_ID"];
    _schoolIdStr = schoolIdStr;
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"school_id":_schoolIdStr};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
//        NSLog(@"=================%@", responseObj);
        NSDictionary *dic = responseObj[@"data"];
        
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
        [_saveButton setBackgroundImage:_saveImage forState:UIControlStateNormal];
        
        //LOGO 图标
        _logoIconStr = dic[@"logo"];
        //学校 名称
        _schoolNameStr = dic[@"name"];
        //评分
        _score_num = dic[@"score_num"];
        //浏览
        _read_num = dic[@"read_num"];
        //收藏
        _collect_num = dic[@"collect_num"];

        //资质
        NSString *examine = dic[@"examine"];
        //特点
        NSString *charact = dic[@"charact"];
        //注册教师
        NSString *teacher_num = dic[@"teacher_num"];
        //注册学生
        NSString *baby_num = dic[@"baby_num"];
        //电话
        NSString *tel = dic[@"tel"];
        //QQ
        NSString *qq = dic[@"qq"];
        //邮箱
        NSString *email = dic[@"email"];
        //简介
        _introduction = dic[@"introduction"];
        //相册
//        _school_pic_groupArray = dic[@"school_pic_group"];
        //视频
        _school_video_groupArray = dic[@"school_video_group"];
        
        if ([dic[@"school_video_group"] count] != 0) {

            for (NSDictionary *dicItem in dic[@"school_video_group"]) {
                
                NSString *videoUrl = [NSString stringWithFormat:@"%@%@", picURL, dicItem[@"url"]];
                [_school_video_group_urlArray addObject:videoUrl];
                
                NSString *titleStr = dicItem[@"title"];
                [_school_video_group_titleArray addObject:titleStr];
                
                NSString *timeStr = dicItem[@"date_tm"];
                [_school_video_group_timeArray addObject:timeStr];

            }
        }
        

        self.contentArray = [[NSMutableArray alloc] initWithObjects: examine, charact, teacher_num, baby_num, tel, qq, email, nil];
        
        
        [self createImageView];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];
    
}

- (void)createImageView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120 * kWidth / 375)];
    headView.backgroundColor = UIColorFromRGB(0, 170, 42);
    
    //设置头像
    CGFloat iconWidth = 87.0 * kWidth / 375;
    CGFloat iconHeight = 87.0 * kWidth / 375;
    
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.frame = CGRectMake(iconWidth / 4, headView.frame.size.height / 2 - iconHeight / 2, iconWidth, iconHeight);
//    _iconImageView.image = [UIImage imageNamed:@"头像174x174@2x.png"];
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picURL, _logoIconStr]] placeholderImage:[UIImage imageNamed:@"头像174x174"]];
    
    _iconImageView.layer.cornerRadius = iconWidth / 2;
    _iconImageView.layer.masksToBounds = YES;
    
    [headView addSubview:_iconImageView];
    
    //设置头像右边文字
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconWidth * 1.4, headView.frame.size.height / 2 - iconHeight / 2, 150 * kWidth / 375, 30 * kWidth / 375)];
//    titleLabel.text = @"北京大学";
    titleLabel.text = _schoolNameStr;
    titleLabel.font = [UIFont systemFontOfSize:16 * kWidth / 375];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [headView addSubview:titleLabel];
    
    //星级评分
    UIButton *starRankButton = [UIButton buttonWithType:UIButtonTypeCustom];
  starRankButton.frame = CGRectMake(iconWidth * 1.4, headView.frame.size.height / 2 - iconHeight / 2 + 30 * kWidth / 375, 100 * kWidth / 375, 40 * kWidth / 375);
    starRankButton.backgroundColor = [UIColor clearColor];

    NSString *str1 = _score_num;
    [starRankButton setTitle:[NSString stringWithFormat:@"星级评分:%.2f", str1.floatValue] forState:UIControlStateNormal];
    [starRankButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [starRankButton addTarget:self action:@selector(starRankButtonClick) forControlEvents:UIControlEventTouchUpInside];
    starRankButton.titleLabel.font = [UIFont boldSystemFontOfSize:14 * kWidth / 375];
    starRankButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [headView addSubview:starRankButton];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 30 * kWidth / 375, 95 * kWidth / 375, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [starRankButton addSubview:lineView];
    
    
    //浏览
    UILabel *browseLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconWidth * 1.4 + 100, headView.frame.size.height / 2 - iconHeight / 2 + 40 * kWidth / 375, 80 * kWidth / 375, 20 * kWidth / 375)];
    browseLabel.backgroundColor = [UIColor clearColor];
    NSString *str2 = _read_num;
    browseLabel.text = [NSString stringWithFormat:@"浏览:%@", str2];
    browseLabel.textColor = [UIColor whiteColor];
    browseLabel.font = [UIFont boldSystemFontOfSize:14 * kWidth / 375];
    [headView addSubview:browseLabel];
   
    
    //收藏
    UILabel *collectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconWidth * 1.4 + 100 * kWidth / 375 + 80 * kWidth / 375, headView.frame.size.height / 2 - iconHeight / 2 + 40 * kWidth / 375, 100 * kWidth / 375, 20 * kWidth / 375)];
    collectionLabel.backgroundColor = [UIColor clearColor];
    NSString *str3 = _collect_num;
    collectionLabel.text = [NSString stringWithFormat:@"收藏:%@", str3];
    collectionLabel.textColor = [UIColor whiteColor];
    collectionLabel.font = [UIFont boldSystemFontOfSize:14 * kWidth / 375];
    
    [headView addSubview:collectionLabel];

    [self.view addSubview:headView];
}

#pragma mark 星级评分 跳转----------------------------------------------
- (void)starRankButtonClick{
    
    if ([XXEUserInfo user].login) {
        StarRemarkViewController *starRemarkVC = [[StarRemarkViewController alloc] init];
        starRemarkVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:starRemarkVC animated:YES];
        
    }else{
        [SVProgressHUD showInfoWithStatus:@"请用账号登录后查看"];
    }


}


- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120 * kWidth / 375, kScreenWidth, kScreenHeight - 49 - 120 * kWidth / 375) style:UITableViewStyleGrouped];

        _tableView.dataSource = self;
        _tableView.delegate = self;
        
    }
    return _tableView;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.pictureArray.count;
//    return ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailCell *cell =(DetailCell*)[tableView dequeueReusableCellWithIdentifier:DETAIL];
    if (cell == nil) {
        NSArray *nib =[[NSBundle mainBundle] loadNibNamed:DETAIL owner:[DetailCell class] options:nil];
        cell =(DetailCell *)[nib objectAtIndex:0];
    }

        cell.titleLabel.text = self.titleArray[indexPath.row];
        cell.pictureImageView.image = [UIImage imageNamed:self.pictureArray[indexPath.row]];
    if (self.contentArray.count != 0 && indexPath.row >= 0 && indexPath.row <= 6) {
        cell.contentLabel.text = self.contentArray[indexPath.row];
        NSLog(@"%@", cell.contentLabel.text);
    }
        if (indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 9) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


#pragma mark didSelectRowAtIndexPath-------------------------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([XXEUserInfo user].login) {
        //学校简介
        if (indexPath.row == 7) {
            SchoolIntroductionDetailViewController *SchoolIntroductionDetailVC = [[SchoolIntroductionDetailViewController alloc] init];
            SchoolIntroductionDetailVC.hidesBottomBarWhenPushed = YES;
            if (_introduction) {
                SchoolIntroductionDetailVC.contentText = _introduction;
                //            NSLog(@"%@", _introduction);
            }
            
            [self.navigationController pushViewController:SchoolIntroductionDetailVC animated:YES];
            
        }else if (indexPath.row == 8) {
            //相册
            AlbumViewController *albumVC = [[AlbumViewController alloc] init];
            albumVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:albumVC animated:YES];
        }else if (indexPath.row == 9){
            //视频
            SchoolVideoViewController *schoolVideoVC = [[SchoolVideoViewController alloc] init];
            if (_school_video_groupArray.count != 0) {
                //            schoolVideoVC.dataSource = _school_video_groupArray;
                //            NSLog(@"%@", _school_video_groupArray);
                schoolVideoVC.videoImageViewArray = _school_video_group_urlArray;
                schoolVideoVC.videoTitleArray = _school_video_group_titleArray;
                schoolVideoVC.videoTimeArray = _school_video_group_timeArray;
                
                
            }
            
            schoolVideoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:schoolVideoVC animated:YES];
            
        }
  
    }else{
        [SVProgressHUD showInfoWithStatus:@"请用账号登录后查看"];
    }
    

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectio{
    return 0.000001;
}

//返回
- (void)backClick{
    
  [self dismissViewControllerAnimated:YES completion:nil];
}



-(void)collectbtn:(UIButton *)btn{
    
    if ([XXEUserInfo user].login) {
        
        if (_isCollected== NO) {
            
            [self collectArticle];
            
        }
        else  if (_isCollected== YES) {
            [self deleteCollectArticle];
            
        }
    }else{
        [SVProgressHUD showInfoWithStatus:@"请用账号登录后查看"];
    }
    
}

//收藏机构
- (void)collectArticle
{
    /*
     接口:
     http://www.xingxingedu.cn/Global/collect
     
     传参:
     collect_id	//收藏id
     collect_type	//收藏品种类型	1:商品  2:点评  3:老师  4:课程  5:学校
     */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/collect";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];

    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"collect_id":_schoolIdStr,
                           @"collect_type":@"5",
                           
                           };
    //    NSLog(@"%@",dict);
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
        
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             [SVProgressHUD showSuccessWithStatus:@"收藏课程成功"];
             UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
             [rightButton setBackgroundImage:[UIImage imageNamed:@"commentInfo10.png"] forState:UIControlStateNormal];
             UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
             self.navigationItem.rightBarButtonItem= rightItem;
             [rightButton addTarget:self action:@selector(collectbtn:)forControlEvents:UIControlEventTouchUpInside];
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
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/deleteCollect";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"collect_id":_schoolIdStr,
                           @"collect_type":@"5",
                           
                           };
    //    NSLog(@"%@",dict);
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] ){
             [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];
             UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
             [rightButton setBackgroundImage:[UIImage imageNamed:@"commentInfo9.png"] forState:UIControlStateNormal];
             UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
             self.navigationItem.rightBarButtonItem= rightItem;
             [rightButton addTarget:self action:@selector(collectbtn:)forControlEvents:UIControlEventTouchUpInside];
             _isCollected=!_isCollected;
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}



@end

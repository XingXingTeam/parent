


//
//  CourseViewController.m
//  XingXingEdu
//
//  Created by Mac on 16/5/9.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "CourseViewController.h"
#import "CourseTableViewCell.h"
#import "HHControl.h"
#import "ClassRoomSubjectInfoViewController.h"
#import "StarRemarkViewController.h"

#import "WZYHttpTool.h"

#define COURSE @"CourseTableViewCell"

#define kScreenWidth self.view.frame.size.width
#define kScreenHeight self.view.frame.size.height
#define Space 10


@interface CourseViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSString *parameterXid;
    NSString *parameterUser_Id;

}
@property (nonatomic, strong) UIView *headView;

@property (nonatomic) NSMutableArray *bookIconArray;
@property (nonatomic) NSMutableArray *courseNameArray;
@property (nonatomic) NSMutableArray *teacherNameArray;
@property (nonatomic) NSMutableArray *timeArray;
@property (nonatomic) NSMutableArray *totalNumberArray;
@property (nonatomic) NSMutableArray *numberArray;
@property (nonatomic) NSMutableArray *oldPriceArray;
@property (nonatomic) NSMutableArray *nowPriceArray;

@property (nonatomic) UITableView *myTableView;

@property (nonatomic) UIImageView *backgroundImageView;
@property (nonatomic) UIImageView *iconImageView;
@property (nonatomic, strong) MBProgressHUD *HUDSave;


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
//课程
@property (nonatomic) NSMutableArray *course_groupArray;
//课程 id
//@property (nonatomic, copy) NSString *course_id;
//课程 id 数组
@property (nonatomic) NSMutableArray *course_idArray;

@property (nonatomic, copy) NSString *schoolIdStr;

@end

@implementation CourseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _bookIconArray = [[NSMutableArray alloc] init];
        _courseNameArray = [[NSMutableArray alloc] init];
        _teacherNameArray = [[NSMutableArray alloc] init];
        _timeArray = [[NSMutableArray alloc] init];
        _numberArray = [[NSMutableArray alloc] init];
        _totalNumberArray = [[NSMutableArray alloc] init];
        _oldPriceArray = [[NSMutableArray alloc] init];
        _nowPriceArray = [[NSMutableArray alloc] init];
        _course_groupArray = [[NSMutableArray alloc] init];
        _course_idArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}

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

    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0, 170, 42)];
    
    self.myTableView.backgroundColor = UIColorFromRGB(229, 232, 233);

    [self settingNavgiationBar];
    
//    [self fetchNetData];

    [self.view addSubview:self.myTableView];

}

- (void)settingNavgiationBar{
    //1、设置 navigationBar 左边 返回
    UIImage *backImage = [UIImage imageNamed:@"首页90x38"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage: backImage  style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    
    //    2、设置 navigationBar 标题 颜色
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    
//    //3、设置 navigationBar 右边 收藏
//    UIButton *saveButton = [HHControl createButtonWithFrame:CGRectMake(kScreenWidth - 100, 0, 22, 22) backGruondImageName:@"收藏icon44x44" Target:self Action:@selector(saveButtonClick:) Title:nil];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
//    self.navigationItem.rightBarButtonItem = rightItem;


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
    
    //请求参数
    //获取学校id数组
    NSString *schoolIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"SCHOOL_ID"];
//    _schoolIdStr = schoolIdStr;
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"school_id":schoolIdStr};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
//                NSLog(@"=================%@", responseObj);
        NSDictionary *dic = responseObj[@"data"];
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
        
        //课程
        _course_groupArray = dic[@"course_group"];
        
//        if (_course_groupArray.count != 0) {
//                    }
        
        if (_course_groupArray.count == 0) {
            // 1、无数据的时候
            UIImage *myImage = [UIImage imageNamed:@"人物"];
            CGFloat myImageWidth = myImage.size.width;
            CGFloat myImageHeight = myImage.size.height;
            
            UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - myImageWidth / 2, 300, myImageWidth, myImageHeight)];
            myImageView.image = myImage;
            [self.view addSubview:myImageView];
            
        }else{

            for (NSDictionary *dic in _course_groupArray) {
                
                //course_id
                NSString *course_id = dic[@"id"];
                [_course_idArray addObject:course_id];
                
                //书籍 icon
                NSString *bookIconUrlStr = [NSString stringWithFormat:@"%@%@", picURL, dic[@"course_pic"]];
                [_bookIconArray addObject:bookIconUrlStr];
                
                //课程名称
                NSString *courseName = dic[@"course_name"];
                [_courseNameArray addObject:courseName];
                
                //                //老师 名称
                NSArray *teacherNameArr = dic[@"teacher_tname_group"];
                [_teacherNameArray addObject:teacherNameArr];
                
                //开班 总人数
                NSString *totalNumber = [NSString stringWithFormat:@"%@人班级", dic[@"need_num"]];
                [_totalNumberArray addObject:totalNumber];
                
                //开班 已报名人数
                NSString *number = dic[@"now_num"];
                [_numberArray addObject:number];
                
                //原价
                NSString *oldPrice = dic[@"original_price"];
                [_oldPriceArray addObject:oldPrice];
                
                //现价
                NSString *nowPrice = dic[@"now_price"];
                [_nowPriceArray addObject:nowPrice];
                
            }
        }
        [self createImageView];
        
        [self.myTableView reloadData];
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];
    
}



- (void)createImageView{
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 120 * kWidth / 375)];
    _headView.backgroundColor = UIColorFromRGB(0, 170, 42);
    
    //设置头像
    CGFloat iconWidth = 87.0 * kWidth / 375;
    CGFloat iconHeight = 87.0 * kWidth / 375;
    
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.frame = CGRectMake(iconWidth / 4, _headView.frame.size.height / 2 - iconHeight / 2, iconWidth, iconHeight);
    //    _iconImageView.image = [UIImage imageNamed:@"头像174x174@2x.png"];
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picURL, _logoIconStr]] placeholderImage:[UIImage imageNamed:@"头像174x174"]];
    
    _iconImageView.layer.cornerRadius = iconWidth / 2;
    _iconImageView.layer.masksToBounds = YES;
    
    [_headView addSubview:_iconImageView];
    
    //设置头像右边文字
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconWidth * 1.4, _headView.frame.size.height / 2 - iconHeight / 2, 150 * kWidth / 375, 30 * kWidth / 375)];
    //    titleLabel.text = @"北京大学";
    titleLabel.text = _schoolNameStr;
    titleLabel.font = [UIFont systemFontOfSize:16 * kWidth / 375];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [_headView addSubview:titleLabel];
    
    //星级评分
    UIButton *starRankButton = [UIButton buttonWithType:UIButtonTypeCustom];
    starRankButton.frame = CGRectMake(iconWidth * 1.4, _headView.frame.size.height / 2 - iconHeight / 2 + 30 * kWidth / 375, 100 * kWidth / 375, 40 * kWidth / 375);
    starRankButton.backgroundColor = [UIColor clearColor];
    
    NSString *str1 = _score_num;
    [starRankButton setTitle:[NSString stringWithFormat:@"星级评分:%.2f", str1.floatValue] forState:UIControlStateNormal];
    [starRankButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [starRankButton addTarget:self action:@selector(starRankButtonClick) forControlEvents:UIControlEventTouchUpInside];
    starRankButton.titleLabel.font = [UIFont boldSystemFontOfSize:14 * kWidth / 375];
    starRankButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_headView addSubview:starRankButton];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 30 * kWidth / 375, 95 * kWidth / 375, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [starRankButton addSubview:lineView];
    
    
    //浏览
    UILabel *browseLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconWidth * 1.4 + 100 * kWidth / 375, _headView.frame.size.height / 2 - iconHeight / 2 + 40 * kWidth / 375, 80 * kWidth / 375, 20 * kWidth / 375)];
    browseLabel.backgroundColor = [UIColor clearColor];
    NSString *str2 = _read_num;
    browseLabel.text = [NSString stringWithFormat:@"浏览:%@", str2];
    browseLabel.textColor = [UIColor whiteColor];
    browseLabel.font = [UIFont boldSystemFontOfSize:14 * kWidth / 375];
    [_headView addSubview:browseLabel];
    
    
    //收藏
    UILabel *collectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconWidth * 1.4 + 100 * kWidth / 375 + 80 * kWidth / 375, _headView.frame.size.height / 2 - iconHeight / 2 + 40 * kWidth / 375, 100 * kWidth / 375, 20 * kWidth / 375)];
    collectionLabel.backgroundColor = [UIColor clearColor];
    NSString *str3 = _collect_num;
    collectionLabel.text = [NSString stringWithFormat:@"收藏:%@", str3];
    collectionLabel.textColor = [UIColor whiteColor];
    collectionLabel.font = [UIFont boldSystemFontOfSize:14 * kWidth / 375];
    //    collectionLabel.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:10];
    
    [_headView addSubview:collectionLabel];
    
    [self.view addSubview:_headView];
}

- (void)starRankButtonClick{
    if ([XXEUserInfo user].login) {
        
        StarRemarkViewController *starRemarkVC = [[StarRemarkViewController alloc] init];
        starRemarkVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:starRemarkVC animated:YES];
  
    }else{
        [SVProgressHUD showInfoWithStatus:@"请用账号登录后查看"];
    }
    
}



- (UITableView *)myTableView{
    if (_myTableView == nil) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120 * kWidth / 375, kScreenWidth, kScreenHeight - 49 - 120 * kWidth / 375) style:UITableViewStyleGrouped];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
    }
    return _myTableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _course_groupArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    
    CourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CourseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    
    cell.bookIconImage.layer.cornerRadius= cell.bookIconImage.bounds.size.width/2;
    cell.bookIconImage.layer.masksToBounds=YES;
    [cell.bookIconImage sd_setImageWithURL:[NSURL URLWithString:_bookIconArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"sdimg1.png"]];

//
    cell.courseNameLabel.text = self.courseNameArray[indexPath.row];
    
    if ([_teacherNameArray[indexPath.row] count] != 0) {
        
        for (int i = 0; i < [_teacherNameArray[indexPath.row] count]; i++) {
            UILabel *teacherNameLabel = [HHControl createLabelWithFrame:CGRectMake((190 + 65 * i) * kWidth / 375, 35 , 60 * kWidth / 375, 20) Font:14 * kWidth / 375 Text:_teacherNameArray[indexPath.row][i]];
            [cell.contentView addSubview:teacherNameLabel];
        }
        
    }

    cell.totalNumberLabel.text = [NSString stringWithFormat:@"%@", _totalNumberArray[indexPath.row]];
    cell.numberLabel.text = [NSString stringWithFormat:@"还剩%@人", self.numberArray[indexPath.row]];
    cell.oldPriceLabel.text = [NSString stringWithFormat:@"原价:%@", self.oldPriceArray[indexPath.row]];
    cell.nowPriceLbl.text = [NSString stringWithFormat:@"限时抢购价:%@", self.nowPriceArray[indexPath.row]];

//    cell.coinImageView.image = [UIImage imageNamed:@"猩币icon28x30"];
//    cell.reduceImageView.image = [UIImage imageNamed:@"退icon28x30@2x.png"];
//    cell.saveImageView.image = [UIImage imageNamed:@"收藏icon28x30"];
    cell.fullImageView.image = [UIImage imageNamed:@"满班icon28x30"];
    if ([self.numberArray[indexPath.row] integerValue] != 0) {
        cell.fullImageView.hidden = YES;
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([XXEUserInfo user].login) {
        
        ClassRoomSubjectInfoViewController *classRoomSubjectInfoVC = [[ClassRoomSubjectInfoViewController alloc] init];
        
        classRoomSubjectInfoVC.courseId = _course_idArray[indexPath.row];
        
        //    NSLog(@"%@", classRoomSubjectInfoVC.courseId);
        classRoomSubjectInfoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:classRoomSubjectInfoVC animated:YES];
    }else{
        [SVProgressHUD showInfoWithStatus:@"请用账号登录后查看"];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.00000001;
}


//返回
- (void)backClick{
[self dismissViewControllerAnimated:YES completion:nil];

}


@end

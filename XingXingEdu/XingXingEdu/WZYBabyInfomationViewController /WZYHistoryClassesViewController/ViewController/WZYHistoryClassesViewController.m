//
//  WZYHistoryClassesViewController.m
//  XingXingEdu
//
//  Created by Mac on 16/5/11.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "WZYHistoryClassesViewController.h"
#import "WZYHistoryClassesTableViewCell.h"
#import "CourseDetailViewController.h"


#define COURSE @"WZYHistoryClassesTableViewCell"
#define kScreenWidth self.view.frame.size.width
#define kScreenHeight self.view.frame.size.height
#define Space 10

@interface WZYHistoryClassesViewController ()<UITableViewDataSource, UITableViewDelegate>
{

    //请求参数
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@property (nonatomic) NSMutableArray *iconImageViewArray;
@property (nonatomic) NSMutableArray *stateImageViewArray;
@property (nonatomic) NSMutableArray *courseNameArray;
@property (nonatomic) NSMutableArray *schoolNameArray;
@property (nonatomic) NSMutableArray *teacherNameArray;
@property (nonatomic) NSMutableArray *addressArray;
@property (nonatomic) NSMutableArray *targetArray;
@property (nonatomic, strong) UIImageView *placeholderImageView;

@property (nonatomic) NSMutableArray *courseTimeArray;


@property (nonatomic) UIImageView *courseState;
@property (nonatomic) NSString *courseName;
@property (nonatomic) NSString *teacherName;
@property (nonatomic) NSString *schoolName;

@property (nonatomic) UITableView *myTableView;

@end

@implementation WZYHistoryClassesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }

        self.view.backgroundColor = [UIColor whiteColor];
        
        [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0, 170, 42)];

        self.myTableView.backgroundColor = UIColorFromRGB(229, 232, 233);
    //设置 navigationBar 左边 返回
    UIImage *backImage = [UIImage imageNamed:@"返回icon90x38"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage: backImage  style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    
        self.title = @"班级历史";
        //设置 navigationBar 标题 颜色
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    [self fetchNetData];
    
    [self createTableView];
    }

- (void)fetchNetData{

/*
 【孩子班级历史列表】
 ★注:班级详情(课程详情)不额外给接口了,请从这边的数据页面传递
 接口:
 http://www.xingxingedu.cn/Parent/baby_class_all 已修改  原来的grade和class  改成了 class_name和class_id ,里面的class_name是班级名,已经拼装好了
 传参:
	baby_id		//孩子id (单页测试可以填3)
 */

    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/baby_class_all";
    
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE,
                             @"baby_id":_babyId  };
    
//    NSLog(@"gggg  %@", params);
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        self.iconImageViewArray = [[NSMutableArray alloc] init];
//        self.stateImageViewArray = [[NSMutableArray alloc]init];
        self.schoolNameArray = [[NSMutableArray alloc] init];
        self.courseNameArray = [[NSMutableArray alloc] init];
        self.teacherNameArray = [[NSMutableArray alloc] init];
        self.courseTimeArray = [[NSMutableArray alloc] init];
        self.addressArray = [[NSMutableArray alloc] init];
        self.targetArray = [[NSMutableArray alloc] init];
        //
//        NSLog(@"11%@", responseObj);
        
 if([[NSString stringWithFormat:@"%@",responseObj[@"code"]]isEqualToString:@"1"] ){
        
        if ([responseObj[@"data"] count] != 0 ) {

            NSArray *dataArray = responseObj[@"data"];
            
            for (NSDictionary *dic in dataArray) {
                
                //如果是 培训机构
                if ([[NSString stringWithFormat:@"%@",dic[@"sch_type"]] isEqualToString:@"4"]) {
                    //课程名称 grade 抽象设计
                    
//                    NSString *courseNameStr = [NSString stringWithFormat:@"%@%@",dic[@"grade"], dic[@"class"]];
                    
                    NSString *courseNameStr = dic[@"class_name"];
                    
                    [_courseNameArray addObject:courseNameStr];
                    
                    NSDictionary *course_infoDic = dic[@"course_info"];
                    
                    //课程目标
                    [_targetArray addObject:course_infoDic[@"teach_goal"]];
                    
                    //上课地址
                    [_addressArray addObject:course_infoDic[@"address"]];
                    
                    //课程 时间
                    //开始 时间
                    NSString *startTime = [WZYTool dateStringFromNumberTimer:course_infoDic[@"course_start_tm"]];
                    
                    //结束 时间
                    NSString *endTime = [WZYTool dateStringFromNumberTimer:course_infoDic[@"course_end_tm"]];
                    
                    NSString *courseTimeStr = [NSString stringWithFormat:@"%@——%@", startTime, endTime];
                    
                    [_courseTimeArray addObject:courseTimeStr];
                }else{
                    //课程名称 几年级 几班
                    
                    NSString *courseNameStr = dic[@"class_name"];
                    
                    [_courseNameArray addObject:courseNameStr];
                    
                    //课程 目标
                    [_targetArray addObject:@""];
                    
                    //上课 地址
                    [_addressArray addObject:@""];
                    
                    //上课 时间
                    [_courseTimeArray addObject:@""];
                    
                }
                
                //学校 logo
                NSString *iconStr = [NSString stringWithFormat:@"%@%@", picURL, dic[@"school_logo"]];
                
                [self.iconImageViewArray addObject:iconStr];
                
                //学校名称
                [self.schoolNameArray addObject:dic[@"school_name"]];
                //老师名称
                [self.teacherNameArray addObject:dic[@"teacher"]];
                
            }
            
        }
 }
        
        [self customContentView];
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];


}

// 有数据 和 无数据 进行判断
- (void)customContentView{
    
    if (_iconImageViewArray.count == 0) {
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // 1、无数据的时候
        [self createPlaceholderView];
        
    }else{
        
    }
    
    [_myTableView reloadData];
}


//没有 数据 时,创建 占位图
- (void)createPlaceholderView{
    
    // 1、无数据的时候
    UIImage *myImage = [UIImage imageNamed:@"人物"];
    CGFloat myImageWidth = myImage.size.width;
    CGFloat myImageHeight = myImage.size.height;
    
    _placeholderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - myImageWidth / 2, (kHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
    _placeholderImageView.image = myImage;
    [self.view addSubview:_placeholderImageView];
}

- (void)createTableView{

    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    
    [self.view addSubview:_myTableView];

}


    
#pragma mark - UITableViewDataSource
    - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 1;
        
    }

    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        
        return self.schoolNameArray.count;
    }
    
    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        WZYHistoryClassesTableViewCell *cell =(WZYHistoryClassesTableViewCell*)[tableView dequeueReusableCellWithIdentifier:COURSE];
        if (cell == nil) {
            NSArray *nib =[[NSBundle mainBundle] loadNibNamed:COURSE owner:[WZYHistoryClassesTableViewCell class] options:nil];
            cell =(WZYHistoryClassesTableViewCell *)[nib objectAtIndex:0];
        }
        
        cell.lineImageView.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0];
        
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:_iconImageViewArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"LOGO172x172"]];
        
        cell.courseNameLabel.text = self.courseNameArray[indexPath.row];
        
        cell.schoolNameLabel.text = self.schoolNameArray[indexPath.row];
        cell.teacherNameLabel.text = self.teacherNameArray[indexPath.row];
        
        return cell;
    }
    
    
    - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 100;
    }
    
    - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        CourseDetailViewController *courseDetailVC = [[CourseDetailViewController alloc] init];
        
        courseDetailVC.courseStr = _courseNameArray[indexPath.row];
        
        courseDetailVC.schoolStr = self.schoolNameArray[indexPath.row];
        courseDetailVC.teacherStr = self.teacherNameArray[indexPath.row];

        courseDetailVC.courseTimeStr = self.courseTimeArray[indexPath.row];

        courseDetailVC.targetStr = self.targetArray[indexPath.row];

        courseDetailVC.addressStr = self.addressArray[indexPath.row];
        
        [self.navigationController pushViewController:courseDetailVC animated:YES];
    }

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00000001;
}


- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

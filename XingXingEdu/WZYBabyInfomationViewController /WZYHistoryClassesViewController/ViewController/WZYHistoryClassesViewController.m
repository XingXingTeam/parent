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

@property (nonatomic) NSMutableArray *iconImageViewArray;
@property (nonatomic) NSMutableArray *stateImageViewArray;
@property (nonatomic) NSMutableArray *courseNameArray;
@property (nonatomic) NSMutableArray *schoolNameArray;
@property (nonatomic) NSMutableArray *teacherNameArray;
@property (nonatomic) NSMutableArray *addressArray;
@property (nonatomic) NSMutableArray *targetArray;

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

        self.view.backgroundColor = [UIColor whiteColor];
        
        [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0, 170, 42)];

        self.myTableView.backgroundColor = UIColorFromRGB(229, 232, 233);
//        self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
 http://www.xingxingedu.cn/Parent/baby_class_all
 
 http://www.xingxingedu.cn/Parent/baby_class_all 已修改  原来的grade和class  改成了 class_name和class_id ,里面的class_name是班级名,已经拼装好了
 
 传参:
	baby_id		//孩子id (单页测试可以填3)
 */

    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/baby_class_all";
    
    //请求参数

    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":XID, @"user_id":USER_ID, @"user_type":USER_TYPE, @"baby_id":_babyId};
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
        /*
         {
         school_name = 上海梅花琴行,
         school_logo = app_upload/text/school_logo/2.jpg,
         grade = 1,
         class = 1,
         teacher = ,
         sch_type = 2,
         school_id = 2,
         course_id = 0
         },
         
         {
         msg = Success!,
         data = [
         {
         class_name = 一年级一班,
         school_name = 上海桃园小学,
         school_logo = app_upload/text/school_logo/3.jpg,
         sch_type = 2,
         class_id = 1,
         teacher = 李小川,赵大京等
         },
         {
         school_logo = app_upload/text/school_logo/9.jpg,
         class_id = 6,
         course_info = {
         course_end_tm = 1469197548,
         teach_goal = 陶冶情操,
         course_start_tm = 1466032366,
         course_time = [
         {
         sch_tm_end = 10:30,
         sch_tm_start = 09:00,
         week_date = 6
         },
         {
         sch_tm_end = 14:30,
         sch_tm_start = 13:00,
         week_date = 6
         },
         {
         sch_tm_end = 15:25,
         sch_tm_start = 13:55,
         week_date = 5
         }
         ],
         address = 上海市浦东新区张扬北路100号
         },
         class_name = 二年级一班,
         teacher = 董璐梅,夏雨荷,
         sch_type = 4,
         school_name = 雨墨轩
         },
         {
         school_logo = app_upload/text/school_logo/13.jpg,
         class_id = 10,
         course_info = {
         course_end_tm = 1463197548,
         teach_goal = 陶冶情操,
         course_start_tm = 1460864748,
         course_time = [
         {
         sch_tm_end = 20:30,
         sch_tm_start = 19:00,
         week_date = 1
         },
         {
         sch_tm_end = 20:30,
         sch_tm_start = 19:00,
         week_date = 2
         }
         ],
         address = 上海市浦东新区金京路346号
         },
         class_name = 二年级五班,
         teacher = 韩可可,
         sch_type = 4,
         school_name = 永新艺术
         }
         ],
         code = 1
         }

         
         */
        
        if ([responseObj[@"data"] count] == 0 ) {
        
            // 1、无数据的时候
            UIImage *myImage = [UIImage imageNamed:@"人物"];
            CGFloat myImageWidth = myImage.size.width;
            CGFloat myImageHeight = myImage.size.height;
            
            UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - myImageWidth / 2, kHeight / 2 - myImageWidth / 2, myImageWidth, myImageHeight)];
            myImageView.image = myImage;
            [self.view addSubview:myImageView];
            
        }else{
        
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
            
            [_myTableView reloadData];
            
        }
        
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];


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

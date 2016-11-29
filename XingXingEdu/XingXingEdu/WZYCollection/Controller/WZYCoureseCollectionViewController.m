//
//  WZYCoureseCollectionViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/6/14.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "WZYCoureseCollectionViewController.h"

#import "WZYCoureseCollectionTableViewCell.h"

#define COURSE @"WZYCoureseCollectionTableViewCell"

#define kScreenWidth self.view.frame.size.width
#define kScreenHeight self.view.frame.size.height
#define Space 10

@interface WZYCoureseCollectionViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *idArray;
    NSMutableArray *courseNameArray;
    NSMutableArray *priceArray;
    NSMutableArray *timeArray;
    NSMutableArray *iconArray;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;

}

@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, copy) NSString *collectionId;

@end

@implementation WZYCoureseCollectionViewController

- (void)viewWillAppear:(BOOL)animated{

    [_myTableView reloadData];

}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    [_myTableView.header beginRefreshing];

}

- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0, 170, 42)];
    self.myTableView.backgroundColor = UIColorFromRGB(229, 232, 233);
    //    self.myTableView.separatorStyle = UITableViewCellAccessoryNone;

    
    //    2、设置 navigationBar 标题 颜色
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }

    [self createTableView];
}


- (void)createTableView{

    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight - 64 - 15) style:UITableViewStyleGrouped];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;

    [self.view addSubview:_myTableView];
    
    _myTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];

}

- (void)loadNewData{

    [self fetchNetData];
    
    [_myTableView.header endRefreshing];

}

- (void)endRefresh{

    [_myTableView.header endRefreshing];

}

- (void)fetchNetData{

    /*
     【我的收藏---课程】
     
     接口:
     http://www.xingxingedu.cn/Global/col_course_list
     
     传参:     */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/col_course_list";
    
    //请求参数  无
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        
        idArray = [[NSMutableArray alloc] init];
        courseNameArray = [[NSMutableArray alloc] init];
        priceArray = [[NSMutableArray alloc] init];
        timeArray =[[NSMutableArray alloc] init];
        iconArray = [[NSMutableArray alloc] init];
        //
//                NSLog(@"sssss%@", responseObj);
        
        /*
         {
         id = 3,
         course_name = 钢琴进阶全日班,
         now_price = 2300,
         pic = app_upload/text/course/lesson2.jpg,
         date_tm = 1466504948
         }
         */
        NSArray *dataSource = responseObj[@"data"];
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            for (NSDictionary *dic in dataSource) {
                
                [idArray addObject:dic[@"id"]];
                
                [courseNameArray addObject:dic[@"course_name"]];
                
                NSString *priceStr = [NSString stringWithFormat:@"%@元", dic[@"now_price"]];
                [priceArray addObject:priceStr];
                
                NSString *timeStr = [WZYTool dateStringFromNumberTimer:dic[@"date_tm"]];
                [timeArray addObject:timeStr];
                
                NSString *picStr = [NSString stringWithFormat:@"%@%@", picURL, dic[@"pic"]];
                [iconArray addObject:picStr];
            }
            
            
        }else{
    
        
        }
        
        [_myTableView reloadData];
        
    } failure:^(NSError *error) {
        //
        
        NSLog(@"%@", error);
    }];

}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return idArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WZYCoureseCollectionTableViewCell *cell =(WZYCoureseCollectionTableViewCell*)[tableView dequeueReusableCellWithIdentifier:COURSE];
    if (cell == nil) {
        NSArray *nib =[[NSBundle mainBundle] loadNibNamed:COURSE owner:[WZYCoureseCollectionTableViewCell class] options:nil];
        cell =(WZYCoureseCollectionTableViewCell *)[nib objectAtIndex:0];
    }
    
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"sdimg1.png"]];
    cell.courseNameLabel.text = courseNameArray[indexPath.row];
    
    cell.priceLabel.text = priceArray[indexPath.row];
    
    cell.timeLabel.text = timeArray[indexPath.row];

    
    //添加 长按 取消 收藏
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressClick:)];
    
    [cell.contentView addGestureRecognizer:longPress];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    ClassRoomSubjectInfoViewController *classRoomSubjectInfoVC = [[ClassRoomSubjectInfoViewController alloc] init];
//    classRoomSubjectInfoVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:classRoomSubjectInfoVC animated:YES];
//    
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.00000001;
}

- (void)longPressClick:(UILongPressGestureRecognizer *)longPress{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"取消收藏" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
        WZYCoureseCollectionTableViewCell *cell = (WZYCoureseCollectionTableViewCell *)[longPress.view superview];
        
        NSIndexPath *path = [_myTableView indexPathForCell:cell];
        
        _collectionId = idArray[path.row];
        
        [self cancelCollection];
        
        [_myTableView.header beginRefreshing];
        
        [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];
        
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:doneAction];
    [self presentViewController:alertController animated:YES completion:nil];

}


- (void)cancelCollection{
    
    /*
     接口:
     http://www.xingxingedu.cn/Global/deleteCollect
     
     传参:
     collect_id	//收藏id (如果是收藏用户,这里是xid)
     collect_type	//收藏品种类型	1:商品  2:点评  3:用户  4:课程  5:学校  6:花朵
     */
    
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/deleteCollect";
    
    //请求参数
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"collect_id":_collectionId, @"collect_type":@"4"};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        
        //        NSLog(@"yyyyy%@", responseObj);
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];
    
    
}


@end

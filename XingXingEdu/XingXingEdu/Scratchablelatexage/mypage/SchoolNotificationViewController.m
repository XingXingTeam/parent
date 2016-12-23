//
//  SchoolNotificationViewController.m
//  teacher
//
//  Created by codeDing on 16/12/13.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "SchoolNotificationViewController.h"
//#import "XXESchoolNotificationApi.h"
#import "XXESchoolNotificationModel.h"
//#import "XXERedFlowerSentHistoryTableViewCell.h"
#import "XXESchoolNotificationDetailViewController.h"
#import "NotificationService.h"
#import "XXERedFlowerSentHistoryTableViewCell.h"

@interface SchoolNotificationViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    
    UITableView *_myTableView;
    //学校通知 数据
    NSMutableArray *_schoolDataSourceArray;
    //学校通知 page
    NSInteger schoolPage;
    //身份
    NSString *position;
    //数据请求参数
    NSString *parameterXid;
    NSString *parameterUser_Id;
    //无数据 时 的占位图
    UIImageView *placeholderImageView;
    
}
@property(nonatomic ,strong)EmptyView *empty;
@end

@implementation SchoolNotificationViewController

-(EmptyView *)empty {
    if (!_empty) {
        CGRect frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64);
        _empty = [EmptyView conveniceWithTitle:@"您目前接收不到校园通知" frame:frame];
        [_myTableView addSubview:_empty];
        _empty.hidden = YES;
    }
    
    return _empty;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_myTableView.header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    
    _schoolDataSourceArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = XXEBackgroundColor;
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
//    position = [DEFAULTS objectForKey:@"POSITION"];
    [self createTableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
    
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.rowHeight = 95;
    [self.view addSubview:_myTableView];
    
    _myTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    _myTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooterNewData)];
    
}

-(void)loadNewData{
    schoolPage ++;
    [self fetchSchoolNetData];
    [ _myTableView.header endRefreshing];
}
-(void)endRefresh{
    [_myTableView.header endRefreshing];
    [_myTableView.footer endRefreshing];
}

- (void)loadFooterNewData{
    schoolPage ++;
    [self fetchSchoolNetData];
    [ _myTableView.footer endRefreshing];
    
}


//校园通知
- (void)fetchSchoolNetData{
    /*
     传参:
     school_id	//学校id (测试值:1)
     class_id	//班级id (测试值:1)
     position	//身份 1,2,3,4 (校长和管理身份不需要传class_id)
     page		//页码,不传值默认1
     */
        self.empty.hidden = YES;
        if (self.schoolInfo == SchoolInfoNone) {
            self.empty.hidden = NO;
            return;
        }
    
    NSString *pageStr = [NSString stringWithFormat:@"%ld", (long)schoolPage];
    
    //    NSLog(@"pageStr === %@", pageStr);
    
    NSDictionary *parameters = @{
                                 @"appkey":APPKEY,
                                 @"backtype":BACKTYPE,
                                 @"xid":parameterXid,
                                 @"user_id":parameterUser_Id,
                                 @"user_type":USER_TYPE,
                                 @"class_id":self.classId,
                                 @"school_id":self.schoolId,
                                 @"baby_id":self.babyId,
                                 @"page":pageStr
                                 };

    [kNotificationServiceInstance schoolNotificationRequestWithparameters:parameters succeed:^(id request) {
            NSDictionary *dict = request;
            if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
            {
                NSArray *modelArray = [XXESchoolNotificationModel parseResondsData:dict[@"data"]];
                [_schoolDataSourceArray addObjectsFromArray:modelArray];
        
            }else{
            
            }
              [self customContent];
            
    } fail:^{
        [SVProgressHUD showInfoWithStatus:@"数据获取失败,请检查网络!"];
    }];
    
    
    
}

// 有数据 和 无数据 进行判断
- (void)customContent{
    // 如果 有占位图 先 移除
    [self removePlaceholderImageView];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    dataArray = _schoolDataSourceArray;
    
    if (dataArray.count == 0) {
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
    UIImage *myImage = [UIImage imageNamed:@"all_placeholder"];
    CGFloat myImageWidth = myImage.size.width;
    CGFloat myImageHeight = myImage.size.height;
    
    placeholderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - myImageWidth / 2, (kHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
    placeholderImageView.image = myImage;
    [self.view addSubview:placeholderImageView];
}

//去除 占位图
- (void)removePlaceholderImageView{
    if (placeholderImageView != nil) {
        [placeholderImageView removeFromSuperview];
    }
}

#pragma mark
#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    dataArray = _schoolDataSourceArray;
    return dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXERedFlowerSentHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXERedFlowerSentHistoryTableViewCell" owner:self options:nil]lastObject];
    }
    
    XXESchoolNotificationModel * model = _schoolDataSourceArray[indexPath.row];
    cell.iconImageView.layer.cornerRadius =cell.iconImageView.bounds.size.width/2;
    cell.iconImageView.layer.masksToBounds =YES;
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kXXEPicURL,model.school_logo]] placeholderImage:[UIImage imageNamed:@"school_logo"]];
    cell.titleLabel.text = model.school_name;
    cell.contentLabel.text = model.title;
    cell.timeLabel.text = [XXETool dateStringFromNumberTimer:model.date_tm];
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XXESchoolNotificationDetailViewController *schoolNotificationDetailVC =[[XXESchoolNotificationDetailViewController alloc]init];
    XXESchoolNotificationModel *model = _schoolDataSourceArray[indexPath.row];
    
    schoolNotificationDetailVC.name = model.school_name;
    //[type] => 2		//通知范围需要  1:班级通知, 2:学校通知
    if ([model.type integerValue] == 1) {
        schoolNotificationDetailVC.scope = @"班级通知";
    }else if ([model.type integerValue] == 2){
        schoolNotificationDetailVC.scope = @"学校通知";
    }
    
    
    schoolNotificationDetailVC.time =[XXETool dateStringFromNumberTimer:model.date_tm];
    schoolNotificationDetailVC.content = model.con;
    schoolNotificationDetailVC.titleStr = model.title;
    [self.navigationController pushViewController:schoolNotificationDetailVC animated:YES];
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

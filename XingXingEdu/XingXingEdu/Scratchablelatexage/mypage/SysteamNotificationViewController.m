//
//  SysteamNotificationViewController.m
//  teacher
//
//  Created by codeDing on 16/12/13.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "SysteamNotificationViewController.h"
#import "XXESystemNotificationModel.h"
#import "XXERedFlowerSentHistoryTableViewCell.h"
#import "XXESystemNotificationDetailViewController.h"
#import "NotificationService.h"

@interface SysteamNotificationViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_myTableView;
    //系统通知 数据
    NSMutableArray *_systemDataSourecArray;
    //系统通知 page
    NSInteger systemPage;
    //身份
    NSString *position;
    //数据请求参数
    NSString *parameterXid;
    NSString *parameterUser_Id;
    //无数据 时 的占位图
    UIImageView *placeholderImageView;
    
}
//@property (nonatomic, strong)EmptyView *empty;
@end

@implementation SysteamNotificationViewController

//-(EmptyView *)empty {
//    if (!_empty) {
//        CGRect frame = CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64);
//        _empty = [EmptyView conveniceWithTitle:@"您暂时没有系统消息" frame:frame];
//        [_myTableView addSubview:_empty];
//        _empty.hidden = YES;
//    }
//    
//    return _empty;
//}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_myTableView.header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XXEBackgroundColor;
    _systemDataSourecArray = [[NSMutableArray alloc] init];
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    position = [DEFAULTS objectForKey:@"POSITION"];
    [self createTableView];
    
    // Do any additional setup after loading the view.
}

//系统通知
- (void)fetchSystemNetData{
    /*
     【系统消息】
     接口类型:1
     接口:
     http://www.xingxingedu.cn/Global/official_notice
     传参:
     app_type	//1:家长端, 2:教师端
     page		//页码,加载更多, 默认1
     */
    
    
    
    NSString *pageStr = [NSString stringWithFormat:@"%ld", (long)systemPage];
    
    NSDictionary * pragm = @{ @"appkey":APPKEY,
                              @"backtype":BACKTYPE,
                              @"xid":parameterXid,
                              @"user_id":parameterUser_Id,
                              @"user_type":USER_TYPE,
                              @"app_type":@"2",//1:家长端, 2:教师端
                              @"page":pageStr,
                              };
    [kNotificationServiceInstance systemNotificationRequestWithparameters:pragm succeed:^(id request) {
        
//        self.empty.hidden = YES;
        
        NSDictionary *dict = request;
        
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
            NSArray *modelArray = [XXESystemNotificationModel parseResondsData:dict[@"data"]];
            [_systemDataSourecArray addObjectsFromArray:modelArray];
        }else{
            
        }
        [self customContent];
        
    } fail:^{
//        self.empty.hidden = NO;
        [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络"];
    }];
}

// 有数据 和 无数据 进行判断
- (void)customContent{
    // 如果 有占位图 先 移除
    [self removePlaceholderImageView];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    dataArray = _systemDataSourecArray;
    
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
    systemPage ++;
    [self fetchSystemNetData];
    [ _myTableView.header endRefreshing];
}
-(void)endRefresh{
    [_myTableView.header endRefreshing];
    [_myTableView.footer endRefreshing];
}

- (void)loadFooterNewData{
    systemPage ++;
    [self fetchSystemNetData];
    [ _myTableView.footer endRefreshing];
    
}

#pragma mark
#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    dataArray = _systemDataSourecArray;
    return dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXERedFlowerSentHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXERedFlowerSentHistoryTableViewCell" owner:self options:nil]lastObject];
    }
    XXESystemNotificationModel *model = _systemDataSourecArray[indexPath.row];
    cell.iconImageView.layer.cornerRadius =cell.iconImageView.bounds.size.width/2;
    cell.iconImageView.layer.masksToBounds =YES;
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kXXEPicURL,model.school_logo]] placeholderImage:[UIImage imageNamed:@""]];
    
    cell.titleLabel.text =model.school_name;
    cell.contentLabel.text =model.title;
    cell.timeLabel.text = [XXETool dateStringFromNumberTimer:model.date_tm];
    
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0.000001;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    switch ([condit integerValue]) {
//            case 0:
//        {
//            XXESchoolNotificationDetailViewController *schoolNotificationDetailVC =[[XXESchoolNotificationDetailViewController alloc]init];
//            XXESchoolNotificationModel *model = _schoolDataSourceArray[indexPath.row];
//            
//            schoolNotificationDetailVC.name = model.school_name;
//            //[type] => 2		//通知范围需要  1:班级通知, 2:学校通知
//            if ([model.type integerValue] == 1) {
//                schoolNotificationDetailVC.scope = @"班级通知";
//            }else if ([model.type integerValue] == 2){
//                schoolNotificationDetailVC.scope = @"学校通知";
//            }
//            
//            schoolNotificationDetailVC.time =[XXETool dateStringFromNumberTimer:model.date_tm];
//            schoolNotificationDetailVC.content = model.con;
//            schoolNotificationDetailVC.titleStr = model.title;
//            [self.navigationController pushViewController:schoolNotificationDetailVC animated:YES];
//        }
//            break;
//            case 1:
//        {
//        }
//            break;
//        default:
//            break;
//    }
    XXESystemNotificationDetailViewController *systemNotificationDetailVC =[[XXESystemNotificationDetailViewController alloc]init];
    XXESystemNotificationModel *model = _systemDataSourecArray[indexPath.row];
    
    systemNotificationDetailVC.name = model.school_name;
    systemNotificationDetailVC.time =[XXETool dateStringFromNumberTimer:model.date_tm];
    systemNotificationDetailVC.content = model.con;
    systemNotificationDetailVC.titleStr = model.title;
    [self.navigationController pushViewController:systemNotificationDetailVC animated:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001;
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

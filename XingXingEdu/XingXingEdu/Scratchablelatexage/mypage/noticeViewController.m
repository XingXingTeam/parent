

#define KT @"yyyy年MM月dd日 HH:MM:ss"
#import "noticeViewController.h"
#import "schoolTableViewCell.h"
//#import "NoticeSettingInfomationViewController.h"
#import "XXESchoolNotificationModel.h"
#import "XXESystemNotificationModel.h"
#import "XXESchoolNotificationDetailViewController.h"
#import "XXESystemNotificationDetailViewController.h"
#import "SysteamNotificationViewController.h"
#import "SchoolNotificationViewController.h"

@interface noticeViewController ()
//<UITableViewDataSource,UITableViewDelegate>
{
    UISegmentedControl *segementedControl;
    //学校通知 a=0; 系统通知 a=1;
    NSInteger segmentNumber;
    //数据请求参数
    NSString *parameterXid;
    NSString *parameterUser_Id;
    NSString *baby_idStr;
    NSString *schoolId;
    NSString *classId;
    //占位图
    UIImageView *placeholderImageView;
    
}
@property(nonatomic ,strong)SysteamNotificationViewController *sysVC;
@property(nonatomic ,strong)SchoolNotificationViewController *schoolVC;
@property(nonatomic ,strong)UIViewController *currentVC;

//@property (strong, nonatomic) IBOutlet UITableView *releaseTabelView;
//@property (strong ,nonatomic)NSMutableArray * dataArray;
@end

@implementation noticeViewController

-(SysteamNotificationViewController *)sysVC {
    if (!_sysVC) {
        _sysVC = [[SysteamNotificationViewController alloc] init];
        _sysVC.schoolId = schoolId;
        _sysVC.classId = classId;
        _sysVC.schoolInfo = self.schoolInfo;
    }

    return _sysVC;
}

-(SchoolNotificationViewController *)schoolVC {
    if (!_schoolVC) {
        _schoolVC = [[SchoolNotificationViewController alloc] init];
        _schoolVC.schoolId = schoolId;
        _schoolVC.classId = classId;
        _schoolVC.babyId = baby_idStr;
        _schoolVC.schoolInfo = self.schoolInfo;
    }

    return _schoolVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XXEBackgroundColor;
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    baby_idStr = [DEFAULTS objectForKey:@"BABYID"];
    schoolId = [DEFAULTS objectForKey:@"SCHOOL_ID"];
    classId = [DEFAULTS objectForKey:@"CLASS_ID"];
    segmentNumber = 0;
    
    [self createLeftButton];
    [self createSegement];
    
    [self addChildViewController:self.sysVC];
    [self addChildViewController:self.schoolVC];
    [self.view addSubview:self.sysVC.view];
    self.currentVC = self.sysVC;
    
    
//    [self loadMoreData:schoolPage];
    
}


- (void)createSegement{
    segementedControl =[[UISegmentedControl alloc]initWithFrame:CGRectMake(80, 5, 100, 30)];
    [segementedControl insertSegmentWithTitle:@"系统消息" atIndex:0 animated:NO];
    [segementedControl insertSegmentWithTitle:@"校园通知" atIndex:1 animated:NO];
    self.navigationItem.titleView = segementedControl;
    segementedControl.tintColor =[UIColor whiteColor];
    segementedControl.selectedSegmentIndex =0;
    [segementedControl addTarget:self action:@selector(controlPressed:) forControlEvents:UIControlEventValueChanged];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.releaseTabelView.delegate = self;
//    self.releaseTabelView.dataSource = self;
//    self.releaseTabelView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MJloadMoreData)];
//    UINib *nib = [UINib nibWithNibName:@"schoolTableViewCell" bundle:nil];
//    [self.releaseTabelView registerNib:nib forCellReuseIdentifier:@"cell"];
    
}

- (void)controlPressed:(UISegmentedControl*)segment{
    NSInteger selectedIndex =[segment selectedSegmentIndex];
    if (selectedIndex ==0) {
        segmentNumber = 0;
        [self transitionFromViewController:self.currentVC toViewController:self.sysVC duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            
        } completion:^(BOOL finished) {
            
        }];
        self.currentVC = self.sysVC;
//        [self loadMoreData:schoolPage];
//        [self.releaseTabelView reloadData];
    }
    else{
        segmentNumber = 1;
        [self transitionFromViewController:self.currentVC toViewController:self.schoolVC duration:0.4 options:UIViewAnimationOptionTransitionFlipFromRight animations:nil completion:nil];
        self.currentVC = self.schoolVC;
//        [self loadSetData:systemPage];
//        [self.releaseTabelView reloadData];
    }
    
}


//-(void)MJloadMoreData{
//    a = segementedControl.selectedSegmentIndex;
//    if(a == 0){
//        schoolPage ++;
//        [self loadMoreData:schoolPage];
//    }
//    else if(a == 1){
//        
//        systemPage++;
//        [self loadSetData:systemPage];
//    }
//    [self.releaseTabelView.footer endRefreshing];
//}


-(void)createLeftButton{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(- 10, 0, 44, 20);
    
    [backBtn setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}
-(void)doBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//学校通知
//- (void)loadMoreData:(NSInteger)page{
//    //加载网络数据
////    NSLog(@"%@ -- %@ -- %@", schoolId, classId, baby_idStr);
//    
//  NSString * urlStr = @"http://www.xingxingedu.cn/Parent/school_notice";
//  NSDictionary * pragm = @{ @"appkey":APPKEY,
//                           @"backtype":BACKTYPE,
//                           @"xid":parameterXid,
//                           @"user_id":parameterUser_Id,
//                           @"user_type":USER_TYPE,
//                           @"school_id":schoolId,
//                           @"class_id":classId,
//                            @"baby_id":baby_idStr,
//                           @"page":[NSString stringWithFormat:@"%ld",page]
//                           };
//    
////    NSLog(@"1111 传参 --- %@", pragm);
//
//  [WZYHttpTool post:urlStr params:pragm success:^(id responseObj) {
//       NSDictionary *dict =responseObj;
//      
////      NSLog(@"===========school_notice===========%@",dict);
//    if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
//    {
//        NSArray *modelArray = [XXESchoolNotificationModel parseResondsData:dict[@"data"]];
//        [_schoolDataSourceArray addObjectsFromArray:modelArray];
//
//    }else{
//    
//    }
//      [self customContent];
//    
//  } failure:^(NSError *error) {
//    NSLog(@"%@", error);
//    [SVProgressHUD showInfoWithStatus:@"数据获取失败,请检查网络!"];
// }];
//
//}

// 有数据 和 无数据 进行判断
//- (void)customContent{
//    //移除 先前 的占位图
//    [self removePlaceholderImageView];
//    
//    if (_schoolDataSourceArray.count == 0) {
//        _releaseTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        
//        // 1、无数据的时候
//        [self createPlaceholderView];
//
//    }else{
//        
//    }
//   [self.releaseTabelView reloadData];
//
//}


//- (void)loadSetData:(NSInteger)page{
//// con   date_tm  id  title  type
//    //加载网络数据
//    NSString * urlStr = @"http://www.xingxingedu.cn/Global/official_notice";
//    NSDictionary * pragm = @{ @"appkey":APPKEY,
//                              @"backtype":BACKTYPE,
//                              @"xid":parameterXid,
//                              @"user_id":parameterUser_Id,
//                              @"user_type":USER_TYPE,
//                              @"app_type":@"1",//1:家长端, 2:教师端
//                              @"page":[NSString stringWithFormat:@"%ld",page],
//                              };
////    NSLog(@"2222 传参 --- %@", pragm);
//
//    [WZYHttpTool post:urlStr params:pragm success:^(id responseObj) {
//        NSDictionary *dict =responseObj;
//        
////     NSLog(@"===========official_notice===========%@",dict);
//        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
//        {
//            NSArray *modelArray = [XXESystemNotificationModel parseResondsData:dict[@"data"]];
//            [_systemDataSourecArray addObjectsFromArray:modelArray];
//        }else{
//        
//        }
//        [self customContentView];
//        
//    } failure:^(NSError *error) {
//        
//      [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络"];
//        
//    }];
//
//}
//
//// 有数据 和 无数据 进行判断
//- (void)customContentView{
//    
//    [self removePlaceholderImageView];
//    
//    if (_systemDataSourecArray.count == 0) {
//        _releaseTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        
//        // 1、无数据的时候
//        [self createPlaceholderView];
//        
//    }else{
//        
//    }
//    
//    [self.releaseTabelView reloadData];
//    
//}
//
//
////没有 数据 时,创建 占位图
//- (void)createPlaceholderView{
//
//    // 1、无数据的时候
//    UIImage *myImage = [UIImage imageNamed:@"人物"];
//    CGFloat myImageWidth = myImage.size.width;
//    CGFloat myImageHeight = myImage.size.height;
//    
//    placeholderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - myImageWidth / 2, (kHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
//    placeholderImageView.image = myImage;
//    [self.view addSubview:placeholderImageView];
//}
//
////去除 占位图
//- (void)removePlaceholderImageView{
//    if (placeholderImageView != nil) {
//        [placeholderImageView removeFromSuperview];
//    }
//
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0.0000001;
//}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (a ==0) {
//        return _schoolDataSourceArray.count;
//    }else if (a ==1) {
//        return _systemDataSourecArray.count;
//    }
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *identifier = @"cell";
//    schoolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"schoolTableViewCell" owner:self options:nil]lastObject];
//    }
//    if (a == 0) {
//    XXESchoolNotificationModel * model = _schoolDataSourceArray[indexPath.row];
//    cell.image.layer.cornerRadius =cell.image.bounds.size.width/2;
//    cell.image.layer.masksToBounds =YES;
//    [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picURL,model.school_logo]] placeholderImage:[UIImage imageNamed:@"picterPlace"]];
//    cell.schoolname.text = model.school_name;
//    cell.liYouLabel.text = model.title;
// 
//    cell.firstwellLabel.text = [WZYTool dateStringFromNumberTime:model.date_tm];
//    }else if (a == 1){
//        XXESystemNotificationModel *model = _systemDataSourecArray[indexPath.row];
//        cell.image.layer.cornerRadius =cell.image.bounds.size.width/2;
//        cell.image.layer.masksToBounds =YES;
//        [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picURL,model.school_logo]] placeholderImage:[UIImage imageNamed:@"picterPlace"]];
//        
//        cell.schoolname.text =model.school_name;
//        cell.liYouLabel.text =model.title;
//        cell.firstwellLabel.text = [WZYTool dateStringFromNumberTime:model.date_tm];
//    }
//    
//   cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
//    
//    return cell;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return 100;
//}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    switch (a) {
//        case 0:
//        {
//            
//            //XXESchoolNotificationDetailViewController
//            XXESchoolNotificationDetailViewController *notificationDetailVC =[[XXESchoolNotificationDetailViewController alloc]init];
//            XXESchoolNotificationModel *model = _schoolDataSourceArray[indexPath.row];
//            
////            NSLog(@"bbb %@", model);
//            
//            notificationDetailVC.name = model.school_name;
//            //[type] => 2		//1:班级通知, 2:学校通知
//            if ([model.type integerValue] == 1) {
//                notificationDetailVC.scope = @"班级通知";
//            }else if ([model.type integerValue] == 2){
//                notificationDetailVC.scope = @"学校通知";
//            }else{
//                notificationDetailVC.scope = @"班级通知";
//            }
//            notificationDetailVC.time =[WZYTool dateStringFromNumberTime:model.date_tm];
//            notificationDetailVC.content = model.con;
//            notificationDetailVC.titleStr = model.title;
//            [self.navigationController pushViewController:notificationDetailVC animated:YES];
//        }
//            break;
//        case 1:
//        {
//            //XXESystemNotificationDetailViewController
//            XXESystemNotificationDetailViewController *notificationDetailVC =[[XXESystemNotificationDetailViewController alloc]init];
//            XXESystemNotificationModel *model = _systemDataSourecArray[indexPath.row];
//            
//            notificationDetailVC.name = model.school_name;
//            notificationDetailVC.time =[WZYTool dateStringFromNumberTime:model.date_tm];
//            notificationDetailVC.content = model.con;
//            notificationDetailVC.titleStr = model.title;
//            [self.navigationController pushViewController:notificationDetailVC animated:YES];
//        }
//            break;
//        default:
//            break;
//    }
//}

@end

//
//  WZYSchoolCollectionViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/6/14.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "WZYSchoolCollectionViewController.h"

//#import "ClassSchoolTableViewCell.h"

#import "WZYSchoolCollectionTableViewCell.h"

@interface WZYSchoolCollectionViewController ()<UITableViewDelegate, UITableViewDataSource>
{

    NSMutableArray *idArray;
    NSMutableArray *schoolNameArray;
    NSMutableArray *iconArray;
    NSMutableArray *timeArray;
    NSInteger page;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}
//@property (nonatomic ,strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, copy) NSString *collectionId;

@end

@implementation WZYSchoolCollectionViewController

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    page = 0;
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
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
    
    self.view.backgroundColor = [UIColor redColor];
    
//    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
//    [self createData];
    [self createTableView];
    
    UINib *nib = [UINib nibWithNibName:@"WZYSchoolCollectionTableViewCell" bundle:nil];
    [_myTableView registerNib:nib forCellReuseIdentifier:@"cell"];
}


- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64 - 15) style:UITableViewStyleGrouped];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;

    [self.view addSubview:_myTableView];
    
    _myTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    _myTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooterNewData)];

}

- (void)loadNewData{
    page ++;
    [self fetchNetData];
    
    [_myTableView.header endRefreshing];

}

- (void)endRefresh{

    [_myTableView.header endRefreshing];
    [_myTableView.footer endRefreshing];
    
}

- (void)loadFooterNewData{
    page ++ ;
    
    [self fetchNetData];
    [ _myTableView.footer endRefreshing];
    
}

- (void)fetchNetData{

    /*
     【我的收藏---学校】
     
     接口:
     http://www.xingxingedu.cn/Global/col_school_list
     
     传参:
     */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/col_school_list";
    
    //请求参数  无
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE};

    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        idArray = [[NSMutableArray alloc] init];
        schoolNameArray = [[NSMutableArray alloc] init];
        iconArray = [[NSMutableArray alloc] init];
        timeArray = [[NSMutableArray alloc] init];
        
        //
//        NSLog(@"fffff%@", responseObj);
        
        /*
         {
         date_tm = 1465717276,
         id = 7,
         name = 猩猩教室,
         logo = app_upload/text/school_logo/7.jpg
         }
         */
        NSArray *dataSource = responseObj[@"data"];
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            for (NSDictionary *dic in dataSource) {
                
                [schoolNameArray addObject:dic[@"name"]];
                
                //头像
                NSString *picStr = [NSString stringWithFormat:@"%@%@", picURL, dic[@"logo"]];
                [iconArray addObject:picStr];
                
                //时间
                NSString *timeStr = [WZYTool dateStringFromNumberTimer:dic[@"date_tm"]];
                [timeArray addObject:timeStr];
                
                //id
                [idArray addObject:dic[@"id"]];
                
            }
            
        }else{
        
        
        }
        
        [_myTableView reloadData];
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return idArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WZYSchoolCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil){
        cell=[[WZYSchoolCollectionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"sdimg1.png"]];
    
    cell.nameLabel.text = schoolNameArray[indexPath.row];
    
    cell.timeLabel.text = timeArray[indexPath.row];
    
    //添加 长按 取消 收藏
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressClick:)];
    
    [cell.contentView addGestureRecognizer:longPress];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
    
}

- (void)longPressClick:(UILongPressGestureRecognizer *)longPress{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"取消收藏" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
        WZYSchoolCollectionTableViewCell *cell = (WZYSchoolCollectionTableViewCell *)[longPress.view superview];
        
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
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"collect_id":_collectionId, @"collect_type":@"5"};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        
        //        NSLog(@"yyyyy%@", responseObj);
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];
    
    
}

@end

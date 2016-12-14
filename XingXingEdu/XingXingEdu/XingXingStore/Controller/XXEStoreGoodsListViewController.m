
//
//  XXEStoreGoodsListViewController.m
//  teacher
//
//  Created by Mac on 2016/11/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStoreGoodsListViewController.h"
#import "XXEStoreGoodsOrderListTableViewCell.h"
#import "XXEStoreGoodsOrderListModel.h"
#import "XXEStoreGoodsOrderDetailViewController.h"


@interface XXEStoreGoodsListViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    UISegmentedControl *_segmentedControl;
    NSMutableDictionary  *_listVCQueue;
    
    UITableView *_myTableView;
    NSMutableArray *_dataSourceArray;
    
    UIImageView *placeholderImageView;
    //订单 状态
    NSString *condit;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}


@end

@implementation XXEStoreGoodsListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];


    if (condit == nil) {
        condit = @"0";
    }
    
//    NSLog(@"condit === %@", condit);
    
    [self  fetchNetData:condit];

}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.title = @"订单列表";
    _firstStr = @"first";
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    [self createSegmentedControl];
    
    [self createTableView];
    
//    [self  fetchNetData:@"0"];
    
}

- (void)createSegmentedControl{

    NSArray *titleArray = [[NSArray alloc] initWithObjects:@"待付款", @"待发货", @"待收货", @"已完成", @"退货",  nil];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:titleArray];
    _segmentedControl.frame = CGRectMake(5, 10, KScreenWidth - 10, 35);
    _segmentedControl.tintColor = UIColorFromRGB(0, 170, 42);
    _segmentedControl.selectedSegmentIndex = 0;
    _segmentedControl.backgroundColor = [UIColor whiteColor];
    
    [_segmentedControl addTarget:self action:@selector(didClickSegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentedControl];
    
}

- (void)didClickSegmentedControlAction:(UISegmentedControl *)seg{
    if (!_listVCQueue) {
        _listVCQueue=[[NSMutableDictionary alloc] init];
    }
    
    condit = [NSString stringWithFormat:@"%ld", seg.selectedSegmentIndex];
//    NSLog(@"condit : %@", condit);

    [self fetchNetData:condit];
    
}


- (void)fetchNetData:(NSString *)conditStr{
    /*
     【猩猩商城--我的订单(5个标签)】
     接口类型:1
     接口:
     http://www.xingxingedu.cn/Global/my_goods_order
     传参:
     condit		//要求返回什么数据 0:待付款 1:待发货 2:待收货 3:完成 4:退货  (★待收货状态才允许退货)	*/
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/my_goods_order";
    
//    if ([condit isEqualToString:@""]) {
//        condit = @"0";
//    }
    
//    NSLog(@"------ %@", condit);
    
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE,
                             @"condit":conditStr
                             };
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        _dataSourceArray = [[NSMutableArray alloc] init];
        
        //
//        NSLog(@"kkkk %@", responseObj);
        
        if ([responseObj[@"code"] integerValue] == 1) {
            
            NSArray *modelArray = [[NSArray alloc] init];
            
            modelArray = [XXEStoreGoodsOrderListModel parseResondsData:responseObj[@"data"]];
            
            [_dataSourceArray addObjectsFromArray:modelArray];
            
        }
        [self customContent];
        
    } failure:^(NSError *error) {
        //
        [self showString:@"获取数据失败!" forSecond:1.5];
    }];
    
}


// 有数据 和 无数据 进行判断
- (void)customContent{
    // 如果 有占位图 先 移除
    [self removePlaceholderImageView];
    
    if (_dataSourceArray.count == 0) {
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 1、无数据的时候
        [self createPlaceholderView];
        
    }else{
        //2、有数据的时候

    }
    
    [_myTableView reloadData];
    
}


//没有 数据 时,创建 占位图
- (void)createPlaceholderView{
    // 1、无数据的时候
    UIImage *myImage = [UIImage imageNamed:@"人物"];
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
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, KScreenWidth, KScreenHeight - 50) style:UITableViewStyleGrouped];
//    _myTableView.backgroundColor = [UIColor redColor];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    
    [self.view addSubview:_myTableView];
}



#pragma mark
#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataSourceArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    XXEStoreGoodsOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[XXEStoreGoodsOrderListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    XXEStoreGoodsOrderListModel *model = _dataSourceArray[indexPath.row];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kXXEPicURL, model.pic]] placeholderImage:[UIImage imageNamed:@"sdimg1"]];
    
    cell.titleLabel.text = model.title;
    cell.totalIconLabel.text = model.exchange_coin;
    cell.orderCodeLabel.text = [NSString stringWithFormat:@"订单编号:%@", model.order_index];
    cell.moneyLabel.text = model.exchange_price;
    cell.timeLabel.text = [WZYTool dateStringFromNumberTimer:model.date_tm];

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XXEStoreGoodsOrderDetailViewController*storeGoodsOrderDetailVC=  [[XXEStoreGoodsOrderDetailViewController alloc]init];
    XXEStoreGoodsOrderListModel *model = _dataSourceArray[indexPath.row];
    storeGoodsOrderDetailVC.order_id=model.order_id;
    [self.navigationController pushViewController:storeGoodsOrderDetailVC animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  OrderListViewController.m
//  XingXingEdu
//
//  Created by codeDing on 16/2/29.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "SubjectOrderListViewController.h"
#import "ZXOrderCell.h"
#import "ZXOrderModel.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "OrderInfoViewController.h"
#import "HHControl.h"
#import "ReturnOfGoodsDetaileViewController.h"

#define kSegmented_Left 20
#define kSegmented_Top 64+5
#define kSegmented_Width KScreenW-(2*kSegmented_Left)
#define kSegmented_Height 40
#define KScreenW [UIScreen mainScreen].bounds.size.width
#define KScreenH [UIScreen mainScreen].bounds.size.height

@interface SubjectOrderListViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSString *orderId;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@property (nonatomic, strong) UISegmentedControl *segmented;
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation SubjectOrderListViewController

static NSString * const OrderCell = @"ZXOrderCell";

#pragma mark - 懒加载
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataSource;
}

- (UISegmentedControl *)segmented{
    if (!_segmented) {
        self.segmented = [[UISegmentedControl alloc]initWithItems:@[@"待付款",@"待发货", @"待收货", @"已完成",@"退货"]];
        self.segmented.frame = CGRectMake(kSegmented_Left, 5, kSegmented_Width, kSegmented_Height);
        self.segmented.tintColor =UIColorFromRGB(0, 170, 42);
        self.segmented.selectedSegmentIndex = 0;
        //设置UISegmentedControl字体
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName,UIColorFromRGB(29, 29, 29), NSForegroundColorAttributeName, nil];
        [self.segmented setTitleTextAttributes:attributes forState:UIControlStateNormal];
        self.segmented.backgroundColor = [UIColor whiteColor];
        [_segmented addTarget:self action:@selector(handleSegmented:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_segmented];
    }
    return _segmented;
}

- (UITableView *)listView {
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 53, KScreenW, KScreenH - kSegmented_Height -74) style:UITableViewStylePlain];
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewCollectData)];
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_listView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXOrderCell class]) bundle:nil] forCellReuseIdentifier:OrderCell];
        
        [self.view addSubview:_listView];
    }
    return _listView;
}

-(void)loadNewCollectData{
    [self RequestData:@"0"];
}
-(void)endRefresh{
    [_listView.header endRefreshing];
}
-(void)viewDidAppear:(BOOL)animated{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_listView.header beginRefreshing];
        [_listView.header endRefreshing];
    });
    
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }

    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"订单列表";
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    [self.view addSubview:[HHControl createImageViewWithFrame:CGRectMake(0, 50, WinWidth, 3) ImageName:@"big750.png"]];
    
    [self segmented];
    [self listView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//下拉刷新,上拉加载
- (void)Refreshing:(NSString *)type{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //上拉刷新
        _listView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self RequestData:type];
            [_listView.header endRefreshing];
        }];
        [_listView.header beginRefreshing];
    });
    
    
}

// 分类请求数据
- (void)RequestData:(NSString *)type {
    
//    NSLog(@"===============>%@",type);
    
    for (UIView *subviews in [self.view subviews]) {
        if (subviews.tag==100) {
            [subviews removeFromSuperview];
        }
    }
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/my_goods_order";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"condit":type,
                           
                           };
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
//         NSLog(@"++======================>%@",dict);
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             
             _dataSource = [ZXOrderModel objectArrayWithKeyValuesArray:dict[@"data"]];
             
             [_listView reloadData];
         }else{
             UIImageView *bg=[HHControl createImageViewWithFrame:CGRectMake(0, 50, WinWidth, WinHeight) ImageName:@"nodatabg.png"];
             [self.view addSubview:bg];
             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",dict[@"msg"]]];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZXOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderCell];
    ZXOrderModel *order = _dataSource[indexPath.row];
    cell.order = order;
    if (self.segmented.selectedSegmentIndex==0) {
        
    }
    else if (self.segmented.selectedSegmentIndex==1) {
    }
    else if (self.segmented.selectedSegmentIndex==2) {
    }
    else if (self.segmented.selectedSegmentIndex==3) {
        
    }else if (self.segmented.selectedSegmentIndex==4) {
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonpress:)];
        cell.orderCondit.text=@"查看详情";
        cell.orderCondit.userInteractionEnabled = YES;
        cell.orderCondit.tag = [order.orderID integerValue];
        [cell.orderCondit addGestureRecognizer:singleTap];
    }
    return cell;
}
-(void)buttonpress:(id)sender{
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    NSInteger tag = [tap view].tag;

    ReturnOfGoodsDetaileViewController *returnOfGoodsDetaileVC = [[ReturnOfGoodsDetaileViewController alloc] init];
    returnOfGoodsDetaileVC.orderId = [NSString stringWithFormat:@"%ld",tag];
    [self.navigationController pushViewController:returnOfGoodsDetaileVC animated:YES];
}


#pragma mark - delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [_listView deselectRowAtIndexPath:indexPath animated:NO];
    
    ZXOrderModel *model=_dataSource[indexPath.row];
    
    OrderInfoViewController * vc=[[OrderInfoViewController alloc]init];
    vc.hiddenLeftButton = YES;
    vc.orderID = model.orderID;
    if ([model.ordercondit isEqualToString:@"0"]) {
        vc.isDid = YES;
    }
    if(_segmented.selectedSegmentIndex == 0){
        vc.isDid=YES;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Segment M
- (void)handleSegmented:(UISegmentedControl *)segmented {
    NSInteger index = segmented.selectedSegmentIndex;
    switch (index) {
        case 0:
            [self Refreshing:@"0"];
            break;
        case 1:
            [self Refreshing:@"1"];
            break;
        case 2:
            [self Refreshing:@"2"];
            break;
        case 3:
            [self Refreshing:@"3"];
            break;
        case 4:
            [self Refreshing:@"4"];
            break;
        default:
            break;
    }
}

@end

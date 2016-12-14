//
//  StoreCollectTableViewController.m
//  XingXingStore
//
//  Created by codeDing on 16/1/21.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "StoreCollectTableViewController.h"
#import "StoreCollectTableViewCell.h"
#import "XXEStoreGoodDetailInfoViewController.h"
#import "MJRefresh.h"
@interface StoreCollectTableViewController ()<UITableViewDelegate,UITableViewDataSource>
{

    //占位图
    UIImageView *placeholderImageView;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@property(nonatomic ,strong)NSMutableArray * allArray;

@end

@implementation StoreCollectTableViewController


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (_allArray.count != 0) {
        [_allArray removeAllObjects];
    }
    
    //收藏商品 数据
    [self collect_goods_show];
    
    [self.tableView reloadData];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    self.allArray = [NSMutableArray array];

    [self createTabelView];
}

-(void)createTabelView{
    
    UINib *nib = [UINib nibWithNibName:@"StoreCollectTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
//    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewCollectData)];

}


//-(void)loadNewCollectData{
//    [self collect_goods_show];
//    [self.tableView.header endRefreshing];
//}
//-(void)endRefresh{
//    [self.tableView.header endRefreshing];
//}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    
//      [self.tableView reloadData];
//}
//-(void)viewDidAppear:(BOOL)animated{
//    [self.tableView.header beginRefreshing];
//}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.allArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoreCollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil){
        cell=[[StoreCollectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
//    NSLog(@"---- %@", self.allArray[indexPath.row]);
    
    NSArray * tmp=self.allArray[indexPath.row];
    [cell.articleImageView sd_setImageWithURL:[NSURL URLWithString:tmp[0]] placeholderImage:[UIImage imageNamed:@"sdimg1.png"]];
   
    cell.articleName.text=tmp[1];
    cell.articleDate.text=[CodeDingUtil timestampToTimeWith:tmp[3]];
    cell.articlePrice.text=tmp[2];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XXEStoreGoodDetailInfoViewController*vc=  [[XXEStoreGoodDetailInfoViewController alloc]init];
    vc.orderNum=self.allArray[indexPath.row][4];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}


#pragma mark ============= 猩猩商城--我收藏的商品列表 ==========
- (void)collect_goods_show{
    /*
     【猩猩商城--我收藏的商品列表】
     接口类型:1
     接口:
     http://www.xingxingedu.cn/Global/collect_goods_show
     传参:*/
   
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/collect_goods_show";
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           };
    
    
//    NSLog(@"传参 ==== %@", dict);
    
    [WZYHttpTool post:urlStr params:dict success:^(id responseObj) {
        //
//        NSLog(@"responseObj == %@", responseObj);
        if ([responseObj[@"code"] integerValue] == 1) {
            for (NSDictionary *dic in responseObj[@"data"] ) {
                NSString * goods_pic=[picURL stringByAppendingString:dic[@"pic"]];
                NSString * title=dic[@"title"];
                NSString * exchange_coin=dic[@"exchange_coin"];
                NSString * date_tm=dic[@"collect_tm"];
                NSString *  orderid=dic[@"id"];
                NSMutableArray *arr=[NSMutableArray arrayWithObjects:goods_pic, title,exchange_coin,date_tm,orderid,nil];
                
                [self.allArray addObject:arr];
            }
            
        }
         [self customContent];
    } failure:^(NSError *error) {
        //
        [SVProgressHUD showErrorWithStatus:@"获取数据失败!"];
    }];
    
}

// 有数据 和 无数据 进行判断
- (void)customContent{
    // 如果 有占位图 先 移除
    [self removePlaceholderImageView];
    
    if (self.allArray.count == 0) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 1、无数据的时候
        [self createPlaceholderView];
        
    }else{
        //2、有数据的时候
    }
    
    [self.tableView reloadData];
    
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


@end

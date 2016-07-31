//
//  StoreCollectTableViewController.m
//  XingXingStore
//
//  Created by codeDing on 16/1/21.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "StoreCollectTableViewController.h"
#import "StoreCollectTableViewCell.h"
#import "ArticleInfoViewController.h"
#import "MJRefresh.h"
@interface StoreCollectTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic ,strong)NSMutableArray * allArray;

@end

@implementation StoreCollectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    [self createTabelView];
    
}

-(void)createTabelView{
    
    UINib *nib = [UINib nibWithNibName:@"StoreCollectTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewCollectData)];

}


-(void)loadNewCollectData{
    [self collect_goods_show];
    [self.tableView.header endRefreshing];
}
-(void)endRefresh{
    [self.tableView.header endRefreshing];
}
-(void)viewWillAppear:(BOOL)animated{
      [self.tableView reloadData];
}
-(void)viewDidAppear:(BOOL)animated{
    [self.tableView.header beginRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    ArticleInfoViewController*vc=  [[ArticleInfoViewController alloc]init];
    vc.orderNum=self.allArray[indexPath.row][4];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark 网络
- (void)collect_goods_show{
    
   self.allArray = [NSMutableArray array];
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/collect_goods_show";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           };
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
        
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
            
             
             for (NSDictionary *dic in dict[@"data"] ) {
                 NSString * goods_pic=[picURL stringByAppendingString:dic[@"pic"]];
                 NSString * title=dic[@"title"];
                 NSString * exchange_coin=dic[@"exchange_coin"];
                 NSString * date_tm=dic[@"collect_tm"];
                 NSString *  orderid=dic[@"id"];
                 NSMutableArray *arr=[NSMutableArray arrayWithObjects:goods_pic, title,exchange_coin,date_tm,orderid,nil];

                 [self.allArray addObject:arr];
             }
         
         
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"获取收藏失败，%@",dict[@"msg"]]];
         }
           [self.tableView reloadData];

         
       
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
       
         
     }];
    
}


@end

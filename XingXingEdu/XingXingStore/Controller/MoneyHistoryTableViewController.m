//
//  MoneyHistoryTableViewController.m
//  XingXingStore
//
//  Created by codeDing on 16/1/21.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "MoneyHistoryTableViewController.h"
#import "MoneyHistoryTableViewCell.h"
@interface MoneyHistoryTableViewController ()
@property(nonatomic ,strong)NSMutableArray * allArray;

@end

@implementation MoneyHistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.allArray=[NSMutableArray array];
    
    UINib *nib = [UINib nibWithNibName:@"MoneyHistoryTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    self.title = @"猩币历史";
    
    [self createLeftButton];
    [self netManage];
}

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
    MoneyHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil){
        cell=[[MoneyHistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSArray * tmp=self.allArray[indexPath.row];
    cell.iconImage.layer.cornerRadius= cell.iconImage.bounds.size.width/2;
    cell.iconImage.layer.masksToBounds=YES;
    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:tmp[0]] placeholderImage:[UIImage imageNamed:@"sdimg1.png"]];
    cell.date=[CodeDingUtil timestampToTimeWith:tmp[1]];
    cell.price=tmp[3];
    cell.use=tmp[2];

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 73;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView* header1 = [[[NSBundle mainBundle] loadNibNamed:@"MoneyHistoryHeadView"owner:self options:nil]lastObject];
    return header1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 38;
}
#pragma mark 网络
- (void)netManage
{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/select_coin_msg";
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
//         NSLog(@"%@",dict);
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             NSArray *keys = [dict[@"data"] allKeys];
             NSMutableArray *categoryArray=[NSMutableArray array];
             NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                 return [obj2 compare:obj1 options:NSNumericSearch];
             }];
             for (NSString *categoryId in sortedArray) {
                 [categoryArray addObject:[dict[@"data"]  objectForKey:categoryId]];
                 
             }
             for (NSDictionary *dic in categoryArray) {
                 //判断是否是第三方头像
                 NSString * head_img;
                 if([[NSString stringWithFormat:@"%@",dic[@"head_img_type"]]isEqualToString:@"0"]){
                      head_img=[picURL stringByAppendingString:dic[@"head_img"]];
                 }else{
                     head_img=dic[@"head_img"];
                 }
                 NSString * date_tm=dic[@"date_tm"];
                 NSString * coin_num=dic[@"coin_num"];
                 NSString * con=dic[@"con"];
                 
                 NSMutableArray *arr=[NSMutableArray arrayWithObjects:head_img,date_tm,con,coin_num,nil];
                 
                 [self.allArray addObject:arr];
             }

             [self.tableView reloadData];
             
         }else{
             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",dict[@"msg"]]];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}




@end

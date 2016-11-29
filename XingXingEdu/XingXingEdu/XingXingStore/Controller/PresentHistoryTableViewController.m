//
//  PresentHistoryTTableViewController.m
//  XingXingEdu
//
//  Created by codeDing on 16/2/29.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "PresentHistoryTableViewController.h"
#import "PresentHistoryTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "AFNetworking.h"
@interface PresentHistoryTableViewController ()
{
    NSString *parameterXid;
    NSString *parameterUser_Id;
}
@property(nonatomic ,strong)NSMutableArray * allArray;

@end

@implementation PresentHistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    self.allArray=[NSMutableArray array];
    
    UINib *nib = [UINib nibWithNibName:@"PresentHistoryTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
[[self navigationItem] setTitle:@"转赠历史"];
    [self netManage];
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
    PresentHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil){
        cell=[[PresentHistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSArray * tmp=self.allArray[indexPath.row];
    
    cell.iconImage.layer.cornerRadius= cell.iconImage.bounds.size.width/2;
    cell.iconImage.layer.masksToBounds=YES;
    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:tmp[0]] placeholderImage:[UIImage imageNamed:@"sdimg1.png"]];
    cell.timeLabel.text=[CodeDingUtil timestampToTimeWith:tmp[1]];
    cell.moneyLabel.text=tmp[2];
    cell.nameLabel.text=tmp[3];
    

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 71;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView* header1 = [[[NSBundle mainBundle] loadNibNamed:@"PresentHistoryHeadView"owner:self options:nil]lastObject];
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
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"require_con":@"4",
                           
                           };
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dict);

         
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
             
//             NSLog(@"----%@",categoryArray);
             
             for (NSDictionary *dic in categoryArray) {
                 //判断是否是第三方头像
                 NSString * head_img;
//                 if([[NSString stringWithFormat:@"%@",dic[@"msg_type"]]isEqualToString:@"0"]){
//                     head_img=[picURL stringByAppendingString:dic[@"head_img"]];
//                 }else{
                     head_img = dic[@"pic"];
//                 }

                 NSString * date_tm=dic[@"date_tm"];
                 NSString * coin_num=dic[@"coin_num"];
                 NSString * tname=dic[@"tname"];
                
                 NSMutableArray *arr=[NSMutableArray arrayWithObjects:head_img,date_tm,coin_num,tname,nil];
 
                 [self.allArray addObject:arr];
             }
             
                      [self.tableView reloadData];
             
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"获取信息失败，%@",dict[@"msg"]]];
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}



@end

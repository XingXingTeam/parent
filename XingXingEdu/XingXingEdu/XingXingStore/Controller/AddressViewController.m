//
//  AddressViewController.m
//  XingXingStore
//
//  Created by codeDing on 16/1/25.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressTableViewCell.h"
#import "AddAddressViewController.h"
#import "ModifyAddressViewController.h"
#import "MJRefresh.h"
#import "StoreArticleBuyViewController.h"
@interface AddressViewController ()<UITableViewDelegate,UITableViewDataSource>
{

    NSString *parameterXid;
    NSString *parameterUser_Id;
}


@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)addAddressBtn:(id)sender;

@end

@implementation AddressViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView.header beginRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }

    
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
    [rightButton setImage:[UIImage imageNamed:@"addicon4.png"]forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(addadressBtn)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;

    
    [self netManage];
   
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight - 64);
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    UINib *nib = [UINib nibWithNibName:@"AddressTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"AddressAddresscell"];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
}
-(void)loadNewData{
    [self netManage];
    [self.tableView.header endRefreshing];
}
-(void)endRefresh{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addressArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
   AddressTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell==nil){
        cell=[[AddressTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"AddressAddresscell"];
    }
    NSArray * tmp=self.addressArray[indexPath.row];
    
    UILabel * nameLabel = [HHControl createLabelWithFrame:CGRectMake(10, 10, 120,20) Font:16 Text:tmp[2]];
    [cell.contentView addSubview:nameLabel];
    
    UILabel * phoneLabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame) + 70, 10, kWidth - 150,20) Font:14 Text:tmp[1]];
    [cell.contentView addSubview:phoneLabel];
    if ([tmp[4] isEqualToString:@"1"]) {
        
        UILabel * defaultLabel = [HHControl createLabelWithFrame:CGRectMake(10, 45, 70,20) Font:14 Text:@"默认地址:"];
        defaultLabel.textColor=UIColorFromRGB(248, 121, 64);
        defaultLabel.numberOfLines = 0;
        [cell.contentView addSubview:defaultLabel];
        
    }else{
        UILabel * defaultLabel = [HHControl createLabelWithFrame:CGRectMake(10, 45, 70,20) Font:14 Text:@""];
        defaultLabel.textColor= [UIColor grayColor];
        defaultLabel.numberOfLines = 0;
        [cell.contentView addSubview:defaultLabel];
    }
    
    UILabel * addressLabel = [HHControl createLabelWithFrame:CGRectMake(90, CGRectGetMaxY(nameLabel.frame)+15 , kWidth - 130,20) Font:14 Text:tmp[3]];
    addressLabel.numberOfLines = 0;
    [cell.contentView addSubview:addressLabel];
        return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.isBuy){
      
        NSArray *tmpArr=self.addressArray[indexPath.row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(sendAddressArray:)]) {
            
              [self.delegate sendAddressArray:tmpArr];
           }
        [self.navigationController popViewControllerAnimated:YES];
    }
else{
    
    ModifyAddressViewController*vc =[[ModifyAddressViewController alloc]init];
    NSArray *tmpArr=self.addressArray[indexPath.row];
     vc.addressId=tmpArr[0];
     vc.addressPhone=tmpArr[1];
     vc.addressName=tmpArr[2];
     vc.addressProvince=tmpArr[5];
     vc.addressCity=tmpArr[6];
     vc.addressDistrict=tmpArr[7];
     vc.addressInfo=tmpArr[8];
     vc.addressMail=tmpArr[9];
     [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)addAddressBtn:(id)sender {
    [self.navigationController pushViewController:[[AddAddressViewController alloc]init] animated:YES];
}

-(void)addadressBtn{
    [self.navigationController pushViewController:[[AddAddressViewController alloc]init] animated:YES];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
if(editingStyle == UITableViewCellEditingStyleDelete)
{

//数据库删除
   NSArray* tmp=self.addressArray[indexPath.row];
    [self deleteAddress:tmp[0]:indexPath];
    [self.tableView reloadData];
}
}

#pragma mark 网络
//获取地址
- (void)netManage
{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/get_shopping_address";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           };
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
          self.addressArray=[NSMutableArray array];
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             for (NSDictionary *dic in dict[@"data"]) {
                NSString * addid=dic[@"id"];
                 NSString * phone=dic[@"phone"];
                 NSString * name=dic[@"name"];
                 NSString * address=[NSString string];
                 address=[address stringByAppendingString:dic[@"province"]];
                 address=[address stringByAppendingString:dic[@"city"]];
                 address=[address stringByAppendingString:dic[@"district"]];
                 address=[address stringByAppendingString:dic[@"address"]];
                 NSString * selected=dic[@"selected"];
                 
                 NSString * province=dic[@"province"];
                  NSString * city=dic[@"city"];
                  NSString * district=dic[@"district"];
                  NSString * addressinfo=dic[@"address"];
                  NSString * zip_code=dic[@"zip_code"];
                 
                  NSMutableArray * tmpArray=[NSMutableArray arrayWithObjects:addid,phone,name,address,selected,province,city,district,addressinfo,zip_code,nil];
                 [self.addressArray addObject:tmpArray];
             }

             [self.tableView reloadData];
         }

         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}

//滑动删除地址
- (void)deleteAddress:(NSString *)addressId :(NSIndexPath *)index
{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/delete_shopping_address";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"address_id":addressId,
                           };
    
//    NSLog(@"%@",dict);

    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//         NSLog(@"%@",dict);
         
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             [SVProgressHUD showSuccessWithStatus:@"删除成功"];
             //// 数据要删除
             [self.addressArray removeObjectAtIndex:index.row];
             //// 单元格也要删除
             [self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationLeft];
            
             [self.tableView reloadData];
        }
     
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}


@end

//
//  StoreArticleBuyViewController.m
//  XingXingEdu
//
//  Created by codeDing on 16/3/4.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "StoreArticleBuyViewController.h"
#import "AddressTableViewCell.h"
#import "AddressViewController.h"
#import "PayMannerViewController.h"


@interface StoreArticleBuyViewController ()<UITableViewDelegate,UITableViewDataSource,selectAddreseeIdDelegate>{
//     PayPalConfiguration * _payPalConfig;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
}
- (IBAction)buyBtn:(id)sender;

@end

@implementation StoreArticleBuyViewController

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

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self  getDefaultAddress];
    
    self.nameLabel.text=@"文具盒";
    self.rmbMoneyLabel.text=self.rmbMoney;
    self.xingMoneyLabel.text=self.xingMoney;
    self.addressArray=[NSMutableArray array];
    
    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
    UINib *nib = [UINib nibWithNibName:@"AddressTableViewCell" bundle:nil];
    [self.myTableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
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
        cell=[[AddressTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSArray * tmp=self.addressArray[indexPath.row];
    
    UILabel * nameLabel = [HHControl createLabelWithFrame:CGRectMake(15, 10, 120,20) Font:16 Text:tmp[2]];
    [cell.contentView addSubview:nameLabel];
    
    UILabel * phoneLabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame) + 70, 10, kWidth - 150,20) Font:14 Text:tmp[1]];
    [cell.contentView addSubview:phoneLabel];
    if ([tmp[4] isEqualToString:@"1"]) {
        
        UILabel * defaultLabel = [HHControl createLabelWithFrame:CGRectMake(10, 45, 70,20) Font:14 Text:@"默认地址:"];
        defaultLabel.textColor=UIColorFromRGB(248, 121, 64);
        defaultLabel.numberOfLines = 0;
        [cell.contentView addSubview:defaultLabel];
        
    }else{
        UILabel * defaultLabel = [HHControl createLabelWithFrame:CGRectMake(10, 45, 70,20) Font:14 Text:@"[发货地址]"];
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
    AddressViewController*vc =[[AddressViewController alloc]init];
    vc.isBuy=YES;
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)buyBtn:(id)sender {
 
    [self makeOrderAndAddressID:self.addressId];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
   [self.view endEditing:YES];
}


- (void)showAlertView:(NSString *)msg {
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}



#pragma mark 网络
//生产订单
- (void)makeOrderAndAddressID:(NSString *)addressId
{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/coin_shopping";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"goods_id":self.orderNum,
                           @"receipt":self.billNameText.text,
                           @"address_id":addressId,
                           @"buyer_words":self.messageText.text,
                           };
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//             NSLog(@"---------------%@",dict);
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             
             self.order_id = dict[@"data"][@"order_id"];
             PayMannerViewController *vc=[[PayMannerViewController alloc]init];
             vc.orderId = dict[@"data"][@"order_id"];
             vc.price = dict[@"data"][@"pay_price"];
//             vc.user_coin_able = dict[@"data"][@"user_coin_able"];
             vc.xingMoney = dict[@"data"][@"pay_coin"];
             vc.order_index = dict[@"data"][@"order_index"];
             vc.isFlower = NO;
             [self.navigationController pushViewController:vc animated:YES];

         }else{
             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"获取信息失败，%@",dict[@"msg"]]];
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}


//获取默认地址
- (void)getDefaultAddress
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
                  NSLog(@"%@",dict);
         
         self.addressArray=[NSMutableArray array];
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             for (NSDictionary *dic in dict[@"data"]) {
                 if([dic[@"selected"] isEqualToString:@"1"]){
                    
                 NSString * addid=dic[@"id"];
                      self.addressId=addid;
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
             }
             [self.myTableView reloadData];
         }else{
             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"获取信息失败，%@",dict[@"msg"]]];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
     }];
}

//商品订单确认兑换 (只用于纯猩币兑换)
- (void)goods_confirm_payAndOrderID:(NSString *)order_id
{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/goods_confirm_pay";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"order_id":order_id,
                           
                           };
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         //         NSLog(@"%@",dict);
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             [SVProgressHUD showSuccessWithStatus:@"兑换成功"];
             [self.navigationController popViewControllerAnimated:YES];
         
         }else{
             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"获取信息失败，%@",dict[@"msg"]]];
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
     }];
}


- (void)sendAddressArray:(NSArray *)array{
    
    self.addressId = array[0];
    
    self.addressArray = [NSMutableArray arrayWithObject:array];
    
    [self.myTableView reloadData];
    
}
@end

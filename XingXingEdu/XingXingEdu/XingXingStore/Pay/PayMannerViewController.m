//
//  PayMannerViewController.m
//  XingXingEdu
//
//  Created by codeDing on 16/5/16.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "PayMannerViewController.h"
#import "BeeCloud.h"
#import "LSSAlertView.h"
#import "OrderInfoViewController.h"
#import "StoreHomePageViewController.h"

#define Kmgar 15.0f
#define KlabelH 20.0f
#define KlabelW 150.0f
#define KlabelWL 180.0f
@interface PayMannerViewController ()<BeeCloudDelegate>{
    BOOL isCollect;
    NSInteger  btnNumber;
    UILabel *_priceLabel;
    //    NSString *_genBillNo;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}
@property(nonatomic,copy)NSString *user_coin_able;
@end

@implementation PayMannerViewController

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
    self.view.backgroundColor = UIColorFromRGB(230, 230, 230);
    self.title = @"订单详情";
    
    NSLog(@"orderId%@",self.orderId);
    NSLog(@"self.price%@",self.price);
    NSLog(@"xingMoney%@",self.xingMoney);
    NSLog(@"self.order_index %@",self.order_index);
    
    [self good_user_coin_able];
    
    
}

//查询可用猩币
- (void)good_user_coin_able
{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/getUserGlobalInfo";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"field":@"coin_able",
                           };
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             _user_coin_able = [NSString stringWithFormat:@"%@",dict[@"data"][@"coin_able"]];
         }
         
         [self createBuydetailMessage];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)createBuydetailMessage{
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 300)];
    bgView.backgroundColor = UIColorFromRGB(255, 255, 255);
    [self.view addSubview:bgView];
    
    UIImageView *headImage = [HHControl createImageViewWithFrame:CGRectMake(Kmgar *2, Kmgar + 3, 38, 33) ImageName:@"gouwuche"];
    [bgView addSubview:headImage];
    if (_xingMoney == nil && _xingMoney == NULL) {
        _priceLabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame) + Kmgar, Kmgar, KlabelW, KlabelH) Font:16 Text:[NSString stringWithFormat:@"￥:%@",self.price]];
        [bgView addSubview:_priceLabel];
    }else{
        _priceLabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame) + Kmgar, Kmgar, KlabelW, KlabelH) Font:16 Text:[NSString stringWithFormat:@"猩币:%@ ￥:%@",_xingMoney,self.price]];
        [bgView addSubview:_priceLabel];
    }
    UILabel *orderLabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame) + Kmgar,CGRectGetMaxY(_priceLabel.frame), KlabelW, KlabelH) Font:12 Text:[NSString stringWithFormat:@"订单号:%@",self.order_index]];
    orderLabel.textColor = UIColorFromRGB(153, 153, 153);
    [bgView addSubview:orderLabel];
    
    UIImageView *lineImageOne = [HHControl createImageViewWithFrame:CGRectMake(0,CGRectGetMaxY(orderLabel.frame) + Kmgar, kWidth, Kmgar) ImageName:@""];
    lineImageOne.backgroundColor = UIColorFromRGB(230, 230, 230);
    [bgView addSubview:lineImageOne];
    
    
    NSMutableArray *imageNameArr = [[NSMutableArray alloc] initWithObjects:@"xingbiXB",@"weixinWX",@"zhifubaoZFB",nil];
    
    for (int i = 0; i < imageNameArr.count; i ++) {
        UIImageView *imageNameView = [HHControl createImageViewWithFrame:CGRectMake(Kmgar ,CGRectGetMaxY(lineImageOne.frame) + Kmgar + (KlabelH + 30) * i, 38, 33) ImageName:imageNameArr[i]];
        [bgView addSubview:imageNameView];
        
        if (i == 0) {
            UILabel *xingbiLabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(imageNameView.frame) + Kmgar, CGRectGetMaxY(lineImageOne.frame) + 10, KlabelW, KlabelH) Font:14 Text:@"猩币支付"];
            [bgView addSubview:xingbiLabel];
            
            UILabel *sayXblabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(imageNameView.frame) + Kmgar, CGRectGetMaxY(xingbiLabel.frame), kWidth - 130, KlabelH) Font:9 Text:[NSString stringWithFormat:@"您的剩余猩币总数:%@(每100猩币可抵扣1元)",_user_coin_able]];
            [bgView addSubview:sayXblabel];
            
            UIImageView *lineImageTwo = [HHControl createImageViewWithFrame:CGRectMake(0,CGRectGetMaxY(sayXblabel.frame) + 3, kWidth, 1) ImageName:@""];
            lineImageTwo.backgroundColor = UIColorFromRGB(230, 230, 230);
            [bgView addSubview:lineImageTwo];
        }
        if (i == 1) {
            UILabel *weiChatLabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(imageNameView.frame) + Kmgar, CGRectGetMaxY(lineImageOne.frame) + 40 + KlabelH, KlabelW, KlabelH) Font:14 Text:@"微信支付"];
            [bgView addSubview:weiChatLabel];
            
            UILabel *sayWclabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(imageNameView.frame) + Kmgar, CGRectGetMaxY(weiChatLabel.frame), KlabelWL, KlabelH) Font:9 Text:@"推荐安装微信5.0以上的用户使用"];
            [bgView addSubview:sayWclabel];
            
            UIImageView *lineImageThree = [HHControl createImageViewWithFrame:CGRectMake(0,CGRectGetMaxY(sayWclabel.frame) + 7, kWidth, 1) ImageName:@""];
            lineImageThree.backgroundColor = UIColorFromRGB(230, 230, 230);
            [bgView addSubview:lineImageThree];
        }
        if (i == 2) {
            UILabel *alipayLabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(imageNameView.frame) + Kmgar, CGRectGetMaxY(lineImageOne.frame) + 90 + KlabelH, KlabelW, KlabelH) Font:14 Text:@"支付宝支付"];
            [bgView addSubview:alipayLabel];
            
            UILabel *sayAllabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(imageNameView.frame) + Kmgar, CGRectGetMaxY(alipayLabel.frame), KlabelWL, KlabelH) Font:9 Text:@"推荐有支付宝账号的用户使用"];
            [bgView addSubview:sayAllabel];
        }
        
        UIButton *selectButton = [HHControl createButtonWithFrame:CGRectMake(kWidth - Kmgar - 40, CGRectGetMaxY(lineImageOne.frame) + 16 + (KlabelH + 35) * i, 25, 25) backGruondImageName:@"weixuan" Target:self Action:@selector(clickButton:) Title:@""];
        selectButton.tag =100 + i ;
        [bgView addSubview:selectButton];
    }
    
    CGFloat maxH = CGRectGetMaxY(lineImageOne.frame) + 165;
    bgView.frame = CGRectMake(0, 0, kWidth, maxH);
    
    UIButton *sureButton = [HHControl createButtonWithFrame:CGRectMake(20, CGRectGetMaxY(bgView.frame) + Kmgar *2,kWidth - 40, 40) backGruondImageName:@"zhifuaniu" Target:self Action:@selector(clickSureButton:) Title:[NSString stringWithFormat:@"确认支付%@",_priceLabel.text]];
    [sureButton setTitleColor:UIColorFromRGB(255, 255, 255) forState:UIControlStateNormal];
    [self.view addSubview:sureButton];
}


-(void)clickButton:(UIButton *)btn {
    
    if (btn.tag == 100) {
        btnNumber = 100;
        
        if (isCollect == NO) {
            [btn setBackgroundImage:[UIImage imageNamed:@"yixuan"] forState:UIControlStateNormal];
            UIButton *button1 = (UIButton*)[self.view viewWithTag:101];
            [button1 setBackgroundImage:[UIImage imageNamed:@"weixuan"] forState:UIControlStateNormal];
            UIButton *button2 =(UIButton*) [self.view viewWithTag:102];
            [button2 setBackgroundImage:[UIImage imageNamed:@"weixuan"] forState:UIControlStateNormal];
            
        }else{
            [btn setBackgroundImage:[UIImage imageNamed:@"weixuan"] forState:UIControlStateNormal];
        }
        
    }
    if (btn.tag == 101) {
        btnNumber = 101;
        if (isCollect == NO) {
            [btn setBackgroundImage:[UIImage imageNamed:@"yixuan"] forState:UIControlStateNormal];
            UIButton *button = (UIButton*)[self.view viewWithTag:100];
            [button setBackgroundImage:[UIImage imageNamed:@"weixuan"] forState:UIControlStateNormal];
            UIButton *button2 = (UIButton*)[self.view viewWithTag:102];
            [button2 setBackgroundImage:[UIImage imageNamed:@"weixuan"] forState:UIControlStateNormal];
        }else{
            [btn setBackgroundImage:[UIImage imageNamed:@"weixuan"] forState:UIControlStateNormal];
        }
        
    }
    if (btn.tag == 102) {
        btnNumber = 102;
        if (isCollect == NO) {
            [btn setBackgroundImage:[UIImage imageNamed:@"yixuan"] forState:UIControlStateNormal];
            UIButton *button1 = (UIButton*)[self.view viewWithTag:101];
            [button1 setBackgroundImage:[UIImage imageNamed:@"weixuan"] forState:UIControlStateNormal];
            UIButton *button = (UIButton*)[self.view viewWithTag:100];
            [button setBackgroundImage:[UIImage imageNamed:@"weixuan"] forState:UIControlStateNormal];
        }else{
            [btn setBackgroundImage:[UIImage imageNamed:@"weixuan"] forState:UIControlStateNormal];
        }
    }
}

-(void)clickSureButton:(UIButton *)btn{
    if (btnNumber == 100) {
        
        if (([_xingMoney intValue] > [_user_coin_able intValue])) {
            [SVProgressHUD showInfoWithStatus:@"您的猩币余额不足"];
            return;
        }if ([_price floatValue] > 0) {
            [SVProgressHUD showInfoWithStatus:@"此物品不支持纯猩币抵换"];
            return;
        }
        else{
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定使用猩币支付？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self goods_confirm_payAndOrderID:self.orderId];
                
            }];
            [alert addAction:ok];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }
    if (btnNumber == 101) {
        if (([_xingMoney intValue] > [_user_coin_able intValue])) {
            [SVProgressHUD showInfoWithStatus:@"您的猩币余额不足"];
            return;
        }else if ([self.price intValue] <= 0 && self.price == nil && self.price == NULL && [self.price isEqualToString:@"0.00"]){
            [SVProgressHUD showInfoWithStatus:@"此物品不支持微信支付"];
            return;
        }else if ([[NSString stringWithFormat:@"%@",_price] isEqualToString:@"0.00"]){
            [SVProgressHUD showInfoWithStatus:@"此物品不支持微信支付"];
            return;
        }else{
            [self doPay:PayChannelWxApp];
        }
        
        
    }
    if (btnNumber == 102) {
        
        if ([_xingMoney intValue] > [_user_coin_able intValue]) {
            [SVProgressHUD showInfoWithStatus:@"您的猩币余额不足"];
            return;
        }else if ([self.price intValue] <= 0 && self.price == nil && self.price == NULL && [self.price isEqualToString:@"0.00"]){
            [SVProgressHUD showInfoWithStatus:@"此物品不支持支付宝支付"];
            return;
        }else if ([[NSString stringWithFormat:@"%@",_price] isEqualToString:@"0.00"]){
            [SVProgressHUD showInfoWithStatus:@"此物品不支持支付宝支付"];
            return;
        }
        else{
            [self doPay:PayChannelAliApp];
        }
        
    }
    
}
- (void)viewWillAppear:(BOOL)animated {
#pragma mark - 设置delegate
    [BeeCloud setBeeCloudDelegate:self];
}

#pragma mark - BCPay回调
- (void)onBeeCloudResp:(BCBaseResp *)resp {
    
    switch (resp.type) {
        case BCObjsTypePayResp:
        {
            // 支付请求响应
            BCPayResp *tempResp = (BCPayResp *)resp;
            if (tempResp.resultCode == 0) {
                //微信、支付宝、银联支付成功
                //                [self showAlertView:resp.resultMsg];
                if (_isFlower == YES) {
                    NSString *urlStr = @"http://www.xingxingedu.cn/Global/pay_fbasket_back";
                    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
                    
                    NSDictionary *dict = @{@"appkey":APPKEY,
                                           @"backtype":BACKTYPE,
                                           @"xid":parameterXid,
                                           @"user_id":parameterUser_Id,
                                           @"user_type":USER_TYPE,
                                           @"order_index":_order_index,
                                           @"pay_price":_price,
                                           };
                    
                    // 服务器返回的数据格式
                    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
                    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
                     {
                         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                         
                         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
                         {
                             
                             LSSAlertView *alert = [[LSSAlertView alloc] initWithTitle:resp.resultMsg message:@"您已完成支付,请注意上课时间哦"  picImage:@"支付完成icon120x120"  sureBtn:@"查看订单" cancleBtn:@"现在离开"];
                             alert.returnIndex = ^(NSInteger index){
                                 if (index == 0) {
                                     
                                     OrderInfoViewController *OrderInfoVC = [[OrderInfoViewController alloc] init];
                                     OrderInfoVC.orderID = self.orderId;
                                     OrderInfoVC.isDid = YES;
                                     OrderInfoVC.order_index = _order_index;
                                     OrderInfoVC.hiddenLeftButton = NO;
                                     [self.navigationController pushViewController:OrderInfoVC animated:YES];
                                 }
                                 if (index == 1) {
                                     [self.navigationController popToRootViewControllerAnimated:YES];
                                 }
                             };
                             [alert showAlertView];
                             
                         }
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
                         
                     }];
                    
                }else {
                    
                    NSString *urlStr = @"http://www.xingxingedu.cn/Global/pay_goods_back";
                    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
                    
                    NSDictionary *dict = @{@"appkey":APPKEY,
                                           @"backtype":BACKTYPE,
                                           @"xid":parameterXid,
                                           @"user_id":parameterUser_Id,
                                           @"user_type":USER_TYPE,
                                           @"order_index":_order_index,
                                           @"pay_price":_price,
                                           };
                    
                    // 服务器返回的数据格式
                    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
                    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
                     {
                         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                         
                         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
                         {
                             
                             LSSAlertView *alert = [[LSSAlertView alloc] initWithTitle:resp.resultMsg message:@"您已完成支付,请注意上课时间哦"  picImage:@"支付完成icon120x120"  sureBtn:@"查看订单" cancleBtn:@"现在离开"];
                             alert.returnIndex = ^(NSInteger index){
                                 if (index == 0) {
                                     
                                     OrderInfoViewController *OrderInfoVC = [[OrderInfoViewController alloc] init];
                                     OrderInfoVC.orderID = self.orderId;
                                     OrderInfoVC.isDid = NO;
                                     OrderInfoVC.order_index = _order_index;
                                     OrderInfoVC.hiddenLeftButton = NO;
                                     [self.navigationController pushViewController:OrderInfoVC animated:YES];
                                     
                                 }
                                 
                                 if (index == 1) {
                                     [self.navigationController popToRootViewControllerAnimated:YES];
                                 }
                             };
                             [alert showAlertView];
                             
                         }
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         NSLog(@"请求失败:%@",error);
                         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
                         
                     }];
                    
                    
                }
                
            } else {
                //支付取消或者支付失败
                //                [self showAlertView:[NSString stringWithFormat:@"%@ : %@",tempResp.resultMsg, tempResp.errDetail]];
                LSSAlertView *alert = [[LSSAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@",tempResp.errDetail] message:@"您已取消支付，或者密码不对"  picImage:@"支付失败icon120x120"  sureBtn:@"重新购买" cancleBtn:@"现在离开"];
                alert.returnIndex = ^(NSInteger index){
                    
                    if (index == 1) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                };
                
                [alert showAlertView];
            }
        }
            break;
        default:
        {
            if (resp.resultCode == 0) {
                [self showAlertView:resp.resultMsg];
            } else {
                [self showAlertView:[NSString stringWithFormat:@"%@ : %@",resp.resultMsg, resp.errDetail]];
                
            }
        }
            break;
    }
}
- (void)showAlertView:(NSString *)msg {
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - 微信、支付宝、银联、百度钱包
- (void)doPay:(PayChannel)channel {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value",@"key", nil];
    /**
     按住键盘上的option键，点击参数名称，可以查看参数说明
     **/
    BCPayReq *payReq = [[BCPayReq alloc] init];
    payReq.channel = channel; //支付渠道
    payReq.title = @"猩猩教室订单";//订单标题
    int price  = [self.price floatValue]*100;
    payReq.totalFee = [NSString stringWithFormat:@"%d",price];//订单价格
//        payReq.totalFee = @"1";
    payReq.billNo = self.order_index;//商户自定义订单号
    payReq.scheme = @"payDemo";//URL Scheme,在Info.plist中配置; 支付宝必有参数
    payReq.billTimeOut = 300;//订单超时时间
    payReq.viewController = self; //银联支付和Sandbox环境必填
    payReq.optional = dict;//商户业务扩展参数，会在webhook回调时返回
    [BeeCloud sendBCReq:payReq];
}

//#pragma mark - 订单查询
//- (void)doQuery:(PayChannel)channel {
//
//    if (self.actionType == 1) {
//        BCQueryBillsReq *req = [[BCQueryBillsReq alloc] init];
//        req.channel = channel;
//        req.billStatus = BillStatusOnlySuccess;
//        req.needMsgDetail = YES;
//        req.billNo = self.order_index;//订单号
//        req.startTime = @"2015-10-22 00:00";//订单时间
//        req.endTime = @"2015-10-23 00:00";//订单时间
//        req.skip = 0;//
//        req.limit = 10;
//        [BeeCloud sendBCReq:req];
//    } else if (self.actionType == 2) {
//        BCQueryRefundsReq *req = [[BCQueryRefundsReq alloc] init];
//        req.channel = channel;
//        req.needApproved = NeedApprovalAll;
//        req.billNo = self.order_index;
//        req.startTime = @"2015-07-21 00:00";
//        req.endTime = @"2015-07-23 12:00";
//        req.refundNo = @"20150709173629127";
//        req.skip = 0;
//        req.limit = 10;
//        [BeeCloud sendBCReq:req];
//    }
//}

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
         
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             [SVProgressHUD showSuccessWithStatus:@"猩币支付成功"];
             [self.navigationController popToRootViewControllerAnimated:YES];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}



@end

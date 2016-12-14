

//
//  XXEStorePayViewController.m
//  teacher
//
//  Created by Mac on 2016/11/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStorePayViewController.h"
#import "BeeCloud.h"
#import "LSSAlertView.h"
#import "XXEStoreGoodsOrderDetailViewController.h"
//#import "OrderInfoViewController.h"

@interface XXEStorePayViewController ()<BeeCloudDelegate>
{
    //上部 订单bgView
    UIView *orderBgView;
    //下部 支付bgView
    UIView *payBgView;
    
    //确认支付 按钮
    UIButton *sureButton;
    
    //可用猩币数
    NSString *coinAble;
    //纯猩币支付时候的说明
    UILabel *noteLabel1;
    //
    NSInteger buttonTag;
    //
    NSMutableArray *seleteButtonArray;
    
    //判断是否支付成功过
    BOOL isPaySuccess;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}
@end

@implementation XXEStorePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    coinAble = _dict[@"user_coin_able"];
    seleteButtonArray = [[NSMutableArray alloc] init];
    isPaySuccess = NO;
    
    //输出BOOL值的方法：
//    NSLog(@"%@", _onlyXingCoin ?@"YES":@"NO");

    //创建 内容
    [self createContent];
}

- (void)createContent{

    //上部 订单
    orderBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, 80)];
    orderBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:orderBgView];
    
    //购物车
    UIImageView *shoppingCart = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 38, 33)];
    shoppingCart.image = [UIImage imageNamed:@"gouwuche"];
    [orderBgView addSubview:shoppingCart];
    
    //金额
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(shoppingCart.frame.origin.x + shoppingCart.width + 20, 10, KScreenWidth - 50, 20)];
    moneyLabel.font = [UIFont systemFontOfSize:16 * kScreenRatioWidth];
    if (_dict) {
        if ([_dict[@"pay_price"] floatValue] == 0.000000) {
            _onlyXingCoin = YES;
        }else{
            _onlyXingCoin = NO;
        }
        _pay_coin = _dict[@"pay_coin"];
        _pay_price = _dict[@"pay_price"];
        _order_index = _dict[@"order_index"];

    }
    
    if (_onlyXingCoin == YES) {
        moneyLabel.text = [NSString stringWithFormat:@"猩币:%@", _pay_coin];
    }else if (_onlyXingCoin == NO){
//        NSLog(@"_pay_coin === %@", _pay_coin);
        if (_pay_coin == nil) {
            moneyLabel.text = [NSString stringWithFormat:@"￥:%@", _pay_price];
        }else{
            
            moneyLabel.text = [NSString stringWithFormat:@"猩币:%@     ￥:%@",_pay_coin, _pay_price];
        }
        
   }

    [orderBgView addSubview:moneyLabel];
    
    //订单号
    UILabel *orderCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(moneyLabel.frame.origin.x ,moneyLabel.frame.origin.y + moneyLabel.height + 10, KScreenWidth - 50, 20)];
    orderCodeLabel.font = [UIFont systemFontOfSize:12 * kScreenRatioWidth];
    orderCodeLabel.text = [NSString stringWithFormat:@"订单号:%@", _order_index];
    orderCodeLabel.textColor = [UIColor lightGrayColor];
    [orderBgView addSubview:orderCodeLabel];
    
//    NSLog(@"~~~~~~~~~%f", [_dict[@"pay_price"] floatValue]);
    //下部 支付
    NSString *buttonTitle = @"";
    if (_onlyXingCoin == YES) {
        //纯猩币 支付
        [self createOnlyXingCoinPay];
        buttonTitle = [NSString stringWithFormat:@"确认支付猩币:%@个", _pay_coin];
    }else{
        // 可猩币 / 可钱
        [self createMoneyPay];
        buttonTitle = [NSString stringWithFormat:@"确认支付金额:%@元", _pay_price];
    }
    
    //确认 支付 按钮
    CGFloat buttonX = (KScreenWidth - 325 * kScreenRatioWidth) / 2;
    CGFloat buttonY = payBgView.frame.origin.y + payBgView.height + 20;
    CGFloat buttonW = 325 * kScreenRatioWidth;
    CGFloat buttonH = 42 * kScreenRatioHeight;
    
    sureButton = [HHControl createButtonWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH) backGruondImageName:@"zhifuaniu" Target:self Action:@selector(sureButtonClick:) Title:@""];
    
    sureButton.titleLabel.font = [UIFont systemFontOfSize:16 * kScreenRatioWidth];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    

    [sureButton setTitle:buttonTitle forState:UIControlStateNormal];
    [self.view addSubview:sureButton];

}


#pragma mark ======= 纯 猩币 支付 =============
- (void)createOnlyXingCoinPay{
    payBgView = [[UIView alloc] initWithFrame:CGRectMake(0, orderBgView.frame.origin.y + orderBgView.height + 10, KScreenWidth, 70)];
    payBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:payBgView];
    
    //支付 icon
    UIImageView *xingxingicon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 38, 33)];
    xingxingicon.image = [UIImage imageNamed:@"xingbiXB"];
    [payBgView addSubview:xingxingicon];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xingxingicon.frame.origin.x + xingxingicon.width + 20, 10, KScreenWidth - 50, 20)];
    titleLabel.text = @"猩币支付";
    titleLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    [payBgView addSubview:titleLabel];
    
    //说明
    noteLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x ,titleLabel.frame.origin.y + titleLabel.height + 10, KScreenWidth - 50, 20)];
    noteLabel1.font = [UIFont systemFontOfSize:10 * kScreenRatioWidth];
    [payBgView addSubview:noteLabel1];

    UIButton *selectButton = [HHControl createButtonWithFrame:CGRectMake(KScreenWidth - 50, 20, 25, 25) backGruondImageName:@"weixuan" Target:self Action:@selector(selectButtonClick:) Title:@""];
    selectButton.tag = 100;
    [payBgView addSubview:selectButton];

}

//选择使用猩币支付
- (void)selectButtonClick:(UIButton *)button{

    if (button.tag == 100) {
        buttonTag = 100;
        
        [button setBackgroundImage:[UIImage imageNamed:@"yixuan"] forState:UIControlStateNormal];
    }else if (button.tag == 101){
        buttonTag = 101;
        [button setBackgroundImage:[UIImage imageNamed:@"yixuan"] forState:UIControlStateNormal];
        UIButton *btn = (UIButton *)[self.view viewWithTag:102];
        [btn setBackgroundImage:[UIImage imageNamed:@"weixuan"] forState:UIControlStateNormal];
    
    }else if (button.tag == 102){
        buttonTag = 102;
        [button setBackgroundImage:[UIImage imageNamed:@"yixuan"] forState:UIControlStateNormal];
        UIButton *btn = (UIButton *)[self.view viewWithTag:101];
        [btn setBackgroundImage:[UIImage imageNamed:@"weixuan"] forState:UIControlStateNormal];
        
    }

}

#pragma mark ======= 可猩币 / 可钱 ============
- (void)createMoneyPay{

    payBgView = [[UIView alloc] initWithFrame:CGRectMake(0, orderBgView.frame.origin.y + orderBgView.height + 10, KScreenWidth, 140)];
    [self.view addSubview:payBgView];
    
    //支付 icon
    NSMutableArray *iconArray = [[NSMutableArray alloc] initWithObjects:@"weixinWX", @"zhifubaoZFB", nil];
    //title
    NSMutableArray *titleArray = [NSMutableArray arrayWithObjects:@"微信支付", @"支付宝支付", nil];
    //说明
    NSMutableArray *noteArray = [NSMutableArray arrayWithObjects:@"推荐安装微信5.0以上的用户使用", @"推荐有支付宝账号的用户使用", nil];
    for (int i = 0; i < 2; i++) {
        UIView *cellBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 + (70 + 1) * i, KScreenWidth, 70)];
        cellBgView.backgroundColor = [UIColor whiteColor];
        [payBgView addSubview:cellBgView];
        
        //支付 icon
        UIImageView *xingxingicon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 38, 33)];
        xingxingicon.image = [UIImage imageNamed:iconArray[i]];
        [cellBgView addSubview:xingxingicon];
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xingxingicon.frame.origin.x + xingxingicon.width + 20, 10, KScreenWidth - 50, 20)];
        titleLabel.text = titleArray[i];
        titleLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
        [cellBgView addSubview:titleLabel];
        
        //说明
        UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x ,titleLabel.frame.origin.y + titleLabel.height + 10, KScreenWidth - 50, 20)];
        noteLabel.font = [UIFont systemFontOfSize:10 * kScreenRatioWidth];
        noteLabel.text = noteArray[i];
        [cellBgView addSubview:noteLabel];
        
        UIButton *selectButton = [HHControl createButtonWithFrame:CGRectMake(KScreenWidth - 50, 20, 25, 25) backGruondImageName:@"weixuan" Target:self Action:@selector(selectButtonClick:) Title:@""];
        selectButton.tag = 101 + i;
        
        [cellBgView addSubview:selectButton];
    
    }
    
}



#pragma mark ********** 确认支付 ******************
- (void)sureButtonClick:(UIButton *)button{
    if (buttonTag == 100) {
        //纯猩币 支付
        if ([_pay_coin integerValue] > [coinAble integerValue]) {
            [self showHudWithString:@"您猩币余额不足" forSecond:1.5];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定使用猩币支付?" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                //纯猩币兑换
                [self goods_confirm_payAndOrderID:_order_id];
            }];
        
            [alert addAction:ok];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }else if (buttonTag == 101){
    //微信 支付
        if (isPaySuccess == YES) {
            [self showString:@"该订单您已支付过" forSecond:1.5];
        }else{
        [self doPay:PayChannelWxApp];
        }
    }else if (buttonTag == 102){
        //支付宝 支付
        if (isPaySuccess == YES) {
            [self showString:@"该订单您已支付过" forSecond:1.5];
        }else{
        [self doPay:PayChannelAliApp];
        }
    }
}



#pragma mark ============== 纯猩币兑换 ===========
//商品订单确认兑换 (只用于纯猩币兑换)
- (void)goods_confirm_payAndOrderID:(NSString *)order_id{
/*
 【猩猩商城--商品订单确认兑换 (只用于纯猩币兑换)】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Global/goods_confirm_pay
 传参:
	order_id	//订单id
 */
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/goods_confirm_pay";

    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE,
                             @"order_id":order_id
                             };
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        
//        NSLog(@"纯猩币支付 ==== %@", responseObj);
        
        NSString *codeStr = responseObj[@"code"];
        
        if ([codeStr integerValue] == 1) {
            [self showHudWithString:@"支付成功!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });

        }else if ([codeStr integerValue] == 2){
        
            [self showHudWithString:@"appkey错误!" forSecond:1.5];
        }else if ([codeStr integerValue] == 3){
            
            [self showHudWithString:@"此订单不存在!" forSecond:1.5];
        }else if ([codeStr integerValue] == 4){
            
            [self showHudWithString:@"猩币不足!" forSecond:1.5];
        }else if ([codeStr integerValue] == 5){
            
            [self showHudWithString:@"扣除用户猩币失败!" forSecond:1.5];
        }else if ([codeStr integerValue] == 6){
            
            [self showHudWithString:@"修改订单状态失败!" forSecond:1.5];
        }

    } failure:^(NSError *error) {
        //
        [self showHudWithString:@"获取数据失败!" forSecond:1.5];
    }];
    
}

#pragma mark $$$$$$$$$$$$$ beeCloud **************************
#pragma mark - 设置delegate
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [BeeCloud setBeeCloudDelegate:self];
}

/*
 #pragma mark - 微信、支付宝、银联、百度钱包
 - (void)doPay:(PayChannel)channel {
 NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value",@"key", nil];

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

NSLog(@"payReq === %@", payReq);
[BeeCloud sendBCReq:payReq];
}

 */

#pragma mark - 微信、支付宝、银联、百度钱包
- (void)doPay:(PayChannel)channel {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value",@"key", nil];

    BCPayReq *payReq = [[BCPayReq alloc] init];
    /**
     *  支付渠道，PayChannelWxApp,PayChannelAliApp,PayChannelUnApp,PayChannelBaiduApp
     */
    payReq.channel = channel; //支付渠道
    payReq.title = @"猩猩教室家长端订单";//订单标题
    int price = [_pay_price floatValue]*100;
    
    payReq.totalFee = [NSString stringWithFormat:@"%d", price];//订单价格;
    payReq.billNo = _order_index;//商户自定义订单号
    payReq.scheme = @"payDemo";//URL Scheme,在Info.plist中配置; 支付宝必有参数/注意不能有下划线
    payReq.billTimeOut = 300;//订单超时时间
    payReq.viewController = self; //银联支付和Sandbox环境必填
    payReq.optional = dict;//商户业务扩展参数，会在webhook回调时返回

    [BeeCloud sendBCReq:payReq];
}

#pragma mark - BCPay回调
- (void)onBeeCloudResp:(BCBaseResp *)resp {
    
    switch (resp.type) {
        case BCObjsTypePayResp:
        {
            // 支付请求响应
            BCPayResp *tempResp = (BCPayResp *)resp;
            
//            NSLog(@"tempResp ==== %@", tempResp);
//            
//            NSLog(@"tempResp.resultCode --- %ld", tempResp.resultCode);
            
            NSLog(@"错误 详情 == %@", tempResp.errDetail);
            
            if (tempResp.resultCode == 0) {
                
                //支付宝 或者 微信 支付
                [self showAlertView:resp.resultMsg];
                
                [self weixinPayOrAliPay:tempResp];
                
            } else {
                //支付取消或者支付失败
//                [self showAlertView:[NSString stringWithFormat:@"%@ : %@",tempResp.resultMsg, tempResp.errDetail]];
        NSLog(@"tempResp.errDetail == %@", tempResp.errDetail);
                
                LSSAlertView *alert = [[LSSAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@",tempResp.errDetail] message:@"您已取消支付，或者密码不对"  picImage:@"payfailed_icon120x120" sureBtn:@"重新购买" cancleBtn:@"现在离开"];
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




#pragma mark - 生成订单号
- (NSString *)genBillNo {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    return [formatter stringFromDate:[NSDate date]];
}

- (void)setHideTableViewCell:(UITableView *)tableView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = view;
}



- (void)logEventId:(NSString *)eventId eventDesc:(NSString *)eventDesc {
    
    
}



#pragma mark ################ 微信 或者  支付宝 支付 #############
- (void)weixinPayOrAliPay:(BCPayResp *)resp{
/*
 【猩猩商城--商品用钱支付完成回调信息验证】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Global/pay_goods_back
 传参:
	order_index		//订单号
	pay_price		//支付金额
 */
   NSString *urlStr = @"http://www.xingxingedu.cn/Global/pay_goods_back";
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE,
                             @"order_index": _order_index,
                             @"pay_price":_pay_price
                             };
//    NSLog(@"params  支付 %@", params);
    
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
//        NSLog(@"微信 / 支付宝 支付 ==== %@", responseObj);
        NSString *codeStr = responseObj[@"code"];
        
        if ([codeStr integerValue] == 1) {
            
            LSSAlertView *alert = [[LSSAlertView alloc] initWithTitle:resp.resultMsg message:@"支付成功!"  picImage:@"paysuccess_icon120x120"  sureBtn:@"查看订单" cancleBtn:@"现在离开"];
            
            isPaySuccess = YES;
            alert.returnIndex = ^(NSInteger index){
                if (index == 0) {
                    
//                    OrderInfoViewController *OrderInfoVC = [[OrderInfoViewController alloc] init];
//                    OrderInfoVC.orderID = self.order_id;
//                    OrderInfoVC.isDid = YES;
//                    OrderInfoVC.order_index = _order_index;
//                    OrderInfoVC.hiddenLeftButton = NO;
//                    [self.navigationController pushViewController:OrderInfoVC animated:YES];
//                    NSLog(@"查看订单详情");
                    XXEStoreGoodsOrderDetailViewController *goodsOrderDetailVC = [[XXEStoreGoodsOrderDetailViewController alloc] init];
//                    NSLog(@"_order_id === %@", _order_id);
                    
                    if (_order_id) {
                      goodsOrderDetailVC.order_id = _order_id;
                    }

                    [self.navigationController pushViewController:goodsOrderDetailVC animated:YES];
                    
                }
                
                if (index == 1) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            };
            [alert showAlertView];
        }

    } failure:^(NSError *error) {
        //
        [self showHudWithString:@"获取数据失败!" forSecond:1.5];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

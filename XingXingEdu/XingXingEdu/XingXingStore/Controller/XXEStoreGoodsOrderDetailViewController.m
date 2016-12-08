//
//  XXEStoreGoodsOrderDetailViewController.m
//  teacher
//
//  Created by Mac on 2016/11/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStoreGoodsOrderDetailViewController.h"
//支付
#import "XXEStorePayViewController.h"
//申请退货
#import "XXEStoreReturnGoodsViewController.h"


@interface XXEStoreGoodsOrderDetailViewController ()
{
    //上部分 bgView
    UIView *upBgView;
    //中间 bgView
    UIView *middleView;
    
    //下部分 bgView
    UIView *downBgView;
    
    //头像 数组
    NSMutableArray *iconArray;
    //标题 数组
    NSMutableArray *titleArray;
    
    //订单详情结果 字典
    NSDictionary *detailInfoDict;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@end

@implementation XXEStoreGoodsOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    self.edgesForExtendedLayout=UIRectEdgeNone;
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    iconArray = [[NSMutableArray alloc] initWithObjects:@"dingdan", @"time", @"zhuangtai", nil];
    titleArray = [[NSMutableArray alloc] initWithObjects:@"订单号:", @"下单时间:", @"订单状态:", nil];
    detailInfoDict = [[NSDictionary alloc] init];
    
    //获取 数据
    [self fetchCourseOrderDetailInfo];
    
}

- (void)fetchCourseOrderDetailInfo{
    /*
     【猩猩商城--订单详情】
     接口类型:1
     接口:
     http://www.xingxingedu.cn/Global/goods_order_detail
     传参:
     order_id	//订单id	*/
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/goods_order_detail";
    
//    NSLog(@"订单详情 _order_id ==%@", _order_id);
    
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE,
                             @"order_id":_order_id                            };
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        
//        NSLog(@" ooo %@", responseObj);
        //class = 1
        
        if ([responseObj[@"code"] integerValue] == 1) {
            detailInfoDict = responseObj[@"data"];
        }
        
        [self createContent];
        
    } failure:^(NSError *error) {
        //
        [self showString:@"获取数据失败!" forSecond:1.5];
    }];
    
}

- (void)createContent{
    //创建 上部分 内容
    [self createUpContent];
    
    //创建 中间  内容
    [self createMiddleContent];
    
    if ([detailInfoDict[@"class"] integerValue] != 1) {
        //创建 下部分 内容
        [self createDownContent];
    }
    

    if ([detailInfoDict[@"condit"] integerValue] == 0 || [detailInfoDict[@"condit"] integerValue] == 2){
       //待付款 按钮 标题
        NSMutableArray *arr1 = [[NSMutableArray alloc] initWithObjects:@"取消订单", @"确认购买", nil];
        //待收货 按钮 标题
        NSMutableArray *arr2 = [[NSMutableArray alloc] initWithObjects:@"立刻收货", @"可退货", nil];
        
        CGFloat buttonX = (KScreenWidth - 325 * kScreenRatioWidth) / 2;
        CGFloat buttonW = 325 * kScreenRatioWidth;
        CGFloat buttonH = 42 * kScreenRatioHeight;
        
        for (int h = 0; h < 2; h ++) {
            UIButton *button = [HHControl createButtonWithFrame:CGRectMake(buttonX, downBgView.frame.origin.y + downBgView.height + 10 + (buttonH + 10) * h, buttonW, buttonH) backGruondImageName:@"按钮big650x84" Target:self Action:@selector(buttonClick:) Title:@""];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:18 * kScreenRatioWidth];
            
            if ([detailInfoDict[@"condit"] integerValue] == 0){
            
                [button setTitle:arr1[h] forState:UIControlStateNormal];
                button.tag = 100 + h;
            }else if ([detailInfoDict[@"condit"] integerValue] == 2){
                
                [button setTitle:arr2[h] forState:UIControlStateNormal];
                button.tag = 1000 + h;
            }
            
        [self.view addSubview:button];
  
        }
    }
    
}


- (void)buttonClick:(UIButton *)button{
    if (button.tag == 100) {
      //待付款 取消订单
//        NSLog(@"待付款 取消订单");
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定取消此订单？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self cancleStoreGoodsOrder];
        }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }else if (button.tag == 101){
#pragma mark  ************ //待付款 确认购买 ************
         NSLog(@"待付款 确认购买");
        XXEStorePayViewController *vc=[[XXEStorePayViewController alloc]init];
        /*
         "pay_coin" = 100;
         "pay_price" = "0.01";
         */
        if ([detailInfoDict[@"pay_price"] floatValue] == 0.000000) {
            vc.onlyXingCoin = YES;
        }else{
            vc.onlyXingCoin = NO;
        }
        vc.pay_coin = detailInfoDict[@"pay_coin"];
        vc.pay_price = detailInfoDict[@"pay_price"];
        vc.order_index = detailInfoDict[@"order_index"];
        vc.order_id =  _order_id;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (button.tag == 1000){
        //待收货 确认收货
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定要确认收货？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self confirmGetStoreGoods];
        }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else if (button.tag == 1001){
        
#pragma mark ========= //待收货 可退货 ================
        XXEStoreReturnGoodsViewController *storeReturnGoodsVC = [[XXEStoreReturnGoodsViewController alloc] init];
        storeReturnGoodsVC.order_id = _order_id;
        
        [self.navigationController pushViewController:storeReturnGoodsVC animated:YES];
    }


}


#pragma mark ******** 待付款 取消订单 *********
- (void)cancleStoreGoodsOrder{
/*
 【猩猩商城--取消订单】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Global/cancle_goods_order
 传参:
	order_id	//订单id
 */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/cancle_goods_order";
    
    NSDictionary *params = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"order_id":_order_id,
                           };
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
//        NSLog(@"nnn %@", responseObj);
        
        if ([responseObj[@"code"] integerValue] == 1) {
            
            [self showString:@"取消订单成功!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });

        }else{
            [self showString:@"取消订单失败!" forSecond:1.5];
        }

        
    } failure:^(NSError *error) {
        //
        [self showString:@"获取数据失败!" forSecond:1.5];
    }];
}

#pragma mark %%%%%%%%%%%% 待收货 确认收货 %%%%%%%%%%%%%%
- (void)confirmGetStoreGoods{
/*
 【猩猩商城--确认收货】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Global/goods_order_confirm
 传参:
	order_id	//订单id
 */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/goods_order_confirm";
    
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE,
                             @"order_id":_order_id,
                             };
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
//        NSLog(@"nnn %@", responseObj);
        
        if ([responseObj[@"code"] integerValue] == 1) {
            
            [self showString:@"确认收货成功!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            [self showString:@"确认收货失败!" forSecond:1.5];
        }
        
    } failure:^(NSError *error) {
        //
        [self showString:@"获取数据失败!" forSecond:1.5];
    }];

}

#pragma mark ======= 创建 上部分 内容 ======
- (void)createUpContent{
    
    upBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 210)];
    upBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:upBgView];
    
    // [condit] => 1	//0:待付款 1:待发货 2:待收货 3:完成 10:退货中  11:退货驳回  12:退货完成
    NSString *state = @"";
    if ([detailInfoDict[@"condit"] integerValue] == 0) {
        state = @"待付款";
    }else if ([detailInfoDict[@"condit"] integerValue] == 1) {
        state = @"待发货";
    }else if ([detailInfoDict[@"condit"] integerValue] == 2) {
        state = @"待收货";
    }else if ([detailInfoDict[@"condit"] integerValue] == 3) {
        state = @"完成";
    }else if ([detailInfoDict[@"condit"] integerValue] == 10) {
        state = @"退货中";
    }else if ([detailInfoDict[@"condit"] integerValue] == 11) {
        state = @"退货驳回";
    }else if ([detailInfoDict[@"condit"] integerValue] == 12) {
        state = @"退货完成";
    }
    
    NSMutableArray *textArray = [[NSMutableArray alloc] initWithObjects:detailInfoDict[@"order_index"], [WZYTool dateStringFromNumberTimer:detailInfoDict[@"date_tm"]], state, nil];
    
    for (int i = 0; i < 3; i++) {
        //icon
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5 + 30 * i, 18, 20)];
        iconImageView.image = [UIImage imageNamed:iconArray[i]];
        [upBgView addSubview:iconImageView];
        
        //title
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5 + 30 * i, 70, 20)];
        titleLabel.text = titleArray[i];
        titleLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
        [upBgView addSubview:titleLabel];
        
        //text
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 5 + 30 * i, KScreenWidth - 130, 20)];
        textLabel.text = textArray[i];
        textLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
        if (i == 2) {
            textLabel.textColor = [UIColor redColor];
        }
        [upBgView addSubview:textLabel];
        
    }
    
    //分割线
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(10, 90, KScreenWidth - 20, 1)];
    lineView1.backgroundColor = UIColorFromRGB(229, 232, 233);
    [upBgView addSubview:lineView1];
    
    //商品图片
    UIImageView *coursePic = [[UIImageView alloc] initWithFrame:CGRectMake(10, lineView1.frame.origin.y + 5, 70, 70)];
    //course_pic
    [coursePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kXXEPicURL, detailInfoDict[@"pic"]]] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
    [upBgView addSubview:coursePic];
    
    //商品名称
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, coursePic.frame.origin.y, KScreenWidth - 100, 20)];
    nameLabel.text = detailInfoDict[@"title"];
    nameLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    [upBgView addSubview:nameLabel];
    
    //商品价格
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, nameLabel.frame.origin.y + nameLabel.height + 10, KScreenWidth - 100, 20)];
    priceLabel.text = [NSString stringWithFormat:@"¥:%@",detailInfoDict[@"price"]];
    priceLabel.textColor = [UIColor redColor];
    priceLabel.font = [UIFont systemFontOfSize:12 * kScreenRatioWidth];
    [upBgView addSubview:priceLabel];
    
    //猩币
    UIImageView *coinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth / 3 * 2, priceLabel.frame.origin.y, 16, 16)];
    coinImageView.image = [UIImage imageNamed:@"store_xingbi_icon"];
    [upBgView addSubview:coinImageView];
    UILabel *coinLabel = [[UILabel alloc] initWithFrame:CGRectMake(coinImageView.frame.origin.x + 16 + 5, coinImageView.frame.origin.y, KScreenWidth / 3 - 20, 20)];
    coinLabel.text = [NSString stringWithFormat:@"猩币:%@", detailInfoDict[@"exchange_coin"]];
    coinLabel.font = [UIFont systemFontOfSize:12 * kScreenRatioWidth];
    [upBgView addSubview:coinLabel];
    
    
    //销量
    UIImageView *saleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth / 3 * 2, coinImageView.frame.origin.y + coinImageView.height + 5, 16, 16)];
    saleImageView.image = [UIImage imageNamed:@"sale_icon"];
    [upBgView addSubview:saleImageView];
    UILabel *saleLabel = [[UILabel alloc] initWithFrame:CGRectMake(coinImageView.frame.origin.x + 16 + 5, saleImageView.frame.origin.y, KScreenWidth / 3 - 20, 20)];
    saleLabel.text = [NSString stringWithFormat:@"销量:%@", detailInfoDict[@"sale_num"]];
    saleLabel.font = [UIFont systemFontOfSize:12 * kScreenRatioWidth];
    [upBgView addSubview:saleLabel];
    
    //分割线
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(10, coursePic.frame.origin.y + coursePic.height + 5, KScreenWidth - 20, 1)];
    lineView2.backgroundColor = UIColorFromRGB(229, 232, 233);
    [upBgView addSubview:lineView2];
    
    //购买数量
    NSString *numStr = [NSString stringWithFormat:@"购买数量:%@", detailInfoDict[@"buy_num"]];
    //实付金额
    NSString *priceStr = [NSString stringWithFormat:@"实付:%@元", detailInfoDict[@"exchange_price"]];
    //猩币
    NSString *deductionStr = [NSString stringWithFormat:@"猩币:%ld", [detailInfoDict[@"exchange_coin"] integerValue] * [detailInfoDict[@"buy_num"] integerValue]];
    
    NSMutableArray *priceArray = [[NSMutableArray alloc] initWithObjects:numStr, priceStr, deductionStr, nil];
    CGFloat labelW = KScreenWidth / 3;
    CGFloat labelH = 20;
    
    for (int j = 0; j < 3; j++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(j * labelW, lineView2.frame.origin.y + 10, labelW, labelH)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = priceArray[j];
        label.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
        [upBgView addSubview: label];
    }
}

#pragma mark ========= 创建 中间部分 内容 =======
- (void)createMiddleContent{
    middleView = [[UIView alloc] initWithFrame:CGRectMake(0, upBgView.frame.origin.y + upBgView.height + 5, KScreenWidth, 150)];
    middleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:middleView];
    
    //收货人
    NSString *buyer = [NSString stringWithFormat:@"收货人:%@", detailInfoDict[@"name"]];
    //电话
    NSString *phone = [NSString stringWithFormat:@"电话:%@", detailInfoDict[@"phone"]];
    NSMutableArray *contentArray = [[NSMutableArray alloc] initWithObjects:buyer, phone, nil];
    
    CGFloat labelW = (KScreenWidth - 20) / 2;
    CGFloat labelH = 20;
    for (int k = 0; k < 2; k ++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + k * labelW, 5 , labelW, labelH)];
        titleLabel.text = contentArray[k];
        titleLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
        [middleView addSubview:titleLabel];
    }
    
    //分割线
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(10, 30, KScreenWidth - 20, 1)];
    lineView1.backgroundColor = UIColorFromRGB(229, 232, 233);
    [middleView addSubview:lineView1];
    //地址
    UIImageView *addressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, lineView1.frame.origin.y + 20, 18, 20)];
    addressImageView.image = [UIImage imageNamed:@"地址icon30x42"];
    [middleView addSubview:addressImageView];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(addressImageView.frame.origin.x + 18, addressImageView.frame.origin.y, KScreenWidth - 40, 40)];
    
    addressLabel.numberOfLines = 0;
    NSString *addressStr = [NSString stringWithFormat:@"%@%@%@%@", detailInfoDict[@"province"],detailInfoDict[@"city"],detailInfoDict[@"district"],detailInfoDict[@"address"]];
    addressLabel.text = addressStr;
    addressLabel.font = [UIFont systemFontOfSize:12 * kScreenRatioWidth];
    [middleView addSubview:addressLabel];
    
    //分割线
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(10, addressLabel.frame.origin.y + addressLabel.height + 5, KScreenWidth - 20, 1)];
    lineView2.backgroundColor = UIColorFromRGB(229, 232, 233);
    [middleView addSubview:lineView2];
    //留言
    UIImageView *messageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, lineView2.frame.origin.y + 5, 18, 20)];
    messageImageView.image = [UIImage imageNamed:@"Buyer-message"];
    [middleView addSubview:messageImageView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(messageImageView.frame.origin.x + 18, messageImageView.frame.origin.y, 70, 20)];
    titleLabel.text = @"买家留言:";
    titleLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    [middleView addSubview:titleLabel];
    
    UITextView *messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x + titleLabel.width, titleLabel.frame.origin.y, KScreenWidth - 100, 40)];
    messageTextView.text = detailInfoDict[@"buyer_words"];
    messageTextView.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    [middleView addSubview:messageTextView];

}


#pragma mark ======= 创建 下部分 内容 =============
- (void)createDownContent{
    downBgView = [[UIView alloc] initWithFrame:CGRectMake(0, middleView.frame.origin.y + middleView.height + 5, KScreenWidth, 40)];
    downBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:downBgView];
    
    //发票抬头
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, KScreenWidth - 20, 20)];
    titleLabel.text = [NSString stringWithFormat:@"发票抬头:%@", detailInfoDict[@"receipt"]];
    titleLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    [downBgView addSubview:titleLabel];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

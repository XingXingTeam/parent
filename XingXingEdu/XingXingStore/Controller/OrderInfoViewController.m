//
//  OrderInfoViewController.m
//  XingXingEdu
//
//  Created by codeDing on 16/3/2.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "OrderInfoViewController.h"
#import "WZYTool.h"
#import "PayMannerViewController.h"
#import "ReturnOfGoodsViewController.h"
#define Kmarg 10.0f
#define KLabelX 30.0f
#define KLabelW 70.0f
#define KLabelH 30.0f
#define kUnderButtonH 64.0f
@interface OrderInfoViewController (){
    NSMutableArray *orderArray;
    UIScrollView *_bgScrollView;
}

@end

@implementation OrderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"订单详情";
    
    [self createLeftButton];
    
    [self getorderInfo];
}


-(void)createLeftButton{
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(- 10, 0, 44, 20);
    
    [backBtn setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    if (_hiddenLeftButton == NO) {
        [backBtn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [backBtn addTarget:self action:@selector(popDoBack) forControlEvents:UIControlEventTouchUpInside];
        
    }
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}

-(void)popDoBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)doBack:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)creatField{
    
    //背景
    _bgScrollView = [[UIScrollView alloc] init];
    _bgScrollView.frame = CGRectMake(0, 0, kWidth,kHeight + 64 + 49);
    _bgScrollView.backgroundColor = UIColorFromRGB(241, 242, 241);
    _bgScrollView.pagingEnabled = NO;
    _bgScrollView.showsHorizontalScrollIndicator = YES;
    _bgScrollView.showsVerticalScrollIndicator  = YES;
    _bgScrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_bgScrollView];
    
    UIView *bgOrderView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, kWidth - 10, 300)];
    bgOrderView.backgroundColor = UIColorFromRGB(255, 255, 255);
    [_bgScrollView addSubview:bgOrderView];
    
    //订单号
    UILabel *orderLabel = [HHControl createLabelWithFrame:CGRectMake(40, 0, kWidth - 60, KLabelH) Font:14 Text:[NSString stringWithFormat:@"订单号:%@",orderArray[0]]];
    orderLabel.textAlignment = NSTextAlignmentLeft;
    [bgOrderView addSubview:orderLabel];
    UIImageView *orderImage = [[UIImageView alloc] initWithFrame:CGRectMake(- 20, 5, 18, 20)];
    orderImage.image = [UIImage imageNamed:@"dingdan.png"];
    [orderLabel addSubview:orderImage];
    
    //下单时间
    NSString *timeStr = [WZYTool dateStringFromNumberTimer:orderArray[1]];
    UILabel *orderTimeLabel = [HHControl createLabelWithFrame:CGRectMake(40, CGRectGetMaxY(orderLabel.frame), kWidth - 60, KLabelH) Font:14 Text:[NSString stringWithFormat:@"下单时间: %@",timeStr]];
    orderTimeLabel.textAlignment = NSTextAlignmentLeft;
    [bgOrderView addSubview:orderTimeLabel];
    UIImageView *orderTimeImage = [[UIImageView alloc] initWithFrame:CGRectMake(- 20, 5, 18, 20)];
    orderTimeImage.image = [UIImage imageNamed:@"time.png"];
    [orderTimeLabel addSubview:orderTimeImage];
    
    //订单状态
    UILabel *orderStatusLabel = [HHControl createLabelWithFrame:CGRectMake( 40, CGRectGetMaxY(orderTimeLabel.frame), KLabelW, KLabelH) Font:14 Text:@"订单状态:"];
    orderStatusLabel.textAlignment = NSTextAlignmentLeft;
    [bgOrderView addSubview:orderStatusLabel];
    
    UIImageView *orderStatusImage = [[UIImageView alloc] initWithFrame:CGRectMake( - 20, 5, 18, 20)];
    orderStatusImage.image = [UIImage imageNamed:@"zhuangtai.png"];
    [orderStatusLabel addSubview:orderStatusImage];
    
    
    UILabel *orderStatusmessageLabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(orderStatusLabel.frame), CGRectGetMaxY(orderTimeLabel.frame) , kWidth - CGRectGetMaxX(orderStatusLabel.frame)- Kmarg, KLabelH) Font:14 Text:@""];
    if ([orderArray[15] isEqualToString:@"0"]) {
        orderStatusmessageLabel.text = @"待付款";
    }else if ([orderArray[15] isEqualToString:@"1"]){
        if (_isDid == YES) {
            orderStatusmessageLabel.text = @"已完成";
        }else{
            orderStatusmessageLabel.text = @"待发货";
        }
    }else if ([orderArray[15] isEqualToString:@"2"]){
        orderStatusmessageLabel.text = @"待收货";
    }else if ([orderArray[15] isEqualToString:@"3"]){
        orderStatusmessageLabel.text = @"已完成";
    }else{
        orderStatusmessageLabel.text = @"退货";
    }
    orderStatusmessageLabel.textColor = [UIColor redColor];
    [bgOrderView addSubview:orderStatusmessageLabel];
    
    //分割线1
    UIImageView *line1 = [HHControl createImageViewWithFrame:CGRectMake(10, CGRectGetMaxY(orderStatusLabel.frame), kWidth - 30, 1) ImageName:@""];
    line1.backgroundColor = UIColorFromRGB(230, 230, 230);
    [bgOrderView addSubview:line1];
    
    //订单详细信息
    UIView *bgSubjeactView = [HHControl createViewWithFrame:CGRectMake(Kmarg, CGRectGetMaxY(line1.frame), kWidth - 20, 90)];
    [bgOrderView addSubview:bgSubjeactView];
    
    UIImageView *subjeateImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 70, 70)];
    subjeateImage.backgroundColor = [UIColor yellowColor];
    [subjeateImage sd_setImageWithURL:[NSURL URLWithString:orderArray[2]] placeholderImage:nil];
    [bgSubjeactView addSubview:subjeateImage];
    
    UILabel *subjeatName = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(subjeateImage.frame) + Kmarg, 8, bgSubjeactView.size.width - CGRectGetMaxX(subjeateImage.frame) - 20, KLabelH) Font:16 Text:orderArray[3]];
    subjeatName.textAlignment = NSTextAlignmentLeft;
    [bgSubjeactView addSubview:subjeatName];
    
    //猩币
    UILabel *xingbiLabel = [HHControl createLabelWithFrame:CGRectMake(210, CGRectGetMaxY(subjeatName.frame) - 12, 80, KLabelH) Font:14 Text:[NSString stringWithFormat:@"猩币:%@",orderArray[5]]];
    xingbiLabel.textAlignment = NSTextAlignmentLeft;
    //    xingbiLabel.backgroundColor = [UIColor yellowColor];
    [bgSubjeactView addSubview:xingbiLabel];
    UIImageView *xingbiImage = [[UIImageView alloc] initWithFrame:CGRectMake(- 20, 5, 18, 20)];
    xingbiImage.image = [UIImage imageNamed:@"xingbiXB.png"];
    [xingbiLabel addSubview:xingbiImage];
    
    //销量
    UILabel *salesLabel = [HHControl createLabelWithFrame:CGRectMake(210, CGRectGetMaxY(xingbiLabel.frame), 80, KLabelH) Font:14 Text:[NSString stringWithFormat:@"销量:%@",orderArray[6]]];
    salesLabel.textAlignment = NSTextAlignmentLeft;
    //    salesLabel.backgroundColor = [UIColor yellowColor];
    [bgSubjeactView addSubview:salesLabel];
    UIImageView *salesImage = [[UIImageView alloc] initWithFrame:CGRectMake(- 20, 5, 15, 15)];
    salesImage.image = [UIImage imageNamed:@"销量.png"];
    [salesLabel addSubview:salesImage];
    
    UILabel *subjeatPrice = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(subjeateImage.frame) + Kmarg, CGRectGetMaxY(subjeatName.frame) , bgSubjeactView.size.width - CGRectGetMaxX(subjeateImage.frame) - 20, KLabelH) Font:14 Text:[NSString stringWithFormat:@"￥%@",orderArray[4]]];
    subjeatPrice.textColor = [UIColor redColor];
    [bgSubjeactView addSubview:subjeatPrice];
    
    
    //分割线2
    UIImageView *line2 = [HHControl createImageViewWithFrame:CGRectMake(10, CGRectGetMaxY(bgSubjeactView.frame), kWidth - 30, 1) ImageName:@""];
    line2.backgroundColor = UIColorFromRGB(230, 230, 230);
    [bgOrderView addSubview:line2];
    
    
    //付款
    UILabel *orderCount = [HHControl createLabelWithFrame:CGRectMake(20, CGRectGetMaxY(line2.frame) + 3, kWidth - 40, KLabelH) Font:14 Text:[NSString stringWithFormat:@"购买数量: %@      实付: %@      猩币: %@",orderArray[7],orderArray[4],orderArray[5]]];
    orderCount.textAlignment = NSTextAlignmentLeft;
    [bgOrderView addSubview:orderCount];
    
    //重写bgoderViewd的大小
    bgOrderView.frame = CGRectMake(5, 5, kWidth - 10, CGRectGetMaxY(orderCount.frame) + Kmarg);
    
    
    UIView *bgAccountView = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(bgOrderView.frame) + 5, kWidth - 10, 300)];
    bgAccountView.backgroundColor = UIColorFromRGB(255, 255, 255);
    [_bgScrollView addSubview:bgAccountView];
    
    
    //收货人
    UILabel *consigneeLabel = [HHControl createLabelWithFrame:CGRectMake( 20, 5,( kWidth - 20)/2, KLabelH) Font:14 Text:[NSString stringWithFormat:@"收货人:%@",orderArray[8]]];
    consigneeLabel.textAlignment = NSTextAlignmentLeft;
    [bgAccountView addSubview:consigneeLabel];
    
    //联系电话
    UILabel *telephoneLabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(consigneeLabel.frame), 5, ( kWidth - 40)/2,KLabelH) Font:14 Text:[NSString stringWithFormat:@"联系电话:%@",orderArray[9]]];
    telephoneLabel.textAlignment = NSTextAlignmentLeft;
    [bgAccountView addSubview:telephoneLabel];
    
    //分割线3
    UIImageView *line3 = [HHControl createImageViewWithFrame:CGRectMake(10, CGRectGetMaxY(consigneeLabel.frame), kWidth - 30, 1) ImageName:@""];
    line3.backgroundColor = UIColorFromRGB(230, 230, 230);
    [bgAccountView addSubview:line3];
    
    
    //地址
    UILabel *addressLabel = [HHControl createLabelWithFrame:CGRectMake(40, CGRectGetMaxY(line3.frame), kWidth - 60, KLabelH) Font:14 Text:orderArray[10]];
    addressLabel.textAlignment = NSTextAlignmentLeft;
    [bgAccountView addSubview:addressLabel];
    
    UIImageView *addressImage = [[UIImageView alloc] initWithFrame:CGRectMake(- 20, 5, 18, 20)];
    addressImage.image = [UIImage imageNamed:@"地址icon30x42.png"];
    [addressLabel addSubview:addressImage];
    
    //分割线4
    UIImageView *line4 = [HHControl createImageViewWithFrame:CGRectMake(10, CGRectGetMaxY(addressLabel.frame), kWidth - 30, 1) ImageName:@""];
    line4.backgroundColor = UIColorFromRGB(230, 230, 230);
    [bgAccountView addSubview:line4];
    
    //买家留言
    UILabel *buyerLabel = [HHControl createLabelWithFrame:CGRectMake(40, CGRectGetMaxY(line4.frame), kWidth - 60, KLabelH) Font:14 Text:@"买家留言:"];
    buyerLabel.textAlignment = NSTextAlignmentLeft;
    [bgAccountView addSubview:buyerLabel];
    
    UIImageView *buyerImage = [[UIImageView alloc] initWithFrame:CGRectMake(- 20, 5, 18, 20)];
    buyerImage.image = [UIImage imageNamed:@"Buyer-message.png"];
    [buyerLabel addSubview:buyerImage];
    
    UITextView *buyerSayView = [[UITextView alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(buyerLabel.frame), kWidth - 80, 120)];
    buyerSayView.text = orderArray[11];
    buyerSayView.font = [UIFont systemFontOfSize:12];
    buyerSayView.userInteractionEnabled = NO;
    [buyerSayView flashScrollIndicators];   // 闪动滚动条
    //自动适应行高
    static CGFloat maxHeight = 130.0f;
    CGRect frame = buyerSayView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [buyerSayView sizeThatFits:constraintSize];
    if (size.height >= maxHeight){
        size.height = maxHeight;
        buyerSayView.scrollEnabled = YES;   // 允许滚动
    }
    else{
        buyerSayView.scrollEnabled = NO;    // 不允许滚动，当textview的大小足以容纳它的text的时候，需要设置scrollEnabed为NO，否则会出现光标乱滚动的情况
    }
    buyerSayView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    [bgAccountView addSubview:buyerSayView];
    
    
    //重写bgAccountView的大小
    bgAccountView.frame = CGRectMake(5,CGRectGetMaxY(bgOrderView.frame) + Kmarg , kWidth - 10, CGRectGetMaxY(buyerSayView.frame) + Kmarg );
    
    UIView *bgTimeView = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(bgAccountView.frame) + 5, kWidth - 10, 70)];
    bgTimeView.backgroundColor = UIColorFromRGB(255, 255, 255);
    [_bgScrollView addSubview:bgTimeView];
    
    //买家留言
    UILabel *receiptLabel = [HHControl createLabelWithFrame:CGRectMake(20, 5, kWidth - 60, KLabelH) Font:14 Text:[NSString stringWithFormat:@"发票抬头:%@",orderArray[12]]];
    receiptLabel.textAlignment = NSTextAlignmentLeft;
    [bgTimeView addSubview:receiptLabel];
    
    //分割线5
    UIImageView *line5 = [HHControl createImageViewWithFrame:CGRectMake(10, CGRectGetMaxY(receiptLabel.frame), kWidth - 30, 1) ImageName:@""];
    line5.backgroundColor = UIColorFromRGB(230, 230, 230);
    [bgTimeView addSubview:line5];
    
    UILabel *timeLabel = [HHControl createLabelWithFrame:CGRectMake(20, CGRectGetMaxY(line5.frame), kWidth - 40, KLabelH) Font:14 Text:[NSString stringWithFormat:@"收货时间还剩%@",orderArray[13]]];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [bgTimeView addSubview:timeLabel];
    
    //重写bgTimeView的大小
    bgTimeView.frame = CGRectMake(5,CGRectGetMaxY(bgAccountView.frame) + Kmarg , kWidth - 10, 65);
    
    UIButton *cancelBtn  = [HHControl createButtonWithFrame:CGRectMake(20, CGRectGetMaxY(bgTimeView.frame) + 50, kWidth - 40, 42) backGruondImageName:@"按钮（big）icon650x84.png" Target:self Action:nil  Title:@"取消订单"];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bgScrollView addSubview:cancelBtn];
    
    UIButton *buyBtn = [HHControl createButtonWithFrame:CGRectMake(20, CGRectGetMaxY(cancelBtn.frame) + Kmarg, kWidth - 40, 42) backGruondImageName:@"按钮（big）icon650x84.png" Target:self Action:nil Title:@"确认购买"];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bgScrollView addSubview:buyBtn];
    
    
    CGFloat maxH =  CGRectGetMaxY(buyBtn.frame) + 300;
    _bgScrollView.contentSize = CGSizeMake(0, maxH);
    
    //根据condit类型判断button的调用方法 //0:待付款 1:待发货 2:待收货 3:完成 10:退货中  11:退货驳回  12:退货完成
    if ([orderArray[15] isEqualToString:@"0"]) {
        
        cancelBtn.hidden=NO;
        buyBtn.hidden=NO;
        [cancelBtn addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
        [buyBtn addTarget:self action:@selector(buyOrder:) forControlEvents:UIControlEventTouchUpInside];
        
    }else if ([orderArray[15] isEqualToString:@"2"]) {
        cancelBtn.hidden=NO;
        buyBtn.hidden=NO;
        [cancelBtn setTitle:@"立即收货" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(immediatelyTakeOverGoods) forControlEvents:UIControlEventTouchUpInside];
        [buyBtn setTitle:@"可退货" forState:UIControlStateNormal];
        [buyBtn addTarget:self action:@selector(returnOfGoods) forControlEvents:UIControlEventTouchUpInside];
    }else{
        cancelBtn.hidden=YES;
        buyBtn.hidden=YES;
    }
    
    
    if ([orderArray[3] isEqualToString:@"花篮"]) {
        [bgAccountView removeFromSuperview];
        [bgTimeView removeFromSuperview];
        
        cancelBtn.frame = CGRectMake(20,CGRectGetMaxY(bgOrderView.frame) + 50 ,kWidth - 40, 42);
        buyBtn.frame = CGRectMake(20,CGRectGetMaxY(cancelBtn.frame) + Kmarg ,kWidth - 40, 42);
    }

}
//立即收货
-(void)immediatelyTakeOverGoods{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定收货？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self returnOfGoodsOrder];
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
//退货
-(void)returnOfGoods{
    ReturnOfGoodsViewController *ReturnOfGoodsVC = [[ReturnOfGoodsViewController alloc] init];
    ReturnOfGoodsVC.orderId = _orderID;
    [self.navigationController pushViewController:ReturnOfGoodsVC animated:YES];
}

- (IBAction)cancelOrder:(id)sender {
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定取消此订单？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self cancleOrder];
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)buyOrder:(id)sender {
    
    PayMannerViewController *vc=[[PayMannerViewController alloc]init];
    vc.orderId = orderArray[14];
    vc.price = orderArray[4];
    vc.xingMoney = orderArray[5];
    vc.order_index = orderArray[0];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

#pragma mark 网络

//获取订单信息
- (void)getorderInfo
{
    orderArray = [NSMutableArray array];
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/goods_order_detail";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"order_id":_orderID,
                           
                           };
    //    NSLog(@"%@",dict);
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
//        NSLog(@"=============>%@",dict);
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             //订单
             NSString * order_index = dict[@"data"][@"order_index"];
             //下单时间
             NSString * date_tm= dict[@"data"][@"date_tm"];
             //图片
             NSString * pic = [picURL stringByAppendingString:dict[@"data"][@"pic"]];
             //订单名称
             NSString *title = dict[@"data"][@"title"];
             //现价 猩币 销量
             NSString * exchange_price =dict[@"data"][@"exchange_price"];
             NSString * exchange_coin=dict[@"data"][@"exchange_coin"];
             NSString * sale_num = dict[@"data"][@"sale_num"];
             //购买数量
             NSString * buy_num =dict[@"data"][@"buy_num"];
             //收货人 联系方式
             NSString * name = dict[@"data"][@"name"];
             NSString * phone=dict[@"data"][@"phone"];
             //地址  买家留言
             NSString * address=[NSString string];
             address =[address stringByAppendingString:dict[@"data"][@"province"]];
             address =[address stringByAppendingString:dict[@"data"][@"city"]];
             address =[address stringByAppendingString:dict[@"data"][@"district"]];
             address =[address stringByAppendingString:dict[@"data"][@"address"]];
             NSString * buyer_words = dict[@"data"][@"buyer_words"];
             //发票抬头 时间
             NSString * receipt=dict[@"data"][@"receipt"];
             NSString * leave_tm = dict[@"data"][@"leave_tm"];
             NSString * orderid=dict[@"data"][@"id"];
            NSString * condit = dict[@"data"][@"condit"];
             
             orderArray = [NSMutableArray arrayWithObjects: order_index,date_tm,pic,title,exchange_price,exchange_coin,sale_num,buy_num,name,phone,address,buyer_words,receipt,leave_tm,orderid,condit,nil];
             
             [self creatField];
             
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}

//确认收货
- (void)returnOfGoodsOrder{

    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/goods_order_confirm";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"order_id":_orderID,
                           };
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             [SVProgressHUD showSuccessWithStatus:@"收货成功"];
             [self.navigationController popViewControllerAnimated:YES];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}


//取消订单
- (void)cancleOrder
{
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/cancle_goods_order";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"order_id":_orderID,
                           };
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             [SVProgressHUD showSuccessWithStatus:@"取消订单成功"];
             [self.navigationController popViewControllerAnimated:YES];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}


@end

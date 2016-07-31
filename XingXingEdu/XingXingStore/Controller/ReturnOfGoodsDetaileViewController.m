//
//  ReturnOfGoodsDetaileViewController.m
//  XingXingEdu
//
//  Created by mac on 16/7/29.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "ReturnOfGoodsDetaileViewController.h"


#define kmgar 40.0f
#define klabelH 30.0f
#define kdistance 10.0f

@interface ReturnOfGoodsDetaileViewController (){
     NSMutableArray *_orderArray;
}

@end

@implementation ReturnOfGoodsDetaileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(241, 242, 241);
    self.title = @"退货详情";
   
    
    [self returnOfGoodsDetaileMessage];
}

-(void)returnOfGoodsDetaileMessage{
    
    _orderArray = [NSMutableArray array];
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/goods_return_details";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"order_id":_orderId,
                           };
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];

         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             
             //订单
             NSString * order_index = dict[@"data"][@"order_index"];
             //时间
             NSString * return_tm= dict[@"data"][@"return_tm"];
             //订单名称
             NSString *title = dict[@"data"][@"goods_title"];
             //现价 猩币 销量
             NSString * return_price =dict[@"data"][@"return_price"];
             NSString * return_coin=dict[@"data"][@"return_coin"];
             //地址  买家留言
             NSString * return_type = dict[@"data"][@"return_type"];
             
             NSString * reason = dict[@"data"][@"reason"];
             NSString * address = dict[@"data"][@"return_address"];

            _orderArray = [NSMutableArray arrayWithObjects: order_index,return_tm,title,return_type,return_price,return_coin,reason,address,nil];
         }
         
         [self createReturnOfGoodsDetaileView];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
    
}


-(void)createReturnOfGoodsDetaileView{
    
    UIView *bgView = [HHControl createViewWithFrame:CGRectMake(0, 64, kWidth, 400)];
    bgView.userInteractionEnabled = YES;
    bgView.backgroundColor = UIColorFromRGB(255, 255, 255);
    [self.view addSubview:bgView];
    
    //订单号
    UILabel *orderLabel = [HHControl createLabelWithFrame:CGRectMake(kmgar, 0, kWidth - kmgar *2, klabelH) Font:14 Text:[NSString stringWithFormat:@"订单号:%@",_orderArray[0]]];
    orderLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:orderLabel];
    UIImageView *orderImage = [[UIImageView alloc] initWithFrame:CGRectMake(- kmgar/2, kdistance/2, kmgar /2, kmgar/2)];
    orderImage.image = [UIImage imageNamed:@"dingdan.png"];
    [orderLabel addSubview:orderImage];
    
    //下单时间
    NSString *timeStr = [WZYTool dateStringFromNumberTimer:_orderArray[1]];
    UILabel *orderTimeLabel = [HHControl createLabelWithFrame:CGRectMake(kmgar, CGRectGetMaxY(orderLabel.frame), kWidth - kmgar *2, klabelH) Font:14 Text:[NSString stringWithFormat:@"退单时间:%@",timeStr]];
    orderTimeLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:orderTimeLabel];
    UIImageView *orderTimeImage = [[UIImageView alloc] initWithFrame:CGRectMake(- kmgar/2, kdistance/2, kmgar/2, kmgar/2)];
    orderTimeImage.image = [UIImage imageNamed:@"time.png"];
    [orderTimeLabel addSubview:orderTimeImage];
    
    //分割线1
    UIImageView *line1 = [HHControl createImageViewWithFrame:CGRectMake(kdistance, CGRectGetMaxY(orderTimeLabel.frame) , kWidth - kdistance *2, 1) ImageName:@""];
    line1.backgroundColor = UIColorFromRGB(230, 230, 230);
    [bgView addSubview:line1];
    
    UIImageView *line2 = [HHControl createImageViewWithFrame:CGRectMake(kmgar/2, CGRectGetMaxY(line1.frame) + 15, kdistance, 300) ImageName:@"Decorative-thread@2x.png"];
    [bgView addSubview:line2];
    
    UILabel *subjeatName = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(line2.frame) + kdistance, CGRectGetMaxY(line1.frame) + kdistance * 2, bgView.size.width - CGRectGetMaxX(line2.frame) - kdistance * 2, klabelH) Font:16 Text:_orderArray[2]];
    subjeatName.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:subjeatName];
    
    UILabel *subjeatPrice = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(line2.frame) + kdistance, CGRectGetMaxY(subjeatName.frame) , kWidth - CGRectGetMaxX(line2.frame) - kdistance *2, klabelH) Font:14 Text:[NSString stringWithFormat:@"退货金额: ￥%@",_orderArray[4]]];
    subjeatPrice.textColor = [UIColor redColor];
    [bgView addSubview:subjeatPrice];
    
    //猩币
    UILabel *xingbiLabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(line2.frame) + 10, CGRectGetMaxY(subjeatPrice.frame), kWidth - CGRectGetMaxX(line2.frame) - kdistance *2, klabelH) Font:14 Text:[NSString stringWithFormat:@"退猩币数: %@",_orderArray[5]]];
    xingbiLabel.textAlignment = NSTextAlignmentLeft;
    xingbiLabel.textColor = [UIColor redColor];
    [bgView addSubview:xingbiLabel];
    
    //买家留言
    UITextView *buyerSayView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line2.frame) + 10, CGRectGetMaxY(xingbiLabel.frame) + 10, kWidth - 80, 120)];
    buyerSayView.text = [NSString stringWithFormat:@"%@\n%@",_orderArray[3],_orderArray[6]];
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
    [bgView addSubview:buyerSayView];
    
    //地址电话
    UILabel *addressLabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(line2.frame) + kdistance, CGRectGetMaxY(buyerSayView.frame) + kmgar + 10, kWidth - 60, klabelH * 2) Font:14 Text:_orderArray[7]];
    addressLabel.numberOfLines = 0;
    addressLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:addressLabel];
    
    
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

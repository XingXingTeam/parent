//
//  ClassRoomOrderMessageController.m
//  XingXingEdu
//
//  Created by mac on 16/6/17.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "ClassRoomOrderMessageController.h"
#import "ClassRoomOrderNoPayInfo.h"
#import "BeeCloud.h"
#import "ClassRoomOrderAppraiseViewController.h"
#import "ClassRoomOrderDidAppraiseViewController.h"
#import "SubjectBuyDetailMessageController.h"
#import "WZYTool.h"
#define Kmarg 5.0f
#define KLabelW 65.0f
#define KLabelH 25.0f
@interface ClassRoomOrderMessageController (){
    //订单号
    NSString * _order_index;
    //下单时间
    NSString * _date_tm;
    //课程图片
    NSString * _course_pic;
    //课程名字
    NSString * _course_name;
    //课程价格
    NSString * _price;
    //购买数量
    NSString * _buy_num;
    //实付
    NSString * _pay_price;
    //猩币抵扣
    NSString * _deduct_price;
    //课程ID
    NSString * _course_id;
    //购买人
    NSString * _bought_tname;
    //上课学生
    NSString * _baby_name;
    //联系方式
    NSString * _phone;
    NSString *_dingdanId;
    NSString *_comment_id;
    
}

@end

@implementation ClassRoomOrderMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets=YES;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.view.backgroundColor= UIColorFromRGB(232, 232, 232);
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    self.title = @"课程订单详情";
    
    NSLog(@"_orderId_orderId_orderId%@",_orderId);
 
    
    [self createLeftButton];
    [self requestData:_orderId];
    
    // Do any additional setup after loading the view.
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

//请求数据
- (void)requestData:(NSString *)orderId {
    
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/course_order_detail";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"order_id":orderId,
                           };
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"=================%@",dict);
         if([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"] ){
             
             //订单号
             _order_index = [NSString stringWithFormat:@"%@",dict[@"data"][@"order_index"]];
             //下单时间
             _date_tm = [NSString stringWithFormat:@"%@",dict[@"data"][@"date_tm"]];
             //课程图片
             _course_pic = [picURL stringByAppendingString:dict[@"data"][@"course_pic"]];
             //课程名字
             _course_name = [NSString stringWithFormat:@"%@",dict[@"data"][@"course_name"]];
             //课程价格
             _price = [NSString stringWithFormat:@"￥%@",dict[@"data"][@"price"]];
             //购买数量
             _buy_num = [NSString stringWithFormat:@"%@个",dict[@"data"][@"buy_num"]];
             //实付
             _pay_price = [NSString stringWithFormat:@"%@",dict[@"data"][@"pay_price"]];
             //猩币抵扣
             _deduct_price = [NSString stringWithFormat:@"￥%@",dict[@"data"][@"deduct_price"]];
             //课程ID
             _course_id = [NSString stringWithFormat:@"%@",dict[@"data"][@"course_id"]];
             //购买人
             _bought_tname = [NSString stringWithFormat:@"%@",dict[@"data"][@"bought_tname"]];
             //上课学生
             _baby_name = [NSString stringWithFormat:@"%@",dict[@"data"][@"baby_name"]];
             //联系方式
             _phone = [NSString stringWithFormat:@"%@",dict[@"data"][@"phone"]];
             
             _dingdanId = [NSString stringWithFormat:@"%@",dict[@"data"][@"id"]];
             
              _comment_id = [NSString stringWithFormat:@"%@",dict[@"data"][@"comment_id"]];
             
             [self initWithOrderMessage];
         }
         else{
             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",dict[@"msg"]]];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}

- (void)cancleOrder
{
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/cancle_course_order";
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
             [SVProgressHUD showSuccessWithStatus:@"取消订单成功"];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self.navigationController popViewControllerAnimated:YES];
             });
         }  else{
             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"获取收藏失败，%@",dict[@"msg"]]];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}

-(void)initWithOrderMessage {
    UIView *bgOrderView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, kWidth - 10, 300)];
    bgOrderView.backgroundColor = UIColorFromRGB(255, 255, 255);
    [self.view addSubview:bgOrderView];
    
    //订单号
    UIImageView *orderImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 18, 20)];
    orderImage.image = [UIImage imageNamed:@"dingdan.png"];
    [bgOrderView addSubview:orderImage];
    
    UILabel *orderLabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(orderImage.frame)+ Kmarg, 10, KLabelW, KLabelH) Font:16 Text:@"订单号:"];
    orderLabel.textAlignment = NSTextAlignmentLeft;
    [bgOrderView addSubview:orderLabel];
    
    UILabel *ordermessageLabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(orderLabel.frame) + Kmarg, 10, kWidth - CGRectGetMaxX(orderImage.frame) - CGRectGetMaxX(orderLabel.frame) - Kmarg, KLabelH) Font:16 Text:_order_index];
    [bgOrderView addSubview:ordermessageLabel];
    
    //下单时间
    UIImageView *orderTimeImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(orderLabel.frame) + 3, 18, 20)];
    orderTimeImage.image = [UIImage imageNamed:@"time.png"];
    [bgOrderView addSubview:orderTimeImage];
    
    NSString *timeStr = [WZYTool dateStringFromNumberTimer:_date_tm];
    UILabel *orderTimeLabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(orderTimeImage.frame), CGRectGetMaxY(orderLabel.frame), KLabelW, KLabelH) Font:14 Text:@"下单时间:"];
    orderTimeLabel.textAlignment = NSTextAlignmentLeft;
    [bgOrderView addSubview:orderTimeLabel];
    
    UILabel *orderTimemessageLabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(orderTimeLabel.frame) + Kmarg, CGRectGetMaxY(orderLabel.frame), kWidth - CGRectGetMaxX(orderImage.frame) - CGRectGetMaxX(orderLabel.frame) - Kmarg, KLabelH) Font:14 Text:timeStr];
    [bgOrderView addSubview:orderTimemessageLabel];
    
    //订单状态
    UIImageView *orderStatusImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(orderTimeLabel.frame) + 4, 18, 20)];
    orderStatusImage.image = [UIImage imageNamed:@"zhuangtai.png"];
    [bgOrderView addSubview:orderStatusImage];
    
    UILabel *orderStatusLabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(orderStatusImage.frame) + Kmarg, CGRectGetMaxY(orderTimeLabel.frame), KLabelW, KLabelH) Font:14 Text:@"订单状态:"];
    orderStatusLabel.textAlignment = NSTextAlignmentLeft;
    [bgOrderView addSubview:orderStatusLabel];
    
    if (_isBuy == NO) {
        
        UILabel *orderStatusmessageLabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(orderStatusLabel.frame) + Kmarg, CGRectGetMaxY(orderTimeLabel.frame) , kWidth - CGRectGetMaxX(orderImage.frame) - CGRectGetMaxX(orderLabel.frame) - Kmarg, KLabelH) Font:14 Text:@"待付款"];
        orderStatusmessageLabel.textColor = [UIColor redColor];
        [bgOrderView addSubview:orderStatusmessageLabel];
     
    }else{
        UILabel *orderStatusmessageLabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(orderStatusLabel.frame) + Kmarg, CGRectGetMaxY(orderTimeLabel.frame) , kWidth - CGRectGetMaxX(orderImage.frame) - CGRectGetMaxX(orderLabel.frame) - Kmarg, KLabelH) Font:14 Text:@"已付款"];
        orderStatusmessageLabel.textColor = [UIColor redColor];
        [bgOrderView addSubview:orderStatusmessageLabel];
    }
    
    
    //分割线1
    UIImageView *line1 = [HHControl createImageViewWithFrame:CGRectMake(10, CGRectGetMaxY(orderStatusLabel.frame) + Kmarg, kWidth - 30, 1) ImageName:@""];
    line1.backgroundColor = UIColorFromRGB(230, 230, 230);
    [bgOrderView addSubview:line1];
    
    //课程详细信息
    UIView *bgSubjeactView = [HHControl createViewWithFrame:CGRectMake(Kmarg, CGRectGetMaxY(line1.frame) + Kmarg, kWidth - 20, 90)];
    bgSubjeactView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subjectButtonpress:)];
    [bgSubjeactView addGestureRecognizer:singleTap];
    //    bgSubjeactView.backgroundColor = [UIColor grayColor];
    [bgOrderView addSubview:bgSubjeactView];
    
    
    UIImageView *subjeateImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 70, 70)];
    [subjeateImage sd_setImageWithURL:[NSURL URLWithString:_course_pic] placeholderImage:nil];
    [bgSubjeactView addSubview:subjeateImage];
    
    UILabel *subjeatName = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(subjeateImage.frame) + Kmarg, 8, bgSubjeactView.size.width - CGRectGetMaxX(subjeateImage.frame) - 20, KLabelH) Font:16 Text:_course_name];
    subjeatName.textAlignment = NSTextAlignmentLeft;
    [bgSubjeactView addSubview:subjeatName];
    
    UILabel *subjeatPrice = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(subjeateImage.frame) + Kmarg, CGRectGetMaxY(subjeatName.frame) , bgSubjeactView.size.width - CGRectGetMaxX(subjeateImage.frame) - 20, KLabelH) Font:14 Text:_price];
    subjeatPrice.textColor = [UIColor redColor];
    [bgSubjeactView addSubview:subjeatPrice];
    
    //分割线2
    UIImageView *line2 = [HHControl createImageViewWithFrame:CGRectMake(10, CGRectGetMaxY(bgSubjeactView.frame) + Kmarg, kWidth - 30, 1) ImageName:@""];
    line2.backgroundColor = UIColorFromRGB(230, 230, 230);
    [bgOrderView addSubview:line2];
    
    //付款
    UILabel *orderCount = [HHControl createLabelWithFrame:CGRectMake(20, CGRectGetMaxY(line2.frame), kWidth - 40, KLabelH) Font:14 Text:[NSString stringWithFormat:@"购买数量:%@    实付:%@    猩币抵扣:%@",_buy_num,_pay_price,_deduct_price]];
    orderCount.textAlignment = NSTextAlignmentLeft;
    [bgOrderView addSubview:orderCount];
    
    //重写bgoderViewd的大小
    bgOrderView.frame = CGRectMake(5, 5, kWidth - 10, CGRectGetMaxY(orderCount.frame) + Kmarg);
    
    //购买人信息
    UIView *bgBuyerView = [HHControl createViewWithFrame:CGRectMake(5, CGRectGetMaxY(bgOrderView.frame) + 10, kWidth - 10, 80)];
    bgBuyerView.backgroundColor = UIColorFromRGB(255, 255, 255);
    [self.view addSubview:bgBuyerView];
    
    UILabel *buyerLabel = [HHControl createLabelWithFrame:CGRectMake(22, Kmarg, KLabelW, KLabelH) Font:14 Text:@"购 买 人:"];
    buyerLabel.textAlignment = NSTextAlignmentLeft;
    [bgBuyerView addSubview:buyerLabel];
    
    UILabel *buyerName = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(buyerLabel.frame) + Kmarg, Kmarg, kWidth - CGRectGetMaxX(buyerLabel.frame) - Kmarg, KLabelH) Font:14 Text:_bought_tname];
    [bgBuyerView addSubview:buyerName];
    
    UILabel *studentLabel = [HHControl createLabelWithFrame:CGRectMake(20, CGRectGetMaxY(buyerLabel.frame), KLabelW, KLabelH) Font:14 Text:@"上课学生:"];
    studentLabel.textAlignment = NSTextAlignmentLeft;
    [bgBuyerView addSubview:studentLabel];
    
    UILabel *studentName = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(studentLabel.frame) + Kmarg, CGRectGetMaxY(buyerLabel.frame), kWidth - CGRectGetMaxX(buyerLabel.frame) - Kmarg, KLabelH) Font:14 Text:_baby_name];
    [bgBuyerView addSubview:studentName];
    
    UILabel *buyerPhone = [HHControl createLabelWithFrame:CGRectMake(20, CGRectGetMaxY(studentLabel.frame), KLabelW, KLabelH) Font:14 Text:@"联系方式:"];
    buyerPhone.textAlignment = NSTextAlignmentLeft;
    [bgBuyerView addSubview:buyerPhone];
    
    UILabel *buyerPhoneNumber = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(buyerPhone.frame) + Kmarg, CGRectGetMaxY(studentLabel.frame), kWidth - CGRectGetMaxX(buyerLabel.frame) - Kmarg, KLabelH) Font:14 Text:_phone];
    [bgBuyerView addSubview:buyerPhoneNumber];
    
    //重写购买人信息背景的大小
    bgBuyerView.frame = CGRectMake(5, CGRectGetMaxY(bgOrderView.frame) + 10, kWidth - 10, CGRectGetMaxY(buyerPhoneNumber.frame)+ Kmarg);
    
    UIButton *buyBtn = [HHControl createButtonWithFrame:CGRectMake(20, CGRectGetMaxY(bgBuyerView.frame) + 50, kWidth - 40, 42) backGruondImageName:@"按钮（big）icon650x84.png" Target:self Action:@selector(buyBtnClick:)  Title:@"确认购买"];
    [buyBtn setTitleColor:UIColorFromRGB(255, 255, 255) forState:UIControlStateNormal];
    [self.view addSubview:buyBtn];
    
    
    UIButton *cancelBtn  = [HHControl createButtonWithFrame:CGRectMake(20, CGRectGetMaxY(buyBtn.frame) + Kmarg, kWidth - 40, 42) backGruondImageName:@"按钮（big）icon650x84.png" Target:self Action:@selector(cancelBtnClick:)  Title:@"取消订单"];
    [cancelBtn setTitleColor:UIColorFromRGB(255, 255, 255) forState:UIControlStateNormal];
    [self.view addSubview:cancelBtn];
    
    UIButton *appraiseBtn  = [HHControl createButtonWithFrame:CGRectMake(20, CGRectGetMaxY(bgBuyerView.frame) + 50, kWidth - 40, 42) backGruondImageName:@"按钮（big）icon650x84.png" Target:self Action:@selector(appraiseClick:)  Title:@"立即评价"];
    [appraiseBtn setTitleColor:UIColorFromRGB(255, 255, 255) forState:UIControlStateNormal];
    [self.view addSubview:appraiseBtn];
    
    if(_hiddenBuyBtn){
        buyBtn.hidden=YES;
        //        shareBtn.hidden = YES;
    }
    if(self.hiddencancelBtn){
        cancelBtn.hidden=YES;
        
    }
    if(_hiddenAppraiseBtn){
        appraiseBtn.hidden=YES;
        //        shareBtn.hidden = YES;
    }
    if(_appraiseHistory){
        [appraiseBtn setTitle:@"评价详情" forState:UIControlStateNormal];
        [appraiseBtn setTitleColor:UIColorFromRGB(255, 255, 255) forState:UIControlStateNormal];
    }
    
    
}


//调用支付
-(void)buyBtnClick:(UIButton *)btn{
    
    SubjectBuyDetailMessageController *SubjectBuyDetailMessageVC = [[SubjectBuyDetailMessageController alloc] init];
    SubjectBuyDetailMessageVC.order_index = _order_index;
    SubjectBuyDetailMessageVC.price = _pay_price;
    SubjectBuyDetailMessageVC.orderId = _dingdanId;
    [self.navigationController pushViewController:SubjectBuyDetailMessageVC animated:YES];
    
}

//取消订单
-(void)cancelBtnClick:(UIButton *)btn{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"取消订单不可恢复，确定取消？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self cancleOrder];
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

//评价详情
-(void)appraiseClick:(UIButton *)btn{
    if(self.appraiseHistory){
        if (![_comment_id isEqualToString:@"0"]) {
            
            ClassRoomOrderDidAppraiseViewController *ClassRoomOrderDidAppraiseVC = [[ClassRoomOrderDidAppraiseViewController alloc] init];
            ClassRoomOrderDidAppraiseVC.comment_id = _comment_id;
            [self.navigationController pushViewController:ClassRoomOrderDidAppraiseVC animated:YES];
        }else{
            
            return;
        }
        
       
    }
    else{
        ClassRoomOrderAppraiseViewController *ClassRoomOrderAppraiseVC = [[ClassRoomOrderAppraiseViewController alloc] init];
        ClassRoomOrderAppraiseVC.orderId = _orderId;
        [self.navigationController pushViewController:ClassRoomOrderAppraiseVC animated:YES];
    }
}


-(void)subjectButtonpress:(UIButton *)sender {
    ClassRoomOrderNoPayInfo *vc=[[ClassRoomOrderNoPayInfo alloc]init];
    vc.courseId = _course_id;
    [self.navigationController pushViewController:vc animated:YES];
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

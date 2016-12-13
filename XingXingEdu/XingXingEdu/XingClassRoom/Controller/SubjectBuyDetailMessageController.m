//
//  SubjectBuyDetailMessageController.m
//  XingXingEdu
//
//  Created by mac on 16/6/30.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "SubjectBuyDetailMessageController.h"
#import "BeeCloud.h"
#import "LSSAlertView.h"
#import "ClassRoomOrderMessageController.h"
#define Kmgar 15.0f
#define KlabelH 20.0f
#define KlabelW 150.0f
@interface SubjectBuyDetailMessageController ()<BeeCloudDelegate>{
    BOOL isCollect;
    NSInteger  btnNumber;
    
    //判断是否支付成功过
    BOOL isPaySuccess;
}

@end

@implementation SubjectBuyDetailMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = UIColorFromRGB(230, 230, 230);
    self.title = @"订单详情";
    isPaySuccess = NO;
    
    [self createBuydetailMessage];
    // Do any additional setup after loading the view.
}


-(void)createBuydetailMessage{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 300)];
    bgView.backgroundColor = UIColorFromRGB(255, 255, 255);
    [self.view addSubview:bgView];
    
    
    UIImageView *headImage = [HHControl createImageViewWithFrame:CGRectMake(Kmgar *2, Kmgar + 3, 38, 33) ImageName:@"gouwuche"];
    [bgView addSubview:headImage];
    
    UILabel *priceLabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame) + Kmgar, Kmgar, KlabelW, KlabelH) Font:16 Text:[NSString stringWithFormat:@"￥%@",self.price]];
    [bgView addSubview:priceLabel];
    
    UILabel *orderLabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame) + Kmgar,CGRectGetMaxY(priceLabel.frame), KlabelW, KlabelH) Font:12 Text: [NSString stringWithFormat:@"订单号:%@",_order_index]];
    orderLabel.textColor = UIColorFromRGB(153, 153, 153);
    [bgView addSubview:orderLabel];
    
    UIImageView *lineImageOne = [HHControl createImageViewWithFrame:CGRectMake(0,CGRectGetMaxY(orderLabel.frame) + Kmgar, kWidth, Kmgar) ImageName:@""];
    lineImageOne.backgroundColor = UIColorFromRGB(230, 230, 230);
    [bgView addSubview:lineImageOne];
    
    
    NSMutableArray *imageNameArr = [[NSMutableArray alloc] initWithObjects:@"weixinWX",@"zhifubaoZFB",nil];
    
    for (int i = 0; i < imageNameArr.count; i ++) {
        UIImageView *imageNameView = [HHControl createImageViewWithFrame:CGRectMake(Kmgar ,CGRectGetMaxY(lineImageOne.frame) + Kmgar + (KlabelH + 30) * i, 38, 33) ImageName:imageNameArr[i]];
        [bgView addSubview:imageNameView];
        
        if (i == 0) {
            UILabel *weiChatLabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(imageNameView.frame) + Kmgar, CGRectGetMaxY(lineImageOne.frame) + 10, KlabelW, KlabelH) Font:14 Text:@"微信支付"];
            [bgView addSubview:weiChatLabel];
            
            UILabel *sayWclabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(imageNameView.frame) + Kmgar, CGRectGetMaxY(weiChatLabel.frame), 180, KlabelH) Font:10 Text:@"推荐安装微信5.0以上的用户使用"];
            [bgView addSubview:sayWclabel];
            
            UIImageView *lineImageThree = [HHControl createImageViewWithFrame:CGRectMake(0,CGRectGetMaxY(sayWclabel.frame) + 3, kWidth, 1) ImageName:@""];
            lineImageThree.backgroundColor = UIColorFromRGB(230, 230, 230);
            [bgView addSubview:lineImageThree];
        }
        if (i == 1) {
            UILabel *alipayLabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(imageNameView.frame) + Kmgar, CGRectGetMaxY(lineImageOne.frame) + 40 + KlabelH, KlabelW, KlabelH) Font:14 Text:@"支付宝支付"];
            [bgView addSubview:alipayLabel];
            
            UILabel *sayAllabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(imageNameView.frame) + Kmgar, CGRectGetMaxY(alipayLabel.frame), 180, KlabelH) Font:10 Text:@"推荐有支付宝账号的用户使用"];
            [bgView addSubview:sayAllabel];
        }
        
        UIButton *selectButton = [HHControl createButtonWithFrame:CGRectMake(kWidth - Kmgar - 40, CGRectGetMaxY(lineImageOne.frame) + 16 + (KlabelH + 35) * i, 25, 25) backGruondImageName:@"weixuan" Target:self Action:@selector(clickButton:) Title:@""];
        selectButton.tag =100 + i ;
        [bgView addSubview:selectButton];
    }
    
    CGFloat maxH = CGRectGetMaxY(lineImageOne.frame) + 110;
    bgView.frame = CGRectMake(0, 0, kWidth, maxH);
    
    UIButton *sureButton = [HHControl createButtonWithFrame:CGRectMake(20, CGRectGetMaxY(bgView.frame) + Kmgar *2,kWidth - 40, 40) backGruondImageName:@"zhifuaniu" Target:self Action:@selector(clickSureButton:) Title:[NSString stringWithFormat:@"确认支付%@",priceLabel.text]];
    [sureButton setTitleColor:UIColorFromRGB(255, 255, 255) forState:UIControlStateNormal];
    [self.view addSubview:sureButton];
}

-(void)clickButton:(UIButton *)btn {

    if (btn.tag == 100) {
        btnNumber = 100;
        if (isCollect == NO) {
            [btn setBackgroundImage:[UIImage imageNamed:@"yixuan"] forState:UIControlStateNormal];
            UIButton *button = (UIButton*)[self.view viewWithTag:101];
            [button setBackgroundImage:[UIImage imageNamed:@"weixuan"] forState:UIControlStateNormal];
        
        }else{
            [btn setBackgroundImage:[UIImage imageNamed:@"weixuan"] forState:UIControlStateNormal];
        }
        
    }
    if (btn.tag == 101) {
        btnNumber = 101;
        if (isCollect == NO) {
            [btn setBackgroundImage:[UIImage imageNamed:@"yixuan"] forState:UIControlStateNormal];
            UIButton *button1 = (UIButton*)[self.view viewWithTag:100];
            [button1 setBackgroundImage:[UIImage imageNamed:@"weixuan"] forState:UIControlStateNormal];
        }else{
            [btn setBackgroundImage:[UIImage imageNamed:@"weixuan"] forState:UIControlStateNormal];
        }
    }
}

-(void)clickSureButton:(UIButton *)btn{

    if (btnNumber == 100) {
        //微信支付
        if (isPaySuccess == YES) {
            [SVProgressHUD showInfoWithStatus:@"该订单您已支付过"];
        }else{
            
         [self doPay:PayChannelWxApp];
        }

    }
    if (btnNumber == 101) {
        //支付宝 支付
        if (isPaySuccess == YES) {
            [SVProgressHUD showInfoWithStatus:@"该订单您已支付过"];
        }else{
        
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
                
                NSString *urlStr = @"http://www.xingxingedu.cn/Global/xkt_pay_course_back";
                AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
                NSString *xid;
                if ([XXEUserInfo user].login) {
                    xid = [XXEUserInfo user].xid;
                }else {
                    xid = XID;
                }
                
                NSDictionary *dict = @{@"appkey":APPKEY,
                                       @"backtype":BACKTYPE,
                                       @"xid":xid,
                                       @"user_id":USER_ID,
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
                         isPaySuccess = YES;
                         
                         alert.returnIndex = ^(NSInteger index){
                             if (index == 0) {
                                 
                                 ClassRoomOrderMessageController *ClassRoomOrderMessageVC = [[ClassRoomOrderMessageController alloc] init];
                                 ClassRoomOrderMessageVC.hiddenBuyBtn= YES;
                                 ClassRoomOrderMessageVC.hiddencancelBtn=YES;
                                 ClassRoomOrderMessageVC.hiddenAppraiseBtn=YES;
                                 ClassRoomOrderMessageVC.hiddenLeftButton = NO;
                                 ClassRoomOrderMessageVC.orderId = dict[@"data"][@"order_id"];
                                 ClassRoomOrderMessageVC.order_index = _order_index;
                                 ClassRoomOrderMessageVC.isBuy = YES;
                                 [self.navigationController pushViewController:ClassRoomOrderMessageVC animated:YES];
                                 
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
#pragma mark - 生成订单号
- (NSString *)genBillNo {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    return [formatter stringFromDate:[NSDate date]];
}



#pragma mark - 微信、支付宝、银联、百度钱包

- (void)doPay:(PayChannel)channel {
    NSString *billno = [self genBillNo];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value",@"key", nil];
    /**
     按住键盘上的option键，点击参数名称，可以查看参数说明
     **/
    BCPayReq *payReq = [[BCPayReq alloc] init];
    payReq.channel = channel; //支付渠道
    payReq.title = @"猩猩教室订单";//订单标题
    int price  = [self.price floatValue]*100;
    payReq.totalFee = [NSString stringWithFormat:@"%d",price];
//    payReq.totalFee = @"1";
    payReq.billNo = billno;//商户自定义订单号
    payReq.scheme = @"payDemo";//URL Scheme,在Info.plist中配置; 支付宝必有参数
    payReq.billTimeOut = 300;//订单超时时间
    payReq.viewController = self; //银联支付和Sandbox环境必填
    payReq.optional = dict;//商户业务扩展参数，会在webhook回调时返回
    [BeeCloud sendBCReq:payReq];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

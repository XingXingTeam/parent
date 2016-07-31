//
//  MoneyPresentedViewController.m
//  XingXingStore
//
//  Created by codeDing on 16/1/21.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "MoneyPresentedViewController.h"
#import "WJCommboxView.h"
#import "HHControl.h"
#import "MoneyHistoryTableViewController.h"
#import "PresentHistoryTableViewController.h"
#import "NetManager.h"

#define KMarg 10.0f
#define KLabelX 20.0f
#define KLabelW 70.0f
#define KLabelH 30.0f
@interface MoneyPresentedViewController (){
    NSMutableDictionary *xidDict;
    UITextField * moneyText;
    UILabel * moneyRemainLabel;
    UIView *_view1;
    UILabel *_zhuanZeng;
}
@property(nonatomic,strong)WJCommboxView *familyCombox;

@end

@implementation MoneyPresentedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[self navigationItem] setTitle:@"猩币转赠"];
    
    self.familyArray = [NSMutableArray array];
    xidDict = [NSMutableDictionary dictionary];
    self.view.backgroundColor = [UIColor whiteColor];
    [self netManageGet_Relation_Person];
    [self creatFieldset];
    //获取猩币
    [NetManager get_user_coinWithXid:@"18884982" WithSuccessBlock:^(NSString *coin) {
        moneyRemainLabel.text=coin;
        moneyText.placeholder=[NSString stringWithFormat:@"最多可转%@猩币",coin];
        self.moneyRemain=coin;
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"错误"];
        
    }];
    
}


-(void)creatFieldset{
    
    //猩币余额
    UILabel *xingMoney = [HHControl createLabelWithFrame:CGRectMake(KLabelX, KMarg, KLabelW, KLabelH) Font:16 Text:@"猩币余额:"];
    [self.view addSubview:xingMoney];
    moneyRemainLabel=[HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(xingMoney.frame)+KMarg , KMarg, kWidth - CGRectGetMaxX(xingMoney.frame) - KLabelX*2 , KLabelH) Font:16 Text:@"正在加载"];
    moneyRemainLabel.textColor=UIColorFromRGB(29, 29, 29);
    moneyRemainLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:moneyRemainLabel];
    
    _view1=[HHControl createViewWithFrame:CGRectMake(0, CGRectGetMaxY(moneyRemainLabel.frame) + 5, kWidth, 1)];
    _view1.backgroundColor=UIColorFromRGB(193, 193, 193);
    [self.view addSubview:_view1];
    
    //转赠对象
    _zhuanZeng = [HHControl createLabelWithFrame:CGRectMake(KLabelX, CGRectGetMaxY(_view1.frame) + KMarg, KLabelW, KLabelH) Font:16 Text:@"转赠对象:"];
    [self.view addSubview:_zhuanZeng];
    
    
    UIView *view2=[HHControl createViewWithFrame:CGRectMake(0, CGRectGetMaxY(_zhuanZeng.frame) + KMarg, WinWidth, 1)];
    view2.backgroundColor=UIColorFromRGB(193, 193, 193);
    [self.view addSubview:view2];
    
    //转赠猩币数目
    UILabel *xingbiLabel =  [HHControl createLabelWithFrame:CGRectMake(KLabelX, CGRectGetMaxY(view2.frame) + 5, KLabelW, KLabelH) Font:16 Text:@"猩币数目:"];
    [self.view addSubview:xingbiLabel];
    moneyText = [HHControl createTextFielfFrame:CGRectMake(CGRectGetMaxX(xingbiLabel.frame) + KMarg, CGRectGetMaxY(view2.frame) + 5, kWidth - CGRectGetMaxX(xingbiLabel.frame) - KLabelX *2 , KLabelH) font:[UIFont systemFontOfSize:16] placeholder:@"正在加载中"];
    moneyText.keyboardType=UIKeyboardTypeNumberPad;
    moneyText.borderStyle = UITextBorderStyleNone;
    moneyText.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview: moneyText];
    
    UIView *view3=[HHControl createViewWithFrame:CGRectMake(0, CGRectGetMaxY(moneyText.frame) + KMarg, WinWidth, 1)];
    view3.backgroundColor=UIColorFromRGB(193, 193, 193);
    [self.view addSubview:view3];
    
    UIView *view4=[HHControl createViewWithFrame:CGRectMake(0, CGRectGetMaxY(view3.frame), WinWidth, WinHeight-CGRectGetMaxY(view3.frame))];
    view4.backgroundColor=UIColorFromRGB(229, 232, 233);
    [self.view addSubview:view4];
    
    
    //确认转赠
    [self.view addSubview:[HHControl createButtonWithFrame:CGRectMake(KLabelX,CGRectGetMaxY(view3.frame) + KMarg *6 ,kWidth - KLabelX *2 , 42) backGruondImageName:@"surepresent.png" Target:nil Action:@selector(affirmBtn) Title:nil]];
    
    //转赠历史
    
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
    [rightButton setImage:[UIImage imageNamed:@"presenthistoryicon44.png"]forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(moneyHistory)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
}

-(void)affirmBtn{
    
    if([moneyText.text intValue]>[self.moneyRemain intValue]){
        [SVProgressHUD showErrorWithStatus:@"余额不足，转赠失败"];
    }
    else if([self.familyCombox.textField.text isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"请选择增送对象"];
    }
    else if([moneyText.text isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"请输入转赠数目"];
    }
    else if([[moneyText.text substringToIndex:1]isEqualToString:@"0"]){
        [SVProgressHUD showErrorWithStatus:@"赠送数目不能以0开头"];
    }else{
        [self netManageCoin_Turn:moneyText.text To:xidDict[self.familyCombox.textField.text]];
        moneyText.text=@"";
        self.familyCombox.textField.text =@"";
        
    }
}

-(void)moneyHistory{
    [self.navigationController pushViewController:[PresentHistoryTableViewController alloc] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark 网络
- (void)netManageGet_Relation_Person
{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/get_relation_person";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           
                           };
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         //                 NSLog(@"%@",dict);
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             
             for (NSDictionary *dic in [dict[@"data"] allObjects]) {
                 [ self.familyArray addObject:dic[@"tname"]];
                 [xidDict setObject:dic[@"xid"] forKey:dic[@"tname"]];
             }
             
             self.familyCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_zhuanZeng.frame) + KMarg, CGRectGetMaxY(_view1.frame) + KMarg, kWidth - CGRectGetMaxX(_zhuanZeng.frame) - KLabelX*2, KLabelH)];
             self.familyCombox.textField.placeholder = @"请选择转赠对象";
             self.familyCombox.textField.textAlignment = NSTextAlignmentCenter;
             self.familyCombox.textField.borderStyle = UITextBorderStyleNone;
             self.familyCombox.textField.tag = 101;
             self.familyCombox.dataArray =  self.familyArray;
             [self.view addSubview:self.familyCombox];
             self.comBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WinWidth, WinHeight+300)];
             self.comBackView.backgroundColor = [UIColor clearColor];
             self.comBackView.alpha = 0.5;
             
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}


- (void)netManageCoin_Turn:(NSString *)coinCount To:(NSString *)take_xid
{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/coin_turn";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"turn_num":coinCount,
                           @"give_xid":@"18884982",
                           @"take_xid":take_xid,
                           };
    
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         //         NSLog(@"%@",dict);
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             
             [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"转赠成功,还剩%@猩币",dict[@"data"][@"coin_able"]]];
             
             moneyRemainLabel.text=[NSString stringWithFormat:@"%@",dict[@"data"][@"coin_able"]];
             moneyText.placeholder=[NSString stringWithFormat:@"最多可转%@猩币",dict[@"data"][@"coin_able"]];
             self.moneyRemain=[NSString stringWithFormat:@"%@",dict[@"data"][@"coin_able"]];
             
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}


@end

//
//  StoreSettngViewController.m
//  XingXingStore
//
//  Created by codeDing on 16/1/21.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "StoreSettngViewController.h"
#import "StoreCollectTableViewController.h"
#import "MoneyHistoryTableViewController.h"
#import "AddressViewController.h"
#import "SubjectOrderListViewController.h"

#define kMarg 30.0f
#define kButtonH 40.0f


@interface StoreSettngViewController ()

@end


@implementation StoreSettngViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.tabBarController.navigationItem.title=@"我的";
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    
    [self createButton];
}

-(void)createButton{
    UIButton *myCollect = [HHControl createButtonWithFrame:CGRectMake(kMarg, kMarg *2, kWidth - kMarg *2, kButtonH) backGruondImageName:@"按钮big650x84" Target:self Action:@selector(myCollect:) Title:@"我的收藏"];
    [myCollect setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:myCollect];
    
    
    UIButton *moneyHistory = [HHControl createButtonWithFrame:CGRectMake(kMarg, CGRectGetMaxY(myCollect.frame) + kMarg, kWidth - kMarg *2, kButtonH) backGruondImageName:@"按钮big650x84" Target:self Action:@selector(moneyHistory:) Title:@"猩币记录"];
    [moneyHistory setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:moneyHistory];
    
    
    UIButton *adress = [HHControl createButtonWithFrame:CGRectMake(kMarg, CGRectGetMaxY(moneyHistory.frame) + kMarg, kWidth - kMarg *2, kButtonH) backGruondImageName:@"按钮big650x84" Target:self Action:@selector(adress:) Title:@"收货地址"];
    [adress setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:adress];
    
    
    UIButton *subjectOrderBtn = [HHControl createButtonWithFrame:CGRectMake(kMarg, CGRectGetMaxY(adress.frame) + kMarg, kWidth - kMarg *2, kButtonH) backGruondImageName:@"按钮big650x84" Target:self Action:@selector(subjectOrderBtn:) Title:@"商城订单"];
    [subjectOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:subjectOrderBtn];
    
    
}


- (IBAction)myCollect:(id)sender {
    [self.navigationController pushViewController:[StoreCollectTableViewController alloc] animated:YES];
}

- (IBAction)moneyHistory:(id)sender {
    [self.navigationController pushViewController:[MoneyHistoryTableViewController alloc] animated:YES];
}

- (IBAction)adress:(id)sender {
    [self.navigationController pushViewController:[AddressViewController alloc] animated:YES];
    
    
}
- (IBAction)subjectOrderBtn:(id)sender {
    SubjectOrderListViewController *orderListVC = [[SubjectOrderListViewController alloc] init];
    [self.navigationController pushViewController:orderListVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

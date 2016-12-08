//
//  PurchasedViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/5/19.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "PurchasedViewController.h"
#import "WJCommboxView.h"
#import "HHControl.h"
#import "SVProgressHUD.h"
#import "MoneyHistoryTableViewController.h"
#import "PresentHistoryTableViewController.h"
#import "AccountManagerViewController.h"
@interface PurchasedViewController ()<UITextFieldDelegate>
{
    UITextField * moneyText;
    UILabel * moneyRemainLabel;
    UILabel *presentlabe;
    NSMutableArray *familyArray;
}
@property(nonatomic,strong)WJCommboxView *familyCombox;
@property(nonatomic,strong) UIView *comBackView;
@property(nonatomic,copy)NSString *str;
@end

@implementation PurchasedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[self navigationItem] setTitle:@"购买视频"];
    familyArray=[[NSMutableArray alloc]init];
    [self creatFieldset];
}
-(void)creatFieldset{
    //转赠对象
    UILabel *labe =[HHControl createLabelWithFrame:CGRectMake(15, 105, 80, 30) Font:16 Text:@"购买时间："];
    [self.view addSubview:labe];
    //确认转赠
    [self.view addSubview:[HHControl createButtonWithFrame:CGRectMake(25, 300,325 , 42) backGruondImageName:@"按钮big650x84" Target:nil Action:@selector(affirmBtn) Title:@"购买"]];

//
    NSArray *arr =[[NSArray alloc]initWithObjects:@"1小时",@"2小时",@"3小时",@"4小时",@"5小时",@"6小时",@"7小时",@"8小时",@"9小时",@"10小时",nil];
    [familyArray addObjectsFromArray:arr];
    self.familyCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(100, 105, 250, 30)];
    self.familyCombox.textField.placeholder = @"请选择购买时间";
    self.familyCombox.textField.textAlignment = NSTextAlignmentCenter;
    self.familyCombox.textField.tag = 101;
    self.familyCombox.textField.delegate =self;
    self.familyCombox.dataArray = familyArray;
    [self.view addSubview:self.familyCombox];
   _comBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WinWidth, WinHeight+300)];
    _comBackView.backgroundColor = [UIColor clearColor];
   _comBackView.alpha = 0.5;
    [self.familyCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    //购买总金额
    UILabel *totallabe =[HHControl createLabelWithFrame:CGRectMake(15, 155, 85, 30) Font:16 Text:@"购买总金额:"];
    [self.view addSubview:totallabe];
    
    //显示总金额
    presentlabe =[HHControl createLabelWithFrame:CGRectMake(200, 155, 80, 30) Font:16 Text:@" 0"];
    [self.view addSubview:presentlabe];
    
  
}
- (void)affirmBtn{
//购买
    if ([self.familyCombox.textField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入购买时间"];
    }
    else{
    AccountManagerViewController *accountManagerVC =[[AccountManagerViewController alloc]init];
        accountManagerVC.moneyStr =presentlabe.text;
    [self.navigationController pushViewController:accountManagerVC animated:NO];
    }
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    //如果被观察者的对象是_playList
    if ([object isKindOfClass:[UITextField class]]) {
        //如果是name属性值发生变化
        if ([keyPath isEqualToString:@"text"]) {
            //取出name的旧值和新值
            NSString * newName=[change objectForKey:@"new"];
            _str= [newName substringToIndex:1];
            [self createLbl];
    
        }
    }
}
- (void)createLbl{
    presentlabe.text =[NSString stringWithFormat:@"¥: %d", [_str intValue]*50];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)dealloc{
    [self.familyCombox.textField  removeObserver:self forKeyPath:@"text" context:nil];
}

@end

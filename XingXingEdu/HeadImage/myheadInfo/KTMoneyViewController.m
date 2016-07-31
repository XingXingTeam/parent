//
//  KTMoneyViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/5/20.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "KTMoneyViewController.h"
#import "SVProgressHUD.h"
#import "ZCTradeView.h"
#import "UIAlertView+Quick.h"
#import "ForgetPassWordViewController.h"
#import "HHControl.h"
@interface KTMoneyViewController ()<ZCTradeViewDelegate,UIAlertViewDelegate>
@property (nonatomic, strong)ZCTradeView *zctView;
@property (nonatomic, copy)NSString *str;
@property (weak, nonatomic) IBOutlet UITextField *textfield;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;


@end

@implementation KTMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title =@"花篮支付";
    _str =@"111111";
    self.textfield.text =self.accountStr;
    self.moneyTF.text =self.moneyStr;
    [self createBtn];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)createBtn{
    UIButton *Btn =[HHControl createButtonWithFrame:CGRectMake(25, 330, kWidth-50, 42) backGruondImageName:@"按钮big650x84@2x" Target:self Action:@selector(onClick) Title:@"确认支付"];
    [Btn setTitleColor:UIColorFromRGB(255, 255, 255) forState:UIControlStateNormal];
    [self.view addSubview:Btn];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
    // Dispose of any resources that can be recreated.
}



- (void)onClick{
    
    if(![self.nameTF.text isEqualToString:@""]){
        
        __block KTMoneyViewController *blockSelf = self;
        self.zctView = [ZCTradeView tradeView];
        
        [self.zctView showInView:self.view.window];
        self.zctView.delegate = self;
        self.zctView.finish = ^(NSString *passWord){
            
            NSLog(@"  passWord %@ ",passWord);
            
            [blockSelf.zctView hidenKeyboard];
            
            if ([passWord isEqualToString:blockSelf.str]) {
                NSLog(@"密码成功");
                        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定支付？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
                        UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [SVProgressHUD showSuccessWithStatus:@"支付成功，平台将在5个工作日之内审核请求"];
                            [blockSelf.navigationController popViewControllerAnimated:YES];
                        }];
                        [alert addAction:ok];
                        [alert addAction:cancel];
                        [blockSelf presentViewController:alert animated:YES completion:nil];

                
                
                return ;
            }else{
                
                UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"支付密码错误" message:nil delegate:blockSelf cancelButtonTitle:@"重试" otherButtonTitles:@"忘记密码", nil];
                [al show];
                NSLog(@"密码错误");
            }
        };

        
        
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"请输入您的姓名"];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        [self onClick];
        
        NSLog(@" buttonIndex 重试");
    }else if (buttonIndex == 1)
    {
        //        [self.zctView hidenKeyboard];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            ForgetPassWordViewController * forVC=[[ForgetPassWordViewController alloc]init];
            [self.navigationController pushViewController:forVC animated:YES];

        });
    }
}

// 取消
-(void)tradeView:(ZCTradeView *)tradeInputView cancleBtnClick:(UIButton *)cancleBtnClick
{
    NSLog(@"取消");
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end

//
//  newPassWardViewController.m
//  Created by codeDing on 16/1/16.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "NewPassWordViewController.h"
#import "LandingpageViewController.h"
#import "ForgetPassWordViewController.h"
#import "SVProgressHUD.h"

#define kmagr 10.0f
#define kmagrX 25.0f
#define kmagrH 30.0f
#define kmagrW 60.0f
@interface NewPassWordViewController ()
{
    UIView *bgView;
    UITextField *passward;
    UITextField *confirmPassward;//确认密码
    
}
@end

@implementation NewPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"找回密码2/2";
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor= [UIColor colorWithRed:229/255.0f green:232/255.0f blue:234/255.0f alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0, 170, 42);
    
    [self createTextFields];

}

-(void)createTextFields
{
    UILabel *label = [HHControl createLabelWithFrame:CGRectMake(kmagrX, 75, kWidth - kmagrX *2, kmagrH) Font:13 Text:@"请设置新的密码"];
    label.textColor=[UIColor grayColor];
    label.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:label];
    
    bgView=[[UIView alloc]initWithFrame:CGRectMake(kmagr, CGRectGetMaxY(label.frame) + kmagr, kWidth - kmagr *2, 100)];
    bgView.layer.cornerRadius=3.0;
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    
    
    UILabel *phonelabel = [HHControl createLabelWithFrame:CGRectMake(kmagr * 2, kmagr, kmagrW, kmagrH) Font:14 Text:@"设置密码"];
    phonelabel.textColor=[UIColor blackColor];
    phonelabel.textAlignment=NSTextAlignmentRight;
    
    
    passward = [HHControl createTextFielfFrame:CGRectMake(CGRectGetMaxX(phonelabel.frame) + kmagr, kmagr, bgView.size.width - CGRectGetMaxX(phonelabel.frame) - kmagr *2 , kmagrH) font:[UIFont systemFontOfSize:14] placeholder:@"6-20位字母或数字"];
    passward.clearButtonMode = UITextFieldViewModeWhileEditing;
    passward.keyboardType=UIKeyboardTypeNumberPad;
    passward.secureTextEntry=YES;
    
    UIImageView *line1=[HHControl createImageViewFrame:CGRectMake(kmagrX, CGRectGetMaxY(phonelabel.frame) + kmagr, bgView.frame.size.width - kmagrX *2, 1) imageName:nil color:[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3]];
    
    UILabel *codelabel = [HHControl createLabelWithFrame:CGRectMake(kmagr * 2, CGRectGetMaxY(phonelabel.frame) + kmagr *2, kmagrW, kmagrH) Font:14 Text:@"确认密码"];
    codelabel.textColor = [UIColor blackColor];
    codelabel.textAlignment = NSTextAlignmentRight;
    
    
    confirmPassward =[HHControl createTextFielfFrame:CGRectMake(CGRectGetMaxX(codelabel.frame) + kmagr, CGRectGetMaxY(passward.frame) + kmagr*2, bgView.size.width - kmagr *2, kmagrH) font:[UIFont systemFontOfSize:14]  placeholder:@"6-20位字母或数字" ];
    confirmPassward.clearButtonMode = UITextFieldViewModeWhileEditing;
    //密文样式
    confirmPassward.secureTextEntry=YES;
    confirmPassward.keyboardType=UIKeyboardTypeNumberPad;
    
    CGFloat maxH =  CGRectGetMaxY(codelabel.frame) + kmagr;
    bgView.frame = CGRectMake(kmagr, CGRectGetMaxY(label.frame) + kmagr, kWidth - kmagr *2,maxH);
    
    [bgView addSubview:passward];
    [bgView addSubview:phonelabel];
    [bgView addSubview:confirmPassward];
    [bgView addSubview:codelabel];
    [bgView addSubview:line1];
    
    UIButton *landBtn = [HHControl createButtonWithFrame:CGRectMake(kmagr *2, CGRectGetMaxY(bgView.frame) + kmagrH, kWidth - kmagr *4, 42) backGruondImageName:@"按钮（big）icon650x84" Target:self Action:@selector(okClick) Title:@"完成"];
    [landBtn setTitleColor:UIColorFromRGB(255, 255, 255) forState:UIControlStateNormal];
    landBtn.layer.cornerRadius=5.0f;
    [self.view addSubview:landBtn];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [passward resignFirstResponder];
    [confirmPassward resignFirstResponder];
    
}

-(void)okClick
{
    if([passward.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"您还未设置密码"];
        return;
    }
    else if (passward.text.length <6)
    {
        [SVProgressHUD showInfoWithStatus:@"亲,密码长度至少六位"];
        return;
    }
    else if ([passward.text isEqualToString:confirmPassward.text]==NO)
    {
        [SVProgressHUD showInfoWithStatus:@"亲,两次密码输入不同"];
        return;
    }
    
    
    //    [SVProgressHUD showSuccessWithStatus:@"修改成功"];
    [self upload];
    [self.navigationController  popToRootViewControllerAnimated:YES];
}

-(void)clickaddBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 网络
- (void)upload{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/update_pass";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"user_type":USER_TYPE,
                           @"new_pass":passward.text,
                           @"phone":self.userPhone,
                           };
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSLog(@"%@",dict);
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             
             [SVProgressHUD showSuccessWithStatus:@"修改密码成功，请前往首页重新登录"];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self.navigationController pushViewController:[LandingpageViewController alloc] animated:YES];
             });
         }
         else{
             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"注册失败，%@",dict[@"msg"]]];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}

@end

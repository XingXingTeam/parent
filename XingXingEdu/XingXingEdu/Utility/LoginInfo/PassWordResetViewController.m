//
//  PassWordResetViewController.m
//  xingxingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/1/13.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define SureColor [UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
#import "PassWordResetViewController.h"
#import "FirstLaunchViewController.h"
#import "SVProgressHUD.h"
#import "HHControl.h"
#import "HomepageViewController.h"
#import "SchoolInfoViewController.h"
@interface PassWordResetViewController ()
{
    UIImageView *View;
    UIView *bgView;
    UIButton *sureBtn;
    UITextField *oldPassWordTextFiled;
    UITextField *newPassWordTextFiled;
    UITextField *newPassWordAgainTextFiled;
}
@end

@implementation PassWordResetViewController

#pragma mark - Dismiss Methods Sample
- (void)viewWillAppear:(BOOL)animated{
    [SVProgressHUD dismiss];
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden =NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    View = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    //背景图片
    View.userInteractionEnabled = YES;
    View.image = [UIImage imageNamed:@"bg4.jpg"];
    [self.view addSubview:View];
    [self createOldPassWordLbl];
    [self createPassWordTextField];
    [self sureBtn];
}

- (void)createOldPassWordLbl{
    UILabel * OldPassWordLbl = [HHControl createLabelWithFrame:CGRectMake(20, 80, 200, 40) Font:18 Text:@"请设置新密码"];
    OldPassWordLbl.textColor = [UIColor grayColor];
    OldPassWordLbl.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:OldPassWordLbl];
}

- (void)sureBtn{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(20,500,kWidth-40, 40)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.backgroundColor = SureColor;
    sureBtn.layer.cornerRadius = 5.0f;
    [self.view addSubview:sureBtn];
     [sureBtn addTarget:self action:@selector(loadFirstLaunchVC) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)loadFirstLaunchVC{
    if ([oldPassWordTextFiled.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"亲,请输入你的旧密码"];
        
        return;
    }
    else if (oldPassWordTextFiled.text.length <6){
        [SVProgressHUD showInfoWithStatus:@"亲,旧密码输入有误"];
        
        return;
    }
    else if (![oldPassWordTextFiled.text isEqualToString:self.pwdText]){
        [SVProgressHUD showInfoWithStatus:@"亲,你输入的旧密码错误"];
        
        return;
    }
    else if ([newPassWordTextFiled.text isEqualToString:@""]){
        [SVProgressHUD showInfoWithStatus:@"亲,请设置你的新密码"];
        
        return;
    }
    else if ([newPassWordTextFiled.text isEqualToString:self.pwdText]){
        [SVProgressHUD showInfoWithStatus:@"亲,新密码不能和旧密码相重"];
        
        return;
    }
    else if (newPassWordTextFiled.text.length <6)
    {
        [SVProgressHUD showInfoWithStatus:@"亲,密码长度至少六位"];
        
        return;
    }
    else if ([newPassWordAgainTextFiled.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"亲,请再次输入密码"];
        
        return;
    }
    else if (newPassWordAgainTextFiled.text.length <6)
    {
        [SVProgressHUD showInfoWithStatus:@"亲,密码长度至少六位"];
        
        return;
    }
    else if (![newPassWordTextFiled.text isEqualToString:newPassWordAgainTextFiled.text]){
        [SVProgressHUD showErrorWithStatus:@"两次密码不匹配"];
        
    }
    else if ([newPassWordTextFiled.text isEqualToString:newPassWordAgainTextFiled.text])
    {
        //NOTIFICATION
        
          [[NSNotificationCenter defaultCenter]postNotificationName:@"passWord" object:self    userInfo:@{@"word":newPassWordAgainTextFiled.text}];
        [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
        typeof(self) __weak weak =self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weak LoginFirstView];
        });
        
    }
}
- (void)LoginFirstView{
    
    SchoolInfoViewController *schoolInfoVC =[[SchoolInfoViewController alloc]init];
    schoolInfoVC.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:schoolInfoVC animated:YES];
}
- (void)createPassWordTextField{
    //填入框
    bgView=[[UIView alloc]initWithFrame:CGRectMake(10, 175,kWidth-20, 150)];
    bgView.layer.cornerRadius=3.0;
    bgView.alpha=0.7;
    bgView.backgroundColor=[UIColor whiteColor];
    
    //旧密码
    oldPassWordTextFiled=[HHControl createTextFielfFrame:CGRectMake(60, 15, 271, 30) font:[UIFont systemFontOfSize:14] placeholder:@"请输入旧密码"];
    oldPassWordTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    oldPassWordTextFiled.secureTextEntry =YES;
    //新密码
    newPassWordTextFiled=[HHControl createTextFielfFrame:CGRectMake(60, 60, 271, 30) font:[UIFont systemFontOfSize:14]  placeholder:@"请输入新密码"];
    newPassWordTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    newPassWordTextFiled.secureTextEntry=YES;
    //再次输入新密码
    newPassWordAgainTextFiled=[HHControl createTextFielfFrame:CGRectMake(60, 105, 271, 30) font:[UIFont systemFontOfSize:14]  placeholder:@"请再次输入新密码"];
    newPassWordAgainTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    newPassWordAgainTextFiled.secureTextEntry=YES;
    
    // 密码图片
    UIImageView *pwdImageView1=[HHControl createImageViewFrame:CGRectMake(20, 15, 25, 25) imageName:@"mm_normal" color:nil];
    //密码图片
    UIImageView *pwdImageView2=[HHControl createImageViewFrame:CGRectMake(20, 60, 25, 25) imageName:@"mm_normal" color:nil];
    //密码图片
    UIImageView *pwdImageView3=[HHControl createImageViewFrame:CGRectMake(20, 105, 25, 25) imageName:@"mm_normal" color:nil];
    
    [bgView addSubview:oldPassWordTextFiled];
    [bgView addSubview:newPassWordTextFiled];
    [bgView addSubview:newPassWordAgainTextFiled];
    
    [bgView addSubview:pwdImageView1];
    [bgView addSubview:pwdImageView2];
    [bgView addSubview:pwdImageView3];
    
    [self.view addSubview:bgView];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
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

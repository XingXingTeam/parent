//
//  forgetPassWardViewController.m
//  Created by codeDing on 16/1/16.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "ForgetPassWordViewController.h"
#import "NewPassWordViewController.h"
#import "LandingpageViewController.h"
#import "SVProgressHUD.h"
#import <SMS_SDK/SMSSDK.h>

#define kmagr 10.0f
#define kmagrX 25.0f
#define kmagrH 30.0f
#define kmagrW 60.0f
@interface ForgetPassWordViewController ()
{
    UIView *bgView;
    UITextField *phone;
    UITextField *code;
    UINavigationBar *customNavigationBar;
    UIButton *yzButton;
}

@property(nonatomic, copy) NSString *oUserPhoneNum;
@property(assign, nonatomic) NSInteger timeCount;
@property(strong, nonatomic) NSTimer *timer;
//验证码
@property(copy, nonatomic) NSString *smsId;

@end

@implementation ForgetPassWordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.title=@"找回密码1/2";
    self.view.backgroundColor= [UIColor colorWithRed:229/255.0f green:232/255.0f blue:234/255.0f alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0, 170, 42);
    


    [self createTextFields];
    //测试
    UIButton *textBtn=[[UIButton alloc]initWithFrame:CGRectMake(100, 300, 170, 40)];
    [textBtn setTitle:@"测试" forState:UIControlStateNormal];
    [textBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    textBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [textBtn addTarget:self action:@selector(text) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:textBtn];
    

}

-(void)clickaddBtn
{
    [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController pushViewController:[[MMZCViewController alloc]init] animated:YES];
}

-(void)createTextFields
{
    UILabel *label = [HHControl createLabelWithFrame:CGRectMake(kmagrX, 75, kWidth - kmagrX *2, kmagrH) Font:13 Text:@"请输入您的手机号码"];
    label.textColor=[UIColor grayColor];
    label.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:label];
    
    bgView=[[UIView alloc]initWithFrame:CGRectMake(kmagr, CGRectGetMaxY(label.frame) + kmagr, kWidth - kmagr *2, 100)];
    bgView.layer.cornerRadius=3.0;
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    
    
    UILabel *phonelabel = [HHControl createLabelWithFrame:CGRectMake(kmagr * 2, kmagr, kmagrW, kmagrH) Font:14 Text:@"手机号"];
    phonelabel.textColor=[UIColor blackColor];
    phonelabel.textAlignment=NSTextAlignmentRight;
    
    
    UIImageView *phoneImage=[[UIImageView alloc]initWithFrame:CGRectMake(- kmagr, 0, kmagr *2, kmagrH)];
    phoneImage.image=[UIImage imageNamed:@"手机36x58.png"];
    [phonelabel addSubview:phoneImage];
    
    phone = [HHControl createTextFielfFrame:CGRectMake(CGRectGetMaxX(phonelabel.frame) + kmagr, kmagr, bgView.size.width - CGRectGetMaxX(phonelabel.frame) - kmagr *2 , kmagrH) font:[UIFont systemFontOfSize:14] placeholder:@"11位手机号"];
    phone.clearButtonMode = UITextFieldViewModeWhileEditing;
    phone.keyboardType=UIKeyboardTypeNumberPad;
    
    UIImageView *line1=[HHControl createImageViewFrame:CGRectMake(kmagrX, CGRectGetMaxY(phonelabel.frame) + kmagr, bgView.frame.size.width - kmagrX *2, 1) imageName:nil color:[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3]];
    
    UILabel *codelabel = [HHControl createLabelWithFrame:CGRectMake(kmagr * 2, CGRectGetMaxY(phonelabel.frame) + kmagr *2, kmagrW, kmagrH) Font:14 Text:@"验证码"];
    codelabel.textColor = [UIColor blackColor];
    codelabel.textAlignment = NSTextAlignmentRight;
    
    
    UIImageView *codeImage=[[UIImageView alloc]initWithFrame:CGRectMake(- kmagr, 0, 23, 23)];
    codeImage.image=[UIImage imageNamed:@"验证码46x46"];
    [codelabel addSubview:codeImage];
    
    code =[HHControl createTextFielfFrame:CGRectMake(CGRectGetMaxX(codelabel.frame) + kmagr, CGRectGetMaxY(phone.frame) + kmagr*2, bgView.size.width*0.4, kmagrH) font:[UIFont systemFontOfSize:14]  placeholder:@"4位数字" ];
    code.clearButtonMode = UITextFieldViewModeWhileEditing;
    //密文样式
    code.secureTextEntry=YES;
    code.keyboardType=UIKeyboardTypeNumberPad;
    
    
    yzButton = [HHControl createButtonWithFrame:CGRectMake(CGRectGetMaxX(code.frame), CGRectGetMaxY(phone.frame) + kmagr*2, 100, kmagrH) backGruondImageName:@"" Target:self Action:@selector(getValidCode:) Title:@"获取验证码"];
    yzButton.titleLabel.font=[UIFont systemFontOfSize:13];
    [yzButton setTitleColor:[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1] forState:UIControlStateNormal];
    [bgView addSubview:yzButton];
    
    CGFloat maxH =  CGRectGetMaxY(codelabel.frame) + kmagr;
    bgView.frame = CGRectMake(kmagr, CGRectGetMaxY(label.frame) + kmagr, kWidth - kmagr *2,maxH);
    
    
    [bgView addSubview:phone];
    [bgView addSubview:code];
    
    [bgView addSubview:phonelabel];
    [bgView addSubview:codelabel];
    [bgView addSubview:line1];
    
    UIButton *landBtn = [HHControl createButtonWithFrame:CGRectMake(kmagr *2, CGRectGetMaxY(bgView.frame) + kmagrH, kWidth - kmagr *4, 42) backGruondImageName:@"按钮（big）icon650x84" Target:self Action:@selector(landClick) Title:@"下一步"];
    [landBtn setTitleColor:UIColorFromRGB(255, 255, 255) forState:UIControlStateNormal];
    landBtn.layer.cornerRadius=5.0f;
    [self.view addSubview:landBtn];
    
}


#pragma mark 网络 限制验证码的次数
- (void)netManage:(NSString *)phoneNum
{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/limit_phone_verify";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"user_type":USER_TYPE,
                           @"action_page":@"2",
                           @"phone":phoneNum,
                           };
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         //         if([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"] ){
         //
         //             return ;
         //         }
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"4"] ){
             
             [SVProgressHUD showInfoWithStatus:@"今日获取验证码已上限"];
             yzButton.userInteractionEnabled = NO;
             self.timer.fireDate = [NSDate distantFuture];
             
             
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}
//获取验证码
- (void)getValidCode:(UIButton *)sender
{
   
    
    if ([phone.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"亲,请输入注册手机号码"];
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:1.5];
        return;
    }
    else if (phone.text.length !=11)
    {
        [SVProgressHUD showInfoWithStatus:@"您输入的手机号码格式不正确"];
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:1.5];
        return;
    }
    //短信验证码
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phone.text zone:@"86" customIdentifier:nil
                                 result:^(NSError *error){
                                     if (!error) {
                                         NSLog(@"获取验证码成功");
                                     }
                                     else {
                                         NSLog(@"错误信息：%@",error);
                                     }
                                 }];
    
    _oUserPhoneNum =phone.text;
    sender.userInteractionEnabled = NO;
    self.timeCount = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime:) userInfo:sender repeats:YES];
    
    [self netManage:phone.text];
    
}

- (void)reduceTime:(NSTimer *)codeTimer {
    self.timeCount--;
    if (self.timeCount == 0) {
        [yzButton setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        [yzButton setTitleColor:[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1] forState:UIControlStateNormal];
        UIButton *info = codeTimer.userInfo;
        info.enabled = YES;
        yzButton.userInteractionEnabled = YES;
        [self.timer invalidate];
    } else {
        NSString *str = [NSString stringWithFormat:@"%lu秒后重新获取", self.timeCount];
        [yzButton setTitle:str forState:UIControlStateNormal];
        yzButton.userInteractionEnabled = NO;
        
    }
}


- (void)dismiss:(id)sender {
    [SVProgressHUD dismiss];
}

//验证码
-(void)landClick
{
    if ([phone.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"亲,请输入注册手机号码"];
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:1.5];
        return;
    }
    else if (phone.text.length !=11)
    {
        [SVProgressHUD showInfoWithStatus:@"您输入的手机号码格式不正确"];
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:1.5];
        return;
    }
    else if ([code.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"亲,请输入验证码"];
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:1.5];
        return;
    }
    [SMSSDK commitVerificationCode:code.text phoneNumber:phone.text zone:@"86" result:^(NSError *error) {
        
        if (!error) {
            NSLog(@"验证成功");
            [SVProgressHUD showSuccessWithStatus:@"验证成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                NewPassWordViewController*vc= [[NewPassWordViewController alloc]init];
                vc.userPhone=phone.text;
                [self.navigationController pushViewController:vc animated:YES];
            });
        }
        else
        {
            NSLog(@"错误信息:%@",error);
            [SVProgressHUD showInfoWithStatus:@"验证码错误"];
        }
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [phone resignFirstResponder];
    [code resignFirstResponder];
    
}

-(UITextField *)createTextFielfFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder
{
    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
    
    textField.font=font;
    
    textField.textColor=[UIColor grayColor];
    
    textField.borderStyle=UITextBorderStyleNone;
    
    textField.placeholder=placeholder;
    
    return textField;
}

-(UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName color:(UIColor *)color
{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    
    if (imageName)
    {
        imageView.image=[UIImage imageNamed:imageName];
    }
    if (color)
    {
        imageView.backgroundColor=color;
    }
    
    return imageView;
}

-(UIButton *)createButtonFrame:(CGRect)frame backImageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    if (imageName)
    {
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    if (font)
    {
        btn.titleLabel.font=font;
    }
    
    if (title)
    {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (color)
    {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
    if (target&&action)
    {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)text{
    NewPassWordViewController*vc= [[NewPassWordViewController alloc]init];
    vc.userPhone = phone.text;
    [self.navigationController pushViewController:vc animated:YES];
}


@end


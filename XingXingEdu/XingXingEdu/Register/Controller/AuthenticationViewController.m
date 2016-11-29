//
//  AuthenticationViewController.m
//
//  Created by codeDing on 16/1/16.
//  Copyright © 2016年 codeDing. All rights reserved.
//


#import "AuthenticationViewController.h"
#import "SettingPassWordViewController.h"
#import "LandingpageViewController.h"
#import "SVProgressHUD.h"
#import <SMS_SDK/SMSSDK.h>
#import "QCheckBox.h"
#import "TermsViewController.h"

#define kmagr 10.0f
#define kmagrX 25.0f
#define kmagrH 30.0f
#define kmagrW 60.0f
@interface AuthenticationViewController ()<QCheckBoxDelegate>

{
    UIView *bgView;
    UITextField *phone;
    UITextField *code;
    UINavigationBar *customNavigationBar;
    UIButton *yzButton;
    BOOL  isChecked;
}

@property(nonatomic, copy) NSString *oUserPhoneNum;
@property(assign, nonatomic) NSInteger timeCount;
@property(strong, nonatomic) NSTimer *timer;
//验证码
@property(copy, nonatomic) NSString *smsId;
@end

@implementation AuthenticationViewController
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden =NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"注册1/3";
    
    self.view.backgroundColor= [UIColor colorWithRed:229/255.0f green:232/255.0f blue:234/255.0f alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0, 170, 42);
    
    //测试
    UIButton *textBtn=[[UIButton alloc]initWithFrame:CGRectMake(100, 300, 170, 40)];
    [textBtn setTitle:@"测试" forState:UIControlStateNormal];
    [textBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    textBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [textBtn addTarget:self action:@selector(text) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:textBtn];
    
    
    [self createTextFields];
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
    
    
    UIImageView *codeImage=[[UIImageView alloc]initWithFrame:CGRectMake(- 10, 0, 25, 25)];
    codeImage.image=[UIImage imageNamed:@"验证码46x46.png"];
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
    
    //单选框
    QCheckBox *checkRadio = [[QCheckBox alloc] initWithDelegate:self];
    checkRadio.frame = CGRectMake(kWidth/2 - 30, CGRectGetMaxY(bgView.frame) , kmagr * 2, kmagr*4);
    [checkRadio setImage:[UIImage imageNamed:@"未选择icon28x28.png"] forState:UIControlStateNormal];
    [checkRadio setImage:[UIImage imageNamed:@"已选择icon28x28.png"] forState:UIControlStateSelected];
    [self.view addSubview:checkRadio];
    [checkRadio setChecked:NO];
    
    UIButton *radioBtn = [HHControl createButtonWithFrame:CGRectMake(CGRectGetMaxX(checkRadio.frame) + kmagr, CGRectGetMaxY(bgView.frame) + 5, kWidth /2 - kmagr *2, kmagrH) backGruondImageName:@"" Target:self Action:@selector(openTerms) Title:@"我已阅读并同意以上条款"];
    [radioBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    radioBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [self.view addSubview:radioBtn];
    
    
    [bgView addSubview:phone];
    [bgView addSubview:code];
    
    [bgView addSubview:phonelabel];
    [bgView addSubview:codelabel];
    [bgView addSubview:line1];
    
    
    UIButton *landBtn = [HHControl createButtonWithFrame:CGRectMake(kmagr *2, CGRectGetMaxY(radioBtn.frame), kWidth - kmagr *4, 42) backGruondImageName:@"按钮（big）icon650x84" Target:self Action:@selector(next) Title:@"下一步"];
    [landBtn setTitleColor:UIColorFromRGB(255, 255, 255) forState:UIControlStateNormal];
    landBtn.layer.cornerRadius=5.0f;
    [self.view addSubview:landBtn];
    
    
}
-(void)text{
    SettingPassWordViewController * vc=   [[SettingPassWordViewController alloc]init];
    vc.phoneNumber=phone.text;
    [self.navigationController pushViewController:vc animated:YES];
}

//按钮代理方法
- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    ;
    isChecked =checked;
}
-(void)openTerms{
    TermsViewController * termVC=[[TermsViewController alloc]init];
    [self presentViewController:termVC animated:YES completion:nil];
    
    
}

#pragma mark 网络 判断手机号是否已经注册
//获取验证码 判断手机号是否已经注册
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
    else if (phone.text.length == 11)
    {
        NSString *urlStr = @"http://www.xingxingedu.cn/Parent/register_check_phone";
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *dict = @{@"appkey":APPKEY,
                               @"backtype":BACKTYPE,
                               @"user_type":USER_TYPE,
                               @"phone":phone.text,
                               };
        // 服务器返回的数据格式
        mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
        [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
             
             if([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"] ){
                 
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
                 
                 
             }else{
                 [SVProgressHUD showInfoWithStatus:@"此手机号已经注册!"];
                 return ;
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败:%@",error);
             [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
             
         }];
    }
    
    
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [phone resignFirstResponder];
    [code resignFirstResponder];
    
}

#pragma mark 网络 限制验证码的次数
- (void)netManage:(NSString *)phoneNum
{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/limit_phone_verify";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"user_type":USER_TYPE,
                           @"action_page":@"1",
                           @"phone":phoneNum,
                           };
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
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

//验证码
-(void)next
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
    else if (!isChecked)
    {
        [SVProgressHUD showInfoWithStatus:@"亲,请先阅读相关条款"];
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:1.5];
        return;
    }
    /**
     * @from               v1.1.1
     * @brief              提交验证码(Commit the verification code)
     *
     * @param code         验证码(Verification code)
     * @param phoneNumber  电话号码(The phone number)
     * @param zone         区域号，不要加"+"号(Area code)
     * @param result       请求结果回调(Results of the request)
     */
    
    [SMSSDK commitVerificationCode:code.text phoneNumber:phone.text zone:@"86" result:^(NSError *error) {
        
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"验证成功"];
            [self performSelector:@selector(dismiss:) withObject:nil afterDelay:1.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                SettingPassWordViewController * vc=   [[SettingPassWordViewController alloc]init];
                vc.phoneNumber = phone.text;
                [self.navigationController pushViewController:vc animated:YES];
            });
        }
        else{
            [SVProgressHUD showInfoWithStatus:@"验证码错误"];
            [self performSelector:@selector(dismiss:) withObject:nil afterDelay:1.5];
        }
    }];
}

- (void)dismiss:(id)sender {
    [SVProgressHUD dismiss];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

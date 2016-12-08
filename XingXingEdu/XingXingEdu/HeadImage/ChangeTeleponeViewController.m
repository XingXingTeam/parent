//
//  ChangeTeleponeViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/5/10.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "ChangeTeleponeViewController.h"
#import "NewPassWordViewController.h"
#import "LandingpageViewController.h"
#import "SVProgressHUD.h"
#import <SMS_SDK/SMSSDK.h>




@interface ChangeTeleponeViewController ()
{
    UIView *bgView;
    //UITextField *phone;
    UITextField *code;
    UINavigationBar *customNavigationBar;
    UIButton *yzButton;
    NSString *urlStr;
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
}

@property(nonatomic, copy) NSString *oUserPhoneNum;
@property(assign, nonatomic) NSInteger timeCount;
@property(strong, nonatomic) NSTimer *timer;
//验证码
@property(copy, nonatomic) NSString *smsId;
@property (nonatomic, strong) UITextField *phone;
@end

@implementation ChangeTeleponeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }

    self.navigationController.navigationBarHidden = NO;
    self.title=@"更换手机号";
    self.view.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];

    [self createTextFields];
    
}

-(void)createTextFields
{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 75, self.view.frame.size.width-90, 30)];
    label.text=@"请输入您的新手机号码";
    label.textColor=[UIColor grayColor];
    label.textAlignment=NSTextAlignmentLeft;
    label.font=[UIFont systemFontOfSize:13];
    
    [self.view addSubview:label];
    
    
    CGRect frame=[UIScreen mainScreen].bounds;
    bgView=[[UIView alloc]initWithFrame:CGRectMake(10, 110, frame.size.width-20, 100)];
    bgView.layer.cornerRadius=3.0;
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    
    _phone=[self createTextFielfFrame:CGRectMake(100, 10, 200, 30) font:[UIFont systemFontOfSize:14] placeholder:@"11位手机号"];
    _phone.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phone.keyboardType=UIKeyboardTypeNumberPad;
    //phone.text=@"15527002684";
    
    code=[self createTextFielfFrame:CGRectMake(100, 60, 90, 30) font:[UIFont systemFontOfSize:14]  placeholder:@"4位数字" ];
    code.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //密文样式
    code.secureTextEntry=YES;
    code.keyboardType=UIKeyboardTypeNumberPad;
    
    
    UILabel *phonelabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 12, 50, 25)];
    phonelabel.text=@"手机号";
    phonelabel.textColor=[UIColor blackColor];
    phonelabel.textAlignment=NSTextAlignmentLeft;
    phonelabel.font=[UIFont systemFontOfSize:14];
    
    UILabel *codelabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 62, 50, 25)];
    codelabel.text=@"验证码";
    codelabel.textColor=[UIColor blackColor];
    codelabel.textAlignment=NSTextAlignmentLeft;
    codelabel.font=[UIFont systemFontOfSize:14];
    
    
    yzButton=[[UIButton alloc]initWithFrame:CGRectMake(bgView.frame.size.width-100-20, 62, 100, 30)];
    //yzButton.layer.cornerRadius=3.0f;
    //yzButton.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    [yzButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [yzButton setTitleColor:[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1] forState:UIControlStateNormal];
    yzButton.font=[UIFont systemFontOfSize:13];
    [yzButton addTarget:self action:@selector(getValidCode:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:yzButton];
    
    UIImageView *line1=[self createImageViewFrame:CGRectMake(20, 50, bgView.frame.size.width-40, 1) imageName:nil color:[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3]];
    
    UIButton *landBtn=[self createButtonFrame:CGRectMake(10, bgView.frame.size.height+bgView.frame.origin.y+30,self.view.frame.size.width-20, 37) backImageName:nil title:@"提交验证" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:17] target:self action:@selector(landClick)];
    landBtn.backgroundColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    landBtn.layer.cornerRadius=5.0f;
    
    
    [bgView addSubview:_phone];
    [bgView addSubview:code];
    
    [bgView addSubview:phonelabel];
    [bgView addSubview:codelabel];
    [bgView addSubview:line1];
    [self.view addSubview:landBtn];
    
}

- (void)getValidCode:(UIButton *)sender
{
    if ([_phone.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"亲,请输入手机号码"];
        return;
    }
    else if (_phone.text.length !=11)
    {
        [SVProgressHUD showInfoWithStatus:@"您输入的手机号码格式不正确"];
        return;
    }
    //短信验证码
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phone.text zone:@"86" customIdentifier:nil
                                 result:^(NSError *error){
                                     if (!error) {
                                         NSLog(@"获取验证码成功");
                                     }
                                     else {
                                         NSLog(@"错误信息：%@",error);
                                     }
                                 }];
    _oUserPhoneNum =_phone.text;
    sender.userInteractionEnabled = NO;
    self.timeCount = 60;
    //    __weak ForgetPassWordViewController *weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime:) userInfo:sender repeats:YES];
    
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
    [_phone resignFirstResponder];
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

//验证码
-(void)landClick
{
    
    if ([_phone.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"亲,请输入注册手机号码"];
        return;
    }
    else if (_phone.text.length !=11)
    {
        [SVProgressHUD showInfoWithStatus:@"您输入的手机号码格式不正确"];
        return;
    }
    else if (code.text.length !=4)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入4位验证码"];
        return;
    }
    else if (code.text.length !=4)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入4位验证码"];
        return;
    }
    
    
    [SMSSDK commitVerificationCode:code.text phoneNumber:self.phone.text zone:@"86" result:^(NSError *error) {
        
        if (!error) {
           // NSLog(@"验证成功");
            [SVProgressHUD showSuccessWithStatus:@"验证成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self updateTelephone];
                [self.navigationController popViewControllerAnimated:YES];
                
            });
        }
        else
        {
           // NSLog(@"错误信息:%@",error);
            [SVProgressHUD showInfoWithStatus:@"验证码错误"];
        }
    }];
    
    
}
- (void)updateTelephone{

    urlStr = @"http://www.xingxingedu.cn/Global/limit_phone_verify";
    NSDictionary *pragam = @{ @"appkey":APPKEY,
                              @"backtype":BACKTYPE,
                              @"xid":parameterXid,
                              @"user_id":parameterUser_Id,
                              @"user_type":USER_TYPE,
                              @"action_page":@"3",
                              @"phone":_phone.text
                              
                              };
    
    [WZYHttpTool post:urlStr params:pragam success:^(id responseObj) {
        NSDictionary *dict =responseObj;
       // NSLog(@"data=====================================%@",dict);
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
            [self  nextPhone];
        }
        else if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"4"]){
            [SVProgressHUD showErrorWithStatus:@"今日已达到5次验证上限"];
        }
        
    } failure:^(NSError *error) {
       
    }];

}
- (void)nextPhone{
    urlStr = @"http://www.xingxingedu.cn/Parent/edit_my_info";
    NSDictionary *prag = @{   @"appkey":APPKEY,
                              @"backtype":BACKTYPE,
                              @"xid":parameterXid,
                              @"user_id":parameterUser_Id,
                              @"user_type":USER_TYPE,
                              @"phone":_phone.text
                              
                              };
    
    [WZYHttpTool post:urlStr params:prag success:^(id responseObj) {
        NSDictionary *dict =responseObj;
       // NSLog(@"data=====================================%@",dict);
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
            
        }
        else if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"50"]){
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",dict[@"msg"]]];
        }
        else if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"51"]){
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",dict[@"msg"]]];
        }
        
    } failure:^(NSError *error) {
       // NSLog(@"error====error=================================");
    }];
    


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


//
//  XXEMyselfInfoNewPhoneNumViewController.m
//  teacher
//
//  Created by Mac on 2016/12/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfInfoNewPhoneNumViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "MyInfomationViewController.h"


@interface XXEMyselfInfoNewPhoneNumViewController ()
{

    //手机输入框
    UITextField *phoneTextField;
    //验证码 输入框
    UITextField *codeTextField;
    //
    UIButton *getCodeButton;
    //
    UIButton *submitButton;

    NSString *parameterXid;
    NSString *parameterUser_Id;
}



@end

@implementation XXEMyselfInfoNewPhoneNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    self.edgesForExtendedLayout=UIRectEdgeNone;
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    [self createContent];

}


- (void)createContent{
   //输入新 手机号
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, KScreenWidth - 20, 20)];
    titleLabel1.text = @"请输入新手机号:";
    titleLabel1.font = [UIFont systemFontOfSize:14 ];
    [self.view addSubview:titleLabel1];
    
    UIImageView *bgImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BIG400x60"]];
    bgImageView1.frame = CGRectMake(10, titleLabel1.frame.origin.y + titleLabel1.height + 10, 335 * kScreenRatioWidth, 41 * kScreenRatioHeight);
    bgImageView1.userInteractionEnabled = YES;
    [self.view addSubview:bgImageView1];
    
    UIImageView *leftIcon1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account"]];
    leftIcon1.frame = CGRectMake(15, 10 * kScreenRatioHeight, 22 * kScreenRatioWidth, 24 * kScreenRatioHeight);
    [bgImageView1 addSubview:leftIcon1];
    
    phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(50 * kScreenRatioWidth , 10 * kScreenRatioHeight, 250 * kScreenRatioWidth, 20)];
    phoneTextField.placeholder = @"请输入新手机号";
    phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    phoneTextField.clearButtonMode = UITextFieldViewModeAlways;
    phoneTextField.backgroundColor = [UIColor whiteColor];
    phoneTextField.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    [bgImageView1 addSubview:phoneTextField];
    
    
    //获取验证码
    UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, bgImageView1.frame.origin.y + bgImageView1.height + 10, KScreenWidth - 20, 20)];
    titleLabel2.text = @"验证码";
    titleLabel2.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    [self.view addSubview:titleLabel2];
    
    
    UIImageView *bgImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BIG400x60"]];
    bgImageView2.frame = CGRectMake(10, titleLabel2.frame.origin.y + titleLabel2.height + 10, 335 * kScreenRatioWidth, 41 * kScreenRatioHeight);
    bgImageView2.userInteractionEnabled = YES;
    [self.view addSubview:bgImageView2];
    
    UIImageView *leftIcon2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password"]];
    leftIcon2.frame = CGRectMake(15, 10 * kScreenRatioHeight, 22 * kScreenRatioWidth, 24 * kScreenRatioHeight);
    [bgImageView2 addSubview:leftIcon2];
    
    codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(50 * kScreenRatioWidth , 10 * kScreenRatioHeight, 150 * kScreenRatioWidth, 20)];
    codeTextField.placeholder = @"请输入验证码";
    codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    codeTextField.clearButtonMode = UITextFieldViewModeAlways;
    codeTextField.backgroundColor = [UIColor whiteColor];
    
    codeTextField.font = [UIFont systemFontOfSize:14 ];
    [bgImageView2 addSubview:codeTextField];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(codeTextField.frame.origin.x + codeTextField.width + 3, 2, 1, 41* kScreenRatioHeight - 2)];
    line.backgroundColor = [UIColor lightGrayColor];
    [bgImageView2 addSubview:line];
    
    getCodeButton = [HHControl createButtonWithFrame:CGRectMake(codeTextField.frame.origin.x + codeTextField.width + 5, codeTextField.frame.origin.y, 120 * kScreenRatioWidth, 20) backGruondImageName:@"" Target:self Action:@selector(getCodeButtonClick) Title:@"获取验证码"];
    getCodeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [getCodeButton setTitleColor:UIColorFromRGB(189, 210, 38) forState:UIControlStateNormal];
    //    [[UIButton alloc] initWithFrame:];
    
    [bgImageView2 addSubview:getCodeButton];
    
    //下一步
    CGFloat buttonW = 325 * kScreenRatioWidth;
    CGFloat buttonH = 42 * kScreenRatioHeight;
    CGFloat buttonX = (KScreenWidth - buttonW) / 2;
    CGFloat buttonY = bgImageView2.frame.origin.y + bgImageView2.height + 20;
    
    
    submitButton = [HHControl createButtonWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH) backGruondImageName:@"按钮big650x84" Target:self Action:@selector(submitButton:) Title:@"提       交"];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:submitButton];
    
}


// 获取验证码
- (void)getCodeButtonClick{
    //判断是否是电话号
    if ([self isChinaMobile:phoneTextField.text] == NO) {
        [self showString:@"请输入11位手机号码" forSecond:1.5];
    }else{
        
        //先判断 新 手机号 是否 可用
        [self checkPhoneNumberWithPhone:phoneTextField.text];
    
    }

}


- (void)getVerificationNumber
{
    //短信验证码
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phoneTextField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            [self showString:@"获取验证码成功" forSecond:1.f];
            //记录次数
            [self recordTheVerifyCodeNum];
        }
    }];
}

#pragma mark - 获取验证码次数
- (void)recordTheVerifyCodeNum
{
    /*
     【限制手机验证码次数】
     接口类型:1
     接口:
     http://www.xingxingedu.cn/Global/limit_phone_verify
     传参:
     action_page	//执行页面 1:注册页面  2:修改密码页面  3:更换手机页面
     phone		//手机号
     
     code:4		//今日已达到5次验证上限
     */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/limit_phone_verify";
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE,
                             @"action_page":@"3",
                             @"phone":phoneTextField.text
                             };
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
//        NSLog(@"%@", responseObj);
        if ([responseObj[@"code"] integerValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"获取验证码成功!"];
        }else if ([responseObj[@"code"] integerValue] == 4) {
            [SVProgressHUD showInfoWithStatus:@"今日已达到5次验证上限!"];
            getCodeButton.userInteractionEnabled = NO;
        }
        
    } failure:^(NSError *error) {
        //
        [SVProgressHUD showInfoWithStatus:@"获取数据失败!"];
    }];
    
    
}


#pragma mark ======= 判断 是否 是 手机号码 ==============
- (BOOL)isChinaMobile:(NSString *)phoneNum{
    BOOL isChinaMobile = NO;
    
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    if([regextestcm evaluateWithObject:phoneNum] == YES){
        isChinaMobile = YES;
        //        NSLog(@"中国移动");
    }
    
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    if([regextestcu evaluateWithObject:phoneNum] == YES){
        isChinaMobile = YES;
        //        NSLog(@"中国联通");
    }
    
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if([regextestct evaluateWithObject:phoneNum] == YES){
        isChinaMobile = YES;
        //        NSLog(@"中国电信");
    }
    return isChinaMobile;
}


#pragma mark - 判断新 手机号 是否 可用 ==========

- (void)checkPhoneNumberWithPhone:(NSString *)phone
{
    
    /*
     【注册第一步判断手机是否存在】
     接口类型:1
     接口:
     http://www.xingxingedu.cn/Parent/register_check_phone
     传参(参数名):
     phone 		//手机
     */
    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/register_check_phone";
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE,
                             @"phone":phone
                             };
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
//        NSLog(@"%@", responseObj);
        
        if ([responseObj[@"code"] integerValue] == 1) {
            [SVProgressHUD showInfoWithStatus:@"此号码可注册"];
            getCodeButton.userInteractionEnabled = YES;
            codeTextField.enabled = YES;
            [getCodeButton startWithTime:60 title:@"获取验证码" countDownTile:@"s后重新获取" mColor:UIColorFromRGB(189, 210, 38) countColor:UIColorFromRGB(204, 204, 204)];
            
            [self getVerificationNumberWithPhone:phone];

        }else if ([responseObj[@"code"] integerValue] == 3){
            [SVProgressHUD showInfoWithStatus:@"手机已存在,如果您已经在APP上注册过,想要创建多个身份,请在APP首页下拉框编辑身份"];
            
            codeTextField.enabled = NO;
            getCodeButton.userInteractionEnabled = NO;

        }else{
            [SVProgressHUD showInfoWithStatus:@"请重新输入"];
        }
        
    } failure:^(NSError *error) {
        //
        [SVProgressHUD showErrorWithStatus:@"获取数据失败!"];
    }];

}


//获取验证码
- (void)getVerificationNumberWithPhone:(NSString*)phone
{
    //短信验证码
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phone zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            
            //记录次数
            [self recordTheVerifyCodeNumWithPhone:phone];
        }else {
            [self showString:@"获取验证码失败" forSecond:1.f];
        }
    }];
}

#pragma mark - 获取验证码次数
- (void)recordTheVerifyCodeNumWithPhone:(NSString*)phone
{
    /*
     【限制手机验证码次数】
     接口类型:1
     接口:
     http://www.xingxingedu.cn/Global/limit_phone_verify
     传参:
     action_page	//执行页面 1:注册页面  2:修改密码页面  3:更换手机页面
     phone		//手机号
     
     code:4		//今日已达到5次验证上限
     */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/limit_phone_verify";
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE,
                             @"action_page":@"3",
                             @"phone":phoneTextField.text
                             };
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
        //        NSLog(@"%@", responseObj);
        if ([responseObj[@"code"] integerValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"获取验证码成功!"];
        }else if ([responseObj[@"code"] integerValue] == 4) {
            [SVProgressHUD showInfoWithStatus:@"今日已达到5次验证上限!"];
            getCodeButton.userInteractionEnabled = NO;
        }
        
    } failure:^(NSError *error) {
        //
        [SVProgressHUD showInfoWithStatus:@"获取数据失败!"];
    }];
}




#pragma mark ======= 提交 ===========
- (void)submitButton:(UIButton *)button{
//    NSLog(@"提交");
    
    [self verifyNumberISRight];

}

#pragma mark - 验证验证码对不对
-(void)verifyNumberISRight
{
    //    NSLog(@"电话号码%@ 验证码%@",self.registerUerTextField.text,self.registerVerificationTextField.text);
    [SMSSDK commitVerificationCode:codeTextField.text phoneNumber:phoneTextField.text zone:@"86" result:^(NSError *error) {
        if (error) {
            [self showString:@"验证码错误" forSecond:1.f];
        }else {
            //
            [self submitMyselfNewPhoneNum];
        }
    }];
}


- (void)submitMyselfNewPhoneNum{
/*
 【编辑我的资料】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Parent/edit_my_info
 传参:
	phone			//手机
 */
    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/edit_my_info";
    NSDictionary *params = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"phone":phoneTextField.text,
                           };
   [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
    //
//      NSLog(@"修改手机号 === %@", responseObj);
    
    if ([responseObj[@"code"] integerValue] == 1) {
        [self showHudWithString:@"修改成功!" forSecond:1.5];
//        [self updateSaveData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.navigationController popViewControllerAnimated:YES];
            
            for (UIViewController *temp in self.navigationController.viewControllers)
            {
                if ([temp isKindOfClass:[MyInfomationViewController class]])
                {
                    [self.navigationController popToViewController:temp animated:NO];
                    
                }
            }

            
        });
        
    }else{
        [self showHudWithString:@"修改失败!" forSecond:1.5];
    }
    
} failure:^(NSError *error) {
    //
    [self showHudWithString:@"获取数据失败!" forSecond:1.5];
}];
    
}

//更新 存储 数据
//- (void)updateSaveData{
//    
//    [[XXEUserInfo user] cleanUserInfo];
//    NSDictionary *userInfoDic = [[NSDictionary alloc] init];
//    
//    if ([XXEUserInfo user].qqNumber == nil) {
//        [XXEUserInfo user].qqNumber = @"";
//    }
//    
//    if ([XXEUserInfo user].weixin == nil) {
//        [XXEUserInfo user].weixin = @"";
//    }
//    
//    if ([XXEUserInfo user].sinaNumber == nil) {
//        [XXEUserInfo user].sinaNumber = @"";
//    }
//    
//    if ([XXEUserInfo user].zhifubao == nil) {
//        [XXEUserInfo user].zhifubao = @"";
//    }

//    userInfoDic = @{
//                               //             @"account":
//                               @"account": phoneTextField.text,
//                               @"login_times":[XXEUserInfo user].login_times,
//                               @"nickname":[XXEUserInfo user].nickname,
//                               @"token":[XXEUserInfo user].token,
//                               @"qqNumberToken":[XXEUserInfo user].qqNumber,
//                               @"weixinToken":[XXEUserInfo user].weixin,
//                               @"sinaNumberToken":[XXEUserInfo user].sinaNumber,
//                               @"zhifubaoToken":[XXEUserInfo user].zhifubao,
//                               @"login_type":[XXEUserInfo user].login_type,
//                               @"user_head_img":[XXEUserInfo user].user_head_img,
//                               @"user_id":[XXEUserInfo user].user_id,
//                               @"user_type":[XXEUserInfo user].user_type,
//                               @"xid":[XXEUserInfo user].xid,
//                               @"loginStatus":[NSNumber numberWithBool:[XXEUserInfo user].login]
//                               };
//    NSDictionary *userInfo = @{@"account":[XXEUserInfo user].account,
//                               @"login_times":[XXEUserInfo user].login_times,
//                               @"nickname":[XXEUserInfo user].nickname,
//                               @"token":[XXEUserInfo user].token,
//                               @"user_head_img":[XXEUserInfo user].user_head_img,
//                               @"loginStatus":[NSNumber numberWithBool:YES],
//                               //                                    @"qqNumner":account,
//                               @"user_id":user_id,
//                               @"xid":xid
//                               };
//    NSLog(@"%@",userInfo);
//    [[XXEUserInfo user] setupUserInfoWithUserInfo:userInfoDic];
//
//}


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

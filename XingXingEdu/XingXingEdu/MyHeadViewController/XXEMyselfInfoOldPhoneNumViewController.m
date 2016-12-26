//
//  XXEMyselfInfoOldPhoneNumViewController.m
//  teacher
//
//  Created by Mac on 2016/12/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfInfoOldPhoneNumViewController.h"
#import "XXEMyselfInfoNewPhoneNumViewController.h"
//#import "XXEVertifyTimesApi.h"
#import <SMS_SDK/SMSSDK.h>

@interface XXEMyselfInfoOldPhoneNumViewController ()
{

    //手机号
    NSString *oldPhoneNumStr;
    
    UIView *contentView;
    //验证码
    UITextField *codeTextField;
    //获取验证码 按钮
    UIButton *getCodeButton;
    
    //下一步
    UIButton *nextButton;
    NSString *parameterXid;
    NSString *parameterUser_Id;


}


@end

@implementation XXEMyselfInfoOldPhoneNumViewController

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

//    oldPhoneNumStr = [XXEUserInfo user].account;
    
    oldPhoneNumStr = _phoneStr;
    
    [self createContent];


}

- (void)createContent{

//    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 100 * kScreenRatioHeight)];
//    contentView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:contentView];
    
    //当前 注册 手机号
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, KScreenWidth - 20, 20)];
    titleLabel1.text = @"当前注册手机号:";
//    titleLabel1.backgroundColor = [UIColor whiteColor];
    titleLabel1.font = [UIFont systemFontOfSize:14 ];
    [self.view addSubview:titleLabel1];
    
    UILabel *oldPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, titleLabel1.frame.origin.y + titleLabel1.height + 10, KScreenWidth - 20, 20)];
//    oldPhoneLabel.backgroundColor = [UIColor whiteColor];
    NSString *phone = oldPhoneNumStr;
    //账号 中间 隐藏 一部分
    //138 1865 7742 ->  //138 **** 7742
    oldPhoneLabel.text = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    oldPhoneLabel.font = [UIFont systemFontOfSize:14 ];
    [self.view addSubview:oldPhoneLabel];
    
    //验证码
    UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, oldPhoneLabel.frame.origin.y + oldPhoneLabel.height + 10, KScreenWidth - 20, 20)];
    titleLabel2.font = [UIFont systemFontOfSize:14 ];
    titleLabel2.text = @"验证码:";
    [self.view addSubview:titleLabel2];
    

    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BIG400x60"]];
    bgImageView.frame = CGRectMake(10, titleLabel2.frame.origin.y + titleLabel2.height + 10, 335 * kScreenRatioWidth, 41 * kScreenRatioHeight);
    bgImageView.userInteractionEnabled = YES;
    [self.view addSubview:bgImageView];
    
    UIImageView *leftIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password"]];
    leftIcon.frame = CGRectMake(15, 10 * kScreenRatioHeight, 22 * kScreenRatioWidth, 24 * kScreenRatioHeight);
    [bgImageView addSubview:leftIcon];
    
    codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(50 * kScreenRatioWidth , 10 * kScreenRatioHeight, 150 * kScreenRatioWidth, 20)];
    codeTextField.placeholder = @"请输入验证码";
    codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    codeTextField.clearButtonMode = UITextFieldViewModeAlways;
    codeTextField.backgroundColor = [UIColor whiteColor];
    
    codeTextField.font = [UIFont systemFontOfSize:14 ];
    [bgImageView addSubview:codeTextField];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(codeTextField.frame.origin.x + codeTextField.width + 3, 2, 1, 38* kScreenRatioHeight - 2)];
    line.backgroundColor = [UIColor lightGrayColor];
    [bgImageView addSubview:line];
    
   getCodeButton = [HHControl createButtonWithFrame:CGRectMake(codeTextField.frame.origin.x + codeTextField.width + 5, codeTextField.frame.origin.y, 120 * kScreenRatioWidth, 20) backGruondImageName:@"" Target:self Action:@selector(getCodeButtonClick) Title:@"获取验证码"];
    getCodeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [getCodeButton setTitleColor:UIColorFromRGB(189, 210, 38) forState:UIControlStateNormal];
//    [[UIButton alloc] initWithFrame:];
    
    [bgImageView addSubview:getCodeButton];
    
    //下一步
    CGFloat buttonW = 325 * kScreenRatioWidth;
    CGFloat buttonH = 42 * kScreenRatioHeight;
    CGFloat buttonX = (KScreenWidth - buttonW) / 2;
    CGFloat buttonY = bgImageView.frame.origin.y + bgImageView.height + 20;
    
    
    nextButton = [HHControl createButtonWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH) backGruondImageName:@"按钮big650x84" Target:self Action:@selector(nextButtonClick:) Title:@"下一步"];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:nextButton];
}

#pragma mark ====== 获取 验证码 ===========
- (void)getCodeButtonClick{

    NSLog(@"----获取验证码----");
    
    
    [getCodeButton startWithTime:60 title:@"获取验证码" countDownTile:@"s后重新获取" mColor: UIColorFromRGB(189, 210, 38) countColor:UIColorFromRGB(204, 204, 204)];
    [self showString:@"验证码已发送" forSecond:1.f];
    [self getVerificationNumber];
    
}

- (void)getVerificationNumber
{
    //短信验证码
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:oldPhoneNumStr zone:@"86" customIdentifier:nil result:^(NSError *error) {
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
                             @"phone":_phoneStr
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


#pragma mark ======= 下一步 =======
- (void)nextButtonClick:(UIButton *)button{
    
    if ([codeTextField.text isEqualToString:@""]) {
        [self showString:@"请输入4位数验证码!" forSecond:1.5];
    }else{
        //验证验证码对不对
        [self verifyNumberISRight];
    }
}


#pragma mark - 验证验证码对不对
-(void)verifyNumberISRight
{
//    NSLog(@"电话号码%@ 验证码%@",oldPhoneNumStr,codeTextField.text);
    
    [SMSSDK commitVerificationCode:codeTextField.text phoneNumber:oldPhoneNumStr zone:@"86" result:^(NSError *error) {
        if (error) {
            [self showString:@"验证码错误" forSecond:1.f];
        }else {
            XXEMyselfInfoNewPhoneNumViewController *newPhoneNumVC = [[XXEMyselfInfoNewPhoneNumViewController alloc] init];
        
            [self.navigationController pushViewController:newPhoneNumVC animated:YES];
        
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

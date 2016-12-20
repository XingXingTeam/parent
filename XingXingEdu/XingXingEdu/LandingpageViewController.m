//
//  LandingpageViewController.m
//  xingxingEdu
//
//  Created by super on 16/1/13.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define LoginUrl @"http://www.xingxingedu.cn/Parent/login"
#define NUMBERS @"0123456789\n"
#import "LandingpageViewController.h"
#import "PassWordResetViewController.h"
#import "MainViewController.h"
#import "HyLoglnButton.h"
#import "HyTransitions.h"
#import "SVProgressHUD.h"
#import "SettingPersonInfoViewController.h"
#import "AuthenticationViewController.h"
#import "ForgetPassWordViewController.h"
#import "HomepageViewController.h"
#import "AuthenticationViewController.h"
#import "ForgetPassWordViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "SchoolInfoViewController.h"
#import "HHControl.h"
#import "MyTabBarController.h"
#import <CoreLocation/CoreLocation.h>
#import "XXETabBarViewController.h"
#import "ClassEditViewController.h"
#import "UMSocial.h"
#import "ServiceManager.h"
#import "XXENavigationViewController.h"

#import "XXEUserInfo.h"

@interface LandingpageViewController ()<UIViewControllerTransitioningDelegate,UITextFieldDelegate,CLLocationManagerDelegate>

{
    UIImageView *View;
    UIView *bgView;
    UITextField *pwd;
    UITextField *user;
    UIButton *QQBtn;
    UIButton *weixinBtn;
    UIButton *xinlangBtn;
    UIButton *zhifubaoBtn;
    HyLoglnButton *landBtn;
    HyLoglnButton *volatileBtn;
    UIButton *TxBtn;
    UIButton *eyeBtn;
    UIImageView *UserImage;
    NSString *longitudeKT;
    NSString *latitudeKT;
    UIButton *newUserBtn;
    UIButton *visitorsBtn;
    UIButton *forgotPwdBtn;
    
    
}
@property(nonatomic,strong)CLLocationManager *locationManager;
@property (copy,nonatomic) NSString * accountNumber;
@property (copy,nonatomic) NSString * mmmm;
@property (copy,nonatomic) NSString * User;

//沙盒 存储 上一次 登录 账号的信息 ：手机号、头像
@property (nonatomic, copy) NSString *lastTimeLoginAccountStr;
@property (nonatomic, copy) NSString *lastTimeLoginHeadPicStr;

/** 第三方昵称 */
@property (nonatomic, copy)NSString *thirdNickName;
/** 第三放头像 */
@property (nonatomic, copy)NSString *thirdHeadImage;
/** QQToken */
@property (nonatomic, copy)NSString *qqLoginToken;
/** 微信Token */
@property (nonatomic, copy)NSString *weixinLoginToken;
/** 新浪Token */
@property (nonatomic, copy)NSString *sinaLoginToken;
/** 支付宝Token */
@property (nonatomic, copy)NSString *aliPayLoginToken;
/** 登录类型 1为手机 2为qq 3为微信 4为微博 5为 支付宝  10为访客模式(访客模式只要此参数)*/
@property (nonatomic, copy)NSString *login_type;

@end

@implementation LandingpageViewController

//    1. 懒加载初始化：
- (CLLocationManager *)locationManager{
    if(!_locationManager){
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    return _locationManager;
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden =YES;
}
- (void)viewWillDisappear:(BOOL)animated{
self.navigationController.navigationBarHidden =NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //定位
    [self settingLocation];
    //用户 登录 头像
    [self settingHeadImageView];
    //用户 登录 账户/密码
    [self createTextFields];
    //
    [self createButtons];
    
    //
    [self createLabel];
    
}


#pragma mark - 设置手机 自动定位=====================================

    
- (void)settingLocation{
    //    判断定位操作是否允许
    if ([CLLocationManager locationServicesEnabled] &&[CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        
        //经度
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //每隔多少米 更新 一次
        //kCLDistanceFilterNone 任意 移动 都会更新
        _locationManager.distanceFilter = kCLDistanceFilterNone;//横向移动距离更新
        
        if (__IPHONE_8_0) {
            
            [self.locationManager requestWhenInUseAuthorization];
            //        [self.locationManager requestAlwaysAuthorization];
            
        }
        //定位开始
        [self.locationManager startUpdatingLocation];
    }else{
        //提示用户无法定位操作
        [self initAlertWithTitle:@"温馨提醒" Message:@"您尚未开启定位是否开启" ActionTitle:@"开启" CancelTitle:@"取消" URLS:@"prefs:root=LOCATION_SERVICES"];
    }

    
}

- (void)initAlertWithTitle:(NSString *)title Message:(NSString *)message ActionTitle:(NSString *)actionTitle CancelTitle:(NSString *)cancelTitle URLS:(NSString *)urls
{
    //提示用户无法定位操作
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"确定操作");
        NSURL*url=[NSURL URLWithString:urls];
        [[UIApplication sharedApplication] openURL:url];
    }];
    if (cancelTitle==nil) {
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消操作");
        }];
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


#pragma mark ------获得最新位置信息

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *location =[locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;//位置坐标
    
    //    NSLog(@"经度 %f;   纬度 %f ", coordinate.latitude, coordinate.longitude);
    
    longitudeKT = [NSString stringWithFormat:@"%lf", coordinate.longitude];
    latitudeKT=[NSString stringWithFormat:@"%lf",coordinate.latitude];
    
    NSLog(@"经度 == %@； 维度 == %@ ", longitudeKT, latitudeKT);
    //沙盒 存储 当前位置
    [DEFAULTS setObject:longitudeKT forKey:@"Longitude"];
    [DEFAULTS setObject:latitudeKT forKey:@"LatitudeString"];
    [DEFAULTS synchronize];
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}

- (void)settingHeadImageView{

    //设置NavigationBar颜色
    View = [HHControl createImageViewFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) imageName:@"" color:UIColorFromRGB(229, 232, 233)];
    
    //背景图片
    View.userInteractionEnabled = YES;
    [self.view addSubview:View];
    //头像  圆形 直径 100
    
    UserImage = [HHControl createImageViewFrame:CGRectMake((kWidth - 100) / 2, 100 * kWidth / 375, 100 * kWidth / 375, 100 * kWidth / 375) imageName:nil color:nil];
    
    UserImage.layer.cornerRadius = UserImage.frame.size.width / 2;
    UserImage.layer.masksToBounds =  YES;
    
    //上次 登录 的用户头像
    _lastTimeLoginHeadPicStr = [DEFAULTS objectForKey:@"RCUserPortraitUri"];
    
    //上次 登录 账号
    _lastTimeLoginAccountStr = [DEFAULTS objectForKey:@"account"];
    
    [UserImage sd_setImageWithURL:[NSURL URLWithString:_lastTimeLoginHeadPicStr] placeholderImage:[UIImage imageNamed:@"img"]];
    
    [self.view addSubview:UserImage];

}


//上方用户登录填写
-(void)createTextFields
{
    UIImageView *userImVA =[[UIImageView alloc]initWithFrame:CGRectMake(60, 215, 33, 36)];
    UIImageView *userImagViA = [HHControl createImageViewWithFrame:CGRectMake(10, 5, 22, 24) ImageName:@"账号"];
    [userImVA addSubview:userImagViA];
    
//    user =[HHControl createTextFieldWithFrame:CGRectMake(20, 215, kWidth-40, 40) placeholder:@" 手机" passWord:NO leftImageView:userImVA rightImageView:nil Font:14];
    user =[HHControl createTextFieldWithFrame:CGRectMake(20, UserImage.frame.origin.y + UserImage.frame.size.height + 15, kWidth-40, 40 * kWidth / 375) placeholder:@" 手机" passWord:NO leftImageView:userImVA rightImageView:nil Font:14 * kWidth / 375];
    
    user.text = _lastTimeLoginAccountStr;
    
    [self.view addSubview:user];
    
    user.backgroundColor =[UIColor whiteColor];
    user.layer.cornerRadius = user.frame.size.height / 2;
    user.layer.masksToBounds =YES;
    user.keyboardType=UIKeyboardTypeNumberPad;
    user.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [user addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingChanged];
    
    //密码44x48
    UIImageView *pwdImV =[[UIImageView alloc]initWithFrame:CGRectMake(60, 215, 33, 36)];
    UIImageView *pwdImagVi = [HHControl createImageViewWithFrame:CGRectMake(10, 5, 22, 24) ImageName:@"密码"];
    [pwdImV addSubview:pwdImagVi];
    
    
    pwd =[HHControl createTextFieldWithFrame:CGRectMake(20, user.frame.origin.y + user.frame.size.height + 20 * kWidth / 375, kWidth-40, 40 * kWidth / 375) placeholder:@"密码" passWord:YES leftImageView:pwdImV rightImageView:nil Font:14 * kWidth / 375];
    [self.view addSubview:pwd];
    
    pwd.backgroundColor =[UIColor whiteColor];
    pwd.layer.cornerRadius = pwd.frame.size.height / 2;
    pwd.layer.masksToBounds =YES;
    pwd.clearButtonMode = NO;
    //密文样式
    pwd.secureTextEntry=YES;

    //小脚丫
    eyeBtn = [HHControl createButtonWithFrame:CGRectMake(pwd.frame.size.width - 30 * kWidth / 375, 8, 25 * kWidth / 375, 25 * kWidth / 375) backGruondImageName:@"脚丫" Target:self Action:@selector(onClickeye:) Title:nil];
//    eyeBtn.backgroundColor = [UIColor redColor];
    [eyeBtn setImage:[UIImage imageNamed:@"脚丫H"] forState:UIControlStateHighlighted];
    [pwd addSubview:eyeBtn];
    
}

- (void)onClickeye:(UIButton *)shareBtn
{
    if (shareBtn.selected) {
        shareBtn.selected=NO;
        pwd.secureTextEntry=!pwd.secureTextEntry;
        
        [shareBtn setBackgroundImage:[UIImage  imageNamed:@"脚丫"] forState:UIControlStateNormal];
    }
    else{
        shareBtn.selected=YES;
        pwd.secureTextEntry=!pwd.secureTextEntry;
        [shareBtn setBackgroundImage:[UIImage  imageNamed:@"脚丫H"] forState:UIControlStateNormal];
    }
    
}

-(void)touchesEnded:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [user resignFirstResponder];
    [pwd resignFirstResponder];
}
- (void)textFieldDidEndEditing:(UITextField*)textField{
    if (textField==user) {
        if (textField.text.length>11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [user resignFirstResponder];
    [pwd resignFirstResponder];
}



-(void)createButtons
{
    //登陆Button
    //位置
    landBtn = [[HyLoglnButton alloc]initWithFrame:CGRectMake(20, pwd.frame.origin.y + pwd.frame.size.height + 20 * kWidth / 375, kWidth-40, 40 * kWidth / 375)];
    [landBtn setTitle:@"登    录" forState:UIControlStateNormal];
    [landBtn addTarget:self action:@selector(landClick) forControlEvents:UIControlEventTouchUpInside];
    landBtn.backgroundColor = UIColorFromRGB(0, 170, 42);
    landBtn.titleLabel.font = [UIFont systemFontOfSize:18 * kWidth / 375];
    [landBtn setTintColor:[UIColor whiteColor]];
    landBtn.layer.cornerRadius = landBtn.frame.size.height / 2;
    landBtn.layer.masksToBounds = YES;
    [View addSubview:landBtn];
    

    CGFloat buttonWidth = 100;
    CGFloat spaceWidth = (kWidth - buttonWidth * 3) / 4;
    CGFloat buttonY = landBtn.frame.origin.y + landBtn.frame.size.height + 20 * kWidth / 375;
    
    
    //免费注册BUTTOn
    newUserBtn = [HHControl createButtonWithFrame:CGRectMake(spaceWidth ,  buttonY, buttonWidth, 30) backGruondImageName:nil Target:self Action:@selector(registration:) Title:@"免费注册"];
    [newUserBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    newUserBtn.titleLabel.font = [UIFont systemFontOfSize:14 ];

    
    [View addSubview:newUserBtn];

    //访客模式Button
    visitorsBtn = [HHControl createButtonWithFrame:CGRectMake( spaceWidth * 2 + buttonWidth ,buttonY, buttonWidth, 30) backGruondImageName:nil Target:self Action:@selector(onClickvisitorsBtn:) Title:@"访客登陆"];
    [visitorsBtn setTitleColor:UIColorFromRGB(0, 170, 42) forState:UIControlStateNormal];
    visitorsBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [View addSubview:visitorsBtn];
    
    //找回密码BUTTOn
    forgotPwdBtn = [HHControl createButtonWithFrame:CGRectMake(spaceWidth * 3 + buttonWidth * 2, buttonY, buttonWidth, 30) backGruondImageName:nil Target:self Action:@selector(fogetPwd) Title:@"忘记密码?"];
    [forgotPwdBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    forgotPwdBtn.titleLabel.font = [UIFont systemFontOfSize:14 ];
    
    [View addSubview:forgotPwdBtn];

}


//第三方账号快速登陆
-(void)createLabel
{
  CGFloat lineWidth = (kWidth - 150 - 20 * 2) / 2;
    
    
  UIImageView *line3 = [HHControl createImageViewFrame:CGRectMake(20, kHeight - 130, lineWidth, 1) imageName:nil color:UIColorFromRGB(214, 216, 216)];
    
    //位置
    UILabel *label = [HHControl createLabelWithFrame:CGRectMake( line3.frame.origin.x + lineWidth, kHeight - 130 - 10, 150, 20) Font:14 * kWidth / 375 Text:@"使用其他账号登陆"];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;

    UIImageView *line4 = [HHControl createImageViewFrame:CGRectMake(kWidth - 20 - lineWidth, line3.frame.origin.y, lineWidth, 1)  imageName:nil color:UIColorFromRGB(214, 216, 216)];
    
    [self.view addSubview:line3];
    [self.view addSubview:label];
    [self.view addSubview:line4];
    /**
     *   ***************第三方登录***********
     */
    
    //QQ
    
    CGFloat buttonW = 52*kScreenRatioWidth;
    
    //按钮间距
    CGFloat space = (KScreenWidth - 50 * 2 * kScreenRatioWidth - 3 * buttonW) / 2;
    
    QQBtn = [HHControl createButtonWithFrame:CGRectMake((kWidth - (50 * 4 + 25 * 3) * kWidth / 375) / 2, kHeight - 100, 50 * kWidth / 375, 50 * kWidth / 375) backGruondImageName:@"扣扣" Target:self Action:@selector(onClickQQ:) Title:nil];
#pragma Mark ***************第三方登录***********
//    CGFloat btnW = 50 * kWidth / 375;
     [self.view addSubview:QQBtn];
    QQBtn.layer.cornerRadius= QQBtn.frame.size.width / 2;
    QQBtn.layer.masksToBounds =YES;
    [QQBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(50 * kScreenRatioWidth);
        make.bottom.equalTo(self.view.mas_bottom).offset(-45*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(52*kScreenRatioWidth, 50*kScreenRatioHeight));
    }];
    
    //微信
    weixinBtn = [HHControl createButtonWithFrame:CGRectMake(QQBtn.frame.origin.x + QQBtn.frame.size.width + 25 * kWidth / 375, QQBtn.frame.origin.y, 50 * kWidth / 375, 50 * kWidth / 375) backGruondImageName:@"微信" Target:self Action:@selector(onClickWX:) Title:nil];
    weixinBtn.layer.cornerRadius= weixinBtn.frame.size.width / 2;
    weixinBtn.layer.masksToBounds =YES;
    [self.view addSubview:weixinBtn];
    [weixinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(QQBtn.mas_right).offset(space);
        make.bottom.equalTo(self.view.mas_bottom).offset(-45*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(52*kScreenRatioWidth, 50*kScreenRatioHeight));
    }];
    
    
    //新浪
    xinlangBtn = [HHControl createButtonWithFrame:CGRectMake(weixinBtn.frame.origin.x + weixinBtn.frame.size.width + 25 * kWidth / 375, weixinBtn.frame.origin.y, 50 * kWidth / 375, 50 * kWidth / 375) backGruondImageName:@"微博" Target:self Action:@selector(onClickSina:) Title:nil];
    xinlangBtn.layer.cornerRadius = xinlangBtn.frame.size.width / 2;
    xinlangBtn.layer.masksToBounds =YES;
    [self.view addSubview:xinlangBtn];
    [xinlangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weixinBtn.mas_right).offset(space);
        make.bottom.equalTo(self.view.mas_bottom).offset(-45*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(52*kScreenRatioWidth, 50*kScreenRatioHeight));
    }];
   
//    zhifubaoBtn = [HHControl createButtonWithFrame:CGRectMake(xinlangBtn.frame.origin.x + xinlangBtn.frame.size.width + 25 * kWidth / 375, xinlangBtn.frame.origin.y, 50 * kWidth / 375, 50 * kWidth / 375) backGruondImageName:@"支付宝" Target:self Action:@selector(onClickzhifubao:) Title:nil];
//    zhifubaoBtn.layer.cornerRadius = zhifubaoBtn.frame.size.width / 2;
//    zhifubaoBtn.layer.masksToBounds =YES;
//    [View addSubview:zhifubaoBtn];
}



//- (void)registration{
//    AuthenticationViewController *registerVC=[[AuthenticationViewController alloc]init];
//    [self.navigationController pushViewController:registerVC animated:YES];
//    
//}

- (void)onClickQQ:(UIButton *)button
{
    NSLog(@"------QQ登录------");
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //          获取QQ用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            self.login_type = @"2";
            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            self.qqLoginToken = snsAccount.usid;
            self.thirdNickName = snsAccount.userName;
            self.thirdHeadImage = snsAccount.iconURL;
            //            [self getAddInfomationMessage:snsAccount LoginType:self.login_type];
            
           NSDictionary *parameters = @{
                                        @"account":snsAccount.usid,
                                        @"appkey":APPKEY,
                                        @"backtype":BACKTYPE,
                                        @"user_type":USER_TYPE,
                                        @"pass":@"",
                                        @"lng":longitudeKT,
                                        @"lat":latitudeKT,
                                        @"login_type":_login_type
              };
            
            [self thirdLoginRequestWithParameters:parameters];
        }});
}

- (void)onClickWX:(UIButton *)button
{
    NSLog(@"------微信登录------");
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            self.login_type = @"3";
            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:snsPlatform.platformName];
            self.weixinLoginToken = snsAccount.usid;
            self.thirdNickName = snsAccount.userName;
            self.thirdHeadImage = snsAccount.iconURL;
            
            NSLog(@"iD微信:---%@",snsAccount.unionId);
            
            NSDictionary *parameters = @{
                                         @"account":snsAccount.usid,
                                         @"appkey":APPKEY,
                                         @"backtype":BACKTYPE,
                                         @"user_type":USER_TYPE,
                                         @"pass":@"",
                                         @"lng":longitudeKT,
                                         @"lat":latitudeKT,
                                         @"login_type":_login_type
                                         };
            
            [self thirdLoginRequestWithParameters:parameters];
            
//            [self getAddInfomationMessage:snsAccount LoginType:self.login_type];
        }
    });
    
}


- (void)onClickSina:(UIButton *)button
{
    NSLog(@"------新浪登录------");
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            self.login_type = @"4";
            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            self.sinaLoginToken = snsAccount.usid ;
            self.thirdNickName = snsAccount.userName;
            self.thirdHeadImage = snsAccount.iconURL;
            //
            //            [self getAddInfomationMessage:snsAccount LoginType:self.login_type];
//            [self loginInterFaceApiSnsAccount:snsAccount.usid LoginTYpe:self.login_type];
            
            NSDictionary *parameters = @{
                                         @"account":snsAccount.usid,
                                         @"appkey":APPKEY,
                                         @"backtype":BACKTYPE,
                                         @"user_type":USER_TYPE,
                                         @"pass":@"",
                                         @"lng":longitudeKT,
                                         @"lat":latitudeKT,
                                         @"login_type":_login_type
                                         };
            [self thirdLoginRequestWithParameters:parameters];
            
        }});
    
    
}

//访客
-(void)onClickvisitorsBtn:(UIButton *)button
{
    
    XXETabBarViewController *myTableVC =[[XXETabBarViewController alloc]init];
    [self presentViewController:myTableVC animated:YES completion:nil];
    
    
}

#pragma mark ======= 免费注册 =========
-(void)registration:(UIButton *)button
{
//    NSLog(@"00000");
//    AuthenticationViewController *registerVC=[[AuthenticationViewController alloc]init];
    //    UINavigationController *navi=[[UINavigationController alloc]initWithRootViewController:registerVC];
//    [self.navigationController pushViewController:registerVC animated:YES];
    AuthenticationViewController *registerVC = [[AuthenticationViewController alloc]init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    XXENavigationViewController *navi = [[XXENavigationViewController alloc]initWithRootViewController:registerVC];
    window.rootViewController = navi;


}

#pragma Mark ========= 忘记密码 ********
-(void)fogetPwd{
    
//    NSLog(@"忘记 密码");
    
//    ForgetPassWordViewController * forVC=[[ForgetPassWordViewController alloc]init];
//    [self.navigationController pushViewController:forVC animated:YES];
    ForgetPassWordViewController *forgetVC = [[ForgetPassWordViewController alloc]init];
//    forgetVC.loginType = LoginNot;
//    forgetVC.passwordType = LoginPassword;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    XXENavigationViewController *navi = [[XXENavigationViewController alloc]initWithRootViewController:forgetVC];
    window.rootViewController = navi;
}




//登录
-(void)landClick
{
    typeof(self) __weak weak =self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weak LoginView];
    });
}


#pragma mark ========= 账号登录 (非第三方登录) =============
- (void)LoginView{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];

    if ([user.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"亲,请输入用户名"];
        [landBtn ErrorRevertAnimationCompletion:^{
            
        }];
        return;
    }
    else if (user.text.length <11||user.text.length>11)
    {
       
        [SVProgressHUD showInfoWithStatus:@"您输入的手机号码格式不正确"];
        
        [landBtn ErrorRevertAnimationCompletion:^{
            
        }];
        return;
    }
    else if ([pwd.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"亲,请输入密码"];
        [landBtn ErrorRevertAnimationCompletion:^{
         
        }];
        return;
    }
    else if (pwd.text.length <6)
    {
        [SVProgressHUD showInfoWithStatus:@"亲,密码长度至少六位"];
        [landBtn ErrorRevertAnimationCompletion:^{
          
        }];
        return;
    }
    else if (user.text.length==11)
    {
//        NSDictionary *parameters = @{
//                                     @"account":user.text,
//                                     @"appkey":APPKEY,
//                                     @"backtype":BACKTYPE,
//                                     @"user_type":USER_TYPE,
//                                     @"pass":pwd.text,
//                                     @"lng":longitudeKT,
//                                     @"lat":latitudeKT,
//                                     @"login_type":_login_type
//                                     };
//        
//        [self loginRequestWithParameters:parameters];
        
//        NSLog(@"%@ , %@",user.text,pwd.text);
        //创建一个URL :请求路径
        NSURL *url =[NSURL URLWithString:LoginUrl];
        //创建一个请求
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
        //10秒后算请求超时 (默认60s超时)
        request.timeoutInterval =10;
        request.HTTPMethod = @"POST";
        //设置请求体 @"user_lng":@"121.616636",

    NSString *parm = [NSString stringWithFormat:@"appkey=%@&backtype=%@&login_type=%d&account=%@&pass=%@&lng=%@&lat=%@",@"U3k8Dgj7e934bh5Y",@"json",1,user.text,pwd.text,@"",@""];
      //NSString --> NSData
        request.HTTPBody =[parm dataUsingEncoding:NSUTF8StringEncoding];
        // 发送一个同步请求(在主线程发送请求)
        // queue ：存放completionHandler这个任务
        NSOperationQueue *queue =[NSOperationQueue mainQueue];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            if (connectionError || data ==nil) {
                return ;
            }
            
            NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"账户 信息  *****   dict:%@",dict);
            
            NSString *codeStr = [NSString stringWithFormat:@"%@", dict[@"code"]];
            
            if (![codeStr isEqualToString:@"1"]) {
                [SVProgressHUD showInfoWithStatus:@"账号或密码错误!"];
                [landBtn ErrorRevertAnimationCompletion:^{
                    
                }];
                return;
            }else{
                
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                
                //保存默认用户
                
#pragma mark - 数据库 存储 登录 信息----------------------------------------
                NSDictionary *dic = [dict objectForKey:@"data"];
//                NSLog(@"%@",dic);
                
                NSString *account = [dic objectForKey:@"account"];
                NSString *login_times = [dic objectForKey:@"login_times"];
                NSString *nickname = [dic objectForKey:@"nickname"];
                NSString *token = [dic objectForKey:@"token"];
                NSString *user_type = [dic objectForKey:@"user_type"];
                NSString *user_head_img = [dic objectForKey:@"user_head_img"];
                
                NSString *user_id = [dic objectForKey:@"user_id"];
                NSString *xid = [dic objectForKey:@"xid"];
                [XXEUserInfo user].login = YES;
                
//                NSLog(@"fffff  ===  account:%@ ,login_times:%@ ,nickname:%@ token:%@ ,user_head_img:%@ ,user_id:%@ xid:%@ ,user_type:%@",account,login_times,nickname,token,user_head_img,user_id,xid,user_type);
                
                NSDictionary *userInfo = @{@"account":account,
                                           @"login_times":login_times,
                                           @"nickname":nickname,
                                           @"token":token,
                                           @"user_head_img":user_head_img,
                                           @"loginStatus":[NSNumber numberWithBool:YES],
                                           //                                    @"qqNumner":account,
                                           @"user_id":user_id,
                                           @"xid":xid
                                           };
                [[XXEUserInfo user] setupUserInfoWithUserInfo:userInfo];
            
//                NSLog(@"-------token:%@",[XXEUserInfo user].user_id);
                [landBtn ExitAnimationCompletion:^{
                  [self LoginButton];
                }];
            }
          
        }];
       
    }
}



//- (void)loginRequestWithParameters:(NSDictionary *)parameters  {
//    [[ServiceManager sharedInstance] requestWithURLString:LoginUrl parameters:parameters type:HttpRequestTypePost success:^(id responseObject) {
//        //                NSLog(@"%@",request.responseJSONObject);
//        NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
//        NSString *code = [request.responseJSONObject objectForKey:@"code"];
//        NSLog(@"错误信息是什么%@",[request.responseJSONObject objectForKey:@"msg"]);
//        if ([code intValue]==1) {
//            [self LoginSetupUserInfoDict:data SnsAccessToken:@"" LoginType:self.login_type];
//            NSString *login_times = [data objectForKey:@"login_times"];
//            
//            if ([login_times intValue]==1) {
//                NSLog(@"进入信息补全");
//                XXEPerfectInfoViewController *perfecVC = [[XXEPerfectInfoViewController alloc]init];
//                XXENavigationViewController *navi = [[XXENavigationViewController alloc]initWithRootViewController:perfecVC];
//                UIWindow *window = [UIApplication sharedApplication].keyWindow;
//                window.rootViewController = navi;
//                [self.view removeFromSuperview];
//                
//                
//            }else{
//                
//                [_loginButton ExitAnimationCompletion:^{
//                    //                        NSLog(@"111---点击登录按钮-------");
//                    
//                    XXETabBarControllerConfig *tabBarControllerConfig = [[XXETabBarControllerConfig alloc]init];
//                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//                    window.rootViewController = tabBarControllerConfig;
//                    [self.view removeFromSuperview];
//                    
//                }];
//            }
//        }else if([code intValue]==3)
//        {
//            [self showString:@"你的密码错误" forSecond:1.f];
//            [_loginButton ErrorRevertAnimationCompletion:^{
//                NSString *stringMsg = [request.responseJSONObject objectForKey:@"msg"];
//                [self showHudWithString:stringMsg forSecond:2.f];
//            }];
//        }else{
//            
//            [self showString:@"登录失败" forSecond:1.f];
//        }
//        
//    } failure:^(NSError *error) {
//        
//        [_loginButton ErrorRevertAnimationCompletion:^{
//            
//            [self showHudWithString:@"网络请求失败" forSecond:2.f];
//        }];
//        
//    }];
//}

- (void)thirdLoginRequestWithParameters:(NSDictionary *)parameters {
    //微博第三方蹦是因为没有审核通过没有unionId 为空
    [[ServiceManager sharedInstance] requestWithURLString:LoginUrl parameters:parameters type:HttpRequestTypePost success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        
        NSLog(@"%@",[responseObject objectForKey:@"msg"]);
        NSString *code = [responseObject objectForKey:@"code"];
        if ([code intValue] == 1) {
            //存储数据直接进入首页
            [SVProgressHUD showSuccessWithStatus:@"正在登录"];
//            [self showHudWithString:@"正在登录" forSecond:2.f];
            NSDictionary *data = [responseObject objectForKey:@"data"];
            NSString * logintimes = [data objectForKey:@"login_times"];
            [self LoginSetupUserInfoDict:data SnsAccessToken:parameters[@"account"] LoginType:_login_type];
            NSLog(@"%@",logintimes);
            if ([logintimes integerValue]==1 ) {
//                SchoolInfoViewController *schoolInfoVC = [[SchoolInfoViewController alloc] init];
//                XXENavigationViewController *navi = [[XXENavigationViewController alloc]initWithRootViewController:schoolInfoVC];
//                UIWindow *window = [UIApplication sharedApplication].keyWindow;
//                window.rootViewController = navi;
//                [self.view removeFromSuperview];
            
            //ClassEditViewController
            ClassEditViewController *classEditVC = [[ClassEditViewController alloc] init];
            [self presentViewController:classEditVC animated:YES completion:nil];
//            classEditVC.fromPerfectInfo = @"fromPerfectInfo";
//            XXENavigationViewController *navi = [[XXENavigationViewController alloc]initWithRootViewController:classEditVC];
//            UIWindow *window = [UIApplication sharedApplication].keyWindow;
//            window.rootViewController = navi;
//            [self.view removeFromSuperview];

            }else{

                XXETabBarViewController *tabBarControllerConfig = [[XXETabBarViewController alloc]init];
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                window.rootViewController = tabBarControllerConfig;
                [self.view removeFromSuperview];

            }
        
        }else{
            //进入注册的第三个
            SettingPersonInfoViewController *settingVC = [[SettingPersonInfoViewController alloc]init];
            settingVC.phone = @"";
            settingVC.pwd = @"";
            settingVC.nickName = self.thirdNickName;
            settingVC.t_head_img = self.thirdHeadImage;
            settingVC.login_type = _login_type;
            settingVC.QQToken = self.qqLoginToken;
            settingVC.weixinToken = self.weixinLoginToken;
            settingVC.sinaToken = self.sinaLoginToken;
            settingVC.whereFromController = @"loginVC";
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:settingVC];
            UIColor *color = [UIColor whiteColor];
            NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
            navi.navigationBar.titleTextAttributes = dict;
            //
            [self presentViewController:navi animated:true completion:nil];
            //            [self.navigationController pushViewController:navi animated:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)LoginSetupUserInfoDict:(NSDictionary *)data SnsAccessToken:(NSString *)accessToken LoginType:(NSString *)logintype
{
    NSString *phone = [NSString stringWithFormat:@"%@", [data objectForKey:@"phone"]];
    NSString *login_times = [data objectForKey:@"login_times"];
    NSString *nickname = [data objectForKey:@"nickname"];
    NSString *token = [data objectForKey:@"token"];
    NSString *user_head_img = [data objectForKey:@"user_head_img"];
    NSString *user_id = [data objectForKey:@"user_id"];
    NSString *user_type = [data objectForKey:@"user_type"];
    NSString *xid = [data objectForKey:@"xid"];
    NSString *login_type = logintype;
    
    NSLog(@"登录次数%@ 昵称%@ token%@ 用头像%@ 用户Id%@ 用户类型%@ XID%@ ",login_times,nickname,token,user_head_img, user_id, user_type,xid);
    
    if ([logintype  isEqualToString: @"1"]) {
        [XXEUserInfo user].login = YES;
    }else if ([logintype isEqualToString:@"2"]){
        self.qqLoginToken = accessToken;
        [XXEUserInfo user].login = YES;
    }else if ([logintype isEqualToString:@"3"]){
        self.weixinLoginToken = accessToken;
        [XXEUserInfo user].login = YES;
    }else if ([logintype isEqualToString:@"4"]){
        self.sinaLoginToken = accessToken;
        [XXEUserInfo user].login = YES;
    }else if ([logintype isEqualToString:@"5"]){
        self.aliPayLoginToken = accessToken;
        [XXEUserInfo user].login = YES;
    }else if ([logintype isEqualToString:@"10"]){
        [XXEUserInfo user].login = NO;
    }
    NSDictionary *userInfo = @{
                               //                               @"account":
                               @"phone": phone,
                               @"login_times":login_times,
                               @"nickname":nickname,
                               @"token":token,
                               @"qqNumberToken":self.qqLoginToken,
                               @"weixinToken":self.weixinLoginToken,
                               @"sinaNumberToken":self.sinaLoginToken,
                               @"zhifubaoToken":self.aliPayLoginToken,
                               @"login_type":login_type,
                               @"user_head_img":user_head_img,
                               @"user_id":user_id,
                               @"user_type":user_type,
                               @"xid":xid,
                               @"loginStatus":[NSNumber numberWithBool:[XXEUserInfo user].login]
                               };
    NSLog(@"%@",userInfo);
    [[XXEUserInfo user] setupUserInfoWithUserInfo:userInfo];
}

- (void)LoginButton{

    
    if ([[XXEUserInfo user].login_times integerValue] == 1){
        ClassEditViewController *classEditVC = [[ClassEditViewController alloc] init];
        classEditVC.fromPerfectInfo = @"fromPerfectInfo";
        [self.navigationController pushViewController:classEditVC animated:YES];

    
    }else{
        XXETabBarViewController *tabBarControllerConfig = [[XXETabBarViewController alloc]init];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = tabBarControllerConfig;
        [self.view removeFromSuperview];
    }

}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    
    return [[HyTransitions alloc]initWithTransitionDuration:0.4f StartingAlpha:0.5f isBOOL:true];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    
    return [[HyTransitions alloc]initWithTransitionDuration:0.4f StartingAlpha:0.8f isBOOL:false];
    
}

@end

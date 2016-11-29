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
//#import "SchoolInfoViewController.h"
#import "HHControl.h"
#import "MyTabBarController.h"
#import <CoreLocation/CoreLocation.h>
#import "XXETabBarViewController.h"
#import "ClassEditViewController.h"


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
    landBtn.titleLabel.font = [UIFont systemFontOfSize:18];
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
    newUserBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [View addSubview:newUserBtn];

    //访客模式Button
    visitorsBtn = [HHControl createButtonWithFrame:CGRectMake( spaceWidth * 2 + buttonWidth ,buttonY, buttonWidth, 30) backGruondImageName:nil Target:self Action:@selector(onClickvisitorsBtn:) Title:@"访客登陆"];
    [visitorsBtn setTitleColor:UIColorFromRGB(0, 170, 42) forState:UIControlStateNormal];
    visitorsBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [View addSubview:visitorsBtn];
    
    //找回密码BUTTOn
    forgotPwdBtn = [HHControl createButtonWithFrame:CGRectMake(spaceWidth * 3 + buttonWidth * 2, buttonY, buttonWidth, 30) backGruondImageName:nil Target:self Action:@selector(fogetPwd) Title:@"忘记密码?"];
    [forgotPwdBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    forgotPwdBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
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

 
#pragma Mark ***************第三方登录***********
    CGFloat btnW = 50 * kWidth / 375;
    CGFloat btnH = btnW;
    
    CGFloat btnX1 = 20 + ((kWidth - 40) / 3 - btnW) / 2;
    CGFloat btnX2 = btnX1 + (kWidth - 40) / 3;
    CGFloat btnX3 = btnX2 + (kWidth - 40) / 3;
    
    //QQ
    QQBtn = [HHControl createButtonWithFrame:CGRectMake(btnX1, kHeight - 100, btnW, btnH) backGruondImageName:@"扣扣" Target:self Action:@selector(onClickQQ:) Title:nil];
    
    QQBtn.layer.cornerRadius = QQBtn.frame.size.width / 2;
    QQBtn.layer.masksToBounds =YES;
    [View addSubview:QQBtn];
  
    //微信
    weixinBtn = [HHControl createButtonWithFrame:CGRectMake(btnX2, QQBtn.frame.origin.y, btnW, btnH) backGruondImageName:@"微信" Target:self Action:@selector(onClickWX:) Title:nil];
    
    weixinBtn.layer.cornerRadius= weixinBtn.frame.size.width / 2;
    weixinBtn.layer.masksToBounds =YES;
    [View addSubview:weixinBtn];
    
    //新浪
    xinlangBtn = [HHControl createButtonWithFrame:CGRectMake(btnX3, weixinBtn.frame.origin.y, btnW, btnH) backGruondImageName:@"微博" Target:self Action:@selector(onClickSina:) Title:nil];
    xinlangBtn.layer.cornerRadius = xinlangBtn.frame.size.width / 2;
    xinlangBtn.layer.masksToBounds =YES;
    [View addSubview:xinlangBtn];
   
//    //支付宝
//    zhifubaoBtn = [HHControl createButtonWithFrame:CGRectMake(xinlangBtn.frame.origin.x + xinlangBtn.frame.size.width + 25 * kWidth / 375, xinlangBtn.frame.origin.y, 50 * kWidth / 375, 50 * kWidth / 375) backGruondImageName:@"支付宝" Target:self Action:@selector(onClickzhifubao:) Title:nil];
//    zhifubaoBtn.layer.cornerRadius = zhifubaoBtn.frame.size.width / 2;
//    zhifubaoBtn.layer.masksToBounds =YES;
//    [View addSubview:zhifubaoBtn];

    
}



- (void)registration{
    AuthenticationViewController *registerVC=[[AuthenticationViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
    
}

- (void)onClickQQ:(UIButton *)button
{
    //qq
    NSLog(@"click qq");
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
       //  创建一个Url : 请求路径
            NSURL *url =[NSURL URLWithString:LoginUrl];
        //创建一个请求
            NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
            request.HTTPMethod =@"POST";
            request.timeoutInterval =10;
            //设置请求体
            NSString *param =[NSString stringWithFormat:@"appkey=%@&backtype=%@&login_type=%d&nickname=%@&t_head_img=%@&qq=%@",@"U3k8Dgj7e934bh5Y",@"json",2,user.nickname, user.rawData[@"figureurl_qq_2"],user.uid];
    //NSString-->NSData
            request.HTTPBody =[param dataUsingEncoding:NSUTF8StringEncoding];
            
            NSOperationQueue *queue =[NSOperationQueue mainQueue];
            [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                if (connectionError ||data ==nil) {
                    return ;
                }
                NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                if ([dict[@"msg"] isEqualToString:@"Error!账号或密码错误!"]) {
                    [SVProgressHUD showInfoWithStatus:@"账号或密码错误!"];
                
                }
                else if ([dict[@"msg"] isEqualToString:@"Success!登陆成功!"])
                {
            if ([[NSString stringWithFormat:@"%@",dict[@"code"]]  isEqualToString:@"1"]) {
                
                if ([[dict[@"data"] objectForKey:@"login_times"] integerValue]==1) {
                    //跳转到注册
                    NSLog(@"跳转到注册");
                    SettingPersonInfoViewController *settPersonVC =[[SettingPersonInfoViewController alloc]init];
                    settPersonVC.phone =@"15201938305";
                    settPersonVC.pwd =@"123456";
                  
        [self.navigationController pushViewController:settPersonVC animated:YES];

                }else{
                    
                    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                    XXETabBarViewController *myTableVC =[[XXETabBarViewController alloc]init];
                    [self presentViewController:myTableVC animated:YES completion:nil];
                
                }
                
                
    
        }
                    else{
                    
                        
                        [SVProgressHUD showSuccessWithStatus:@"登录失败"];
                        
                      
                    }
                    
                    
                }

            }];
         
        }
        else
        {
            [SVProgressHUD showInfoWithStatus:@"链接错误!"];
        }
        
    }];
    
}

- (void)onClickWX:(UIButton *)button
{
    NSLog(@"click wx");
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
       
           if (state == SSDKResponseStateSuccess)
    {
           
             //  创建一个Url : 请求路径
             NSURL *url =[NSURL URLWithString:LoginUrl];
             //创建一个请求
             NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
             request.HTTPMethod =@"POST";
             request.timeoutInterval =10;
             //设置请求体
             NSString *param =[NSString stringWithFormat:@"appkey=%@&backtype=%@&login_type=%d&nickname=%@&t_head_img=%@&qq=%@",@"U3k8Dgj7e934bh5Y",@"json",3,user.nickname, user.rawData[@"headimgurl"],user.uid];
             //NSString-->NSData
             request.HTTPBody =[param dataUsingEncoding:NSUTF8StringEncoding];
             
             NSOperationQueue *queue =[NSOperationQueue mainQueue];
             [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            
                 if (connectionError ||data ==nil) {
                 return ;
                                 }
             NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
             
             if ([dict[@"msg"] isEqualToString:@"Error!账号或密码错误!"]) {
             [SVProgressHUD showInfoWithStatus:@"账号或密码错误!"];
             
             }
             else if ([dict[@"msg"] isEqualToString:@"Success!登陆成功!"])
             {
                if ([[NSString stringWithFormat:@"%@",dict[@"code"]]  isEqualToString:@"1"]) {
                    
                    if ([[dict[@"data"] objectForKey:@"login_times"] integerValue]==1) {
                        //跳转到注册
                        NSLog(@"跳转到注册");
                        SettingPersonInfoViewController *settPersonVC =[[SettingPersonInfoViewController alloc]init];
                        settPersonVC.phone =@"15201938305";
                        settPersonVC.pwd =@"123456";
                        //                        settPersonVC.qqString =@"qq";
                        //                        settPersonVC.qqImge =user.rawData[@"figureurl_qq_2"];
                        //                        settPersonVC.qqNickName =user.nickname;
                        //                        settPersonVC.qqUid =user.uid;
                        [self.navigationController pushViewController:settPersonVC animated:YES];
                        
                    }else{
                        
                        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                        XXETabBarViewController *myTableVC =[[XXETabBarViewController alloc]init];
                        [self presentViewController:myTableVC animated:YES completion:nil];
                        
                    }
                    

             
                    
                                                                   }
               else{
             
             
             [SVProgressHUD showSuccessWithStatus:@"登录失败"];
             
                                 }
             
             
             }
             
             }];
 
        }
  else
          {
            [SVProgressHUD showInfoWithStatus:@"链接错误!"];
          }
        
    }];
}


- (void)onClickSina:(UIButton *)button
{
    
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess) {

            //  创建一个Url : 请求路径
            NSURL *url =[NSURL URLWithString:LoginUrl];
            //创建一个请求
            NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
            request.HTTPMethod =@"POST";
            request.timeoutInterval =10;
            //设置请求体
//            NSLog(@"uid=%@",user.uid);
//            NSLog(@"user.rawData=%@",user.rawData[@"profile_image_url"]);
//            NSLog(@"nickname=%@",user.nickname);
            NSString *param =[NSString stringWithFormat:@"appkey=%@&backtype=%@&login_type=%d&nickname=%@&t_head_img=%@&qq=%@",@"U3k8Dgj7e934bh5Y",@"json",4,user.nickname, user.rawData[@"profile_image_url"],user.uid];
            //NSString-->NSData
            request.HTTPBody =[param dataUsingEncoding:NSUTF8StringEncoding];
            
            NSOperationQueue *queue =[NSOperationQueue mainQueue];
            [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                
                if (connectionError ||data ==nil) {
                    return ;
                }
                NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"%@",dict);
                
                if ([dict[@"msg"] isEqualToString:@"Error!账号或密码错误!"]) {
                    [SVProgressHUD showInfoWithStatus:@"账号或密码错误!"];
                    
                }
                else if ([dict[@"msg"] isEqualToString:@"Success!登陆成功!"])
                {
        if ([[NSString stringWithFormat:@"%@",dict[@"code"]]  isEqualToString:@"1"]) {
                        
            if ([[dict[@"data"] objectForKey:@"login_times"] integerValue]==1) {
                //跳转到注册
                NSLog(@"跳转到注册");
                SettingPersonInfoViewController *settPersonVC =[[SettingPersonInfoViewController alloc]init];
                settPersonVC.phone =@"15201938305";
                settPersonVC.pwd =@"123456";
                //                        settPersonVC.qqString =@"qq";
                //                        settPersonVC.qqImge =user.rawData[@"figureurl_qq_2"];
                //                        settPersonVC.qqNickName =user.nickname;
                //                        settPersonVC.qqUid =user.uid;
                [self.navigationController pushViewController:settPersonVC animated:YES];
                
            }else{
                
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                XXETabBarViewController *myTableVC =[[XXETabBarViewController alloc]init];
                [self presentViewController:myTableVC animated:YES completion:nil];
                
            }
            
                    }
                    else{
                        
                        [SVProgressHUD showSuccessWithStatus:@"登录失败"];
                        
                        
                    }
                    
                    
                }
                
            }];
  
        }
        else
        {
            [SVProgressHUD showInfoWithStatus:@"链接错误!"];
        }
        
    }];
}

#pragma mark =======  支付宝 登录 ==============
//- (void)onClickzhifubao:(UIButton*)button{
////支付宝
//
//    
//}
//访客
-(void)onClickvisitorsBtn:(UIButton *)button
{
    
//    HomepageViewController*forVC= [[HomepageViewController alloc]init];
    XXETabBarViewController *myTableVC =[[XXETabBarViewController alloc]init];
    [self presentViewController:myTableVC animated:YES completion:nil];
}

-(void)registration:(UIButton *)button
{
    AuthenticationViewController *registerVC=[[AuthenticationViewController alloc]init];
    //    UINavigationController *navi=[[UINavigationController alloc]initWithRootViewController:registerVC];
    [self.navigationController pushViewController:registerVC animated:YES];

    
}
-(void)fogetPwd{
    ForgetPassWordViewController * forVC=[[ForgetPassWordViewController alloc]init];
    [self.navigationController pushViewController:forVC animated:YES];
}




//登录
-(void)landClick
{
    typeof(self) __weak weak =self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weak LoginView];
    });
}

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

- (void)LoginButton{
    
//    SchoolInfoViewController * passWordResetVC = [[SchoolInfoViewController alloc]init];
//    passWordResetVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    passWordResetVC.transitioningDelegate = self;
//    NSLog(@"登录 次数 -- %@", [XXEUserInfo user].login_times);
//    if ([[XXEUserInfo user].login_times integerValue] == 1) {
//        [self.navigationController pushViewController:passWordResetVC animated:YES];
//    }else{
//        XXETabBarViewController *myTableVC =[[XXETabBarViewController alloc]init];
//        [self presentViewController:myTableVC animated:YES completion:nil];
//    }
//    BOOL isNotFirstLauch = [[NSUserDefaults standardUserDefaults] boolForKey:@"isNotFirstL"];
//    if (isNotFirstLauch) {
//        /*
//         判断第一次登录
//         */
//        XXETabBarViewController *myTableVC =[[XXETabBarViewController alloc]init];
//        [self presentViewController:myTableVC animated:YES completion:nil];
//    }
//    else{
//        isNotFirstLauch = !isNotFirstLauch;
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isNotFirstL"];
//        
//        [self.navigationController pushViewController:passWordResetVC animated:YES];
//    }
    ClassEditViewController *classEditVC = [[ClassEditViewController alloc] init];
        classEditVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        classEditVC.transitioningDelegate = self;
    
        NSLog(@"登录 次数 -- %@", [XXEUserInfo user].login_times);
    if ([[XXEUserInfo user].login_times integerValue] == 1) {
//            [self.navigationController pushViewController:classEditVC animated:YES];
        [self presentViewController:classEditVC animated:YES completion:nil];
        }else{
        XXETabBarViewController *myTableVC =[[XXETabBarViewController alloc]init];
            [self presentViewController:myTableVC animated:YES completion:nil];
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

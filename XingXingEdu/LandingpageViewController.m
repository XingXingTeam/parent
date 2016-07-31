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
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden =YES;
}
- (void)viewWillDisappear:(BOOL)animated{
self.navigationController.navigationBarHidden =NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingLocation];
    
//    CLLocationManager *mgr =[[CLLocationManager alloc]init];
//     mgr.delegate =self;
//    [mgr startUpdatingLocation];
//    
//    if ([CLLocationManager locationServicesEnabled]) {
//        self.Im =[[CLLocationManager alloc]init];
//        self.Im.delegate =self;
//        // 最小距离
//        self.Im.distanceFilter =kCLDistanceFilterNone;
//        [self.Im startUpdatingLocation];
//    }
//    else{
//        NSLog(@"定位服务不可利用");
//    }
    
    //设置NavigationBar颜色
    View = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //背景图片
    View.userInteractionEnabled = YES;
    View.backgroundColor =UIColorFromRGB(229, 232, 233);
    [self.view addSubview:View];
    //头像  圆形 直径 100
//    UserImage = [[UIImageView alloc]init];

    UserImage = [[UIImageView alloc] initWithFrame:CGRectMake((kWidth - 100) / 2, 100 * kWidth / 375, 100 * kWidth / 375, 100 * kWidth / 375)];
    UserImage.layer.cornerRadius = UserImage.frame.size.width / 2;
    UserImage.layer.masksToBounds =  YES;
    
    //RCUserPortraitUri
//    [DEFAULTS setObject:[NSString stringWithFormat:@"%@", dict[@"data"][@"user_head_img"]] forKey:@"RCUserPortraitUri"];
    _lastTimeLoginHeadPicStr = [DEFAULTS objectForKey:@"RCUserPortraitUri"];
    
    //账号 即手机号
//    [DEFAULTS setObject:[NSString stringWithFormat:@"%@", dict[@"data"][@"account"]] forKey:@"account"];
    _lastTimeLoginAccountStr = [DEFAULTS objectForKey:@"account"];
    
    [UserImage sd_setImageWithURL:[NSURL URLWithString:_lastTimeLoginHeadPicStr] placeholderImage:[UIImage imageNamed:@"img"]];

    [self.view addSubview:UserImage];
    //头像约束
//    [UserImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(kWidth*(kWidth - 100) / 2/375);
//        make.top.mas_equalTo(kHeight*150/667);
//        make.right.mas_equalTo(-kWidth*100/375);
//        make.bottom.mas_equalTo(-kHeight*100/667);
//        
//    }];
   
    [self createImageViews];
    [self createTextFields];
    
}


#pragma mark - 设置手机 自动定位=====================================

- (void)settingLocation{
    
    //    CLLocationManager *mgr =[[CLLocationManager alloc]init];
    //    mgr.delegate =self;
    //    [mgr startUpdatingLocation];
    _locationManager = [[CLLocationManager alloc] init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        
        [SVProgressHUD showInfoWithStatus:@"定位服务当前可能尚未打开，请设置打开！"];
        
        NSLog(@"定位服务不可利用");
        
    }
    
    //如果没有授权，则请求用户授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        
        [_locationManager requestWhenInUseAuthorization];
        
    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
        //设置代理
        _locationManager.delegate = self;
        //设置定位精度
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        //一米定位一次  频率
        CLLocationDistance distance = 0.1;
        
        //开启定位
        [_locationManager startUpdatingLocation];
    }
    
    
}


#pragma mark ------获得最新位置信息

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *location =[locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;//位置坐标
    
    //    NSLog(@"经度 %f;   纬度 %f ", coordinate.latitude, coordinate.longitude);
    
    longitudeKT = [NSString stringWithFormat:@"%lf", coordinate.longitude];
    latitudeKT=[NSString stringWithFormat:@"%lf",coordinate.latitude];
    
    //        NSLog(@"经度 == %@； 维度 == %@ ", longitudeKT, latitudeKT);
    
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}




//第三方账号快速登陆
-(void)createLabel
{
    //位置
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-140)/2, 460, 140, 21)];
    label.text = @"使用其他账号登陆";
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:label];
    [label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(visitorsBtn.mas_bottom).offset(kHeight*52/kHeight);
        make.centerX.equalTo(visitorsBtn.mas_centerX).offset(0);
        make.size.mas_equalTo(CGSizeMake(kWidth*140/375, kHeight*21/667));
        
    }];
    
   
    UIImageView *line3=[self createImageViewFrame:CGRectMake(20, 460, 100, 1) imageName:nil color:UIColorFromRGB(214, 216, 216)];
    UIImageView *line4=[self createImageViewFrame:CGRectMake(self.view.frame.size.width-100-20, 460, 100, 1) imageName:nil color:UIColorFromRGB(214, 216, 216)];
    
    
    [self.view addSubview:line3];
    [self.view addSubview:line4];
    
    [line3 mas_remakeConstraints:^(MASConstraintMaker *make) {
      
        make.left.mas_equalTo(kWidth*20/375);
        make.right.equalTo(label.mas_left).offset(-10);
        make.height.mas_equalTo(1);
        make.centerY.equalTo(label.mas_centerY).offset(0);
        
    }];
    [line4 mas_remakeConstraints:^(MASConstraintMaker *make) {
   
        make.right.mas_equalTo(-kWidth*20/375);
        make.left.equalTo(label.mas_right).offset(10);
        make.height.mas_equalTo(1);
        make.centerY.equalTo(label.mas_centerY).offset(0);
        
        
    }];
    
    /**
     *   ***************第三方登录***********
     */
#define Start_X 60.0f           // 第一个按钮的X坐标
#define Start_Y 440.0f           // 第一个按钮的Y坐标
#define Width_Space 50.0f        // 2个按钮之间的横间距
#define Height_Space 20.0f      // 竖间距
#define Button_Height 50.0f    // 高
#define Button_Width 50.0f      // 宽
    
    //微信
    weixinBtn=[[UIButton alloc]initWithFrame:CGRectMake(120, 530, 50, 50)];
    weixinBtn=[self createButtonFrame:weixinBtn.frame backImageName:@"微信" title:nil titleColor:nil font:nil target:self action:@selector(onClickWX:)];
    weixinBtn.layer.cornerRadius=kWidth*25/375;
    weixinBtn.layer.masksToBounds =YES;
    [View addSubview:weixinBtn];
    
    [weixinBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(kHeight*42/667);
        make.right.equalTo(landBtn.mas_centerX).offset(-kWidth*12/375);
        make.size.mas_equalTo(CGSizeMake(kWidth*50/375,kHeight*50/667));
        
    }];
    
    
    //qq
    QQBtn=[[UIButton alloc]initWithFrame:CGRectMake(40, 530, 50, 50)];
    QQBtn=[self createButtonFrame:QQBtn.frame backImageName:@"扣扣" title:nil titleColor:nil font:nil target:self action:@selector(onClickQQ:)];
    QQBtn.layer.cornerRadius=kWidth*25/375;
    QQBtn.layer.masksToBounds =YES;
    [View addSubview:QQBtn];
    [QQBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(kHeight*42/667);
        make.right.equalTo(weixinBtn.mas_left).offset(-kWidth*25/375);
        make.size.mas_equalTo(CGSizeMake(kWidth*50/375,kHeight*50/667));
        
        
    }];
    
    //新浪微博
    xinlangBtn=[[UIButton alloc]initWithFrame:CGRectMake(200, 530, 50, 50)];
    xinlangBtn=[self createButtonFrame:xinlangBtn.frame backImageName:@"微博" title:nil titleColor:nil font:nil target:self action:@selector(onClickSina:)];
    xinlangBtn.layer.cornerRadius=kWidth*25/375;
    xinlangBtn.layer.masksToBounds =YES;
    [View addSubview:xinlangBtn];
    
    [xinlangBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(kHeight*42/667);
        make.left.equalTo(landBtn.mas_centerX).offset(kWidth*12/375);
        make.size.mas_equalTo(CGSizeMake(kWidth*50/375,kHeight*50/667));
        
    }];
    
    //支付宝
    zhifubaoBtn=[self createButtonFrame:CGRectMake(280, 530, 50, 50) backImageName:@"支付宝" title:nil titleColor:nil font:nil target:self action:@selector(onClickzhifubao:)];
    zhifubaoBtn.layer.cornerRadius=kWidth*25/375;
    zhifubaoBtn.layer.masksToBounds =YES;
    [View addSubview:zhifubaoBtn];
    
    [zhifubaoBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(kHeight*42/667);
        make.left.equalTo(xinlangBtn.mas_right).offset(kWidth*25/375);
        make.size.mas_equalTo(CGSizeMake(kWidth*50/375,kHeight*50/667));
        
    }];
 
    
    
    
    
    
}
//上方用户登录填写
-(void)createTextFields
{
    UIImageView *imVA =[[UIImageView alloc]initWithFrame:CGRectMake(60, 215, 33, 36)];
    UIImageView *imagViA =[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 22, 24)];
    imagViA.image =[UIImage imageNamed:@"账号"];
    [imVA addSubview:imagViA];
    
    user =[HHControl createTextFieldWithFrame:CGRectMake(20, 215, kWidth-40, 40) placeholder:@" 手机" passWord:NO leftImageView:imVA rightImageView:nil Font:15];
    
    user.text = _lastTimeLoginAccountStr;
    
       [self.view addSubview:user];
    [user mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidth*20/375);
        make.right.mas_equalTo(-kWidth*20/375);
        make.top.equalTo(UserImage.mas_bottom).offset(kWidth*18/375);
        make.height.mas_equalTo(40);
    
    }];
    
   
    //加线
//    UIImageView *lin1=[self createImageViewFrame:CGRectMake(40, 255, kWidth-75, 1) imageName:nil color:UIColorFromRGB(222, 225, 226)];
//    [self.view addSubview:lin1];
  
    
    
    
    user.backgroundColor =[UIColor whiteColor];
    //user.alpha =0.7;
    user.layer.cornerRadius =20;
    user.layer.masksToBounds =YES;
    user.keyboardType=UIKeyboardTypeNumberPad;
    user.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [user addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingChanged];
   
    //密码44x48
    UIImageView *imV =[[UIImageView alloc]initWithFrame:CGRectMake(60, 215, 33, 36)];
    
    UIImageView *imagVi =[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 22, 24)];
    imagVi.image =[UIImage imageNamed:@"密码"];
    [imV addSubview:imagVi];

 
    pwd =[HHControl createTextFieldWithFrame:CGRectMake(20, 270, kWidth-40, 40) placeholder:@" 密码" passWord:YES leftImageView:imV rightImageView:nil Font:15];
      [self.view addSubview:pwd];
    
    //加线
//    UIImageView *lin2=[self createImageViewFrame:CGRectMake(40, 310, kWidth-75, 1) imageName:nil color:UIColorFromRGB(222, 225, 226)];
//    [self.view addSubview:lin2];
    pwd.backgroundColor =[UIColor whiteColor];
    pwd.layer.cornerRadius =20;
    pwd.layer.masksToBounds =YES;
    pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    pwd.clearButtonMode = NO;
    //密文样式
    pwd.secureTextEntry=YES;
    [pwd mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidth*20/375);
        make.right.mas_equalTo(-kWidth*20/375);
        make.top.equalTo(user.mas_bottom).offset(kWidth*14/375);
        make.height.mas_equalTo(40);
        
    }];
    //眼睛
    eyeBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-68, 8, 25, 25)];
    //weixinBtn.tag = UMSocialSnsTypeWechatSession;
    eyeBtn.layer.cornerRadius=25;
    eyeBtn=[self createButtonFrame:eyeBtn.frame backImageName:@"脚丫" title:nil titleColor:nil font:nil target:self action:@selector(onClickeye:)];
    [eyeBtn setImage:[UIImage imageNamed:@"脚丫H"] forState:UIControlStateHighlighted];
        [pwd addSubview:eyeBtn];
    [eyeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(pwd.mas_top).offset(8);
        make.right.equalTo(pwd.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(25, 25));
        
    }];
    
    
 
     [self createButtons];
    
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
-(void)createImageViews
{
    
    
  
    
}


-(void)createButtons
{
    //登陆Button
    //位置
    landBtn = [[HyLoglnButton alloc]initWithFrame:CGRectMake(20, 330, kWidth-40, 40)];
    [landBtn setTitle:@"登    录" forState:UIControlStateNormal];
    [landBtn addTarget:self action:@selector(landClick) forControlEvents:UIControlEventTouchUpInside];
    landBtn.backgroundColor = UIColorFromRGB(0, 170, 42);
    landBtn.titleLabel.font = [UIFont systemFontOfSize:19];
    [landBtn setTintColor:[UIColor whiteColor]];
    landBtn.layer.cornerRadius = 20.0f;
    [View addSubview:landBtn];
    
    [landBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidth*20/375);
        make.right.mas_equalTo(-kWidth*20/375);
        make.top.equalTo(pwd.mas_bottom).offset(kWidth*18/375);
        make.height.mas_equalTo(kHeight*40/667);

    }];
    
    
    
    
    //访客模式Button
    visitorsBtn=[self createButtonFrame:CGRectMake(150,380, 70, 30) backImageName:nil title:@"访客登陆" titleColor:UIColorFromRGB(0, 170, 42) font:[UIFont systemFontOfSize:13] target:self action:@selector(onClickvisitorsBtn:)];
    [View addSubview:visitorsBtn];
    
    //添加约束
    [visitorsBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(landBtn.mas_bottom).offset(kHeight*18/667);
        make.centerX.mas_equalTo(landBtn.mas_centerX).offset(0);
        make.size.mas_equalTo(CGSizeMake(kWidth*70/375,kHeight*30/667));
    }];
    
    //免费注册BUTTOn
    //位置
     newUserBtn=[self createButtonFrame:CGRectMake(70, 380, 70, 30) backImageName:nil title:@"免费注册" titleColor:[UIColor grayColor] font:[UIFont systemFontOfSize:13] target:self action:@selector(registration:)];
     [View addSubview:newUserBtn];
    
    //约束
     [newUserBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
         make.right.equalTo(visitorsBtn.mas_left).offset(-kWidth*56/375);
         make.top.equalTo(landBtn.mas_bottom).offset(kHeight*18/667);
         make.size.mas_equalTo(CGSizeMake(kWidth*70/375,kHeight*30/667));
        
     }];
    
    //找回密码BUTTOn
   forgotPwdBtn=[self createButtonFrame:CGRectMake(self.view.frame.size.width-130, 380, 60, 30) backImageName:nil title:@"忘记密码?" titleColor:[UIColor grayColor] font:[UIFont systemFontOfSize:13] target:self action:@selector(fogetPwd)];
     [View addSubview:forgotPwdBtn];
    
    [forgotPwdBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(visitorsBtn.mas_right).offset(kWidth*56/375);
        make.top.equalTo(landBtn.mas_bottom).offset(kHeight*18/667);
        make.size.mas_equalTo(CGSizeMake(kWidth*70/375,kHeight*30/667));
        
    }];
      [self createLabel];
    
    
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
                    MyTabBarController *myTableVC =[[MyTabBarController alloc]init];
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
                        MyTabBarController *myTableVC =[[MyTabBarController alloc]init];
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
//            NSLog(@"uid=%@",user.uid);
//            NSLog(@"%@",user.credential);
//            NSLog(@"token=%@",user.credential.token);
//            NSLog(@"nickname=%@",user.nickname);
          
            //
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
                MyTabBarController *myTableVC =[[MyTabBarController alloc]init];
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
- (void)onClickzhifubao:(UIButton*)button{
//支付宝

    
}
//访客
-(void)onClickvisitorsBtn:(UIButton *)button
{
    
//    HomepageViewController*forVC= [[HomepageViewController alloc]init];
    MyTabBarController *myTableVC =[[MyTabBarController alloc]init];
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
        
        NSLog(@"%@ , %@",user.text,pwd.text);
        //创建一个URL :请求路径
        NSURL *url =[NSURL URLWithString:LoginUrl];
        //创建一个请求
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
        //10秒后算请求超时 (默认60s超时)
        request.timeoutInterval =10;
        request.HTTPMethod = @"POST";
        //设置请求体 @"user_lng":@"121.616636",
//    NSString *parm = [NSString stringWithFormat:@"appkey=%@&backtype=%@&login_type=%d&account=%@&pass=%@&lng=%@&lat=%@",@"U3k8Dgj7e934bh5Y",@"json",1,user.text,pwd.text,longitudeKT,latitudeKT];
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
//            NSLog(@"dict:%@",dict);
//              NSLog(@"dict:%@",dict[@"msg"]);
//           NSLog(@"dict:%@",dict[@"code"]);
          
            /*
             dict:{
             msg = Success!登陆成功!,
             data = {
             token = lJELO79GiykHxvqdSxvKcJQEwCVP7+PYbY08BpzgYl48DKZh/HyFQH3WEkDs8QQy/DibEI+T5ZwHAuk3NAfi1Hij3+TGVQ+r,
             login_times = 2,
             user_id = 2,
             user_head_img = http://www.xingxingedu.cn/Public/app_upload/text/aisi3.jpg,
             nickname = 大熊猫,
             xid = 18886064
             account = 18221082692,
             },
             code = 1
             }
             */
            
            NSString *codeStr = [NSString stringWithFormat:@"%@", dict[@"code"]];
            
            //            if ([dict[@"msg"] isEqualToString:@"Error!账号或密码错误!"]) {
            if (![codeStr isEqualToString:@"1"]) {
                [SVProgressHUD showInfoWithStatus:@"账号或密码错误!"];
                [landBtn ErrorRevertAnimationCompletion:^{
                    
                }];
                return;
            }else{
                
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                
                //保存默认用户
                
                //用户名
                //                [DEFAULTS setObject:userName forKey:@"userName"];
                //密码
                //                [DEFAULTS setObject:password forKey:@"userPwd"];
                
                //                NSLog(@" token===---/// %@", dict[@"data"][@"token"]);
                //                NSLog(@" nickname===---/// %@", dict[@"data"][@"nickname"]);
                //                NSLog(@" xid===---/// %@", dict[@"data"][@"xid"]);
                //                NSLog(@" user_head_img===---/// %@", dict[@"data"][@"user_head_img"]);
                //                NSLog(@" user_id===---/// %@", dict[@"data"][@"user_id"]);
                
                
                //RCUserToken
                [DEFAULTS setObject:[NSString stringWithFormat:@"%@", dict[@"data"][@"token"]] forKey:@"RCUserToken"];
                
                //RCUserNickName
                [DEFAULTS setObject:[NSString stringWithFormat:@"%@", dict[@"data"][@"nickname"]] forKey:@"RCUserNickName"];
                
                //RCUserId
                [DEFAULTS setObject:[NSString stringWithFormat:@"%@", dict[@"data"][@"xid"]] forKey:@"RCUserId"];
                
                //RCUserPortraitUri
                [DEFAULTS setObject:[NSString stringWithFormat:@"%@", dict[@"data"][@"user_head_img"]] forKey:@"RCUserPortraitUri"];
                
                //userId  保存 后台 自动生成的 userId
                [DEFAULTS setObject:[NSString stringWithFormat:@"%@", dict[@"data"][@"user_id"]] forKey:@"UserId"];
                
                //账号 即手机号
                [DEFAULTS setObject:[NSString stringWithFormat:@"%@", dict[@"data"][@"account"]] forKey:@"account"];
                
                
                [DEFAULTS synchronize];
                
                [landBtn ExitAnimationCompletion:^{
                  [self LoginButton];
                }];
            }
          
        }];
       
    }
}

- (void)LoginButton{
    
    SchoolInfoViewController * passWordResetVC = [[SchoolInfoViewController alloc]init];
    passWordResetVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    passWordResetVC.transitioningDelegate = self;
    BOOL isNotFirstLauch = [[NSUserDefaults standardUserDefaults] boolForKey:@"isNotFirstL"];
    if (isNotFirstLauch) {
        /*
         判断第一次登录
         */
        MyTabBarController *myTableVC =[[MyTabBarController alloc]init];
        [self presentViewController:myTableVC animated:YES completion:nil];
    }
    else{
        isNotFirstLauch = !isNotFirstLauch;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isNotFirstL"];
        
        [self.navigationController pushViewController:passWordResetVC animated:YES];
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
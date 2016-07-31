//
//  CheckInViewController.m
//  XingXingStore
//
//  Created by codeDing on 16/2/3.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "CheckInViewController.h"
#import "MoneyHistoryTableViewController.h"
#import "YSProgressView.h"

#define kLabelX 28.0f
#define kLabelW 60.0f
#define kLabelH 25.0f

@interface CheckInViewController (){
    UILabel *_dayLabel;
    UILabel *_weekLabel;
    UILabel *_moneyLabel;
    YSProgressView *ysView;
}

@end

@implementation CheckInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = UIColorFromRGB(255, 255, 255);
    
    [self netManage];
    [self createHistoryButton];
    [self createCheckInView];
    
    
}

-(void)createCheckInView {
    
    UIView *bgView = [HHControl createViewWithFrame:CGRectMake(kLabelX, kLabelX, kWidth - kLabelX *2, 80)];
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth - kLabelX *2, 80)];
    bgView.backgroundColor = [UIColor clearColor];
    [bgImgView setImage:[UIImage imageNamed:@"titter01"]];
    [bgView addSubview:bgImgView];
    [bgView sendSubviewToBack:bgImgView];
    [self.view addSubview:bgView];
    
    _dayLabel = [HHControl createLabelWithFrame:CGRectMake(kLabelX, 10, kLabelW, kLabelW) Font:14 Text:@""];
    _dayLabel.backgroundColor = UIColorFromRGB(243, 183, 77);
    _dayLabel.layer.cornerRadius= _dayLabel.bounds.size.width/2;
    _dayLabel.layer.masksToBounds=YES;
    _dayLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:_dayLabel];
    
    _weekLabel = [HHControl createLabelWithFrame:CGRectMake((CGRectGetMaxX(bgView.frame) + kLabelX)/2, kLabelX /2, kLabelW *2, kLabelH) Font:12 Text:@""];
    _weekLabel.backgroundColor = [UIColor clearColor];
    [bgView addSubview:_weekLabel];
    
    _moneyLabel = [HHControl createLabelWithFrame:CGRectMake((CGRectGetMaxX(bgView.frame) - kLabelW + kLabelX)/2,CGRectGetMaxY(_weekLabel.frame)+ 10 , 150, kLabelH) Font:12 Text:@""];
    _moneyLabel.backgroundColor = [UIColor clearColor];
    [bgView addSubview:_moneyLabel];
    
    ysView = [[YSProgressView alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(bgView.frame) + 20, kWidth - 80, 2)];
    ysView.progressHeight = 2;
    ysView.progressTintColor = UIColorFromRGB(229, 229, 229);
    ysView.trackTintColor = UIColorFromRGB(67, 181, 59);
    [self.view addSubview:ysView];
 
    UIImageView *bgRuleImgView = [[UIImageView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(ysView.frame) + kLabelX, kWidth - 50, 20)];
    bgRuleImgView.image =  [UIImage imageNamed:@"guize"];
    [self.view addSubview:bgRuleImgView];
 
    UITextView *checkInText = [[UITextView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(bgRuleImgView.frame) + kLabelX, kWidth - 40, kHeight /3)];
    checkInText.text = @"  1.每周第一次签到获得5猩币，之后每天签到多增加5猩币,直至20猩币,如有签到中断,将会重新从5猩币开始获取.\n  2.签到签满1周额外获得10猩币,连续签满2周额外获得20猩币,连续签满3周额外获得30猩币,连续签满4周额外获得40猩币.\n";
    checkInText.layer.backgroundColor = [[UIColor clearColor] CGColor];
    checkInText.font = [UIFont systemFontOfSize:16];
    checkInText.layer.borderColor = [[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]CGColor];
    checkInText.layer.borderWidth = 1.0;
    checkInText.layer.cornerRadius = 8.0f;
    checkInText.userInteractionEnabled = NO;
    checkInText.editable = NO;
    [checkInText.layer setMasksToBounds:YES];
    //自动适应行高
    static CGFloat maxHeight = 130.0f;
    CGRect frame = checkInText.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [checkInText sizeThatFits:constraintSize];
    if (size.height >= maxHeight){
        size.height = maxHeight;
        checkInText.scrollEnabled = YES;   // 允许滚动
    }
    else{
        checkInText.scrollEnabled = NO;    // 不允许滚动，当textview的大小足以容纳它的text的时候，需要设置scrollEnabed为NO，否则会出现光标乱滚动的情况
    }
    checkInText.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    [self.view addSubview:checkInText];
    
}
-(void)createHistoryButton {
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
    [rightButton setImage:[UIImage imageNamed:@"查看历史44x44.png"]forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(xingMoneyHistory)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
}
-(void)xingMoneyHistory{
    [self.navigationController pushViewController:[MoneyHistoryTableViewController alloc] animated:YES];
    
}

- (void)dismiss:(id)sender {
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 网络
- (void)netManage
{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/check_in";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           };
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];

         if([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"] )
         {
             
             [[self navigationItem] setTitle:dict[@"msg"]];
             _moneyLabel.text=[NSString stringWithFormat:@"明天签到将获得%@猩币",dict[@"data"][@"next_sign_coin"]];
             _dayLabel.text=[NSString stringWithFormat:@"%@天",dict[@"data"][@"continued"]];
             _weekLabel.text=[NSString stringWithFormat:@"获得%@猩币",dict[@"data"][@"sign_coin"]];
             
            NSString *next_grade_coin = [NSString stringWithFormat:@"%@",dict[@"data"][@"next_grade_coin"]];
            NSString *coin_total = [NSString stringWithFormat:@"%@",dict[@"data"][@"coin_total"]];
            CGFloat width = kWidth - 80;
            double durationValue = [coin_total intValue]/[next_grade_coin intValue];
             
             if (durationValue > 1 && durationValue < 2) {
                 durationValue = durationValue - 1;
             }else if (durationValue > 2 && durationValue < 3) {
                 durationValue = durationValue - 2;
             }else  if (durationValue > 3 && durationValue < 4) {
                 durationValue = durationValue - 3;
             }else if (durationValue > 4 && durationValue < 5) {
                 durationValue = durationValue - 4;
             }else if (durationValue > 5 && durationValue < 6) {
                 durationValue = durationValue - 5;
             }else if (durationValue > 6 && durationValue < 7) {
                 durationValue = durationValue - 6;
             }else if (durationValue > 7 && durationValue < 8) {
                 durationValue = durationValue - 7;
             }else if (durationValue > 8 && durationValue < 9) {
                 durationValue = durationValue - 8;
             }else if (durationValue > 9 && durationValue < 10) {
                 durationValue = durationValue - 9;
             }else if (durationValue > 10 && durationValue < 1000000000000000000) {
                 durationValue = durationValue - 10;
             }
             
             ysView.progressValue = durationValue *width;
             
             [SVProgressHUD showSuccessWithStatus:@"签到成功"];
             
         }else{
             
             _moneyLabel.text=[NSString stringWithFormat:@"明天签到将获得%@猩币",dict[@"data"][@"next_sign_coin"]];
             _dayLabel.text=[NSString stringWithFormat:@"%@天",dict[@"data"][@"continued"]];
             _weekLabel.text=[NSString stringWithFormat:@"获得%@猩币",dict[@"data"][@"sign_coin"]];
             NSString *next_grade_coin = [NSString stringWithFormat:@"%@",dict[@"data"][@"next_grade_coin"]];
             NSString *coin_total = [NSString stringWithFormat:@"%@",dict[@"data"][@"coin_total"]];
             CGFloat width = kWidth - 80;
             double durationValue = [coin_total doubleValue]/[next_grade_coin doubleValue];
             
             if (durationValue > 1 && durationValue < 2) {
                 durationValue = durationValue - 1;
             }else if (durationValue > 2 && durationValue < 3) {
                 durationValue = durationValue - 2;
             }else  if (durationValue > 3 && durationValue < 4) {
                 durationValue = durationValue - 3;
             }else if (durationValue > 4 && durationValue < 5) {
                 durationValue = durationValue - 4;
             }else if (durationValue > 5 && durationValue < 6) {
                 durationValue = durationValue - 5;
             }else if (durationValue > 6 && durationValue < 7) {
                 durationValue = durationValue - 6;
             }else if (durationValue > 7 && durationValue < 8) {
                 durationValue = durationValue - 7;
             }else if (durationValue > 8 && durationValue < 9) {
                 durationValue = durationValue - 8;
             }else if (durationValue > 9 && durationValue < 10) {
                 durationValue = durationValue - 9;
             }else if (durationValue > 10 && durationValue < 1000000000000000000) {
                 durationValue = durationValue - 10;
             }
             ysView.progressValue = durationValue *width;
             
              [SVProgressHUD showSuccessWithStatus:@"已经签到"];
         }
         //延时返回主页
         //         [self performSelector:@selector(delayMethod) withObject:nil afterDelay:2.0f];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}

//-(void)isCheckIn{
//    //计算出下次能签到的日期
//   NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//   [formatter setDateFormat:@"yyyy-MM-dd"];
//    NSDate *date = [formatter dateFromString:self.lastChickIn];
//   NSDate *tomorrow = [NSDate dateWithTimeInterval:60 * 60 * 24 sinceDate:date];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: tomorrow];
//    NSDate *tomorrowDate = [tomorrow dateByAddingTimeInterval: interval];
//    NSLog(@"tomorrowDate%@",tomorrowDate);
//
//    //计算现在时间
//    NSDate *now=[NSDate date];
//    NSDate *nowDate = [now dateByAddingTimeInterval: interval];
//    NSLog(@"nowDate%@",nowDate);
//
////    NSDate *earlier_date = [tomorrowDate earlierDate:nowDate];
////    NSLog(@"earlierDate  = %@",earlier_date);
//
//
//
//    if ([[nowDate earlierDate:tomorrowDate]isEqualToDate:nowDate]){
//
//        self.succesLabel.text=@"今日已签到";
//        self.moneyLabel.text=@"";
//
// }
//    else{
//        self.succesLabel.text=@"今日签到成功";
//        self.monthLabel.text=[NSString stringWithFormat:@"本次签到获得%@猩币",self.money];
//    }
//
//
//}
//- (IBAction)checkBtn:(id)sender {
//    if (_isCheck == NO) {
////        [self.navigationController pushViewController:[CheckInViewController alloc] animated:YES];
//
//        [_checkBtn setTitle:@"已签到" forState:UIControlStateNormal];
//        [_checkBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        [_checkBtn addTarget:self action:@selector(checkBtn:)forControlEvents:UIControlEventTouchUpInside];
//        _isCheck=!_isCheck;
//    }
//    else  if (_isCheck == YES) {
//        [SVProgressHUD showInfoWithStatus:@"您已经签到过了,请明天再来"];
//        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:1.5];
//
//    }
//}
@end

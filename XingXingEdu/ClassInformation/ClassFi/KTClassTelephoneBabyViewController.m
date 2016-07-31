//
//  KTClassTelephoneBabyViewController.m
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/6/16.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "KTClassTelephoneBabyViewController.h"
#import "MBProgressHUD.h"
#import "HHControl.h"
#import "VPImageCropperViewController.h"

#define DETAIL @"WZYStudentCenterTableViewCell"
#define Space 10

#define ORIGINAL_MAX_WIDTH 640.0f

#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define awayX 20
#define spaceX 5
#define spaceY 50

@interface KTClassTelephoneBabyViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITextFieldDelegate, UIAlertViewDelegate>
{
    MBProgressHUD *HUDDelete;
    MBProgressHUD *HUDDone;
    NSString *nickname;
    NSString *tname;
    NSString *age;
    NSString *relation;
    NSString *birthday;
    NSString *personal_sign;
    NSString *pdescribe;
    NSString *head_img;
    NSString *schoolName;
    NSString *gradeClassName;
}
@property (nonatomic) NSArray *pictureArray;
@property (nonatomic) NSArray *titleArray;
@property (nonatomic) NSArray *contentArray;
@property (nonatomic) UIImageView *backgroundImageView;
@property (nonatomic) UIImageView *iconImageView;
@property (nonatomic) UIView *lineView;
@property (nonatomic) UITextView *myTextView;
@property (nonatomic) UITextField *myTextField;
@property (nonatomic) UILabel *myLabel;

@property (nonatomic, strong) UIButton *confirmClassesBtn;
@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, copy) NSString *oldNiChengStr;
@property (nonatomic, copy) NSString *nowNiChengStr;
@property (nonatomic, copy) NSString *oldDecriptionStr;
@property (nonatomic, copy) NSString *nowDecriptionStr;

@end

@implementation KTClassTelephoneBabyViewController
- (void)viewWillAppear:(BOOL)animated{
    schoolName =[[NSUserDefaults standardUserDefaults]objectForKey:@"SCHOOL"];
    gradeClassName =[[NSUserDefaults standardUserDefaults]objectForKey:@"GRADE_CLASS"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0, 170, 42)];
    self.title = @"学生中心";
    
    [self loadNewData];
    
    self.pictureArray =[[NSMutableArray alloc]initWithObjects:@"昵称40x44", @"姓名40x40", @"年龄40x46", @"关系40x46", @"生日40x40", @"学校40x40", @"班级40x40",  @"个性签名40x40", @"个人描述40x40", nil];
    self.titleArray =[[NSMutableArray alloc]initWithObjects:@"昵称:",@"姓名:",@"年龄:", @"关系:", @"生日:", @"学校:", @"班级:", @"个性签名:", @"个人描述:", nil];
    
    //创建头视图
    [self createHeaderImageView];
    //创建脚视图
    [self createFooterImageView];
}
- (void)loadNewData{
    
    /*
     【孩子个人中心首页】
     
     接口:
     http://www.xingxingedu.cn/Parent/my_baby_info
     
     传参:
     baby_id		//孩子id
     */
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/my_baby_info";

    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":XID, @"user_id":USER_ID, @"user_type":USER_TYPE, @"baby_id":self.idKT};
   [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
       NSDictionary *dic =responseObj;
       
//       NSLog(@"%@", dic);
       /*
        {
        msg = Success!,
        data = {
        id = 1,
        pdescribe = Qwweeeeeeee,
        head_img = app_upload/head_img/2016/07/01/20160701193636_9651.png,
        tname = 李小红,
        age = 8,
        sex = 女,
        id_card = 3101142003032520006,
        flower = 6,
        passport = ,
        personal_sign = 好好学习,天天向上!,
        birthday = 2008-03-15,
        relation = ,
        nickname = 我们要
        },
        code = 1
        }
        */
       
       if([[NSString stringWithFormat:@"%@",dic[@"code"]]isEqualToString:@"1"])
       {

           NSDictionary *dictItem = dic[@"data"];
           
           NSString *schoolNameStr = [DEFAULTS objectForKey:@"SCHOOLNAME"];
           
           NSString *gradeAndClassStr = [DEFAULTS objectForKey:@"GRADEANDCLASS"];
           
           self.contentArray =[[NSMutableArray alloc]initWithObjects:dictItem[@"nickname"], dictItem[@"tname"], dictItem[@"age"], dictItem[@"relation"], dictItem[@"birthday"], schoolNameStr, gradeAndClassStr,dictItem[@"personal_sign"],  dictItem[@"pdescribe"], nil];
           
           head_img = dictItem[@"head_img"];

       }
    
//       NSLog(@"%@", self.contentArray);
       
       //创建内容
       [self createContent];
       
   } failure:^(NSError *error) {
       
   }];

}

//创建tableView的头视图
- (void)createHeaderImageView{
    _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, WinWidth, 100)];
    _backgroundImageView.backgroundColor = UIColorFromRGB(0, 170, 42);
    _backgroundImageView.userInteractionEnabled = YES;
    //设置头像
    CGFloat iconWidth = 86.0;
    CGFloat iconHeight = 86.0;
    
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.frame = CGRectMake(WinWidth / 2 - iconWidth / 2, _backgroundImageView.frame.size.height / 2 - iconHeight/2, 86, 86);
   
    _iconImageView.layer.cornerRadius = iconWidth / 2;
    _iconImageView.layer.masksToBounds = YES;
    
    _iconImageView.userInteractionEnabled = YES;
    
    [_backgroundImageView addSubview:_iconImageView];
    
    [self.view addSubview:_backgroundImageView];
}

//创建内容
- (void)createContent{
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picURL,head_img]] placeholderImage:[UIImage imageNamed:@"人物头像占位图136x136@2x"]];
    
    
    //创建 前7 条view
    for (int i = 0; i < 8; i++) {
        UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, _backgroundImageView.frame.origin.y + 100 + 40 * i, kWidth, 40)];
        myView.backgroundColor = [UIColor whiteColor];
        
        //创建 左边 icon
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
        icon.image = [UIImage imageNamed:_pictureArray[i]];
        [myView addSubview:icon];
        
        //创建 中间 标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + 20 + 14, 10, 70, 20)];
        titleLabel.text = _titleArray[i];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [myView addSubview:titleLabel];
        
        //创建 右边 内容
        UITextField *contentTextField = [[UITextField alloc] initWithFrame:CGRectMake(20 + 20 + 14 + 70 + 6, 5, 235, 30)];
        contentTextField.text = _contentArray[i];
        contentTextField.delegate = self;
        contentTextField.font = [UIFont systemFontOfSize:14];
        [myView addSubview:contentTextField];
        contentTextField.userInteractionEnabled =NO;
        
        //创建分割线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5, 39, kWidth - 5, 1)];
        lineView.backgroundColor = UIColorFromRGB(230, 230, 230);
        [myView addSubview:lineView];
        
        if (i != 0) {
            contentTextField.enabled = NO;
        }
        [self.view addSubview:myView];
        
    }
    
    //创建 个人描述
    UIView *descriptionView = [[UIView alloc] initWithFrame:CGRectMake(0, _backgroundImageView.frame.origin.y + 100 + 40 * 8, kWidth, 70)];
        descriptionView.backgroundColor = [UIColor whiteColor];
        descriptionView.userInteractionEnabled =NO;
    
    
    //创建 左边 icon
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
    icon.image = [UIImage imageNamed:[_pictureArray lastObject]];
    [descriptionView addSubview:icon];
    
    //创建 中间 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + 20 + 14, 10, 70, 20)];
    titleLabel.text = [_titleArray lastObject];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [descriptionView addSubview:titleLabel];
    
    //创建 右边 内容
    self.myTextView = [[UITextView alloc] initWithFrame:CGRectMake(20 + 20 + 14 + 70 + 6, 5, 235, 60)];
    self.myTextView.text = [_contentArray lastObject];
    self.myTextView.font = [UIFont systemFontOfSize:14];
    self.myTextView.delegate = self;
    [descriptionView addSubview:self.myTextView];
    
    self.oldDecriptionStr = self.myTextView.text;
    
//    //输入框 默认 的提示 文字 字数
//    self.myLabel = [[UILabel alloc] initWithFrame:CGRectMake(WinWidth - 70, 50, 60, 15)];
//    self.myLabel.text = @"1/200";
//    self.myLabel.textAlignment = NSTextAlignmentCenter;
//    self.myLabel.textColor = [UIColor lightGrayColor];
//    self.myLabel.font = [UIFont systemFontOfSize:14];
//    [descriptionView addSubview:self.myLabel];
    
    [self.view addSubview:descriptionView];
    
}

//创建脚视图
- (void)createFooterImageView{
    UIImageView *footBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, kHeight - 110, WinWidth, 110)];
    footBackground.backgroundColor = UIColorFromRGB(229, 232, 233);
    footBackground.userInteractionEnabled = YES;
}


- (void)textViewDidChange:(UITextView *)textView{
    
    self.myTextView = textView;
    self.myLabel.text = [NSString stringWithFormat:@"%ld/200", (unsigned long)textView.text.length];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    CGRect rect = CGRectMake(0, 667, WinWidth, 258);
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, -rect.size.height, WinWidth, WinHeight);
        
    }];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(0, 0, WinWidth, WinHeight);
    }];

    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
}

//返回
- (void)backClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

@end

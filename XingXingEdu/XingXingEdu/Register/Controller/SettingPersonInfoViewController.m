//
// SettingPersonInfoViewController.m
//  Created by codeDing on 16/1/16.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "SettingPersonInfoViewController.h"
#import "LandingpageViewController.h"
#import "HHControl.h"
#import "WJCommboxView.h"
#import "SVProgressHUD.h"
#import "CheckIDCard.h"
#import "HomepageViewController.h"

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AFNetworking.h"

#define ORIGINAL_MAX_WIDTH 640.0f

#define awayX 20
#define spaceX 10
#define spaceY 50
#define portraitImageViewSize 120.0f
#define headLabelSize 80.f
#define klabelH 30.0f
#define klabelW 120.0f
@interface SettingPersonInfoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, VPImageCropperDelegate>

{
    UIView *bgView;
    
    UILabel *parentsNameLabel;   //家长姓名
    UILabel *studentNameLabel;   //学生姓名
    UILabel *studentIDCardLabel;   //学生身份证号
    UILabel *studentRelationLabel;   //与学生关系
    UILabel *inviteCodeLabel;   //邀请码
    
    UITextField *parentsName;   //家长姓名
    UITextField *parentsIDCard;   //家长身份证号
    UITextField *studentName;   //学生姓名
    UITextField *studentIDCard;   //学生身份证号
    UITextField *inviteCode;   //邀请码
}
@property (nonatomic,strong) UIButton *head; //头像
@property(nonatomic,strong)WJCommboxView *relationCombox;//下拉选择框
@property(nonatomic,strong)WJCommboxView *parentsIDCardCombox;//家长身份证下拉选择框
@property(nonatomic,strong)WJCommboxView *studentIDCardCombox;//学生身份证下拉选择框
@property (nonatomic, strong) UIImageView *portraitImageView;//头像

@end

@implementation SettingPersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"注册3/3";
    self.view.backgroundColor= [UIColor colorWithRed:229/255.0f green:232/255.0f blue:234/255.0f alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0, 170, 42);
    
    
    [self createTextFields];
    [self loadPortrait];
    
}

-(void)createTextFields
{
    //头像
    _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kWidth - portraitImageViewSize)/2, spaceY+ awayX, portraitImageViewSize, portraitImageViewSize)];
    [_portraitImageView.layer setCornerRadius:(_portraitImageView.frame.size.height/2)];
    [_portraitImageView.layer setMasksToBounds:YES];
    [_portraitImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_portraitImageView setClipsToBounds:YES];
    _portraitImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    _portraitImageView.layer.shadowOffset = CGSizeMake(4, 4);
    _portraitImageView.layer.shadowOpacity = 0.5;
    _portraitImageView.layer.shadowRadius = 2.0;
    _portraitImageView.layer.borderColor = [[UIColor clearColor] CGColor];
    _portraitImageView.layer.borderWidth = 2.0f;
    _portraitImageView.userInteractionEnabled = YES;
    _portraitImageView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
    [_portraitImageView addGestureRecognizer:portraitTap];
    [self.view addSubview:self.portraitImageView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake((kWidth - headLabelSize)/2, CGRectGetMaxY(_portraitImageView.frame) + spaceX, headLabelSize, klabelH)];
    label.text=@"点击设置头像";
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:13];
    [self.view addSubview:label];
    
    //家长姓名
    parentsNameLabel = [self createLabelWithFrame:CGRectMake(awayX, CGRectGetMaxY(label.frame) + spaceX, klabelW, klabelH) Font:14 Text:@"家长姓名"];
    parentsNameLabel.textAlignment = NSTextAlignmentCenter ;
    parentsNameLabel.layer.cornerRadius = 17.0f;
    parentsNameLabel.layer.borderWidth = 0.1f;
    parentsNameLabel.backgroundColor = UIColorFromRGB(255, 255, 255);
    parentsNameLabel.clipsToBounds = YES;
    UIImageView *parentsImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 20, 20)];
    parentsImage.image=[UIImage imageNamed:@"必填符号60x60.png"];
    [parentsNameLabel addSubview:parentsImage];
    [self.view addSubview:parentsNameLabel];
    
    parentsName = [self createTextFielfFrame:CGRectMake(CGRectGetMaxX(parentsNameLabel.frame) + spaceX, CGRectGetMaxY(label.frame) + spaceX, kWidth - parentsNameLabel.size.width - awayX * 2, klabelH) font:[UIFont systemFontOfSize:14] placeholder:@"请输入您的姓名"  alignment:NSTextAlignmentCenter clearButtonMode:UITextFieldViewModeWhileEditing];
    parentsName.layer.cornerRadius = 17.0f;
    parentsName.layer.borderWidth = 0.1f;
    parentsName.clipsToBounds = YES;
    [self.view addSubview:parentsName];
    
    
    //家长身份证选择
    self.parentsIDCardArray = [[NSArray alloc]initWithObjects:@"家长身份证",@"家长护照",nil];
    self.parentsIDCardCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(awayX, CGRectGetMaxY(parentsNameLabel.frame) + spaceX, klabelW, klabelH)];
    //    self.parentsIDCardCombox.textField.placeholder = @"请选择关系";
    self.parentsIDCardCombox.textField.text = @"家长身份证";
    self.parentsIDCardCombox.textField.textAlignment = NSTextAlignmentCenter;
    self.parentsIDCardCombox.textField.tag = 102;
    self.parentsIDCardCombox.textField.layer.borderWidth = 0.1f;
    self.parentsIDCardCombox.textField.layer.cornerRadius = 17.0f;
    self.parentsIDCardCombox.textField.clipsToBounds = YES;
    self.parentsIDCardCombox.textField.font = [UIFont systemFontOfSize: 14];
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 20,20)];
    imageView1.image = [UIImage imageNamed:@"必填符号60x60"];
    self.parentsIDCardCombox.textField.leftView = imageView1;
    self.parentsIDCardCombox.textField.leftViewMode = UITextFieldViewModeAlways;
    
    self.parentsIDCardCombox.dataArray = self.parentsIDCardArray;
    self.parentsIDCardCombox.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.parentsIDCardCombox];
    self.parentsIDCardComBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight + 300)];
    self.parentsIDCardComBackView.backgroundColor = [UIColor clearColor];
    self.parentsIDCardComBackView.alpha = 0.5;
    
    //家长身份证号
    parentsIDCard = [self createTextFielfFrame:CGRectMake(CGRectGetMaxX(self.parentsIDCardCombox.frame) + spaceX, CGRectGetMaxY(parentsNameLabel.frame) + spaceX, kWidth - parentsNameLabel.size.width - awayX * 2, klabelH) font:[UIFont systemFontOfSize:14] placeholder:@"请输入您的身份号"  alignment:NSTextAlignmentCenter clearButtonMode:UITextFieldViewModeWhileEditing];
    parentsIDCard.layer.cornerRadius = 17.0f;
    parentsIDCard.layer.borderWidth = 0.1f;
    parentsIDCard.clipsToBounds = YES;
    parentsIDCard.backgroundColor = [UIColor whiteColor];
    parentsIDCard.textAlignment = NSTextAlignmentCenter ;
    [self.view addSubview:parentsIDCard];
    [parentsIDCard addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    //学生姓名
    studentNameLabel=[self createLabelWithFrame:CGRectMake(awayX, CGRectGetMaxY(parentsIDCard.frame) + spaceX, klabelW, klabelH) Font:14 Text:@"学生姓名"];
    studentNameLabel.textAlignment = NSTextAlignmentCenter ;
    studentNameLabel.backgroundColor = [UIColor whiteColor];
    studentNameLabel.layer.cornerRadius = 17.0f;
    studentNameLabel.layer.borderWidth = 0.1f;
    studentNameLabel.clipsToBounds = YES;
    UIImageView *studentImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 20, 20)];
    studentImage.image=[UIImage imageNamed:@"必填符号60x60.png"];
    [studentNameLabel addSubview:studentImage];
    [self.view addSubview:studentNameLabel];
    
    studentName=[self createTextFielfFrame:CGRectMake(CGRectGetMaxX(studentNameLabel.frame) + spaceX, CGRectGetMaxY(parentsIDCard.frame) + spaceX, kWidth - studentNameLabel.size.width - awayX * 2, klabelH) font:[UIFont systemFontOfSize:14] placeholder:@"请输入学生姓名"  alignment:NSTextAlignmentCenter clearButtonMode:UITextFieldViewModeWhileEditing];
    studentName.layer.cornerRadius = 17.0f;
    studentName.layer.borderWidth = 0.1f;
    studentName.clipsToBounds = YES;
    [self.view addSubview:studentName];
    
    
    //学生身份证号
    //学生身份证选择
    self.studentIDCardArray = [[NSArray alloc]initWithObjects:@"学生身份证",@"学生护照",nil];
    self.studentIDCardCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(awayX, CGRectGetMaxY(studentNameLabel.frame) + spaceX, klabelW, klabelH)];
    self.studentIDCardCombox.textField.text = @"学生身份证";
    self.studentIDCardCombox.textField.textAlignment = NSTextAlignmentCenter;
    self.studentIDCardCombox.textField.tag = 103;
    self.studentIDCardCombox.textField.font = [UIFont systemFontOfSize:14];
    self.studentIDCardCombox.textField.layer.borderWidth = 0.1f;
    self.studentIDCardCombox.textField.layer.cornerRadius = 17.0f;
    self.studentIDCardCombox.textField.clipsToBounds = YES;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 20,20)];
    imageView.image = [UIImage imageNamed:@"必填符号60x60"];
    self.studentIDCardCombox.textField.leftView = imageView;
    self.studentIDCardCombox.textField.leftViewMode = UITextFieldViewModeAlways;
    self.studentIDCardCombox.dataArray = self.studentIDCardArray;
    self.studentIDCardCombox.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.studentIDCardCombox];
    self.studentIDCardComBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight + 300)];
    self.studentIDCardComBackView.backgroundColor = [UIColor clearColor];
    self.studentIDCardComBackView.alpha = 0.5;
    
    studentIDCard=[self createTextFielfFrame:CGRectMake(CGRectGetMaxX(self.studentIDCardCombox.frame) + spaceX, CGRectGetMaxY(studentNameLabel.frame) + spaceX, kWidth - studentNameLabel.size.width - awayX * 2, klabelH) font:[UIFont systemFontOfSize:14] placeholder:@"请输入学生身份号"  alignment:NSTextAlignmentCenter clearButtonMode:UITextFieldViewModeWhileEditing];
    studentIDCard.backgroundColor = [UIColor whiteColor];
    studentIDCard.textAlignment = NSTextAlignmentCenter ;
    studentIDCard.layer.cornerRadius = 17.0f;
    studentIDCard.clipsToBounds = YES;
    [self.view addSubview:studentIDCard];
    [self.view addSubview:studentIDCardLabel];
    
    
    //与学生关系
    studentRelationLabel=[self createLabelWithFrame:CGRectMake(awayX,CGRectGetMaxY(studentIDCard.frame) + spaceX , klabelW, klabelH) Font:14 Text:@"与学生关系"];
    studentRelationLabel.textAlignment = NSTextAlignmentCenter ;
    studentRelationLabel.backgroundColor = [UIColor whiteColor];
    studentRelationLabel.layer.cornerRadius = 17.0f;
    studentRelationLabel.layer.borderWidth = 0.1f;
    studentRelationLabel.clipsToBounds = YES;
    UIImageView *studentRelationImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 20, 20)];
    studentRelationImage.image=[UIImage imageNamed:@"必填符号60x60.png"];
    [studentRelationLabel addSubview:studentRelationImage];
    [self.view addSubview:studentRelationLabel];
    
    
    //邀请码
    inviteCodeLabel=[self createLabelWithFrame:CGRectMake(awayX, CGRectGetMaxY(studentRelationLabel.frame) + spaceX, klabelW, klabelH) Font:14 Text:@"邀请码"];
    inviteCodeLabel.backgroundColor = [UIColor whiteColor];
    inviteCodeLabel.textAlignment = NSTextAlignmentCenter;
    inviteCodeLabel.layer.cornerRadius = 17.0f;
    inviteCodeLabel.layer.borderWidth = 0.1f;
    inviteCodeLabel.clipsToBounds = YES;
    
    
    inviteCode=[self createTextFielfFrame:CGRectMake(CGRectGetMaxX(inviteCodeLabel.frame) + spaceX, CGRectGetMaxY(studentRelationLabel.frame) + spaceX, kWidth - studentNameLabel.size.width - awayX * 2, klabelH) font:[UIFont systemFontOfSize:14] placeholder:@"可不填"  alignment:NSTextAlignmentCenter clearButtonMode:UITextFieldViewModeWhileEditing];
    inviteCode.layer.cornerRadius = 17.0f;
    inviteCode.layer.borderWidth = 0.1f;
    inviteCode.clipsToBounds = YES;
    [self.view addSubview:inviteCode];
    [self.view addSubview:inviteCodeLabel];
    
    
    //确认按钮
    UIButton *landBtn=[self createButtonFrame:CGRectMake(awayX, CGRectGetMaxY(inviteCode.frame) + awayX,kWidth - awayX *2, 40) backImageName:@"按钮（big）icon650x84" title:@"完   成" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:17] target:self action:@selector(landClick)];
    landBtn.backgroundColor=[UIColor colorWithRed:229/255.0f green:232/255.0f blue:234/255.0f alpha:1];
    landBtn.layer.cornerRadius=5.0f;
    [self.view addSubview:landBtn];
}


- (void) textFieldDidChange:(id) sender {
    UITextField *_field = (UITextField *)sender;
    if([self.parentsIDCardCombox.textField.text isEqualToString:@"家长身份证"]){
        if(_field.text.length==18){
            if ([CheckIDCard checkIDCardSexMan:_field.text]) {
                
                [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"性别"];
                self.relationArray = [[NSArray alloc]initWithObjects:@"爸爸",@"爷爷",@"外公",@"其他",nil];
            }
            else{
                [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"性别"];
                self.relationArray = [[NSArray alloc]initWithObjects:@"妈妈",@"外婆",@"奶奶",@"其他",nil];
            }
        }
    }
    else{
        self.relationArray = [[NSArray alloc]initWithObjects:@"爸爸",@"爷爷",@"外公",@"妈妈",@"外婆",@"奶奶",@"其他",nil];
    }
    //与学生关系
    self.relationCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(studentRelationLabel.frame) + spaceX,CGRectGetMaxY(studentIDCard.frame) + spaceX, kWidth - studentRelationLabel.size.width - awayX * 2, klabelH)];
    self.relationCombox.textField.placeholder = @"请选择关系";
    self.relationCombox.textField.textAlignment = NSTextAlignmentCenter;
    self.relationCombox.textField.tag = 101;
    self.relationCombox.textField.font = [UIFont systemFontOfSize:14];
    self.relationCombox.textField.layer.cornerRadius = 17.0f;
    self.relationCombox.textField.layer.borderWidth = 0.1f;
    self.relationCombox.textField.clipsToBounds = YES;
    self.relationCombox.dataArray = self.relationArray;
    [self.view addSubview:self.relationCombox];
    self.comBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WinWidth, WinHeight+300)];
    self.comBackView.backgroundColor = [UIColor clearColor];
    self.comBackView.alpha = 0.5;
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden)];
    [self.comBackView addGestureRecognizer:singleTouch];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction:) name:@"commboxNotice"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction2:) name:@"commboxNotice2"object:nil];
    
}
-(void)landClick
{
    
    if ([parentsName.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"亲,请输入您的姓名"];
        return;
    }
    else if (parentsName.text.length >5||parentsName.text.length <2)
    {
        [SVProgressHUD showInfoWithStatus:@"亲,请输入您正确的姓名"];
        return;
    }
    else if ([parentsIDCard.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"亲,请输入您的身份证号"];
        return;
    }
    else if ([studentName.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"亲,请输入学生的姓名"];
        return;
    }
    else if (studentName.text.length >5||studentName.text.length <2)
    {
        [SVProgressHUD showInfoWithStatus:@"亲,请输入学生正确的姓名"];
        return;
    }
    else if ([studentIDCard.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"亲,请输入学生的身份证号"];
        return;
    }
    else if ([self.relationCombox.textField.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"亲,请选择学生与您的关系"];
        return;
    }
    
    else if ([self.studentIDCardCombox.textField.text isEqualToString:@"学生身份证"]&&studentIDCard.text.length !=18)
    {
        [SVProgressHUD showInfoWithStatus:@"您输入的学生身份证号码格式不正确"];
        return;
    }
    else if ( [self.parentsIDCardCombox.textField.text isEqualToString:@"家长身份证"]&&parentsIDCard.text.length !=18)
    {
        [SVProgressHUD showInfoWithStatus:@"您输入的身份证号码格式不正确"];
        return;
    }
    else if ([self.parentsIDCardCombox.textField.text isEqualToString:@"家长身份证"]&&![CheckIDCard checkIDCard:parentsIDCard.text]){
        [SVProgressHUD showInfoWithStatus:@"您输入的家长身份证号码不存在"];
        return;
    }
    else if ([self.studentIDCardCombox.textField.text isEqualToString:@"学生身份证"]&&![CheckIDCard checkIDCard:studentIDCard.text]){
        [SVProgressHUD showInfoWithStatus:@"您输入的学生身份证号码不存在"];
        return;
    }
    else if ([self.studentIDCardCombox.textField.text isEqualToString:@"学生身份证"]&&![[self rangeString:studentIDCard.text begin:6 length:2] isEqualToString:@"20"]){
        [SVProgressHUD showInfoWithStatus:@"您输入的学生身份证号码不正确"];
        return;
    }
    
    [self upload];
    
    
    
}

-(NSString * )rangeString:(NSString *)str begin:(NSInteger )begin  length:(NSInteger)length{
    NSRange r1 = {begin,length};
    return  [str substringWithRange:r1];
}

-(UITextField *)createTextFielfFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder alignment:(NSTextAlignment )alignment clearButtonMode:(UITextFieldViewMode )clearButtonMode
{
    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
    
    textField.font=font;
    
    textField.textColor=[UIColor grayColor];
    
    textField.borderStyle=UITextBorderStyleNone;
    
    textField.placeholder=placeholder;
    textField.textAlignment=alignment;
    textField.clearButtonMode=clearButtonMode;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.layer.cornerRadius = 10.0f;
    textField.clipsToBounds = YES;
    
    return textField;
}

-(UILabel *)createLabelWithFrame:(CGRect )frame Font:(int)font Text:(NSString *)text{
    UILabel *myLabel = [[UILabel alloc]initWithFrame:frame];
    myLabel.numberOfLines = 0;//限制行数
    myLabel.textAlignment = NSTextAlignmentRight;//对齐的方式
    myLabel.backgroundColor = [UIColor clearColor];//背景色
    myLabel.font = [UIFont systemFontOfSize:font];//字号
    myLabel.textColor = [UIColor blackColor];//颜色默认是黑色
    //NSLineBreakByCharWrapping以单词为单位换行，以单词为阶段换行
    
    myLabel.lineBreakMode = NSLineBreakByCharWrapping;
    myLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    myLabel.text = text;
    return myLabel;
    
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

-(void)clickaddBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)changeHeadView1:(UIButton *)tap
{
    
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"更改头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册上传", nil];
    menu.delegate=self;
    menu.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [menu showInView:self.view];
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

- (void)commboxAction:(NSNotification *)notif{
    switch ([notif.object integerValue]) {
        case 101:
            [self.self.relationCombox removeFromSuperview];
            [self.view addSubview:self.comBackView];
            [self.view addSubview:self.relationCombox];
            break;
        default:
            break;
    }
    
}

- (void)commboxAction2:(NSNotification *)notif{
    
    [self.comBackView removeFromSuperview];
}

- (void)commboxHidden{
    [self.comBackView removeFromSuperview];
    
    [self.relationCombox setShowList:NO];
    self.relationCombox.listTableView.hidden = YES;
    
    CGRect sf = self.relationCombox.frame;
    sf.size.height = 30;
    self.relationCombox.frame = sf;
    CGRect frame = self.relationCombox.listTableView.frame;
    frame.size.height = 0;
    self.relationCombox.listTableView.frame = frame;
    
    
    [self.relationCombox removeFromSuperview];
    [self.view addSubview:self.relationCombox];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark --更换头像
- (void)loadPortrait {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        UIImage *protraitImg = [UIImage imageNamed:@"头像194x194"];
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.portraitImageView.image = protraitImg;
        });
    });
}

- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.portraitImageView.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark 网络
- (void)upload
{
    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/register";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dic = @{@"appkey":@"U3k8Dgj7e934bh5Y",
                          @"backtype":@"json",
                          @"phone":self.phone,
                          @"pass":self.pwd,
                          @"tname":parentsName.text,
                          //                          @"id_card":parentsIDCard.text,
                          @"relation":self.relationCombox.textField.text,
                          //                          @"age":[CheckIDCard checkIDCardAge:parentsIDCard.text],
                          @"sex":[CheckIDCard checkIDCardSex:parentsIDCard.text],
                          @"baby_tname":studentName.text,
                          //                          @"baby_id_card":studentIDCard.text,
                          //                          @"baby_age":[CheckIDCard checkIDCardAge:studentIDCard.text],
                          @"baby_sex":[CheckIDCard checkIDCardSex:studentIDCard.text],
                          @"code":inviteCode.text,
                          };
    
    
    NSMutableDictionary  *dict=[NSMutableDictionary dictionaryWithDictionary:dic];
    if([self.parentsIDCardCombox.textField.text isEqualToString:@"家长身份证"]){
        [dict setObject:parentsIDCard.text forKey:@"id_card"];
        [dict setObject:[CheckIDCard checkIDCardAge:parentsIDCard.text] forKey:@"age"];
    }else{
        [dict setObject:parentsIDCard.text forKey:@"passport"];
        
    }
    
    if([self.studentIDCardCombox.textField.text isEqualToString:@"学生身份证"]){
        [dict setObject:studentIDCard.text forKey:@"baby_id_card"];
        [dict setObject:[CheckIDCard checkIDCardAge:studentIDCard.text] forKey:@"baby_age"];
    }else{
        [dict setObject:studentIDCard.text forKey:@"baby_passport"];
    }
    
    //    NSLog(@"%@",dict);
    
    // 请求时提交的数据格式
    //    mgr.requestSerializer = [AFJSONRequestSerializer serializer];// JSON
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 构建请求体
        UIImage *upImage = self.portraitImageView.image;
        NSData *imageData = UIImagePNGRepresentation(upImage);
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"2" mimeType:@"image/png"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         //        NSLog(@"%@",dict);
         //        NSLog(@"%@",dict[@"code"]);
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             
             [SVProgressHUD showSuccessWithStatus:@"注册成功，请前往首页登录"];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self.navigationController pushViewController:[LandingpageViewController alloc] animated:YES];
             });
             
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"注册失败，%@",dict[@"msg"]]];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}


@end

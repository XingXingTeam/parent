//
//  KTSubjectInfoViewController.m
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/6/17.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "KTSubjectInfoViewController.h"
#define ORIGINAL_MAX_WIDTH 640.0f
#import "HZQDatePickerView.h"
#import "WJCommboxView.h"
#import "FSImagePickerView.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface KTSubjectInfoViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,HZQDatePickerViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    NSArray *_nameArray;
    MBProgressHUD *HUD;
    UIAlertView *_alert;
    HZQDatePickerView *_pikerView;
    NSMutableArray *_dataMArr;
    
}
@property (weak, nonatomic) IBOutlet UIView *weekdayView;
@property (weak, nonatomic) IBOutlet UITextField *teacherNameTF;
@property (weak, nonatomic) IBOutlet UITextField *classNameTF;
@property (weak, nonatomic) IBOutlet UITextField *upTimeTF;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UITextField *downTimeTF;
@property (weak, nonatomic) IBOutlet UITextField *roomTF;
@property (weak, nonatomic) IBOutlet UITextField *remarkTF;
@property (nonatomic, strong)WJCommboxView *weekBox;

@end

@implementation KTSubjectInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"课程详情";
    //    [self createRightBar];
    // Do any additional setup after loading the view.
   
    [self createUpTimeField];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)createUpTimeField{
    
    if (_hidden == YES) {
   
        self.roomTF.delegate = self;
        self.roomTF.text = _dataArr[0];
        self.roomTF.userInteractionEnabled = YES;
        self.roomTF.tag = 1000;
        
        self.teacherNameTF.delegate = self;
        self.teacherNameTF.text = _dataArr[2];
        self.teacherNameTF.userInteractionEnabled = YES;
        self.teacherNameTF.tag = 2000;
        
        self.classNameTF.delegate = self;
        self.classNameTF.text = _dataArr[1];
        self.classNameTF.userInteractionEnabled = YES;
        self.classNameTF.tag = 3000;
        
        self.remarkTF.delegate = self;
        self.remarkTF.text = _dataArr[6];
        self.remarkTF.userInteractionEnabled = YES;
        self.remarkTF.tag = 4000;
        
        self.upTimeTF.delegate =self;
        self.upTimeTF.text = _dataArr[3];
        self.upTimeTF.tag =5000;
        
        self.downTimeTF.delegate =self;
        self.downTimeTF.text = _dataArr[4];
        self.downTimeTF.tag =6000;
        
        self.weekBox.hidden = YES;
        _weekdayView.hidden = YES;
        
    }else{
        
        self.roomTF.text = _dataArr[0];
        self.roomTF.userInteractionEnabled = NO;
        
        self.teacherNameTF.text = _dataArr[2];
        self.teacherNameTF.userInteractionEnabled = NO;
        
        self.classNameTF.text = _dataArr[1];
        self.classNameTF.userInteractionEnabled = NO;
        
        self.remarkTF.text = _dataArr[6];
        self.remarkTF.userInteractionEnabled = NO;
        
        self.upTimeTF.text = _dataArr[3];
        self.upTimeTF.userInteractionEnabled = NO;
        
        self.downTimeTF.text = _dataArr[4];
        self.downTimeTF.userInteractionEnabled = NO;
        
        _nameArray = [NSArray arrayWithObjects:@"1 周",@"2 周",@"3 周",@"4 周", nil];
        self.weekBox = [[WJCommboxView alloc]initWithFrame:CGRectMake(50, 393,320, 30)];
        self.weekBox.textField.text = _dataArr[8];
        self.weekBox.textField.textAlignment = NSTextAlignmentLeft;
        self.weekBox.textField.borderStyle =UITextBorderStyleNone;
        self.weekBox.textField.tag = 7000;
        self.weekBox.textField.userInteractionEnabled = NO;
        self.weekBox.textField.layer.cornerRadius =15;
        self.weekBox.textField.textAlignment =NSTextAlignmentCenter;
        self.weekBox.textField.layer.masksToBounds =YES;
        self.weekBox.dataArray = _nameArray;
        [self.view addSubview:self.weekBox];
    }
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField; {
    if (textField.tag == 1000) {
        self.roomTF.text = textField.text;
    }
    if (textField.tag == 2000) {

    }
    if (textField.tag == 3000) {
        self.classNameTF.text = textField.text;

    }
    if (textField.tag == 4000) {
        self.remarkTF.text = textField.text;
    }
    if (textField.tag == 5000) {
       [self.view endEditing:YES];
       self.upTimeTF.text = textField.text;
    }
    if (textField.tag == 6000) {
      [self.view endEditing:YES];
      self.downTimeTF.text = textField.text;
    }
    if (textField.tag == 7000) {
        self.weekBox.textField.text = textField.text;
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 5000) {
        [self.view endEditing:YES];
        [self setupDateView:DateTypeOfStart];
        return NO;
    }
    if (textField.tag == 6000) {
        [self.view endEditing:YES];
        [self setupDateView:DateTypeOfEnd];
         return NO;
    }
    return YES;
}

- (void)setupDateView:(DateType)type {
    
    _pikerView = [HZQDatePickerView instanceDatePickerView];
    _pikerView.frame = CGRectMake(0, 0, kWidth  , kHeight + 20);
    [_pikerView setBackgroundColor:[UIColor clearColor]];
    _pikerView.delegate = self;
    _pikerView.type = type;
    // 今天开始往后的日期
    [_pikerView.datePickerView
     setMinimumDate:[NSDate date]];
    // 在今天之前的日期
    [self.view addSubview:_pikerView];
    
}

- (void)getSelectDate:(NSString *)date type:(DateType)type {
    
    switch (type) {
        case DateTypeOfStart:
            
            self.upTimeTF.text = [[NSString stringWithFormat:@"%@", date] substringWithRange:NSMakeRange(11,5)];
            
            break;
        case DateTypeOfEnd:
            self.downTimeTF.text = [[NSString stringWithFormat:@"%@", date] substringWithRange:NSMakeRange(11,5)];

            
            break;
            
        default:
            break;
    }
}



- (IBAction)sureBtn:(id)sender {
    
    [self postTheDataToServer];

}

-(void)postTheDataToServer{
    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/schedule_parent_edit";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"baby_id":@"3",
                           @"week_date":_weekDataStr,
                           @"schedule_id":[NSString stringWithFormat:@"%@",_dataArr[7]],
                           @"wd":[NSString stringWithFormat:@"%@",_dataArr[8]],
                           @"lesson_start_tm":self.upTimeTF.text,
                           @"lesson_end_tm":self.downTimeTF.text,
                           @"course_name":self.roomTF.text,
                           @"teacher_name":self.teacherNameTF.text,
                           @"classroom":self.classNameTF.text,
                           @"notes": self.remarkTF.text,
                           };
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"===========>%@",dict);
        if([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"] ){
            HUD =[[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:HUD];
            
            HUD.dimBackground =YES;
            HUD.labelText =@"正在上传中.....";
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2);
            } completionBlock:^{
                HUD.labelText =@"上传成功!";
                [HUD removeFromSuperview];
                HUD =nil;
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"修改失败"];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

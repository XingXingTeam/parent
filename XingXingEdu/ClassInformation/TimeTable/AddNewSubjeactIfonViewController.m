//
//  AddNewSubjeactIfonViewController.m
//  XingXingEdu
//
//  Created by mac on 16/7/12.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "AddNewSubjeactIfonViewController.h"
#import "WJCommboxView.h"
#import "HZQDatePickerView.h"
#define kViewH 50.0f
#define kTextFH 30.0f
#define kImageW 20.0f
#define kImageH 25.0f
#define kMarg 5.0f
@interface AddNewSubjeactIfonViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,HZQDatePickerViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,WJCommboxViewDelegate>{
    HZQDatePickerView *_pikerView;
    UITextField * infoText;
    NSString *_weekDataStr;
    NSInteger _weekNumber;
}

@property (nonatomic, strong)WJCommboxView *weekBox;
@property (weak, nonatomic) UITextField *teacherNameTF;
@property (weak, nonatomic) UITextField *classNameTF;
@property (weak, nonatomic) UITextField *upTimeTF;
@property (weak, nonatomic) UIButton *sureBtn;
@property (weak, nonatomic) UITextField *downTimeTF;
@property (weak, nonatomic) UITextField *roomTF;
@property (weak, nonatomic) UITextField *remarkTF;
@end

@implementation AddNewSubjeactIfonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"添加自定义课程";
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    
    [self ctreateNewSubjectInfo];
    [self createRightButton];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)createRightButton {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(- 10, 0, 44, 20);
    
    [rightBtn setTitle:@"提交"  forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = backItem;
}

-(void)ctreateNewSubjectInfo{
    NSMutableArray *imageArr = [[NSMutableArray alloc] initWithObjects:@"课程名icon40x50.png",@"老师icon40x50.png",@"教室icon40x50.png",@"备注icon40x50.png",@"上下课时间icon40x50.png",@"上下课时间icon40x50.png",@"复制icon40x50.png",nil];
    NSMutableArray *placeholderArr = [[NSMutableArray alloc] initWithObjects:@"请输入课程名",@"请输入老师名",@"请输入教室名",@"请输入备注内容",@"请选择上课时间",@"请选择下课时间",@"请选择当前复制的周数",nil];
    for (int i = 0; i < imageArr.count; i ++) {
        UIView *bgView = [HHControl createViewWithFrame:CGRectMake(0, (kViewH + kMarg)*i, kWidth,kViewH)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.userInteractionEnabled = YES;
        [self.view addSubview:bgView];
        
        UIImageView *imageView = [HHControl createImageViewWithFrame:CGRectMake(kImageW, kMarg *3, kImageW, kImageH) ImageName:imageArr[i]];
        [bgView addSubview:imageView];
        
        if (i == 6) {
            NSArray *weekDay = [NSArray arrayWithObjects:@"1周",@"2周",@"3周",@"4周",@"5周",@"6周",@"7周",@"8周",@"9周",@"10周",@"11周",@"12周",@"13周",@"14周",@"15周",@"16周",@"17周",@"18周",@"19周",@"20周", nil];
            self.weekBox = [[WJCommboxView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + kMarg *3, kViewH *6 + kMarg *6 + kMarg *2,kWidth - CGRectGetMaxX(imageView.frame) - kImageW -kMarg *2, kTextFH)];
            self.weekBox.textField.textAlignment = NSTextAlignmentLeft;
            self.weekBox.textField.borderStyle =UITextBorderStyleNone;
            self.weekBox.textField.tag = 7000;
            self.weekBox.textField.placeholder = placeholderArr[6];
            self.weekBox.textField.layer.cornerRadius =15;
            self.weekBox.textField.textAlignment =NSTextAlignmentCenter;
            self.weekBox.textField.layer.masksToBounds =YES;
            self.weekBox.delegate = self;
            self.weekBox.dataArray = weekDay;
            [self.view addSubview:self.weekBox];
            
        }else if (i == 0) {
            self.roomTF = [HHControl createTextFielfFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + kMarg *3, 13, kWidth - CGRectGetMaxX(imageView.frame) - kImageW -kMarg *2, kTextFH) font:[UIFont systemFontOfSize:14] placeholder:placeholderArr[i]];
            self.roomTF.tag = 1000 ;
            self.roomTF.delegate = self;
            [bgView addSubview:self.roomTF];
            
        }else if (i == 1) {
            self.teacherNameTF = [HHControl createTextFielfFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + kMarg *3, 13, kWidth - CGRectGetMaxX(imageView.frame) - kImageW -kMarg *2, kTextFH) font:[UIFont systemFontOfSize:14] placeholder:placeholderArr[i]];
            self.teacherNameTF.tag = 1000 + 1;
            self.teacherNameTF.delegate = self;
            [bgView addSubview:self.teacherNameTF];
            
        }else if (i == 2) {
            self.classNameTF = [HHControl createTextFielfFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + kMarg *3, 13, kWidth - CGRectGetMaxX(imageView.frame) - kImageW -kMarg *2, kTextFH) font:[UIFont systemFontOfSize:14] placeholder:placeholderArr[i]];
            self.classNameTF.tag = 1000 + 2;
            self.classNameTF.delegate = self;
            [bgView addSubview:self.classNameTF];
            
        }else if (i == 3) {
            self.remarkTF = [HHControl createTextFielfFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + kMarg *3, 13, kWidth - CGRectGetMaxX(imageView.frame) - kImageW -kMarg *2, kTextFH) font:[UIFont systemFontOfSize:14] placeholder:placeholderArr[i]];
            self.remarkTF.tag = 1000 + 3;
            self.remarkTF.delegate = self;
            [bgView addSubview:self.remarkTF];
            
        }
        else if (i == 4) {
            self.upTimeTF = [HHControl createTextFielfFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + kMarg *3, 13, kWidth - CGRectGetMaxX(imageView.frame) - kImageW -kMarg *2, kTextFH) font:[UIFont systemFontOfSize:14] placeholder:placeholderArr[i]];
            self.upTimeTF.tag = 1000 + 4;
            self.upTimeTF.delegate = self;
            [bgView addSubview:self.upTimeTF];
            
        }else if(i == 5){
            self.downTimeTF = [HHControl createTextFielfFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + kMarg *3, 13, kWidth - CGRectGetMaxX(imageView.frame) - kImageW -kMarg *2, kTextFH) font:[UIFont systemFontOfSize:14] placeholder:placeholderArr[i]];
            self.downTimeTF.tag = 1000 + 5;
            self.downTimeTF.delegate = self;
            [bgView addSubview:self.downTimeTF];
        }
        
    }
    
}

-(void)clickButton{
    
    [self addNewSubjectNetWorking];
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField; {
    if (textField.tag == 1000) {
        self.roomTF.text = textField.text;
        
    }
    if (textField.tag == 1001) {
        
        self.teacherNameTF.text = textField.text;
        
    }
    if (textField.tag == 1002) {
        self.classNameTF.text = textField.text;
        
        
    }
    if (textField.tag == 1003) {
        self.remarkTF.text = textField.text;
        
    }
    if (textField.tag == 1004) {
        [self.view endEditing:YES];
        
    }
    if (textField.tag == 1005) {
        [self.view endEditing:YES];
        
    }
    if (textField.tag == 7000) {
        self.weekBox.textField.text = textField.text;
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 1004) {
        [self.view endEditing:YES];
        [self setupDateView:DateTypeOfStart];
        return NO;
    }
    if (textField.tag == 1005) {
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
    [_pikerView.datePickerView setMinimumDate:[NSDate date]];
    // 在今天之前的日期
    [self.view addSubview:_pikerView];
    
}

- (void)getSelectDate:(NSString *)date type:(DateType)type {
    
    switch (type) {
        case DateTypeOfStart:
            _weekDataStr = [[NSString stringWithFormat:@"%@", date] substringWithRange:NSMakeRange(0,10)];
            self.upTimeTF.text = [[NSString stringWithFormat:@"%@", date] substringWithRange:NSMakeRange(11,5)];
            
            break;
        case DateTypeOfEnd:
            self.downTimeTF.text = [[NSString stringWithFormat:@"%@", date] substringWithRange:NSMakeRange(11,5)];
            
            break;
        default:
            break;
    }
}


-(void)sendSelectCellNum:(NSInteger)num{
    _weekNumber = num + 1;
}
//网络请求
-(void)addNewSubjectNetWorking{
//    
//    NSLog(@"=================>%@",_weekDataStr);
//        NSLog(@"=================>%ld",_weekNumber);
//    
    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/schedule_parent_add";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"baby_id":@"3",
                           @"date":_weekDataStr,
                           @"lesson_start_tm":self.upTimeTF.text,
                           @"lesson_end_tm":self.downTimeTF.text,
                           @"course_name":self.roomTF.text,
                           @"teacher_name":self.teacherNameTF.text,
                           @"classroom":self.classNameTF.text,
                           @"notes": self.remarkTF.text,
                           @"copy_week_num": [NSString stringWithFormat:@"%ld",_weekNumber],

                           };
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"===========>%@",dict);
        if([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"] ){
            
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"提交失败，请检查网络是否通畅"];
            
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

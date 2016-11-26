//
//  SubEditViewController.m
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/2/17.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define KPATA @"AddClassSubjectCell"
#import "AddClassSubjectCell.h"
#import "SubEditViewController.h"
#import "HZQDatePickerView.h"
#import "HHControl.h"
#import "WJCommboxView.h"
@interface SubEditViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,HZQDatePickerViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *dataArr;
    NSMutableArray *placeArr;
    NSArray *_nameArray;
    UIAlertView *_alert;
    UIAlertView *_aler;
    HZQDatePickerView *_pickerView;
    UITextField *goClassFid;
}
@property (nonatomic, strong)WJCommboxView *weekBox;
@end

@implementation SubEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"课程详情";
    // Do any additional setup after loading the view.
    [self createTableView];
    [self createRightBar];
   
}
- (void)createTableView{
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    [self.view addSubview: _tableView];
    
    UIView *footView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 400)];
    footView.backgroundColor =UIColorFromRGB(255, 255, 255);
    UIImageView *imgV =[[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 20, 25)];
    imgV.image =[UIImage imageNamed:@"复制icon40x50@2x"];
    [footView addSubview:imgV];
            _nameArray = [NSArray arrayWithObjects:@"1周",@"2周",@"3周",@"4周",@"5周",@"6周",@"7周", nil];
            self.weekBox = [[WJCommboxView alloc]initWithFrame:CGRectMake(50, 5,320, 30)];
            self.weekBox.textField.placeholder = @"复制到第几周";
            self.weekBox.textField.textAlignment = NSTextAlignmentLeft;
            self.weekBox.textField.borderStyle =UITextBorderStyleNone;
            self.weekBox.textField.tag = 1000;
            self.weekBox.textField.layer.cornerRadius =15;
            self.weekBox.textField.textAlignment =NSTextAlignmentCenter;
            self.weekBox.textField.layer.masksToBounds =YES;
            self.weekBox.dataArray = _nameArray;
    [footView addSubview:self.weekBox];
    
    UIButton *passBtn =[HHControl createButtonWithFrame:CGRectMake(25, 70, 325, 42) backGruondImageName:@"按钮big650x84" Target:self Action:@selector(passWord) Title:@"确 定"];
    [passBtn setTitleColor:UIColorFromRGB(255, 255, 255) forState:UIControlStateNormal];
    [footView addSubview:passBtn];
    _tableView.tableFooterView =footView;
    dataArr =[[NSMutableArray alloc]init];
    placeArr =[[NSMutableArray alloc]init];
    
    NSArray *placeArray =@[@"请输入课程名",@"请输入老师名",@"请输入教室名",@"请输入备注内容",@"请输入上课时间",@"请输入下课时间"];
    
    NSArray *headArr =@[@"课程名icon40x50@2x",@"老师icon40x50@2x",@"教室icon40x50@2x",@"备注icon40x50@2x",@"上下课时间icon40x50@2x",@"上下课时间icon40x50@2x"];
    
    [placeArr addObjectsFromArray:placeArray];
    [dataArr addObjectsFromArray:headArr];

}
- (void)passWord{

    [SVProgressHUD showSuccessWithStatus:@"添加完成"];
    typeof(self) __weak weak =self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weak LoginFirstView];
    });

}
- (void)LoginFirstView{

    [self.navigationController popViewControllerAnimated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddClassSubjectCell *cell =(AddClassSubjectCell*)[tableView dequeueReusableCellWithIdentifier:KPATA];
    if (!cell) {
        NSArray *nib =[[NSBundle mainBundle]loadNibNamed:KPATA owner:[AddClassSubjectCell class] options:nil];
        cell =(AddClassSubjectCell *)[nib objectAtIndex:0];
    }
    cell.headImgV.image =[UIImage imageNamed:dataArr[indexPath.row]];
    cell.textFid.placeholder =placeArr[indexPath.row];
    cell.textFid.tag =indexPath.row +100;
    cell.textFid.delegate =self;
    [cell.textFid addTarget:self action:@selector(next:) forControlEvents:UIControlEventEditingDidBegin];

    return cell;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}
- (void)classHidden{
    [self.classView removeFromSuperview];
    
    [self.weekBox setShowList:NO];
    self.weekBox.listTableView.hidden = YES;
    
    CGRect sf = self.weekBox.frame;
    sf.size.height = 30;
    self.weekBox.frame = sf;
    CGRect frame = self.weekBox.listTableView.frame;
    frame.size.height = 0;
    self.weekBox.listTableView.frame = frame;
    
    [self.weekBox removeFromSuperview];
    [_tableView addSubview:self.weekBox];

}
- (void)next:(UITextField *)textField{
    NSLog(@"%ld",textField.tag);
    switch (textField.tag) {
        case 100:
        {
            //[textField resignFirstResponder];
        
        }
            break;
        case 101:
        {
            // [textField resignFirstResponder];
            
        }
            break;
        case 102:
        {
             //[textField resignFirstResponder];
            
        }
            break;
        case 103:
        {  //[textField resignFirstResponder];
            
            
        }
            break;
        case 104:
        {  //[textField resignFirstResponder];
            goClassFid =textField;
            [self dataNext];
            
        }
            break;
        case 105:
        { // [textField resignFirstResponder];
            goClassFid =textField;
            [self dataNext];
            
        }
            break;
        case 106:
        {
             // [textField resignFirstResponder];
            
        }
            break;
        default:
            break;
    }




}
- (void)dataNext{
    
    [self setupDateView:DateTypeOfStart];
}
- (void)setupDateView:(DateType)type {
    
    _pickerView = [HZQDatePickerView instanceDatePickerView];
    _pickerView.frame = CGRectMake(0, 0, kWidth, kHeight + 20);
    [_pickerView setBackgroundColor:[UIColor clearColor]];
    _pickerView.delegate = self;
    _pickerView.type = type;
    // 今天开始往后的日期
    [_pickerView.datePickerView
     setMinimumDate:[NSDate date]];
    // 在今天之前的日期
    //    [_pikerView.datePickerView setMaximumDate:[NSDate date]];
    [self.view addSubview:_pickerView];
    
}

- (void)getSelectDate:(NSString *)date type:(DateType)type {
    NSLog(@"%d - %@", type, date);
    
    switch (type) {
        case DateTypeOfStart:
            goClassFid.text = [NSString stringWithFormat:@" %@", date];
            
            break;
            
            
        default:
            break;
    }
}

- (void)createRightBar{
    
    UIButton *firstBtn =[HHControl createButtonWithFrame:CGRectMake(251, 0, 26, 26) backGruondImageName:@"优先级icon" Target:self Action:@selector(rightItm:) Title:nil];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:firstBtn];
    self.navigationItem.rightBarButtonItem =rightItem;
}
- (void)rightItm:(UIBarButtonItem*)rightItem{
//提示
    _alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"已设置为优先课程" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [_alert show];



}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
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

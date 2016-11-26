//
//  AddSubViewController.m
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/2/18.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "AddSubViewController.h"

@interface AddSubViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSArray *_nameArray;
    UIAlertView *_alert;
}
@property (weak, nonatomic) IBOutlet UITextField *subName;
@property (weak, nonatomic) IBOutlet UITextField *teachName;
@property (weak, nonatomic) IBOutlet UITextField *roomName;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;

@property (weak, nonatomic) IBOutlet UITextField *markName;
@property (weak, nonatomic) IBOutlet UIDatePicker *goDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *stopDatePicker;
@end

@implementation AddSubViewController
- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"添加课程";
    self.view.backgroundColor = UIColorFromRGB(116,205, 169);
    
    self.pickView.dataSource =self;
    self.pickView.delegate =self;
    [self.view addSubview:self.pickView];
    [self.pickView reloadAllComponents];
    
    _nameArray = [NSArray arrayWithObjects:@"1周",@"2周",@"3周",@"4周",@"5周",@"6周",@"7周",@"8周",@"9周", nil];
    [self createRightBar];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)createRightBar{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"优先" style:UIBarButtonItemStylePlain target:self action:@selector(rightItm:)];
    self.navigationItem.rightBarButtonItem =rightItem;
}
- (void)rightItm:(UIBarButtonItem*)rightItem{
    //提示
    _alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"已设置为优先课程" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [_alert show];
    
    
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    return _nameArray.count;

}
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    NSString *str =[_nameArray objectAtIndex:row];
    return str;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
   // NSLog(@"%@",[_nameArray objectAtIndex:row]);
}
- (IBAction)btn:(UIButton *)sender {
    sender.layer.cornerRadius =5;
    sender.layer.masksToBounds =YES;
    NSDate *select =[self.goDatePicker date];
    NSDate *sele = [self.stopDatePicker date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateAndTime = [dateFormatter stringFromDate:select];
    NSString *dateAnd = [dateFormatter stringFromDate:sele];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"时间提示" message:[NSString stringWithFormat:@"上课时间:%@                 下课时间:%@",dateAndTime,dateAnd] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
    
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

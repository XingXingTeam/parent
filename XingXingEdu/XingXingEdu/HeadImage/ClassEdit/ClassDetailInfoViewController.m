






//
//  ClassDetailInfoViewController.m
//  XingXingEdu
//
//  Created by Mac on 16/7/2.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "ClassDetailInfoViewController.h"



@interface ClassDetailInfoViewController ()

@property (nonatomic, strong) UIAlertView *alert;


@end

@implementation ClassDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    
//    [self createRightBar];
    
    [self customContent];
}

//- (void)createRightBar{
//    UIButton *deleteBtn =[HHControl createButtonWithFrame:CGRectMake(251, 0, 17, 21) backGruondImageName:@"删除icon34x42" Target:self Action:@selector(rightBar) Title:nil];
//    UIBarButtonItem *rightBar =[[UIBarButtonItem alloc]initWithCustomView:deleteBtn];
//    self.navigationItem.rightBarButtonItem =rightBar;
//    
//}
//- (void)rightBar{
//    NSLog(@"删除");
//    _alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要删除该课程吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [_alert show];
//    
//    
//}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
//    switch (buttonIndex) {
//        case 0:
//            NSLog(@"取消");
//            break;
//        case 1:
//            [self.navigationController popViewControllerAnimated:YES];
//            break;
//        default:
//            break;
//    }
//    
//}



- (void)customContent{

    //地区
    _areaTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * kWidth / 375, 100 * kWidth / 375, 70 * kWidth / 375, 30 * kWidth / 375)];
    _areaTitleLabel.textAlignment = NSTextAlignmentCenter;
    _areaTitleLabel.text = @"区 域";
    _areaTitleLabel.backgroundColor = [UIColor whiteColor];
    _areaTitleLabel.font = [UIFont systemFontOfSize:14 * kWidth / 375];
    [self.view addSubview:_areaTitleLabel];
    
    _provinceLabel = [[UILabel alloc] initWithFrame:CGRectMake(90 * kWidth / 375, 100 * kWidth / 375, 80 * kWidth / 375, 30 * kWidth / 375)];
    _provinceLabel.font = [UIFont systemFontOfSize:14 * kWidth / 375];
    _provinceLabel.textAlignment = NSTextAlignmentCenter;
    _provinceLabel.backgroundColor = [UIColor whiteColor];
    _provinceLabel.layer.cornerRadius = 5;
    _provinceLabel.layer.masksToBounds = YES;
    _provinceLabel.text = _model.province;
    [self.view addSubview:_provinceLabel];
    
    _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(185 * kWidth / 375, 100 * kWidth / 375, 70 * kWidth / 375, 30 * kWidth / 375)];
    _cityLabel.font = [UIFont systemFontOfSize:14 * kWidth / 375];
    _cityLabel.textAlignment = NSTextAlignmentCenter;
    _cityLabel.backgroundColor = [UIColor whiteColor];
    _cityLabel.layer.cornerRadius = 5;
    _cityLabel.layer.masksToBounds = YES;
    _cityLabel.text = _model.city;
    [self.view addSubview:_cityLabel];
    
    _areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(280 * kWidth / 375, 100 * kWidth / 375, 70 * kWidth / 375, 30 * kWidth / 375)];
    _areaLabel.font = [UIFont systemFontOfSize:14 * kWidth / 375];
    _areaLabel.textAlignment = NSTextAlignmentCenter;
    _areaLabel.backgroundColor = [UIColor whiteColor];
    _areaLabel.layer.cornerRadius = 5;
    _areaLabel.layer.masksToBounds = YES;
    _areaLabel.text = _model.district;
    [self.view addSubview:_areaLabel];
    
    //学校 类型
    _schoolTypeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * kWidth / 375, 170 * kWidth / 375, 70 * kWidth / 375, 30 * kWidth / 375)];
    _schoolTypeTitleLabel.textAlignment = NSTextAlignmentCenter;
    _schoolTypeTitleLabel.backgroundColor = [UIColor whiteColor];
    _schoolTypeTitleLabel.text = @"学校类型";
    _schoolTypeTitleLabel.font = [UIFont systemFontOfSize:14 * kWidth / 375];
    [self.view addSubview:_schoolTypeTitleLabel];
    
    
    _schoolTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(90 * kWidth / 375, 170 * kWidth / 375, 270 * kWidth / 375, 30 * kWidth / 375)];
    _schoolTypeLabel.font = [UIFont systemFontOfSize:14 * kWidth / 375];
    _schoolTypeLabel.textAlignment = NSTextAlignmentCenter;
    _schoolTypeLabel.backgroundColor = [UIColor whiteColor];
    _schoolTypeLabel.layer.cornerRadius = 5;
    _schoolTypeLabel.layer.masksToBounds = YES;
    //school_type 	//学校类型,请传数字代号:幼儿园/小学/中学/培训机构 1/2/3/4
    if ([_model.sch_type isEqualToString:@"1"]) {
        _schoolTypeLabel.text = @"幼儿园";
    }else if ([_model.sch_type isEqualToString:@"2"]){
    _schoolTypeLabel.text = @"小学";
    }else if ([_model.sch_type isEqualToString:@"3"]){
    _schoolTypeLabel.text = @"中学";
    }else if ([_model.sch_type isEqualToString:@"4"]){
    _schoolTypeLabel.text = @"培训机构";
    }
    [self.view addSubview:_schoolTypeLabel];
    
    
    //学校 名称
    _schoolNameTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * kWidth / 375, 240 * kWidth / 375, 70 * kWidth / 375, 30 * kWidth / 375)];
    _schoolNameTitleLabel.textAlignment = NSTextAlignmentCenter;
    _schoolNameTitleLabel.backgroundColor = [UIColor whiteColor];
    _schoolNameTitleLabel.text = @"学校名称";
    _schoolNameTitleLabel.font = [UIFont systemFontOfSize:14 * kWidth / 375];
    [self.view addSubview:_schoolNameTitleLabel];
    
    _schoolNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90 * kWidth / 375, 240 * kWidth / 375, 270 * kWidth / 375, 30 * kWidth / 375)];
    _schoolNameLabel.font = [UIFont systemFontOfSize:14 * kWidth / 375];
    _schoolNameLabel.textAlignment = NSTextAlignmentCenter;
    _schoolNameLabel.backgroundColor = [UIColor whiteColor];
    _schoolNameLabel.layer.cornerRadius = 5;
    _schoolNameLabel.layer.masksToBounds = YES;
    _schoolNameLabel.text = _model.school_name;
    [self.view addSubview:_schoolNameLabel];
    
    
    //班级 信息
    _classInfoTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * kWidth / 375, 310 * kWidth / 375, 70 * kWidth / 375, 30 * kWidth / 375)];
    _classInfoTitleLabel.textAlignment = NSTextAlignmentCenter;
    _classInfoTitleLabel.backgroundColor = [UIColor whiteColor];
    _classInfoTitleLabel.text = @"班级信息";
    _classInfoTitleLabel.font = [UIFont systemFontOfSize:14* kWidth / 375];
    [self.view addSubview:_classInfoTitleLabel];
    
    
    _gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(90 * kWidth / 375, 310 * kWidth / 375, 260* kWidth / 375, 30 * kWidth / 375)];
    _gradeLabel.font = [UIFont systemFontOfSize:14 * kWidth / 375];
    _gradeLabel.textAlignment = NSTextAlignmentCenter;
    _gradeLabel.backgroundColor = [UIColor whiteColor];
    _gradeLabel.layer.cornerRadius = 5;
    _gradeLabel.layer.masksToBounds = YES;
    _gradeLabel.text = _model.class_name;
    [self.view addSubview:_gradeLabel];
    //审核 人员
    _checkTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * kWidth / 375, 380 * kWidth / 375, 70 * kWidth / 375, 30 * kWidth / 375 )];
    _checkTitleLabel.textAlignment = NSTextAlignmentCenter;
    _checkTitleLabel.backgroundColor = [UIColor whiteColor];
    _checkTitleLabel.text = @"审核人员";
    _checkTitleLabel.font = [UIFont systemFontOfSize:14* kWidth / 375];
    [self.view addSubview:_checkTitleLabel];
    
    _checkLabel = [[UILabel alloc] initWithFrame:CGRectMake(90 * kWidth / 375, 380 * kWidth / 375, 270 * kWidth / 375, 30 * kWidth / 375)];
    _checkLabel.font = [UIFont systemFontOfSize:14 * kWidth / 375];
    _checkLabel.textAlignment = NSTextAlignmentCenter;
    _checkLabel.backgroundColor = [UIColor whiteColor];
    _checkLabel.layer.cornerRadius = 5;
    _checkLabel.layer.masksToBounds = YES;
    _checkLabel.text = _model.examine_tname;
    [self.view addSubview:_checkLabel];

}



@end

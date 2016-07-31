






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
    
    [self createRightBar];
    
    [self customContent];
}

- (void)createRightBar{
    UIButton *deleteBtn =[HHControl createButtonWithFrame:CGRectMake(251, 0, 17, 21) backGruondImageName:@"删除icon34x42" Target:self Action:@selector(rightBar) Title:nil];
    UIBarButtonItem *rightBar =[[UIBarButtonItem alloc]initWithCustomView:deleteBtn];
    self.navigationItem.rightBarButtonItem =rightBar;
    
}
- (void)rightBar{
    NSLog(@"删除");
    _alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要删除该课程吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [_alert show];
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            NSLog(@"取消");
            break;
        case 1:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        default:
            break;
    }
    
}



- (void)customContent{

    _provinceLabel.layer.cornerRadius = 5;
    _provinceLabel.layer.masksToBounds = YES;
    _provinceLabel.text = _provinceStr;
    
    _cityLabel.layer.cornerRadius = 5;
    _cityLabel.layer.masksToBounds = YES;
    _cityLabel.text = _cityStr;
    
    _areaLabel.layer.cornerRadius = 5;
    _areaLabel.layer.masksToBounds = YES;
    _areaLabel.text = _areaStr;
    
    _schoolTypeLabel.layer.cornerRadius = 5;
    _schoolTypeLabel.layer.masksToBounds = YES;
//    _schoolTypeLabel.text = _schoolTypeStr;
    //school_type 	//学校类型,请传数字代号:幼儿园/小学/中学/培训机构 1/2/3/4
    if ([_schoolTypeStr isEqualToString:@"1"]) {
        _schoolTypeLabel.text = @"幼儿园";
    }else if ([_schoolTypeStr isEqualToString:@"2"]){
    _schoolTypeLabel.text = @"小学";
    }else if ([_schoolTypeStr isEqualToString:@"3"]){
    _schoolTypeLabel.text = @"中学";
    }else if ([_schoolTypeStr isEqualToString:@"4"]){
    _schoolTypeLabel.text = @"培训机构";
    }
    
    _schoolNameLabel.layer.cornerRadius = 5;
    _schoolNameLabel.layer.masksToBounds = YES;
    _schoolNameLabel.text = _schoolNameStr;
    
    _gradeLabel.layer.cornerRadius = 5;
    _gradeLabel.layer.masksToBounds = YES;
    _gradeLabel.text = _gradeStr;
//    _gradeLabel.text = [NSString stringWithFormat:@"%@年级", [WZYTool changeStringFromFigure:_gradeStr]];
    
    _classLabel.layer.cornerRadius = 5;
    _classLabel.layer.masksToBounds = YES;
    _classLabel.text = _classStr;
//    _classLabel.text = [NSString stringWithFormat:@"%@班", [WZYTool changeStringFromFigure:_classStr]];
    
    _checkLabel.layer.cornerRadius = 5;
    _checkLabel.layer.masksToBounds = YES;
    _checkLabel.text = _checkStr;

}



@end

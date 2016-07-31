



//
//  CourseDetailViewController.m
//  XingXingEdu
//
//  Created by Mac on 16/5/12.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "CourseDetailViewController.h"

@interface CourseDetailViewController ()

@end

@implementation CourseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"课程详情";

    //1、设置 navigationBar 左边 返回
    UIImage *backImage = [UIImage imageNamed:@"返回icon90x38"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage: backImage  style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.view.backgroundColor = UIColorFromRGB(223.0, 226.0, 226.0);
    [self customContent];
}

- (void)customContent{
    
    self.courseStateImageView.image = [UIImage imageNamed:self.courseStateStr];
    
    self.courseLabel.text = self.courseStr;
    
    self.schoolLabel.text = self.schoolStr;
    
    self.teacherLabel.text = self.teacherStr;
    
    
//    self.targetLabel.text=@"掌握好写字的诀窍";
    self.targetLabel.text = _targetStr;
    
    self.targetLabel.font = [UIFont systemFontOfSize:14];
    
//    self.placeLabel.text=@"上海市浦东新区1058号";
    self.placeLabel.text = _addressStr;
    self.placeLabel.font = [UIFont systemFontOfSize:14];
    
//    self.timeLabel.text=@"2016-1-2 至 2016-3-8，每周一18：00~19：30";
    self.timeLabel.text = _courseTimeStr;
    self.timeLabel.font = [UIFont systemFontOfSize:14];

}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];

}



@end

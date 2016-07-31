//
//  CourseDetailViewController.h
//  XingXingEdu
//
//  Created by Mac on 16/5/12.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *courseStateLab;
@property (weak, nonatomic) IBOutlet UILabel *courseLab;
@property (weak, nonatomic) IBOutlet UILabel *schoolLab;
@property (weak, nonatomic) IBOutlet UILabel *teacherLab;

@property (weak, nonatomic) IBOutlet UIImageView *courseStateImageView;
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;

@property (weak, nonatomic) IBOutlet UILabel *targetLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;



@property (nonatomic, copy) NSString *courseStateStr;
@property (nonatomic, copy) NSString *courseStr;
@property (nonatomic, copy) NSString *schoolStr;
@property (nonatomic, copy) NSString *teacherStr;

@property (nonatomic, copy) NSString *targetStr;
@property (nonatomic, copy) NSString *courseTimeStr;
@property (nonatomic, copy) NSString *addressStr;


@end

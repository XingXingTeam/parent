



//
//  CourseDetailViewController.m
//  XingXingEdu
//
//  Created by Mac on 16/5/12.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "CourseDetailViewController.h"

@interface CourseDetailViewController ()

@property (nonatomic, strong) UIImageView *upBgImageView;
@property (nonatomic, strong) UIImageView *downBgImageView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *contentArray;


@end

@implementation CourseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"课程详情";
    
    _titleArray = [[NSMutableArray alloc] initWithObjects:@"授课老师:", @"机构名称:", @"教学目标:", @"上课时间:", @"上课地址:", nil];
    _contentArray = [[NSMutableArray alloc] initWithObjects:_teacherStr , _schoolStr, _targetStr, _courseTimeStr, _addressStr, nil];

    //1、设置 navigationBar 左边 返回
    UIImage *backImage = [UIImage imageNamed:@"返回icon90x38"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage: backImage  style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];

    self.view.backgroundColor = UIColorFromRGB(229.0, 232.0, 233.0);
    [self customContent];
}

- (void)customContent{
    
    _upBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5 ,64 + 5, kWidth - 10, 50 * kWidth / 375)];
    CGFloat upBgImageViewWidth = _upBgImageView.frame.size.width;
    CGFloat upBgImageViewHeight = _upBgImageView.frame.size.height;
    
    _upBgImageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_upBgImageView];
    
    //上面 背景图 上的内容
    //左上角的图片   Triangle    /// 右下角 图片 Triangle01
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 15, 15)];
    leftImageView.image = [UIImage imageNamed:@"Triangle"];
    [_upBgImageView addSubview:leftImageView];
    
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(upBgImageViewWidth - 15 - 1, upBgImageViewHeight - 15 - 1, 15, 15)];
    rightImageView.image = [UIImage imageNamed:@"Triangle01"];
    [_upBgImageView addSubview:rightImageView];

    //课程 名称 label
    UILabel *courseLabel = [HHControl createLabelWithFrame:CGRectMake(20, 10, upBgImageViewWidth - 100, 30) Font:18.0 * kWidth / 375 Text:_courseStr];

    [_upBgImageView addSubview:courseLabel];
    
    //开课状态  yijieke
    UIImageView *stateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth - 70, (upBgImageViewHeight - 35 * kWidth / 375) / 2, 35 * kWidth / 375, 35 * kWidth / 375)];
    stateImageView.image = [UIImage imageNamed:@"yijieke"];
    [_upBgImageView addSubview:stateImageView];
    
    
    _downBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, _upBgImageView.origin.y + upBgImageViewHeight + 5, kWidth - 10, kHeight - _upBgImageView.origin.y - upBgImageViewHeight - 5)];
    _downBgImageView.backgroundColor = [UIColor whiteColor];
    CGFloat downBgImageViewWidth = _downBgImageView.frame.size.width;
    CGFloat downBgImageViewHeight = _downBgImageView.frame.size.height;
    
    [self.view addSubview:_downBgImageView];
    
    //轴线 Decorative-thread01
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 10 * kWidth / 375, 917 / 2 * kWidth / 375)];
    lineImageView.image = [UIImage imageNamed:@"Decorative-thread01"];
    [_downBgImageView addSubview:lineImageView];
    
    //title label
    for (int i = 0; i < 5; i++) {
        UILabel * titleLabel = [HHControl createLabelWithFrame:CGRectMake(30, (20 + 90 * i) * kWidth / 375, downBgImageViewWidth - 50, 20) Font:16.0 * kWidth / 375 Text:_titleArray[i]];
        [_downBgImageView addSubview:titleLabel];
        
        //content label
        UILabel * contentLabel = [HHControl createLabelWithFrame:CGRectMake(30, (40 + 90 * i) * kWidth / 375, downBgImageViewWidth - 50, 40) Font:16.0 * kWidth / 375 Text:_contentArray[i]];
        [_downBgImageView addSubview:contentLabel];
        
    }
    
    
    
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];

}



@end

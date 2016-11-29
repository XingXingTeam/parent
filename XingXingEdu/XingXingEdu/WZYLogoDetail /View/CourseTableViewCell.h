//
//  CourseTableViewCell.h
//  XingXingEdu
//
//  Created by Mac on 16/5/10.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseTableViewCell : UITableViewCell


@property (nonatomic, strong) UIImageView *bookIconImage;

@property (nonatomic, strong) UIImageView *coinImageView;
@property (nonatomic, strong) UIImageView *reduceImageView;
@property (nonatomic, strong) UIImageView *saveImageView;
@property (nonatomic, strong) UIImageView *fullImageView;

//课程名称
@property (nonatomic, strong) UILabel *courseNameLabel;
//课程老师
@property (nonatomic, strong) UILabel *teacherNameLabel;
//招生总人数  8人班级
@property (nonatomic, strong) UILabel *totalNumberLabel;
//现人数     还剩5人
@property (nonatomic, strong) UILabel *numberLabel;
//原价       原价:3500
@property (nonatomic, strong) UILabel *oldPriceLabel;
//现价       限时抢购价:3100
@property (nonatomic, strong) UILabel *nowPriceLbl;

@property (nonatomic, strong) UIImageView *lineImageViewOne;
@property (nonatomic, strong) UIImageView *lineImageViewTwo;
@property (nonatomic, strong) UIImageView *lineImageViewThree;
@property (nonatomic, strong) UIImageView *separateImageView;



@end

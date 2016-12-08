


//
//  CourseTableViewCell.m
//  XingXingEdu
//
//  Created by Mac on 16/5/10.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "CourseTableViewCell.h"

@implementation CourseTableViewCell

- (void)awakeFromNib {
//    _separateImageView.backgroundColor = UIColorFromRGB(229, 232, 233);
//    
//    [_lineImageViewOne setImage:[UIImage imageNamed:@"线552x1"]];
//    [_lineImageViewTwo setImage:[UIImage imageNamed:@"线552x1"]];
//    [_lineImageViewThree setImage:[UIImage imageNamed:@"线552x1"]];
//    _lineImageViewOne.frame = CGRectMake(0,0,250,2);
//    _lineImageViewTwo.frame = CGRectMake(0,0,250,2);
//    _lineImageViewThree.frame = CGRectMake(0,0,250,2);
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //分隔条
        _separateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 7)];
        _separateImageView.backgroundColor = UIColorFromRGB(229, 232, 233);
        [self.contentView addSubview:_separateImageView];
        
        //左边头像
        _bookIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
       [self.contentView addSubview:_bookIconImage];
        
        //右边 三条分割线
        //课程名称
        _courseNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120 * kWidth / 375, 10, 150 * kWidth / 375, 20 )];
        _courseNameLabel.font = [UIFont systemFontOfSize:14 * kWidth / 375];
        [self.contentView addSubview:_courseNameLabel];
        //右上角 四个 图片
        _coinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth - 100, 10, 15, 15)];
        [self.contentView addSubview:_coinImageView];
        
        _reduceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth -75, 10, 15, 15)];
        [self.contentView addSubview:_reduceImageView];
        
        _saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth - 50, 10, 15, 15)];
        [self.contentView addSubview:_saveImageView];
        
        _fullImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth -25, 10, 15, 15)];
        [self.contentView addSubview:_fullImageView];
        
        
        _lineImageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(120 * kWidth / 375, 30, kWidth - 100 - 10, 2)];
        [_lineImageViewOne setImage:[UIImage imageNamed:@"线552x1"]];
        [self.contentView addSubview:_lineImageViewOne];
        
        
        //老师 名称
        _teacherNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120 * kWidth / 375, 35, 100 * kWidth / 375, 20)];
        _teacherNameLabel.font = [UIFont systemFontOfSize:14 * kWidth / 375];
        _teacherNameLabel.text = @"授课老师:";
        [self.contentView addSubview:_teacherNameLabel];
        
        _lineImageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(120 * kWidth / 375, 55, kWidth - 100 - 10, 2)];
        [_lineImageViewTwo setImage:[UIImage imageNamed:@"线552x1"]];
        [self.contentView addSubview:_lineImageViewTwo];
        
        
        //班级招收人数
        _totalNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(120 * kWidth / 375, 60, 100 * kWidth / 375, 20)];
        _totalNumberLabel.font = [UIFont systemFontOfSize:14 * kWidth / 375];
        [self.contentView addSubview:_totalNumberLabel];
        
        //还剩人数
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(220 * kWidth / 375, 60, 100 * kWidth / 375, 20)];
        _numberLabel.font = [UIFont systemFontOfSize:14 * kWidth / 375];
        [self.contentView addSubview:_numberLabel];
        
        _lineImageViewThree = [[UIImageView alloc] initWithFrame:CGRectMake(120 * kWidth / 375, 80, kWidth - 100 - 10, 2)];
        [_lineImageViewThree setImage:[UIImage imageNamed:@"线552x1"]];
        [self.contentView addSubview:_lineImageViewThree];
        
        //原价
        _oldPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(120 * kWidth / 375, 80, 100 * kWidth / 375, 20)];
        _oldPriceLabel.font = [UIFont systemFontOfSize:14 * kWidth / 375];
        [self.contentView addSubview:_oldPriceLabel];
        
        //现价
        _nowPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(kWidth - 150, 80, 150 * kWidth / 375, 20)];
        _nowPriceLbl.font = [UIFont systemFontOfSize:14 * kWidth / 375];
        [self.contentView addSubview:_nowPriceLbl];
        
    }

    return self;
}


@end

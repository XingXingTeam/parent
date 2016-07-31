


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
    _lineImageView.backgroundColor = UIColorFromRGB(229, 232, 233);
    
    [_separateImageViewOne setImage:[UIImage imageNamed:@"线552x1"]];
    [_separateImageViewTwo setImage:[UIImage imageNamed:@"线552x1"]];
    [_separateImageViewThree setImage:[UIImage imageNamed:@"线552x1"]];
    _separateImageViewOne.frame = CGRectMake(0,0,250,2);
    _separateImageViewTwo.frame = CGRectMake(0,0,250,2);
    _separateImageViewThree.frame = CGRectMake(0,0,250,2);
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

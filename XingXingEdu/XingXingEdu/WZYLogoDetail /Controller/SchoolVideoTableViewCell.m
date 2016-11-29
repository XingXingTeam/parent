




//
//  SchoolVideoTableViewCell.m
//  XingXingEdu
//
//  Created by Mac on 16/5/20.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "SchoolVideoTableViewCell.h"

@implementation SchoolVideoTableViewCell

- (void)awakeFromNib {
   
    _titleLabel.textColor = [UIColor whiteColor];
    _timeLabel.textColor = [UIColor whiteColor];
    
    _titleLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.backgroundColor = [UIColor clearColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

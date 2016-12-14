//
//  DetailCell.m
//  XingXingEdu
//
//  Created by Mac on 16/5/6.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "DetailCell.h"

@implementation DetailCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    self.contentLabel.width = 230 * kScreenRatioWidth;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

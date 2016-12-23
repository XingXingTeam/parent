//
//  ClassTeacherTableViewCell.m
//  XingXingStore
//
//  Created by codeDing on 16/1/27.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "ClassTeacherTableViewCell.h"

@implementation ClassTeacherTableViewCell

- (void)awakeFromNib {
    
    UIImage *backGroungImage =[UIImage imageNamed:@"线552x1"];
    [backGroungImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    [_separator1 setImage:backGroungImage];
    [_separator2 setImage:backGroungImage];
    
    _separator1.frame = CGRectMake(0,0,250,2);
    _separator2.frame = CGRectMake(0,0,250,2);
        
    _distanceLabel.textColor = [UIColor redColor];
    
    self.buttomBackground.hidden = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

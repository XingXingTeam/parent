//
//  ClassSubjectTableViewCell.m
//  XingXingStore
//
//  Created by codeDing on 16/1/28.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "ClassSubjectTableViewCell.h"

@implementation ClassSubjectTableViewCell

- (void)awakeFromNib {
    [_separator1 setImage:[UIImage imageNamed:@"线552x1"]];
    [_separator2 setImage:[UIImage imageNamed:@"线552x1"]];
    [_separator3 setImage:[UIImage imageNamed:@"线552x1"]];
    _separator1.frame = CGRectMake(0,0,250,2);
    _separator2.frame = CGRectMake(0,0,250,2);
    _separator3.frame = CGRectMake(0,0,250,2);
    
    
    self.buttomBackground.hidden = YES;
    
    _distanceLabel.textColor = [UIColor redColor];
    // Initialization code
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  ClassSchoolTableViewCell.m
//  XingXingStore
//
//  Created by codeDing on 16/1/28.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "ClassSchoolTableViewCell.h"



@implementation ClassSchoolTableViewCell


- (void)awakeFromNib {
//   设置分割线
    [_separator1 setImage:[UIImage imageNamed:@"线552x1.png"]];
    [_separator2 setImage:[UIImage imageNamed:@"线552x1.png"]];
    _separator1.frame = CGRectMake(0,0,250,2);
    _separator2.frame = CGRectMake(0,0,250,2);
//    
    
////头像的圆角
//    _iconImg.layer.cornerRadius= _iconImg.bounds.size.width/2;
//    _iconImg.layer.masksToBounds=YES;
    
    
//距离的字体颜色
    _distanceLabel.textColor = [UIColor redColor];
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

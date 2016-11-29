//
//  tackTableViewCell.m
//  Homepage
//
//  Created by super on 16/1/29.
//  Copyright © 2016年 Edu. All rights reserved.
//

#import "tackTableViewCell.h"

@implementation tackTableViewCell


- (void)awakeFromNib {
    // Initialization code
}
//-(void)setSchool:(UILabel *)school
//{
//    
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setSchool:(NSString *)school
{
    _school=school;
    self.Ischool.text = school;
}
-(void)setClassname:(NSString *)class
{
    _classname = class;
    self.Iclass.text = class;
    
}
-(void)setTeacher:(NSString *)teacher
{
    _teacher = teacher;
    self.iteacher.text = teacher;
}
-(void)setZhuangtai:(NSString *)zhuangtai
{
    _zhuangtai = zhuangtai;
    self.izhuangtai.text = zhuangtai;
    
}
-(void)setPhone:(NSString *)phone
{
    _phone = phone;
    self.Iphone.image=[UIImage imageNamed:phone];
    
    
}

@end

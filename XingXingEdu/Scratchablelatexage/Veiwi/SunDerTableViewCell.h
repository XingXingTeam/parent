//
//  SunDerTableViewCell.h
//  Homepage
//
//  Created by super on 16/1/22.
//  Copyright © 2016年 Edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SunDerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *Rphone;
@property (weak, nonatomic) IBOutlet UILabel *TLabel;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *Nlabel;//内容
//@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;//学校
//@property (weak, nonatomic) IBOutlet UILabel *classLabel;//班级
//@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;//课程
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;//理由
@property (weak, nonatomic) IBOutlet UIImageView *flower;//花朵
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;



@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,copy)NSString *img;
@property(nonatomic,copy)NSString *reason;
@property (nonatomic,copy)NSString *school;
@property (nonatomic,copy)NSString *classi;
@property(nonatomic,copy)NSString *subject;
@property (nonatomic,copy)NSString *reasonsss;
@property (nonatomic,copy)NSString *flowers;


@end

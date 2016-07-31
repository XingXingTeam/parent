//
//  WZYHistoryClassesTableViewCell.h
//  XingXingEdu
//
//  Created by Mac on 16/5/11.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZYHistoryClassesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;


@property (weak, nonatomic) IBOutlet UIView *lineImageView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherNameLabel;



@end

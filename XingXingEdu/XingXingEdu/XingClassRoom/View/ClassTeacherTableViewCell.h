//
//  ClassTeacherTableViewCell.h
//  XingXingStore
//
//  Created by codeDing on 16/1/27.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassTeacherTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *NameLabel;

@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UIButton *collect;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@property (weak, nonatomic) IBOutlet UIImageView *attestationImg;
@property (weak, nonatomic) IBOutlet UILabel *agelabel;


@property (weak, nonatomic) IBOutlet UIImageView *separator1;
@property (weak, nonatomic) IBOutlet UIImageView *separator2;
@property (weak, nonatomic) IBOutlet UIImageView *buttomBackground;

@end

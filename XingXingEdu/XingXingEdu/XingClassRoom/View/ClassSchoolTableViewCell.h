//
//  ClassSchoolTableViewCell.h
//  XingXingStore
//
//  Created by codeDing on 16/1/28.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassSchoolTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;


@property (weak, nonatomic) IBOutlet UIButton *collect;



@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *studentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *separator1;
@property (weak, nonatomic) IBOutlet UIImageView *separator2;
@property (weak, nonatomic) IBOutlet UIImageView *buttomBackground;


@end

//
//  ClassEditInfoCell.h
//  XingXingEdu
//
//  Created by keenteam on 16/3/23.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
/*
 dataArray;
 titleArray;
 teacherArray
 stateArray;
 picArray;
 */
#import <UIKit/UIKit.h>

@interface ClassEditInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picIamgeV;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *teachLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stateImag;

@end

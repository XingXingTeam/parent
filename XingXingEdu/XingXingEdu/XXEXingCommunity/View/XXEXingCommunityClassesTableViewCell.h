//
//  XXEXingCommunityClassesTableViewCell.h
//  teacher
//
//  Created by Mac on 2016/12/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXEXingCommunityClassesTableViewCell : UITableViewCell

//头像
@property (nonatomic, strong) UIImageView *iconImageView;
//标题
@property (nonatomic, strong) UILabel *titleLabel;
//简介
@property (nonatomic, strong) UILabel *summaryLabel;
//时间
@property (nonatomic, strong) UILabel *timeLabel;

@end

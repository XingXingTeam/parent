//
//  PresentHistoryTableViewCell.h
//  XingXingEdu
//
//  Created by codeDing on 16/2/29.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PresentHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@end

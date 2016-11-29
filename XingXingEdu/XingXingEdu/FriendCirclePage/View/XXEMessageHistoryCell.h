//
//  XXEMessageHistoryCell.h
//  teacher
//
//  Created by codeDing on 16/9/21.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XXEMessageHistoryModel;
@interface XXEMessageHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *messageImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageNickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageConLabel;

@property (weak, nonatomic) IBOutlet UIImageView *contentPic;



/** 给单元格赋值 */

- (void)configerGetCircleMessageHistory:(XXEMessageHistoryModel *)model;

@end

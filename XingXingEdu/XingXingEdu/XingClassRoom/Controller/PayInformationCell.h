//
//  DetailCell.h
//  XingXingEdu
//
//  Created by Mac on 16/5/6.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayInformationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;

@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextField *contentLabel;

@property (weak, nonatomic) IBOutlet UITextField *phoneNum;

@end

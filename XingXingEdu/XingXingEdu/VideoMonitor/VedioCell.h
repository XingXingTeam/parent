//
//  VedioCell.h
//  XingXingEdu
//
//  Created by keenteam on 16/2/15.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VedioCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *VedioBtn;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

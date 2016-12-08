

//
//  XXEStoreConsigneeAddressTableViewCell.m
//  teacher
//
//  Created by Mac on 16/11/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStoreConsigneeAddressTableViewCell.h"

@implementation XXEStoreConsigneeAddressTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _nameLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    
    _phoneLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    
    _defaultAddressLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    
    _addressLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

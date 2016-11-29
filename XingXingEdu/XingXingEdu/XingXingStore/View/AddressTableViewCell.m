//
//  AddressTableViewCell.m
//  XingXingStore
//
//  Created by codeDing on 16/1/25.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "AddressTableViewCell.h"

@implementation AddressTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setName:(NSString *)name{
    _name=name;
    self.nameLabel.text=name;
}
-(void)setPhone:(NSString *)phone{
    _phone=phone;
    self.phoneLabel.text=phone;
}

-(void)setAddress:(NSString *)address{
    _address = address;
    self.addressLabel.text = address;
}

@end

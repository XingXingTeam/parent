//
//  MoneyHistoryTableViewCell.m
//  XingXingStore
//
//  Created by codeDing on 16/1/21.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "MoneyHistoryTableViewCell.h"

@implementation MoneyHistoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDate:(NSString *)date{
    _date=date;
    self.timeLabel.text=date;
}
-(void)setPrice:(NSString *)price{
    _price = price;
    self.priceLabel.text=price;
}
-(void)setUse:(NSString *)use{
    _use = use;
    self.useLabel.text = use;
}

@end

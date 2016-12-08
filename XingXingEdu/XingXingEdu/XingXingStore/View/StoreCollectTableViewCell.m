//
//  StoreCollectTableViewCell.m
//  XingXingStore
//
//  Created by codeDing on 16/1/21.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "StoreCollectTableViewCell.h"

@implementation StoreCollectTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setName:(NSString *)name{
    _name=name;
    self.articleName.text=name;
}

-(void)setDate:(NSString *)date{
    _date=date;
    self.articleDate.text=date;
}
-(void)setPrice:(NSString *)price{
    _price=price;
    self.articlePrice.text=price;
}

-(void)setImg:(NSString *)img{
    _img=img;
    self.articleImageView.image=[UIImage imageNamed:img];
}
@end

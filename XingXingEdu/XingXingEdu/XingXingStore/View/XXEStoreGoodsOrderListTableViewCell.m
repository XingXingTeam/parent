
//
//  XXEStoreGoodsOrderListTableViewCell.m
//  teacher
//
//  Created by Mac on 2016/11/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStoreGoodsOrderListTableViewCell.h"

@implementation XXEStoreGoodsOrderListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        //左边头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 70, 70)];
        [self.contentView addSubview:_iconImageView];
        
        //名称
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100 * kScreenRatioWidth, 10, 150 * kScreenRatioWidth, 20 )];
        _titleLabel.font = [UIFont systemFontOfSize:14 * kWidth / 375];
        [self.contentView addSubview:_titleLabel];
        //合计猩币
        _totalIconTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth - 100, 10, 60, 20)];
        _totalIconTitleLabel.text = @"合计猩币:";
        _totalIconTitleLabel.textColor = [UIColor lightGrayColor];
        _totalIconTitleLabel.font = [UIFont systemFontOfSize:12 * kScreenRatioWidth];
        [self.contentView addSubview:_totalIconTitleLabel];
        
        _totalIconLabel = [[UILabel alloc] initWithFrame:CGRectMake(_totalIconTitleLabel.frame.origin.x + _totalIconTitleLabel.width , 10, 50, 20)];
        _totalIconLabel.textColor = UIColorFromRGB(244, 52, 139);
        _totalIconLabel.font =  [UIFont systemFontOfSize:12 * kScreenRatioWidth];
        [self.contentView addSubview:_totalIconLabel];
        
        //订单编号
        _orderCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(100 * kScreenRatioWidth, _titleLabel.frame.origin.y + _titleLabel.height + 10, 150 * kScreenRatioWidth, 20)];
        _orderCodeLabel.textColor = [UIColor lightGrayColor];
        _orderCodeLabel.font = [UIFont systemFontOfSize:12 * kScreenRatioWidth];
        [self.contentView addSubview:_orderCodeLabel];
        
        //合计 钱
        _moneyTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 100 , _orderCodeLabel.frame.origin.y , 60, 20)];
        _moneyTitleLabel.text = @"合计:";
        _moneyTitleLabel.textColor = [UIColor lightGrayColor];
        _moneyTitleLabel.font = [UIFont systemFontOfSize:12 * kScreenRatioWidth];
        [self.contentView addSubview:_moneyTitleLabel];
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(_moneyTitleLabel.frame.origin.x + _moneyTitleLabel.width, _moneyTitleLabel.frame.origin.y, 50, 20)];
        _moneyLabel.textColor = UIColorFromRGB(244, 52, 139);
        _moneyLabel.font = [UIFont systemFontOfSize:12 * kScreenRatioWidth];
        [self.contentView addSubview:_moneyLabel];
        
        //下单时间
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(100 * kScreenRatioWidth, _orderCodeLabel.frame.origin.y + _orderCodeLabel.height + 10, 150 * kScreenRatioWidth, 20)];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.font = [UIFont systemFontOfSize:12 * kScreenRatioWidth];
        [self.contentView addSubview:_timeLabel];
        
        //note
        _noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 70, _timeLabel.frame.origin.y, 70, 20)];
        _noteLabel.textColor = [UIColor orangeColor];
        _noteLabel.font = [UIFont systemFontOfSize:12 * kScreenRatioWidth];
        [self.contentView addSubview:_noteLabel];

        
    }
    
    return self;
}



@end

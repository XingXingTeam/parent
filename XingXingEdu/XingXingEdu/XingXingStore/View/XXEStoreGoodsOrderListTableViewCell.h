//
//  XXEStoreGoodsOrderListTableViewCell.h
//  teacher
//
//  Created by Mac on 2016/11/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXEStoreGoodsOrderListTableViewCell : UITableViewCell

//头像
@property (nonatomic, strong) UIImageView *iconImageView;
//名称
@property (nonatomic, strong) UILabel *titleLabel;
//合计 猩币 label
@property (nonatomic, strong) UILabel *totalIconTitleLabel;
@property (nonatomic, strong) UILabel *totalIconLabel;

//订单编号
@property (nonatomic, strong) UILabel *orderCodeLabel;
//合计 金额 label
@property (nonatomic, strong) UILabel *moneyTitleLabel;
@property (nonatomic, strong) UILabel *moneyLabel;

//下单时间
@property (nonatomic, strong) UILabel *timeLabel;

//说明
@property (nonatomic, strong) UILabel *noteLabel;


@end

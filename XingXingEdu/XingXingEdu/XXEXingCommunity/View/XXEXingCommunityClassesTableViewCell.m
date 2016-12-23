

//
//  XXEXingCommunityClassesTableViewCell.m
//  teacher
//
//  Created by Mac on 2016/12/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEXingCommunityClassesTableViewCell.h"

@implementation XXEXingCommunityClassesTableViewCell

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
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 75, 75)];
        _iconImageView.layer.cornerRadius = _iconImageView.frame.size.width / 2;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        
        //标题
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageView.frame.origin.x + _iconImageView.width + 10, 10, KScreenWidth - 100, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:14 * kWidth / 375];
        [self.contentView addSubview:_titleLabel];
        
        //分割线 一
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y + _titleLabel.height , KScreenWidth - 100, 1)];
        line1.backgroundColor = UIColorFromRGB(229, 232, 233);
        [self.contentView addSubview:line1];
        
        //简介
        _summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, line1.frame.origin.y + line1.height + 5, KScreenWidth - 100, 20)];
        _summaryLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
        [self.contentView addSubview:_summaryLabel];
        
        //分割线
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(_summaryLabel.frame.origin.x, _summaryLabel.frame.origin.y + _summaryLabel.height, KScreenWidth - 100, 1)];
        line2.backgroundColor = UIColorFromRGB(229, 232, 233);
        [self.contentView addSubview:line2];
        
    
        //时间
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_summaryLabel.frame.origin.x, line2.frame.origin.y + line1.height + 5, KScreenWidth - 100, 20)];
        _timeLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
        [self.contentView addSubview:_timeLabel];
        
        //分割线
        UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(_timeLabel.frame.origin.x, _timeLabel.frame.origin.y + _timeLabel.height, KScreenWidth - 100, 1)];
        line3.backgroundColor = UIColorFromRGB(229, 232, 233);
        [self.contentView addSubview:line3];
        
        
    }
    
    return self;
}


@end

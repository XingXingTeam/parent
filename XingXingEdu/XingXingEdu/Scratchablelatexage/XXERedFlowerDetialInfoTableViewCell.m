

//
//  XXERedFlowerDetialInfoTableViewCell.m
//  teacher
//
//  Created by Mac on 2016/11/30.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERedFlowerDetialInfoTableViewCell.h"

@implementation XXERedFlowerDetialInfoTableViewCell

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
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        [self.contentView addSubview:_iconImageView];
        
        //title
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageView.frame.origin.x + _iconImageView.width + 10, 10, 80 * kScreenRatioWidth, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
        [self.contentView addSubview:_titleLabel];
        
        //content
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x + _titleLabel.width, _iconImageView.frame.origin.y, KScreenWidth - 140 * kScreenRatioWidth, 20)];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
        [self.contentView addSubview:_contentLabel];
    
    }
    return self;

}
@end

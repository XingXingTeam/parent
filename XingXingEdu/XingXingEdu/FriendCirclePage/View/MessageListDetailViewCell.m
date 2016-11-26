//
//  MessageListDetailViewCell.m
//  XingXingEdu
//
//  Created by mac on 16/7/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "MessageListDetailViewCell.h"

@implementation MessageListDetailViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
        self.contentView.backgroundColor = UIColorFromRGB(243, 243, 243);
    
        UIImage *image = [UIImage imageNamed:@"AlbumOperateMore"];
        _commentIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, image.size.width, image.size.width)];
    //第一行的评论图标
        _commentIconImageView.image = image;
//        _commentIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 15, 15)];
//      _commentIconImageView.image = [UIImage imageNamed:@"AlbumOperateMore"];
        [self.contentView addSubview:_commentIconImageView];
    
        //头像
        _headIconImageView = [[UIImageView alloc] init];
//        _headIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 5, 30, 30)];
        [self.contentView addSubview:_headIconImageView];
    
        //名称
        _nickName = [[UILabel alloc] init];
//        _nickName = [[UILabel alloc] initWithFrame:CGRectMake(_headIconImageView.frame.origin.x + _headIconImageView.width + 5, 5, 160 * kScreenRatioWidth, 20)];
    //        _nickName.backgroundColor = [UIColor purpleColor];
            [self.contentView addSubview:_nickName];
    
        //内容
        _contentTextView = [[UITextView alloc] init];
//        _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(_headIconImageView.frame.origin.x + _headIconImageView.width + 5 + _replyLabel.width, _nickName.frame.origin.y + _nickName.height, 250 * kScreenRatioWidth, 40)];
        [self.contentView addSubview:_contentTextView];
    
    
        _dateTime = [[UILabel alloc] init];
//        _dateTime = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 150, 10, 150 * kScreenRatioWidth, 20)];
        [self.contentView addSubview:_dateTime];
    
//        _nickName.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
//        _replyLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
//        _contentTextView.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
//    
//        _dateTime.font = [UIFont systemWithIphone6P:14 Iphone6:12 Iphone5:10 Iphone4:8];
}

-(void)configure:(XXECommentModel*)commentModel isLastCell:(BOOL)isLastCell {
    
    //头像
    NSString * head_img;
    if([commentModel.head_img_type integerValue] == 0){
        head_img=[kXXEPicURL stringByAppendingString:commentModel.head_img];
    }else{
        head_img=commentModel.head_img;
    }
    [_headIconImageView sd_setImageWithURL:[NSURL URLWithString:head_img] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
    _headIconImageView.frame = CGRectMake(30, 5, 30, 30);
    
    //昵称
    if ([commentModel.com_type integerValue] == 1){
        //别人评论
        _otherName = @"";
        _nickName.text = commentModel.commentNicknName;
    }else if ([commentModel.com_type integerValue] == 2){
        //本人 回复
        _otherName = commentModel.to_who_nickname;
        _nickName.text = [NSString stringWithFormat:@"%@ 回复 %@", commentModel.commentNicknName, commentModel.to_who_nickname];
    }
    _nickName.frame = CGRectMake(_headIconImageView.frame.origin.x + _headIconImageView.width + 5, 5, 0, 0);
    _nickName.font = [UIFont systemFontOfSize:12*kScreenRatioHeight];
    [_nickName sizeToFit];
    
    //评论内容
    _contentTextView.text = commentModel.con;
    _contentTextView.backgroundColor = UIColorFromRGB(243, 243, 243);
    _contentTextView.font = [UIFont systemFontOfSize:12*kScreenRatioHeight];
    _contentTextView.frame = CGRectMake(65 , _nickName.frame.origin.y + _nickName.height, kWidth - 60 - 70, 0);
    _contentTextView.userInteractionEnabled = NO;
    _contentTextView.scrollEnabled = NO;
    
    [_contentTextView sizeToFit];
    
    //时间
    _dateTime.text = commentModel.date_tm;
    _dateTime.font = [UIFont systemFontOfSize:12*kScreenRatioHeight];
    _dateTime.textAlignment = NSTextAlignmentRight;
    _dateTime.frame = CGRectMake(100, 5, KScreenWidth - 60 - 105, 12);
    
    
    NSString *string = [XXETool dateStringFromNumberTimer:commentModel.date_tm];
    if (![string isEqualToString:@""]) {
        //2010-9-9 0:0:0
        NSArray *arr = [string componentsSeparatedByString:@" "];
        //
        NSArray *arr1 = [arr[0] componentsSeparatedByString:@"-"];
        //9月9日
        NSString *str1 = [NSString stringWithFormat:@"%@月%@日", arr1[1], arr1[2]];
        NSArray *arr2 = [arr[1] componentsSeparatedByString:@":"];
        NSString *str2 = [NSString stringWithFormat:@"%@:%@", arr2[0], arr2[1]];
        
        NSString *newStr = [NSString stringWithFormat:@"%@ %@", str1, str2];
        _dateTime.text = newStr;
        
    }else {
        _dateTime.text = nil;
    }
    
    if (isLastCell) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.bounds.origin.y + self.contentView.bounds.size.height - 0.5, kWidth - 60, 0.5)];
//        lineView.backgroundColor = UIColorFromRGB(204, 204, 204);
        [self.contentView addSubview:lineView];
    }
    
}
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        
//        //第一行 的 评论 图标
//        _commentIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 15, 15)];
//        _commentIconImageView.image = [UIImage imageNamed:@"AlbumOperateMore"];
//        [self.contentView addSubview:_commentIconImageView];
//        
//        //头像
//        _headIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 5, 30, 30)];
//        [self.contentView addSubview:_headIconImageView];
//        
//        //名称
//        _nickName = [[UILabel alloc] initWithFrame:CGRectMake(_headIconImageView.frame.origin.x + _headIconImageView.width + 5, 5, 160 * kScreenRatioWidth, 20)];
////        _nickName.backgroundColor = [UIColor purpleColor];
//        [self.contentView addSubview:_nickName];
//
//        //内容
//        _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(_headIconImageView.frame.origin.x + _headIconImageView.width + 5 + _replyLabel.width, _nickName.frame.origin.y + _nickName.height, 250 * kScreenRatioWidth, 40)];
//
//
//        [self.contentView addSubview:_contentTextView];
//        
//        
//        _dateTime = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 150, 10, 150 * kScreenRatioWidth, 20)];
//        
//        [self.contentView addSubview:_dateTime];
//        
//        _nickName.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
//        _replyLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
//        _contentTextView.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
//
//        _dateTime.font = [UIFont systemWithIphone6P:14 Iphone6:12 Iphone5:10 Iphone4:8];
//        
//    }
//    
//    return self;
//}

//-(void)configureWithModel(){
//    
//}


@end

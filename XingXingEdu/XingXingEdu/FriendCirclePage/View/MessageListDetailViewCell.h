//
//  MessageListDetailViewCell.h
//  XingXingEdu
//
//  Created by mac on 16/7/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXECommentModel.h"
@interface MessageListDetailViewCell : UITableViewCell

//判断 评论 类型 1:别人的评论   2:自己回复
@property (nonatomic, copy) NSString *com_type;

//id
@property (nonatomic,copy) NSString *talkId;

//评论 图标
@property (nonatomic, strong) UIImageView *commentIconImageView;
//头像
@property (nonatomic, strong) UIImageView *headIconImageView;
//昵称
@property (nonatomic,strong) UILabel *nickName;
//评论内容
@property (nonatomic,strong) UITextView *contentTextView;

//时间
@property (nonatomic,strong) UILabel *dateTime;
//回复
@property (nonatomic,strong) UILabel *replyLabel;
//回复 对象 名称
@property (nonatomic, copy) NSString *otherName;


-(void)configure:(XXECommentModel*)commentModel isLastCell:(BOOL)isLastCell;
@end

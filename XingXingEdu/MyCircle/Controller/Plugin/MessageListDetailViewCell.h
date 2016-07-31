//
//  MessageListDetailViewCell.h
//  XingXingEdu
//
//  Created by mac on 16/7/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageListDetailViewCell : UITableViewCell

//图片名字
@property (nonatomic,strong) UIImageView *imageName;
//id
@property (nonatomic,copy) NSString *talkId;
//评论内容
@property (nonatomic,strong) UILabel *con;
//昵称
@property (nonatomic,strong) UILabel *nickName;
//时间
@property (nonatomic,strong) UILabel *dateTime;

@end

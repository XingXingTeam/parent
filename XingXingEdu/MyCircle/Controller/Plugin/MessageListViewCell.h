//
//  MessageListViewCell.h
//  XingXingEdu
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageListViewCell : UITableViewCell

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

//
//  XXEPublishFriendCircleApi.m
//  teacher
//
//  Created by codeDing on 16/9/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEPublishFriendCircleApi.h"

@implementation XXEPublishFriendCircleApi{
    
    NSString *_position;
    NSString *_file_type;
    NSString *_words;
    NSString *_pic_group;
    NSString *_video_url;
    NSString *_userXid;
    NSString *_userId;
    NSString *_circle_set;
}

- (id)initWithPublishFriendCirclePosition:(NSString *)position FileType:(NSString *)fileType Words:(NSString *)words PicGroup:(NSString *)picGroup VideoUrl:(NSString *)video_url CircleSet:(NSString *)circle_set UserXid:(NSString *)userXid UserId:(NSString *)userId
{
    self = [super init];
    if (self) {
        _position = position;
        _file_type = fileType;
        _pic_group = picGroup;
        _video_url = video_url;
        _userXid = userXid;
        _userId = userId;
        _words = words;
        _circle_set = circle_set;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXEPublishFriendCircleUrl];
}

- (id)requestArgument
{
    return @{@"xid":_userXid,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"user_id":_userId,
             @"user_type":USER_TYPE,
             @"position":_position,
             @"file_type":_file_type,
             @"words":_words,
             @"pic_group":_pic_group,
             @"circle_set":_circle_set,
             @"video_url":_video_url
             };
}

@end

//
//  XXEDeleteCommentApi.m
//  teacher
//
//  Created by codeDing on 16/9/18.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEDeleteCommentApi.h"

@implementation XXEDeleteCommentApi{
    NSString *_userXid;
    NSString *_userId;
    NSString *_event_type;
    NSString *_talk_id;
    NSString *_comment_id;
}


- (id)initWithDeleteCommentEventType:(NSString *)eventType TalkId:(NSString *)talkId CommentId:(NSString *)commentId UserXid:(NSString *)userXid UserId:(NSString *)userId
{
    self = [super init];
    if (self) {
        _userXid = userXid;
        _userId = userId;
        _event_type = eventType;
        _talk_id = talkId;
        _comment_id = commentId;
    }
    return self;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXEDeleteCommenturl];
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (id)requestArgument
{
    return @{@"xid":_userXid,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"user_id":_userId,
             @"user_type":USER_TYPE,
             @"event_type":_event_type,
             @"comment_id":_comment_id,
             @"talk_id":_talk_id};
}


@end

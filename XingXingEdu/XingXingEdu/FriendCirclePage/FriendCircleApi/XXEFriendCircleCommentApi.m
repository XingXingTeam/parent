//
//  XXEFriendCircleCommentApi.m
//  teacher
//
//  Created by codeDing on 16/9/6.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEFriendCircleCommentApi.h"

@implementation XXEFriendCircleCommentApi{
    NSString *_userXid;
    NSString *_userId;
    NSString *_talkId;
    NSString *_com_type;
    NSString *_con;
    NSString *_to_who_xid;
}

- (id)initWithFriendCircleCommentUerXid:(NSString *)userXid UserID:(NSString *)userId TalkId:(NSString *)talkId Com_type:(NSString *)com_type Con:(NSString *)con To_Who_Xid:(NSString *)to_who_xid
{
    self = [super init];
    if (self) {
        _userXid = userXid;
        _userId = userId;
        _talkId = talkId;
        _com_type = com_type;
        _con = con;
        _to_who_xid = to_who_xid;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXEFriendCircleCommentUrl];
}

- (id)requestArgument
{
    return @{@"xid":_userXid,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"user_id":_userId,
             @"user_type":USER_TYPE,
             @"talk_id":_talkId,
             @"con":_con,
             @"to_who_xid":_to_who_xid,
             @"com_type":_com_type
             };
}

@end

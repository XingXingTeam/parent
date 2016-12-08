//
//  XXEFriendCirclegoodApi.m
//  teacher
//
//  Created by codeDing on 16/9/6.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEFriendCirclegoodApi.h"

@implementation XXEFriendCirclegoodApi{
    NSString *_userXid;
    NSString *_userId;
    NSString *_talkId;
}

- (id)initWithFriendCircleGoodOrCancelUerXid:(NSString *)userXid UserID:(NSString *)userId TalkId:(NSString *)talkId
{
    self = [super init];
    if (self) {
        _userXid = userXid;
        _userId = userId;
        _talkId = talkId;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXEFriendCircleGoodUrl];
}

- (id)requestArgument
{
    return @{@"xid":_userXid,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"user_id":_userId,
             @"user_type":USER_TYPE,
             @"talk_id":_talkId};
}



@end

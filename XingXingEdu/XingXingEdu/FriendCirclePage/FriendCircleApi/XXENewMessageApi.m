//
//  XXENewMessageApi.m
//  teacher
//
//  Created by codeDing on 16/9/21.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXENewMessageApi.h"

@implementation XXENewMessageApi
{
    NSString *_newUserXid;
    NSString *_newUserId;
}

- (id)initWithNewMeesageHistoryUserXid:(NSString *)userXid UserId:(NSString *)userId
{
    self = [super init];
    if (self) {
        _newUserXid = userXid;
        _newUserId = userId;
    }
    return self;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXECircleNewMessageUrl];
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (id)requestArgument
{
    return @{@"xid":_newUserXid,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"user_id":_newUserId,
             @"user_type":USER_TYPE,
             };
}


@end

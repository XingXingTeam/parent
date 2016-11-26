//
//  XXEMessageHistoryApi.m
//  teacher
//
//  Created by codeDing on 16/9/21.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMessageHistoryApi.h"

@implementation XXEMessageHistoryApi{
    NSString *_userXid;
    NSString *_userId;
}

- (id)initWithCircleMeesageHistoryUserXid:(NSString *)userXid UserId:(NSString *)userId
{
    self = [super init];
    if (self) {
        _userXid = userXid;
        _userId = userId;
    }
    return self;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXEMessageHistoryUrl];
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
             };
}
@end

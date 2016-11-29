//
//  XXEFriendCircleApi.m
//  teacher
//
//  Created by codeDing on 16/8/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEFriendCircleApi.h"

@implementation XXEFriendCircleApi{
    NSString *_xid;
    NSString *_pageNum;
    NSString *_userId;

}

- (id)initWithFriendCircleXid:(NSString *)xid CircleUserId:(NSString *)userId  PageNumber:(NSString *)pageNum
{
    self = [super init];
    if (self) {
        _xid = xid;
        _pageNum = pageNum;
        _userId = userId;

    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXEFriendCircleUrl];
}

- (id)requestArgument
{
    return @{@"page":_pageNum,
             @"xid":_xid,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"user_id":_userId,
             @"user_type":USER_TYPE
             };
}

@end

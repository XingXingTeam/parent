//
//  XXEFriendMyCircleApi.m
//  teacher
//
//  Created by codeDing on 16/9/6.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEFriendMyCircleApi.h"

@implementation XXEFriendMyCircleApi{
    NSString *_otherXid;
    NSString *_page;
    NSString *_userId;
    NSString *_myCircleXid;
}

- (id)initWithChechFriendCircleOtherXid:(NSString *)otherXid page:(NSString *)page UserId:(NSString *)userId MyCircleXid:(NSString *)myCircleXid
{
    self = [super init];
    if (self) {
        _otherXid = otherXid;
        _page = page;
        _userId = userId;
        _myCircleXid = myCircleXid;
    }
    return self;
}

-(YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXECheckFriendCircleUrl];
}

- (id)requestArgument
{
    return @{@"page":_page,
             @"other_xid":_otherXid,
             @"xid":_myCircleXid,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"user_id":_userId,
             @"user_type":USER_TYPE
             };
}

@end

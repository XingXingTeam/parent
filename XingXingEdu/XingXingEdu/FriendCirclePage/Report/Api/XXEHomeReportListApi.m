//
//  XXEHomeReportListApi.m
//  teacher
//
//  Created by codeDing on 16/8/26.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEHomeReportListApi.h"

@implementation XXEHomeReportListApi{
    NSString *_userId;
    NSString *_xid;
}

- (id)initWithToReportListUserId:(NSString *)userId XXID:(NSString *)xid
{
    self = [super init];
    if (self) {
        _userId = userId;
        _xid = xid;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXEHomeReportListUrl];
}

- (id)requestArgument
{
    return @{@"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"user_type":USER_TYPE,
             @"xid":_xid,
             @"user_id":_userId
             };
}


@end

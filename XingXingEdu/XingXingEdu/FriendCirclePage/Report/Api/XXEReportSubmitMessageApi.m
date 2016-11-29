//
//  XXEReportSubmitMessageApi.m
//  teacher
//
//  Created by codeDing on 16/8/26.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEReportSubmitMessageApi.h"
#import "XXEHeaderApi.h"
@implementation XXEReportSubmitMessageApi{
    NSString *_userId;
    NSString *_userXid;
    NSString *_otherXid;
    NSString *_reportNameId;
    NSString *_reportType;
    NSString *_photoUrl;
    NSString *_originPage;
}


- (id)initWithReportSubmitUserID:(NSString *)userID UserXID:(NSString *)userXid OtherXid:(NSString *)otherXid ReportNameId:(NSString *)reportNameId ReportType:(NSString *)reportType PhotoUrl:(NSString *)photoUrl OriginPage:(NSString *)originPage
{
    self = [super init];
    if (self) {
        _userId = userID;
        _userXid = userXid;
        _otherXid = otherXid;
        _reportNameId = reportNameId;
        _reportType = reportType;
        _photoUrl = photoUrl;
        _originPage = originPage;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXEHomeReportSubmitUrl];
}

- (id)requestArgument
{
    return @{@"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"user_type":USER_TYPE,
             @"xid":_userXid,
             @"user_id":_userId,
             @"other_xid":_otherXid,
             @"report_name_id":_reportNameId,
             @"report_type":_reportType,
             @"url":_photoUrl,
             @"origin_page":_originPage
             };
}

@end

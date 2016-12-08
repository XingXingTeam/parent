//
//  XXEReportSubmitMessageApi.h
//  teacher
//
//  Created by codeDing on 16/8/26.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXEReportSubmitMessageApi : YTKRequest

- (id)initWithReportSubmitUserID:(NSString *)userID UserXID:(NSString *)userXid OtherXid:(NSString *)otherXid ReportNameId:(NSString *)reportNameId ReportType:(NSString *)reportType PhotoUrl:(NSString *)photoUrl OriginPage:(NSString *)originPage;

@end

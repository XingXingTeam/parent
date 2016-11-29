//
//  XXEHomeReportListApi.h
//  teacher
//
//  Created by codeDing on 16/8/26.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXEHomeReportListApi : YTKRequest

- (id)initWithToReportListUserId:(NSString *)userId XXID:(NSString *)xid;

@end

//
//  XXEMessageHistoryApi.h
//  teacher
//
//  Created by codeDing on 16/9/21.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXEMessageHistoryApi : YTKRequest

- (id)initWithCircleMeesageHistoryUserXid:(NSString *)userXid UserId:(NSString *)userId;

@end

//
//  NotificationService.m
//  XingXingEdu
//
//  Created by codeDing on 16/12/23.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#define kSystemNoticationUrl @"http://www.xingxingedu.cn/Global/official_notice"
#define KSchoolNoticationUrl @"http://www.xingxingedu.cn/Parent/school_notice"

#import "NotificationService.h"
#import "ServiceManager.h"
static NotificationService *handle = nil;
@implementation NotificationService
//创建单例类
+ (NotificationService*)sharedInstance {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!handle) {
            handle = [[NotificationService alloc] init];
        }
    });
    return handle;
}

//MARK: - 系统消息请求
- (void)systemNotificationRequestWithparameters:(id)parameters succeed:(void (^)(id request))succeed fail:(void (^)())fail {
    NSString *requestURL = kSystemNoticationUrl;
    [[ServiceManager sharedInstance] requestWithURLString:requestURL parameters:parameters type:1 success:^(id responseObject) {
        if (!responseObject) {
            fail();
        }else {
            succeed(responseObject);
        }
    } failure:^(NSError *error) {
        fail();
    }];
}

//MARK: - 校园通知请求
- (void)schoolNotificationRequestWithparameters:(id)parameters succeed:(void (^)(id request))succeed fail:(void (^)())fail {
    NSString *requestURL = KSchoolNoticationUrl;
    [[ServiceManager sharedInstance] requestWithURLString:requestURL parameters:parameters type:1 success:^(id responseObject) {
        if (!responseObject) {
            fail();
        }else {
            succeed(responseObject);
        }
    } failure:^(NSError *error) {
        fail();
    }];
}

@end

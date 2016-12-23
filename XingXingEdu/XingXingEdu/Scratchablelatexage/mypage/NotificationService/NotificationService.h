//
//  NotificationService.h
//  XingXingEdu
//
//  Created by codeDing on 16/12/23.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kNotificationServiceInstance [NotificationService sharedInstance]
@interface NotificationService : NSObject
+ (instancetype)sharedInstance;
//MARK: - 系统消息请求
- (void)systemNotificationRequestWithparameters:(id)parameters succeed:(void (^)(id request))succeed fail:(void (^)())fail;

//MARK: - 校园通知请求
- (void)schoolNotificationRequestWithparameters:(id)parameters succeed:(void (^)(id request))succeed fail:(void (^)())fail;
@end

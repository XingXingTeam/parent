//
//  XXEEveryTalkDetailApi.h
//  teacher
//
//  Created by Mac on 16/11/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXEEveryTalkDetailApi : YTKRequest

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id talk_id:(NSString *)talk_id;

@end

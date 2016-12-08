//
//  XXEFriendCirclegoodApi.h
//  teacher
//
//  Created by codeDing on 16/9/6.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXEFriendCirclegoodApi : YTKRequest

- (id)initWithFriendCircleGoodOrCancelUerXid:(NSString *)userXid UserID:(NSString *)userId TalkId:(NSString *)talkId;

@end

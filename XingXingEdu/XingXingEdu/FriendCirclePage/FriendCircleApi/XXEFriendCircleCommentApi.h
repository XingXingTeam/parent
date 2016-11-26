//
//  XXEFriendCircleCommentApi.h
//  teacher
//
//  Created by codeDing on 16/9/6.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXEFriendCircleCommentApi : YTKRequest

- (id)initWithFriendCircleCommentUerXid:(NSString *)userXid UserID:(NSString *)userId TalkId:(NSString *)talkId Com_type:(NSString *)com_type Con:(NSString *)con To_Who_Xid:(NSString *)to_who_xid;

@end

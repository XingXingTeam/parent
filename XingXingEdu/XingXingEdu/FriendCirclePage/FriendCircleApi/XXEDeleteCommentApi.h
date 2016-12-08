//
//  XXEDeleteCommentApi.h
//  teacher
//
//  Created by codeDing on 16/9/18.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXEDeleteCommentApi : YTKRequest
- (id)initWithDeleteCommentEventType:(NSString *)eventType TalkId:(NSString *)talkId CommentId:(NSString *)commentId UserXid:(NSString *)userXid UserId:(NSString *)userId;

@end

//
//  FriendCircleService.h
//  XingXingEdu
//
//  Created by codeDing on 16/11/26.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendCircleService : NSObject
+ (instancetype)sharedInstance;

-(void)friendCircleListRequestWithparameters:(id)parameters succeed:(void (^)(id))succeed fail:(void (^)())fail;

-(void)friendCirclePublishRequestWithparameters:(id)parameters succeed:(void (^)(id request))succeed fail:(void (^)())fail;

//MARK: - 点赞
-(void)friendCircleGoodOrCancelUserXid:(NSString *)userXid UserID:(NSString *)userId TalkId:(NSString *)talkId succeed:(void (^)(id request))succeed fail:(void (^)())fail;

//MARK: - 评论/回复
-(void)friendCircleCommentUerXid:(NSString *)userXid UserID:(NSString *)userId TalkId:(NSString *)talkId Com_type:(NSString *)com_type Con:(NSString *)con To_Who_Xid:(NSString *)to_who_xid succeed:(void (^)(id request))succeed fail:(void (^)())fail;

//MARK: - 删除评论
-(void)friendCircleDeleteCommentEventType:(NSString *)eventType TalkId:(NSString *)talkId CommentId:(NSString *)commentId UserXid:(NSString *)userXid UserId:(NSString *)userId succeed:(void (^)(id request))succeed fail:(void (^)())fail;

//MARK: - 新消息
-(void)friendCircleNewMeesageHistoryUserXid:(NSString *)userXid UserId:(NSString *)userId succeed:(void (^)(id request))succeed fail:(void (^)())fail;

//MARK: - 查看某一人的圈子
-(void)friendCircleCheckOtherCircleWithXid:(NSString *)otherXid page:(NSString *)page UserId:(NSString *)userId MyCircleXid:(NSString *)myCircleXid succeed:(void (^)(id request))succeed fail:(void (^)())fail;

-(void)friendCircleTalkDetailWithXid:(NSString *)xid user_id:(NSString *)user_id talk_id:(NSString *)talk_id succeed:(void (^)(id request))succeed fail:(void (^)())fail;

//MARK: - 历史消息
-(void)friendCircleHistoryMessageWithUserXid:(NSString *)userXid UserId:(NSString *)userId succeed:(void (^)(id request))succeed fail:(void (^)())fail;

@end

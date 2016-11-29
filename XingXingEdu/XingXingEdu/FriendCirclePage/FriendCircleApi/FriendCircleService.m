//
//  FriendCircleService.m
//  XingXingEdu
//
//  Created by codeDing on 16/11/26.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "FriendCircleService.h"
#import "ServiceManager.h"
#import <JSONModel/JSONModel.h>

@implementation FriendCircleService

static id _instance = nil;
+ (instancetype)sharedInstance {
    return [[self alloc] init];
}

//MARK: - 圈子列表请求
-(void)friendCircleListRequestWithparameters:(id)parameters succeed:(void (^)(id request))succeed fail:(void (^)())fail{
    NSString *requestURL = XXEFriendCircleUrl;
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


//MARK: - 圈子发布
-(void)friendCirclePublishRequestWithparameters:(id)parameters succeed:(void (^)(id request))succeed fail:(void (^)())fail{
    NSString *requestURL = XXEPublishFriendCircleUrl;
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

//MARK: - 点赞
-(void)friendCircleGoodOrCancelUserXid:(NSString *)userXid UserID:(NSString *)userId TalkId:(NSString *)talkId succeed:(void (^)(id request))succeed fail:(void (^)())fail {
    NSDictionary *parameters = @{@"xid":userXid,
                           @"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"user_id":userId,
                           @"user_type":USER_TYPE,
                           @"talk_id":talkId};
    NSString *requestURL = XXEFriendCircleGoodUrl;
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

//MARK: - 评论/回复
-(void)friendCircleCommentUerXid:(NSString *)userXid UserID:(NSString *)userId TalkId:(NSString *)talkId Com_type:(NSString *)com_type Con:(NSString *)con To_Who_Xid:(NSString *)to_who_xid succeed:(void (^)(id request))succeed fail:(void (^)())fail {
    NSDictionary *parameters = @{@"xid":userXid,
                                 @"appkey":APPKEY,
                                 @"backtype":BACKTYPE,
                                 @"user_id":userId,
                                 @"user_type":USER_TYPE,
                                 @"talk_id":talkId,
                                 @"con":con,
                                 @"to_who_xid":to_who_xid,
                                 @"com_type":com_type
//                                 @"return_param_all": @"1"
                                 };
    NSString *requestURL = XXEFriendCircleCommentUrl;
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

//MARK: - 删除评论
-(void)friendCircleDeleteCommentEventType:(NSString *)eventType TalkId:(NSString *)talkId CommentId:(NSString *)commentId UserXid:(NSString *)userXid UserId:(NSString *)userId succeed:(void (^)(id request))succeed fail:(void (^)())fail {
    NSDictionary *parameters = @{@"xid":userXid,
                          @"appkey":APPKEY,
                          @"backtype":BACKTYPE,
                          @"user_id":userId,
                          @"user_type":USER_TYPE,
                          @"event_type":eventType,
                          @"comment_id":commentId,
                          @"talk_id":talkId};
    NSString *requestURL = XXEDeleteCommenturl;
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

//MARK: - 新消息
-(void)friendCircleNewMeesageHistoryUserXid:(NSString *)userXid UserId:(NSString *)userId succeed:(void (^)(id request))succeed fail:(void (^)())fail {
    NSDictionary *parameters = @{@"xid":userXid,
                          @"appkey":APPKEY,
                          @"backtype":BACKTYPE,
                          @"user_id":userId,
                          @"user_type":USER_TYPE,
                          };
    NSString *requestURL = XXECircleNewMessageUrl;
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

//MARK: - 查看某一人的圈子
-(void)friendCircleCheckOtherCircleWithXid:(NSString *)otherXid page:(NSString *)page UserId:(NSString *)userId MyCircleXid:(NSString *)myCircleXid succeed:(void (^)(id request))succeed fail:(void (^)())fail {
    NSDictionary *parameters = @{@"page":page,
                                 @"other_xid":otherXid,
                                 @"xid":myCircleXid,
                                 @"appkey":APPKEY,
                                 @"backtype":BACKTYPE,
                                 @"user_id":userId,
                                 @"user_type":USER_TYPE
                                 };
    NSString *requestURL = XXECheckFriendCircleUrl;
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

-(void)friendCircleTalkDetailWithXid:(NSString *)xid user_id:(NSString *)user_id talk_id:(NSString *)talk_id succeed:(void (^)(id request))succeed fail:(void (^)())fail {
    NSDictionary *parameters = @{
                                 @"appkey":APPKEY,
                                 @"backtype":BACKTYPE,
                                 @"xid":xid,
                                 @"user_id":user_id,
                                 @"user_type":USER_TYPE,
                                 @"talk_id":talk_id
                                 };
    NSString *requestURL = XXEEveryTalkDetailUrl;
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

//MARK: - 历史消息
-(void)friendCircleHistoryMessageWithUserXid:(NSString *)userXid UserId:(NSString *)userId succeed:(void (^)(id request))succeed fail:(void (^)())fail {
    NSDictionary *parameters = @{@"xid":userXid,
                                 @"appkey":APPKEY,
                                 @"backtype":BACKTYPE,
                                 @"user_id":userId,
                                 @"user_type":USER_TYPE,
                                 };
    NSString *requestURL = XXEMessageHistoryUrl;
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

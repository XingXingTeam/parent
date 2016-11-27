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

//圈子列表请求
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

//圈子发布
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


@end

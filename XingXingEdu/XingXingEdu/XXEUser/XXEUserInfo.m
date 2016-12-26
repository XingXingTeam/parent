//
//  XXEUserInfo.m
//  XMPPDemo
//
//  Created by codeDing on 16/7/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEUserInfo.h"
#import "YTKKeyValueStore.h"

@interface XXEUserInfo ()

@end

static XXEUserInfo *user = nil;
static NSString *tableName = @"user_table";
static NSString *userInfo_key = @"userInfo";

@implementation XXEUserInfo

+ (instancetype)user
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[super allocWithZone:nil]init];
    });
    return user;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self user];
}

- (instancetype)init
{
    if (user) {
        return user;
    }
    self = [super init];
    if (self) {
        YTKKeyValueStore *store = [[YTKKeyValueStore alloc]initDBWithName:@"data.db"];
        NSDictionary *userInfo = [store getObjectById:userInfo_key fromTable:tableName];
        if (userInfo) {
            [self setupUserInfoWithUserInfo:userInfo];
        }
        else {
            _account = nil;
            _user_head_img = nil;
            _nickname = nil;
            _user_type = nil;
            _passWord = nil;
            _user_id = nil;
            _token = nil;
            _xid = nil;
            _qqNumber = nil;
            _weixin = nil;
            _sinaNumber = nil;
            _zhifubao = nil;
            _login_times = nil;
            _login = NO;
            _login_type = nil;
        }
    }
    return self;
}


- (void)setupUserInfoWithUserInfo:(NSDictionary *)userInfo
{
    _account = userInfo[@"account"];
    _user_head_img = userInfo[@"user_head_img"];
    _nickname = userInfo[@"nickname"];
    _user_type = userInfo[@"user_type"];
    _qqNumber = userInfo[@"qqNumber"];
    _sinaNumber = userInfo[@"sinaNumber"];
    _weixin = userInfo[@"weixin"];
    _zhifubao = userInfo[@"zhifubao"];
    _token = userInfo[@"token"];
    _xid = userInfo[@"xid"];
    _user_id = userInfo[@"user_id"];
    _login = [userInfo[@"loginStatus"] boolValue]?:NO;
    _login_times = userInfo[@"login_times"];
    _login_type = userInfo[@"login_type"];
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc]initDBWithName:@"data.db"];
    [store createTableWithName:tableName];
     
    [store putObject:userInfo withId:userInfo_key intoTable:tableName];
}

- (void)synchronizeDefaultsInfo
{
    if (self.xid) {
        NSDictionary *userInfo = @{@"account":self.account,
                                   @"user_head_img":self.user_head_img,
                                   @"nickname":self.nickname,
                                   @"user_type":self.user_type,
                                   @"token":self.token,
                                   @"xid":self.xid,
                                   @"qqNumber":self.qqNumber,
                                   @"weixin":self.weixin?self.weixin:@"",
                                   @"sinaNumber":self.sinaNumber?self.sinaNumber:@"",
                                   @"password":self.passWord?self.passWord:@"",
                                   @"zhifubao":self.zhifubao?self.zhifubao:@"",
                                   @"loginStatus":[NSNumber numberWithBool:self.login],
                                   @"login_times":self.login_times,
                                   @"login_type":self.login_type,
                                   };
        YTKKeyValueStore *store = [[YTKKeyValueStore alloc]initDBWithName:@"data.db"];
        [store putObject:userInfo withId:userInfo_key intoTable:tableName];
    }
}

- (void)cleanUserInfo
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc]initDBWithName:@"data.db"];
    [store clearTable:tableName];
}

@end

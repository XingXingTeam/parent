

//
//  XXEEveryTalkDetailApi.m
//  teacher
//
//  Created by Mac on 16/11/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEEveryTalkDetailApi.h"



@interface XXEEveryTalkDetailApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *talk_id;


@end


@implementation XXEEveryTalkDetailApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id talk_id:(NSString *)talk_id{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _talk_id = talk_id;
        
    }
    return self;
}


- (NSString *)requestUrl{
    return XXEEveryTalkDetailUrl;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPost;
    
}

- (id)requestArgument{
    
    return @{
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"xid":_xid,
             @"user_id":_user_id,
             @"user_type":USER_TYPE,
             @"talk_id":_talk_id
             };
    
}


@end

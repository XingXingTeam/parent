//
//  XXEAllImageCollectionApi.m
//  teacher
//
//  Created by Mac on 16/9/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEAllImageCollectionApi.h"

#define URL @"http://www.xingxingedu.cn/Global/col_pic_all"

@interface XXEAllImageCollectionApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *url;

@end


@implementation XXEAllImageCollectionApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id url:(NSString *)url{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _url = url;
    }
    return self;
}


- (NSString *)requestUrl{
    return URL;
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
             @"url":_url
             };
    
}


@end

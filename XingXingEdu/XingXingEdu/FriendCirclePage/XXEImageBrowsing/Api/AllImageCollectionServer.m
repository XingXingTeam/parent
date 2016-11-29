//
//  AllImageCollectionServer.m
//  XingXingEdu
//
//  Created by codeDing on 16/11/29.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "AllImageCollectionServer.h"
#import "ServiceManager.h"
@implementation AllImageCollectionServer
static id _instance = nil;
+ (instancetype)sharedInstance {
    return [[self alloc] init];
}

-(void)allImageCollectionWitnXid:(NSString *)xid user_id:(NSString *)user_id url:(NSString *)url succeed:(void (^)(id request))succeed fail:(void (^)())fail {
    NSDictionary *parameters = @{
                                 @"appkey":APPKEY,
                                 @"backtype":BACKTYPE,
                                 @"xid":xid,
                                 @"user_id":user_id,
                                 @"user_type":USER_TYPE,
                                 @"url":url
                                 };
    NSString *requestURL = @"http://www.xingxingedu.cn/Global/col_pic_all";
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

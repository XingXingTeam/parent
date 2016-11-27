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
@end

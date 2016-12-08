//
//  XXEFriendMyCircleApi.h
//  teacher
//
//  Created by codeDing on 16/9/6.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXEFriendMyCircleApi : YTKRequest

- (id)initWithChechFriendCircleOtherXid:(NSString *)otherXid page:(NSString *)page UserId:(NSString *)userId MyCircleXid:(NSString *)myCircleXid;

@end

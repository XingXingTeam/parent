//
//  NetManager.h
//  XingXingEdu
//
//  Created by codeDing on 16/4/18.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetManager : NSObject
+(void)get_user_coinWithXid:(NSString *)xid WithSuccessBlock:(void (^)(NSString *coin))successBlock failBlock:(void (^)(NSError * error))failBlock;
@end

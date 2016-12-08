//
//  WZYHttpTool.h
//  XingXingEdu
//
//  Created by Mac on 16/5/31.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZYHttpTool : NSObject

//GET 请求
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;

//POST 请求
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;


@end

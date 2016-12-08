




//
//  WZYHttpTool.m
//  XingXingEdu
//
//  Created by Mac on 16/5/31.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "WZYHttpTool.h"
#import "AFNetworking.h"


@implementation WZYHttpTool

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    //1、获得请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //添加可接受类型
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    //2、发送GET请求
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];

}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    //1、获得请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //2、添加 可接受类型
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
     
    //3、发送请求
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
    if([[NSString stringWithFormat:@"%@",responseObject[@"code"]]isEqualToString:@"1000"])
        {
            [SVProgressHUD showErrorWithStatus:@"1000"];
            return ;
        }
        else if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]]isEqualToString:@"1001"]){
         [SVProgressHUD showErrorWithStatus:@"1001"];
            return;
        
        }
        else if (success){
          success(responseObject);
        
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}


@end

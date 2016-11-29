//
//  NetManager.m
//  XingXingEdu
//
//  Created by codeDing on 16/4/18.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "NetManager.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
@implementation NetManager

+(void)get_user_coinWithXid:(NSString *)xid WithSuccessBlock:(void (^)(NSString *coin))successBlock failBlock:(void (^)(NSError * error))failBlock{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/get_user_coin";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
  
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":xid,
                           @"user_id":@"1",
                           @"user_type":USER_TYPE,
                           };

   
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSLog(@"%@",dict);
        
    if (dict) {
        
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
            {
                
                successBlock(dict[@"data"][@"coin_able"]);
            }
        
         else
           {
             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"获取信息失败，%@",dict[@"msg"]]];
           }
    }
    else{
             [SVProgressHUD showErrorWithStatus:@"获取信息失败"];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         failBlock(error);
     }];


   
}
@end

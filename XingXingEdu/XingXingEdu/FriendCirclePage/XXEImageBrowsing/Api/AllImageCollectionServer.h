//
//  AllImageCollectionServer.h
//  XingXingEdu
//
//  Created by codeDing on 16/11/29.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllImageCollectionServer : NSObject
+ (instancetype)sharedInstance;
-(void)allImageCollectionWitnXid:(NSString *)xid user_id:(NSString *)user_id url:(NSString *)url succeed:(void (^)(id request))succeed fail:(void (^)())fail;
@end

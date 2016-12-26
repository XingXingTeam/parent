//
//  GlobalVariable.h
//  teacher
//
//  Created by codeDing on 16/12/14.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ChatBadgeHave,
    ChatBadgeNone,
    
} ChatBadgeType;

//苹果审核状态
typedef NS_ENUM(NSInteger, AppleVerify){
    AppleVerifyHave,
    AppleVerifyNo
};

@interface GlobalVariable : NSObject
+ (GlobalVariable *)shareInstance;

@property(nonatomic ,copy)NSString *appStoreURL;
@property(nonatomic)ChatBadgeType chatBagdeType;
@property(nonatomic)AppleVerify appleVerify;

//版本号请求完成
@property(nonatomic)BOOL isVersionRequestDone;

@end

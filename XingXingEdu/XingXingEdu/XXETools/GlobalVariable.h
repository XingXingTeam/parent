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

@interface GlobalVariable : NSObject
+ (GlobalVariable *)shareInstance;

@property(nonatomic ,copy)NSString *appStoreURL;
@property(nonatomic)ChatBadgeType chatBagdeType;

@end

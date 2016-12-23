//
//  GlobalVariable.m
//  teacher
//
//  Created by codeDing on 16/12/14.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "GlobalVariable.h"
static GlobalVariable *single = nil;
@implementation GlobalVariable
+ (GlobalVariable *)shareInstance {
    static dispatch_once_t OnceToken;
    dispatch_once(&OnceToken, ^{
        if (single == nil) {
            single = [[GlobalVariable alloc] init];
        }
    });
    return single;
}
@end

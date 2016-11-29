
//
//  XXESchoolNotificationModel.m
//  XingXingEdu
//
//  Created by Mac on 16/9/13.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "XXESchoolNotificationModel.h"

@implementation XXESchoolNotificationModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXESchoolNotificationModel *model = [[XXESchoolNotificationModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"notice_id"
                                                       }];
}


@end

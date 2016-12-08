
//
//  XXERongCloudPhoneNumListModel.m
//  teacher
//
//  Created by Mac on 16/10/13.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERongCloudPhoneNumListModel.h"

@implementation XXERongCloudPhoneNumListModel


+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXERongCloudPhoneNumListModel *model = [[XXERongCloudPhoneNumListModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"phoneNum_id"
                                                       }];
}

@end

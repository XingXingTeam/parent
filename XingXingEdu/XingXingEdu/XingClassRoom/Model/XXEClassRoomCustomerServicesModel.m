
//
//  XXEClassRoomCustomerServicesModel.m
//  XingXingEdu
//
//  Created by Mac on 2016/12/13.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "XXEClassRoomCustomerServicesModel.h"

@implementation XXEClassRoomCustomerServicesModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXEClassRoomCustomerServicesModel *model = [[XXEClassRoomCustomerServicesModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"service_id"
                                                       }];
}


@end

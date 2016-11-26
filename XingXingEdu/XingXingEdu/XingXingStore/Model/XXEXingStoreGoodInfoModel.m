
//
//  XXEXingStoreGoodInfoModel.m
//  XingXingEdu
//
//  Created by Mac on 16/10/13.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "XXEXingStoreGoodInfoModel.h"

@implementation XXEXingStoreGoodInfoModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXEXingStoreGoodInfoModel *model = [[XXEXingStoreGoodInfoModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"good_id",
                                                       @"class":@"class_id"
                                                       }];
}


@end

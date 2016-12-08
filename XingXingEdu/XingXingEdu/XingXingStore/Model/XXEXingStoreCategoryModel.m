
//
//  XXEXingStoreCategoryModel.m
//  XingXingEdu
//
//  Created by Mac on 16/10/13.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "XXEXingStoreCategoryModel.h"

@implementation XXEXingStoreCategoryModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXEXingStoreCategoryModel *model = [[XXEXingStoreCategoryModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"category_id",
                                                       @"name":@"category_name"
                                                       }];
}

@end
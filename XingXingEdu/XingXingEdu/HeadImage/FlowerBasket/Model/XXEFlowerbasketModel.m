

//
//  XXEFlowerbasketModel.m
//  XingXingEdu
//
//  Created by Mac on 2016/12/9.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "XXEFlowerbasketModel.h"

@implementation XXEFlowerbasketModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXEFlowerbasketModel *model = [[XXEFlowerbasketModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"flowerbasketId"
                                                       }];
}


@end

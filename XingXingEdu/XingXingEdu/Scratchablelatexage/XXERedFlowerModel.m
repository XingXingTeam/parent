


//
//  XXERedFlowerModel.m
//  XingXingEdu
//
//  Created by Mac on 2016/12/7.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "XXERedFlowerModel.h"

@implementation XXERedFlowerModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXERedFlowerModel *model = [[XXERedFlowerModel alloc]initWithDictionary:dic error:nil];
        
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"flowerId"
                                                       }];
}


@end

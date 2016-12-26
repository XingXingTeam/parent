
//
//  XXEXingCommunityClassesModel.m
//  teacher
//
//  Created by Mac on 2016/12/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEXingCommunityClassesModel.h"

@implementation XXEXingCommunityClassesModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXEXingCommunityClassesModel *model = [[XXEXingCommunityClassesModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"articleId",
                                                       @"class":@"xingCommunity_class"
                                                       }];
}

@end

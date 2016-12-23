
//
//  XXEHomeworkListModel.m
//  XingXingEdu
//
//  Created by Mac on 2016/12/23.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "XXEHomeworkListModel.h"

@implementation XXEHomeworkListModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXEHomeworkListModel *model = [[XXEHomeworkListModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"homeworkId"
                                                       }];
}


@end

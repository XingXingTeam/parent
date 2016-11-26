
//
//  XXEXingClassRoomTeacherListModel.m
//  teacher
//
//  Created by Mac on 16/10/20.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEXingClassRoomTeacherListModel.h"

@implementation XXEXingClassRoomTeacherListModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXEXingClassRoomTeacherListModel *model = [[XXEXingClassRoomTeacherListModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"teacher_id"
                                                       }];
}


@end

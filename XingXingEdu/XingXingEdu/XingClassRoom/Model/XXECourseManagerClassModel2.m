
//
//  XXECourseManagerClassModel2.m
//  teacher
//
//  Created by Mac on 16/9/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECourseManagerClassModel2.h"

@implementation XXECourseManagerClassModel2

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXECourseManagerClassModel2 *model = [[XXECourseManagerClassModel2 alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

@end


//
//  XXECourseManagerClassModel1.m
//  teacher
//
//  Created by Mac on 16/9/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECourseManagerClassModel1.h"

@implementation XXECourseManagerClassModel1

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXECourseManagerClassModel1 *model = [[XXECourseManagerClassModel1 alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

@end

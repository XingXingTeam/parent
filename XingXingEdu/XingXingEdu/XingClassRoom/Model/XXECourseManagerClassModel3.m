
//
//  XXECourseManagerClassModel3.m
//  teacher
//
//  Created by Mac on 16/9/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECourseManagerClassModel3.h"

@implementation XXECourseManagerClassModel3

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXECourseManagerClassModel3 *model = [[XXECourseManagerClassModel3 alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

@end

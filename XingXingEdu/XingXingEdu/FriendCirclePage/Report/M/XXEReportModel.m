//
//  XXEReportModel.m
//  teacher
//
//  Created by codeDing on 16/8/26.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEReportModel.h"

@implementation XXEReportModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"reportId",
                                                     @"name":@"reportName"}];
}

@end

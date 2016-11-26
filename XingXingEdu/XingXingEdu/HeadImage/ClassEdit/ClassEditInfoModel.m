
//
//  ClassEditInfoModel.m
//  XingXingEdu
//
//  Created by Mac on 2016/11/18.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "ClassEditInfoModel.h"

@implementation ClassEditInfoModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        ClassEditInfoModel *model = [[ClassEditInfoModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"class_edit_id"
                                                       }];
}



@end

//
//  ClassTimeTableModel.m
//  XingXingEdu
//
//  Created by keenteam on 16/7/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "ClassTimeTableModel.h"

@implementation ClassTimeTableModel
+(JSONKeyMapper*)keyMapper{

    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"kId"}];

}
@end

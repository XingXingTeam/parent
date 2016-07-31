//
//  KTFriendsModel.m
//  XingXingEdu
//
//  Created by keenteam on 16/6/20.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "KTFriendsModel.h"

@implementation KTFriendsModel
+ (JSONKeyMapper*)keyMapper{

    return [[JSONKeyMapper alloc]initWithDictionary:@{
            @"age":@"age",
            @"head_img":@"head_img",
            @"tname":@"tname",
            @"parent_list":@"parent_list"
            }];

}
@end

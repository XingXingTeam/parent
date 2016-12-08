//
//  FriendGroup.m
//  QQ好友列表
//
//  Created by TianGe-ios on 14-8-21.
//  Copyright (c) 2014年 TianGe-ios. All rights reserved.
//

#import "FriendGroup.h"
#import "Friend.h"

@implementation FriendGroup

+ (instancetype)friendGroupWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dict in _friends) {
            Friend *friend = [Friend friendWithDict:dict];
            [tempArray addObject:friend];
        }
        _friends = tempArray;
    }
    return self;
}

@end

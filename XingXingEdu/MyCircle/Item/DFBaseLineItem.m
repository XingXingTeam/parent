//
//  DFBaseLineItem.m
//  DFTimelineView
//
//  Created by keenteam on 16/2/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "DFBaseLineItem.h"

@implementation DFBaseLineItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _likes = [NSMutableArray array];
        _comments = [NSMutableArray array];
        
        _commentStrArray = [NSMutableArray array];
    }
    return self;
}
@end

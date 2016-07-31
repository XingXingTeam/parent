//
//  DFTextImageLineItem.m
//  DFTimelineView
//
//  Created by keenteam on 16/2/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "DFTextImageLineItem.h"

@implementation DFTextImageLineItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _text = @"";
        _thumbImages = [NSMutableArray array];
        _srcImages = [NSMutableArray array];
    }
    return self;
}
@end

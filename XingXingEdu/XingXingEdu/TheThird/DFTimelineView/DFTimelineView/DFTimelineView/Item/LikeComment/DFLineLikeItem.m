//
//  DFLineLikeItem.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/29.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFLineLikeItem.h"
#import "XXEGoodUserModel.h"
@implementation DFLineLikeItem
-(void)configure:(XXEGoodUserModel*)model {
    self.userId = [model.goodXid integerValue];
    self.userNick = model.goodNickName;
}
@end

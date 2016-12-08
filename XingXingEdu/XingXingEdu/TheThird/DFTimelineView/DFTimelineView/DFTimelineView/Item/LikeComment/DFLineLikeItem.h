//
//  DFLineLikeItem.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/29.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

@class XXEGoodUserModel;
@interface DFLineLikeItem : NSObject

@property (nonatomic, assign) NSUInteger userId;

@property (nonatomic, strong) NSString *userNick;

-(void)configure:(XXEGoodUserModel*)model;

@end

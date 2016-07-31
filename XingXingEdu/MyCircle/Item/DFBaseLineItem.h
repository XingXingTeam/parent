//
//  DFBaseLineItem.h
//  DFTimelineView
//
//  Created by keenteam on 16/2/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//


@interface DFBaseLineItem : NSObject

//时间轴itemID 需要全局唯一 一般服务器下发
@property (nonatomic, assign) long long itemId;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) NSUInteger userId;
@property (nonatomic, strong) NSString *userNick;
@property (nonatomic, strong) NSString *userAvatar;

@property (nonatomic, strong) NSString *title;


@property (nonatomic, strong) NSString *location;

@property (nonatomic, assign) long long ts;


@property (nonatomic, strong) NSMutableArray *likes;
@property (nonatomic, strong) NSMutableArray *comments;


@property (nonatomic, strong) NSMutableAttributedString *likesStr;

@property (nonatomic, strong) NSMutableArray *commentStrArray;

@end

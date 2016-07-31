//
//  DFLineCommentItem.h
//  DFTimelineView
//
//  Created by keenteam on 16/2/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//


@interface DFLineCommentItem : NSObject

@property (nonatomic, assign) long long commentId;

@property (nonatomic, assign) NSUInteger userId;

@property (nonatomic, strong) NSString *userNick;

@property (nonatomic, assign) NSUInteger replyUserId;

@property (nonatomic, strong) NSString *replyUserNick;

@property (nonatomic, strong) NSString *text;


@property (nonatomic, strong) NSString *talk_id;

@end

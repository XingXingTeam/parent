//
//  DFLineCommentItem.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/29.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFLineCommentItem.h"
#import "XXECommentModel.h"
@implementation DFLineCommentItem


-(void)configure:(XXECommentModel*)model {
    self.commentId = [model.commentId integerValue];
    self.userId = [model.commentXid integerValue];
    self.userNick = model.commentNicknName;
    self.replyUserId = [model.to_who_xid integerValue];
    self.replyUserNick = model.to_who_nickname;
    self.text = model.con;
}
@end

//
//  XXETimeUserViewController.h
//  teacher
//
//  Created by codeDing on 16/9/21.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "DFBaseTimeLineViewController.h"
#import "DFLineLikeItem.h"
#import "DFLikeCommentView.h"
#import "DFBaseLineItem.h"

@class DFLineCommentItem;

@interface XXETimeUserViewController : DFBaseTimeLineViewController

//赞
-(void) addLikeItem:(DFLineLikeItem *) likeItem itemId:(long long) itemId;

//取消点赞
- (void)cancelLikeItem:(DFLineLikeItem *)likeItem itemId:(long long)itemId;

//评论
-(void)addCommentItem:(DFLineCommentItem *) commentItem itemId:(long long) itemId replyCommentId:(long long) replyCommentId;
//删除评论
-(void)cancelCommentItem:(DFLineCommentItem *)commentItem itemId:(long long)itemId replyCommentId:(long long)replyCommentId;

//回调评论的时候的被评论人的XID
- (void)xxe_friendCirclePageCommentToWhoXid:(NSInteger)toWhoXid;


- (void)detelAllSource;

@end

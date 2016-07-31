//
//  DFTimeLineViewController.h
//  DFTimelineView
//
//  Created by keenteam on 16/2/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "DFBaseLineItem.h"

#import "DFLineLikeItem.h"
#import "DFLineCommentItem.h"

#import "DFBaseTimeLineViewController.h"

@interface DFTimeLineViewController : DFBaseTimeLineViewController

//添加到末尾
-(void) addItem:(DFBaseLineItem *) item;

//添加到头部
-(void) addItemTop:(DFBaseLineItem *) item;

//根据ID删除
-(void) deleteItem:(long long) itemId;

//赞
-(void) addLikeItem:(DFLineLikeItem *) likeItem itemId:(long long) itemId isSelet:(BOOL)isSelet;

//评论
-(void) addCommentItem:(DFLineCommentItem *) commentItem itemId:(long long) itemId replyCommentId:(long long) replyCommentId;


//发送图文
-(void)onSendTextImage:(NSString *)text images:(NSArray *)images;

//发送视频消息
-(void)onSendVideo:(NSString *)text videoPath:(NSString *)videoPath screenShot:(UIImage *) screenShot;

@end

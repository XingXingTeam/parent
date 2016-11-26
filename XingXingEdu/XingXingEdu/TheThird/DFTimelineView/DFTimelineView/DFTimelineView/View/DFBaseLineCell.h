//
//  DFBaseLineCell.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "DFBaseLineItem.h"
#import "DFLikeCommentView.h"
#import "DFLikeCommentToolbar.h"
#import "Const.h"


#define Margin 15

#define Padding 10

#define UserAvatarSize 40

#define  BodyMaxWidth [UIScreen mainScreen].bounds.size.width - UserAvatarSize - 3*Margin

@protocol DFLineCellDelegate <NSObject>

@optional

-(void) onLike:(long long) itemId;

-(void) onComment:(long long) itemId;

-(void) onClickUser:(NSUInteger) userId;

-(void) onClickComment:(long long) commentId itemId:(long long) itemId;
//删除评论
-(void) deleteClickComment:(long long) commentId itemId:(long long) itemId;


@end

@interface DFBaseLineCell : UITableViewCell


@property (nonatomic, strong) UIButton *likeCmtButton;

@property (nonatomic, strong) DFLikeCommentView *likeCommentView;


@property (nonatomic, strong) DFLikeCommentToolbar *likeCommentToolbar;


@property (nonatomic, assign) BOOL isLikeCommentToolbarShow;

@property (nonatomic, assign) BOOL isLiked;

@property(nonatomic ,assign) BOOL isShowLikeComment;


@property (nonatomic, strong) UIView *bodyView;

@property (nonatomic, weak) id<DFLineCellDelegate> delegate;



-(void) updateWithItem:(DFBaseLineItem *) item;

-(CGFloat) getCellHeight:(DFBaseLineItem *) item;

-(CGFloat) getReuseableCellHeight:(DFBaseLineItem *)item;

-(void)updateBodyView:(CGFloat) height;

-(void) hideLikeCommentToolbar;

-(void)showLikeCommentToolbar;

-(UINavigationController *) getController;

-(void)setUnlikedImage;

-(void)setLikeImage;

-(void) configure;

//-(void) onClickLikeCommentBtn:(id)sender;

@end

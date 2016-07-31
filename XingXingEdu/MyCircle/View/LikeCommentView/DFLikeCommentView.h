//
//  DFLikeCommentView.h
//  DFTimelineView
//
//  Created by keenteam on 16/2/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "DFBaseLineItem.h"

@protocol DFLikeCommentViewDelegate <NSObject>

@required
-(void) onClickUser:(NSUInteger) userId;
-(void) onClickComment:(long long) commentId;

@end

@interface DFLikeCommentView : UIView


@property (nonatomic, weak) id<DFLikeCommentViewDelegate> delegate;


-(void) updateWithItem:(DFBaseLineItem *) item;

+(CGFloat) getHeight:(DFBaseLineItem *) item maxWidth:(CGFloat)maxWidth;

@end

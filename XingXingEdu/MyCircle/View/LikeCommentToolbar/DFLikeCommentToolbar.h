//
//  DFLikeCommentToolbar.h
//  DFTimelineView
//
//  Created by keenteam on 16/2/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

@protocol DFLikeCommentToolbarDelegate <NSObject>

@required
-(void) onLike;
-(void) onComment;
@end
@interface DFLikeCommentToolbar : UIImageView

@property (nonatomic, weak) id<DFLikeCommentToolbarDelegate> delegate;

@end

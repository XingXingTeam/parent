//
//  CommentInputView.h
//  DFTimelineView
//
//  Created by keenteam on 16/2/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//



@protocol CommentInputViewDelegate <NSObject>

@required

-(void) onCommentCreate:(long long ) commentId text:(NSString *) text;


@end




@interface CommentInputView : UIView


@property (nonatomic, weak) id<CommentInputViewDelegate> delegate;

@property (nonatomic, assign) long long commentId;

-(void) addNotify;

-(void) removeNotify;

-(void) addObserver;

-(void) removeObserver;

-(void) show;

-(void) setPlaceHolder:(NSString *) text;

@end

//
//  DFPlainGridImageView.h
//  DFTimelineView
//
//  Created by keenteam on 16/2/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DFPlainGridImageViewDelegate <NSObject>

@optional

-(void) onClick:(NSUInteger) index;
-(void) onLongPress:(NSUInteger) index;

@end
@interface DFPlainGridImageView : UIView

@property (nonatomic, weak) id<DFPlainGridImageViewDelegate> delegate;

+(CGFloat)getHeight:(NSMutableArray *)images maxWidth:(CGFloat)maxWidth;

-(void)updateWithImages:(NSMutableArray *)images;

@end

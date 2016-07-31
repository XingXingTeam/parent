//
//  DFGridImageView.h
//  DFTimelineView
//
//  Created by keenteam on 16/2/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFGridImageView : UIView

-(void) updateWithImages:(NSMutableArray *)images srcImages:(NSMutableArray *)srcImages oneImageWidth:(CGFloat)oneImageWidth oneImageHeight:(CGFloat)oneImageHeight;

+(CGFloat) getHeight:(NSMutableArray *) images maxWidth:(CGFloat)maxWidth oneImageWidth:(CGFloat)oneImageWidth oneImageHeight:(CGFloat)oneImageHeight;

@end

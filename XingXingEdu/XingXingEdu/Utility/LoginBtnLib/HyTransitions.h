//
//  HyTransitions.h
//  Example
//
//  Created by  kt on 15/9/2.
//  Copyright (c) 2015年 keenteam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HyTransitions : NSObject <UIViewControllerAnimatedTransitioning>

-(instancetype) initWithTransitionDuration:(NSTimeInterval)transitionDuration StartingAlpha:(CGFloat)startingAlpha isBOOL:(BOOL)is;

@end

//
//  SpinerLayer.h
//  Example
//
//  Created by  kt on 15/9/2.
//  Copyright (c) 2015年 keenteam. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface SpinerLayer : CAShapeLayer

-(instancetype) initWithFrame:(CGRect)frame;

-(void)animation;

-(void)stopAnimation;

@end

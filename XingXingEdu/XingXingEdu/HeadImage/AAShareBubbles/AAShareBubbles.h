//
//  AAShareBubbles.h
//  AAShareBubbles
//
//  Created by kt on 26/11/15.
//  Copyright (c) 2015 keenteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AAShareBubblesDelegate;

typedef enum {
    AAShareBubbleTypeZreo = 0,
    AAShareBubbleTypeFirst = 1,
    AAShareBubbleTypeSecond = 2,
    AAShareBubbleTypeThird = 3,
    AAShareBubbleTypeFour = 4
} AAShareBubbleType;

@interface AAShareBubbles : UIView
{
    NSMutableArray *bubbles;
    
    // Local
    UIView *bgView;
}

@property (nonatomic, assign) id<AAShareBubblesDelegate> delegate;

@property (nonatomic, assign) BOOL showZreoBubble;
@property (nonatomic, assign) BOOL showFirstBubble;
@property (nonatomic, assign) BOOL showSecondBubble;
@property (nonatomic, assign) BOOL showThirdBubble;
@property (nonatomic, assign) BOOL showFourBubble;

@property (nonatomic, assign) int radius;
@property (nonatomic, assign) int bubbleRadius;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, weak) UIView *parentView;


-(id)initWithPoint:(CGPoint)point radius:(int)radiusValue inView:(UIView *)inView;

-(void)show;
-(void)hide;

@end

@protocol AAShareBubblesDelegate<NSObject>
-(void)aaShareBubbles:(AAShareBubbles *)shareBubbles tappedBubbleWithType:(AAShareBubbleType)bubbleType;
@end

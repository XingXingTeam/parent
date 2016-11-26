//
//  AAShareBubbles.m
//  AAShareBubbles
//
//  Created by kt on 26/11/15.
//  Copyright (c) 2015 keenteam. All rights reserved.
//
#define DATA_URL    @"http://www.xingxingedu.cn/Parent/home_data"
#import "AAShareBubbles.h"
#import <QuartzCore/QuartzCore.h>
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
@interface AAShareBubbles()
@end

@implementation AAShareBubbles

@synthesize delegate = _delegate, parentView;

- (id)initWithPoint:(CGPoint)point radius:(int)radiusValue inView:(UIView *)inView
{
    self = [super initWithFrame:CGRectMake(point.x - radiusValue, point.y - radiusValue, 2 * radiusValue, 2 * radiusValue)];
    if (self) {
        self.radius = radiusValue;
        self.bubbleRadius = 120;
        self.parentView = inView;
    }
    return self;
}

#pragma mark -
#pragma mark Actions

-(void)facebookTapped {
    [self shareButtonTappedWithType:AAShareBubbleTypeZreo];
}
-(void)twitterTapped {
    [self shareButtonTappedWithType:AAShareBubbleTypeFirst];
}
-(void)mailTapped {
    [self shareButtonTappedWithType:AAShareBubbleTypeSecond];
}
-(void)googlePlusTapped {
    [self shareButtonTappedWithType:AAShareBubbleTypeThird];
}
-(void)tumblrTapped {
    [self shareButtonTappedWithType:AAShareBubbleTypeFour];
}

-(void)shareButtonTappedWithType:(AAShareBubbleType)buttonType {
    [self hide];
    if([self.delegate respondsToSelector:@selector(aaShareBubbles:tappedBubbleWithType:)]) {
        [self.delegate aaShareBubbles:self tappedBubbleWithType:buttonType];
    }
}

#pragma mark -
#pragma mark Methods

-(void)show
{
    if(!self.isAnimating)
    {
        self.isAnimating = YES;
        
        [self.parentView addSubview:self];
        
        // Create background
        bgView = [[UIView alloc] initWithFrame:self.parentView.bounds];
        bgView.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0.7];
        UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareViewBackgroundTapped:)];
        [bgView addGestureRecognizer:tapges];
        [parentView addSubview:bgView];
        [parentView insertSubview:bgView belowSubview:self];
        // --网络请求
        [self createData];
        
        if(bubbles) {
            bubbles = nil;
        }
        bubbles = [[NSMutableArray alloc] init];
        
        if(self.showZreoBubble) {
            
           
            UIButton *zreoBubble = [self shareButtonWithIcon:[[NSUserDefaults standardUserDefaults] objectForKey:@"0"]];

            [zreoBubble addTarget:self action:@selector(facebookTapped) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:zreoBubble];
            [bubbles addObject:zreoBubble];
        }
        if(self.showFirstBubble) {
            UIButton *twitterBubble = [self shareButtonWithIcon:[[NSUserDefaults standardUserDefaults] objectForKey:@"1"]];
            [twitterBubble addTarget:self action:@selector(twitterTapped) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:twitterBubble];
            [bubbles addObject:twitterBubble];
        }
        if(self.showSecondBubble) {
            UIButton *googlePlusBubble = [self shareButtonWithIcon:[[NSUserDefaults standardUserDefaults] objectForKey:@"2"]];
            [googlePlusBubble addTarget:self action:@selector(googlePlusTapped) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:googlePlusBubble];
            [bubbles addObject:googlePlusBubble];
        }
        if(self.showThirdBubble) {
            UIButton *googlePlusBubble = [self shareButtonWithIcon:[[NSUserDefaults standardUserDefaults] objectForKey:@"3"]];
            [googlePlusBubble addTarget:self action:@selector(tumblrTapped) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:googlePlusBubble];
            [bubbles addObject:googlePlusBubble];
        }
        if(self.showFourBubble) {
            UIButton *mailBubble = [self shareButtonWithIcon:[[NSUserDefaults standardUserDefaults] objectForKey:@"1"]];
            [mailBubble addTarget:self action:@selector(mailTapped) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:mailBubble];
            [bubbles addObject:mailBubble];
        }
        
        if(bubbles.count == 0) return;
        
        float bubbleDistanceFromPivot = self.radius - self.bubbleRadius;
        
        float bubblesBetweenAngel = 360 / bubbles.count;
        float angely = (180 - bubblesBetweenAngel) * 0.5;
        float startAngel = 180 - angely;
        
        NSMutableArray *coordinates = [NSMutableArray array];
        
        for (int i = 0; i < bubbles.count; ++i)
        {
            UIButton *bubble = [bubbles objectAtIndex:i];
            bubble.tag = i;
            
            float angle = startAngel + i * bubblesBetweenAngel;
            float x = cos(angle * M_PI / 180) * bubbleDistanceFromPivot + self.radius;
            float y = sin(angle * M_PI / 180) * bubbleDistanceFromPivot + self.radius;
            
            [coordinates addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:x], @"x", [NSNumber numberWithFloat:y], @"y", nil]];
            
            bubble.transform = CGAffineTransformMakeScale(0.001, 0.001);
            bubble.center = CGPointMake(self.radius, self.radius);
        }
        
        int inetratorI = 0;
        for (NSDictionary *coordinate in coordinates)
        {
            UIButton *bubble = [bubbles objectAtIndex:inetratorI];
            float delayTime = inetratorI * 0.1;
            [self performSelector:@selector(showBubbleWithAnimation:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:bubble, @"button", coordinate, @"coordinate", nil] afterDelay:delayTime];
            ++inetratorI;
        }
    }
}
- (void)createData{
//加载头像
    NSString *urlStr =DATA_URL;
    AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes =[manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager POST:urlStr parameters:@{@"appkey":@"U3k8Dgj7e934bh5Y",@"backtype":@"json",@"xid":@"18886144",@"user_id":@"3",@"user_type":@"1"} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //返回的正文数据
        NSLog(@"responseObject:%@", responseObject);
        
        if ([[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"code"]] isEqualToString:@"1"]) {
            NSLog(@"code=1");
            NSDictionary *dict =[responseObject objectForKey:@"data"];
            NSLog(@"baby_info:%@",dict[@"baby_info"]);
            NSArray *arr =dict[@"baby_info"];
            NSLog(@"arr:%@",arr);
            if (arr.count) {
                NSDictionary *dict =arr[0];
                NSArray *arr =dict[@"family_member"];
                NSMutableArray *arrayM =[[NSMutableArray alloc]init];
                for (id obj in arr) {
                    if ([[obj objectForKey:@"head_img"]  hasPrefix:@"http"]) {
                        [arrayM addObject:[obj objectForKey:@"head_img"]];
                    }
                    else{
                        [arrayM addObject:[NSString stringWithFormat:@"http://www.xingxingedu.cn/%@",[obj objectForKey:@"head_img"]]];

                    }
                   
                }
                NSLog(@"%@",arrayM);
                
            }
            
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];


}
-(void)hide
{
    if(!self.isAnimating)
    {
        self.isAnimating = YES;
        int inetratorI = 0;
        for (UIButton *bubble in bubbles)
        {
            float delayTime = inetratorI * 0.1;
            [self performSelector:@selector(hideBubbleWithAnimation:) withObject:bubble afterDelay:delayTime];
            ++inetratorI;
        }
    }
}

#pragma mark -
#pragma mark Helper functions

-(void)shareViewBackgroundTapped:(UITapGestureRecognizer *)tapGesture {
    [tapGesture.view removeFromSuperview];
     bgView.backgroundColor = [UIColor clearColor];
    [self hide];
}

-(void)showBubbleWithAnimation:(NSDictionary *)info
{
    UIButton *bubble = (UIButton *)[info objectForKey:@"button"];
    NSDictionary *coordinate = (NSDictionary *)[info objectForKey:@"coordinate"];
    
    [UIView animateWithDuration:0.25 animations:^{
        bubble.center = CGPointMake([[coordinate objectForKey:@"x"] floatValue], [[coordinate objectForKey:@"y"] floatValue]);
        bubble.alpha = 1;
        bubble.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            bubble.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                bubble.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished) {
                if(bubble.tag == bubbles.count - 1) self.isAnimating = NO;
                bubble.layer.shadowColor = [UIColor blackColor].CGColor;
                bubble.layer.shadowOpacity = 0.2;
                bubble.layer.shadowOffset = CGSizeMake(0, 1);
                bubble.layer.shadowRadius = 2;
            }];
        }];
    }];
}
-(void)hideBubbleWithAnimation:(UIButton *)bubble
{
    [UIView animateWithDuration:0.2 animations:^{
        bubble.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            bubble.center = CGPointMake(self.radius, self.radius);
            bubble.transform = CGAffineTransformMakeScale(0.001, 0.001);
            bubble.alpha = 0;
        } completion:^(BOOL finished) {
            if(bubble.tag == bubbles.count - 1) {
                self.isAnimating = NO;
                self.hidden = YES;
                [bgView removeFromSuperview];
                bgView = nil;
                [self removeFromSuperview];
            }
            [bubble removeFromSuperview];
        }];
    }];
}

-(UIButton *)shareButtonWithIcon:(NSString *)iconName
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 2 * self.bubbleRadius, 2 * self.bubbleRadius);
   //
    // Circle background
    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2 * self.bubbleRadius, 2 * self.bubbleRadius)];
    circle.layer.cornerRadius = self.bubbleRadius;
    circle.layer.masksToBounds = YES;
    circle.opaque = NO;
    circle.alpha = 0.97;
    
    UIImageView *icon =[[UIImageView alloc]init];
    icon.userInteractionEnabled =YES;
    
    CGRect f = icon.frame;
    f.origin.x = (circle.frame.size.width - f.size.width) * 0.5;
    f.origin.y = (circle.frame.size.height - f.size.height) * 0.5;
    icon.frame = f;
    NSLog(@"网络加载:%@",[NSURL URLWithString:iconName]);
    
    [icon sd_setImageWithURL:[NSURL URLWithString:iconName] placeholderImage:[UIImage imageNamed:@"11111"]];
   
    [circle addSubview:icon];
    
    [button setBackgroundImage:icon.image forState:UIControlStateNormal];
    [button setImage:[self imageWithView:icon] forState:UIControlStateNormal];
   
    button.layer.cornerRadius =button.frame.size.width/2;
    button.layer.masksToBounds =YES;
    
    return button;
}


-(UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end

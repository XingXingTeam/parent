//
//  UIButton+XXExtension.m
//  teacher
//
//  Created by codeDing on 16/8/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "UIButton+XXExtension.h"

@implementation UIButton (XXExtension)

- (void)startWithTime:(NSInteger )timeLine title:(NSString *)title countDownTile:(NSString *)subTitle mColor:(UIColor *)mcolor countColor:(UIColor *)color
{
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每一秒执行一次
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 1.0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        //倒计时结束,关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
//                self.backgroundColor = mcolor;
                [self setTitleColor:mcolor forState:UIControlStateNormal];
                [self setTitle:title forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
            });
        }else {
            int allTime = (int)timeLine + 1;
            int seconds = timeOut % allTime;
            NSString *timeStr = [NSString stringWithFormat:@"%0.2d",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
//                self.backgroundColor = color;
                [self setTitleColor:color forState:UIControlStateNormal];
                [self setTitle:[NSString stringWithFormat:@"%@%@",timeStr,subTitle] forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(timer);
}

//创建学校图标Logo
+ (UIButton *)creatSchoolIconImage:(NSString *)image target:(id)target action:(SEL)action floats:(CGFloat )floats
{
    UIButton *button = [[UIButton alloc]init];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = floats/2;
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)creatHomePageImage:(NSString *)image title:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc]init];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (![title isEqual: @""]) {
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        //    self.homeMiddleFirstButton.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    }
    
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

/** 注册页面校长注册页面4/4 */
+ (UIButton *)creatRegisterHeadMasterImage:(NSString *)image title:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc]init];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (![title isEqual: @""]) {
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
        //    self.homeMiddleFirstButton.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    }
    button.frame = CGRectMake(0, 0, KScreenWidth, 40*kScreenRatioHeight);
    button.backgroundColor = [UIColor darkGrayColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    searchButton.titleLabel.textColor = [UIColor whiteColor];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 20*kScreenRatioWidth;
    button.titleLabel.font = [UIFont systemFontOfSize:15 * kScreenRatioWidth];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark 创建UIButton
+ (UIButton *)createButtonWithFrame:(CGRect)frame backGruondImageName:(NSString *)name Target:(id)target Action:(SEL)action Title:(NSString *)title{
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myButton.frame = frame;
    [myButton setTitle:title forState:UIControlStateNormal];
    [myButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (name) {
        [myButton setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        
    }
    [myButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return myButton;
}



@end

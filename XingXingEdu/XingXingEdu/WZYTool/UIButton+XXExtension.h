//
//  UIButton+XXExtension.h
//  teacher
//
//  Created by codeDing on 16/8/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (XXExtension)

/**
 *   倒计时按钮
 *
 *   @param timeLine 倒计时总时长
 *   @param title    还没有倒计时的title
 *   @param subTitle 倒计时中的文字比如 时 分 秒
 *   @param mColor   还没有倒计时的颜色
 *   @param color    倒计时中的文字
 */
- (void)startWithTime:(NSInteger )timeLine title:(NSString *)title countDownTile:(NSString *)subTitle mColor:(UIColor *)mcolor countColor:(UIColor *)color;
//创建logo
+ (UIButton *)creatSchoolIconImage:(NSString *)image target:(id)target action:(SEL)action floats:(CGFloat )floats;

+ (UIButton *)creatHomePageImage:(NSString *)image title:(NSString *)title target:(id)target action:(SEL)action;
/** 注册页面校长注册页面4/4 */
+ (UIButton *)creatRegisterHeadMasterImage:(NSString *)image title:(NSString *)title target:(id)target action:(SEL)action;

#pragma mark 创建UIButton
+ (UIButton *)createButtonWithFrame:(CGRect)frame backGruondImageName:(NSString *)name Target:(id)target Action:(SEL)action Title:(NSString *)title;



@end

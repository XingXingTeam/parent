//
//  XXEBaseViewController.h
//  teacher
//
//  Created by codeDing on 16/8/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXEBaseViewController : UIViewController

/** 只提示文字 */
- (void)showHudWithString:(NSString *)text;
/** 提示文字多久之后消失 */
- (void)showHudWithString:(NSString *)text forSecond:(NSTimeInterval)seconds;
/** 提示 */
- (void)showString:(NSString *)text forSecond:(NSTimeInterval )seconds;
/** 取消提示 */
- (void)hideHud;
/** 多久取消提示 */
- (void)hideHudAfterSeconds:(NSTimeInterval )interval;

@end

//
//  SystemPopView.m
//  teacher
//
//  Created by codeDing on 16/12/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "SystemPopView.h"

@implementation SystemPopView
+ (void)showSystemPopViewWithTitle:(NSString *)title vc:(UIViewController*)vc {
    UIAlertController *alertViewC = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertViewC addAction:cancelBtn];
    [vc presentViewController:alertViewC animated:YES completion:nil];
}
@end

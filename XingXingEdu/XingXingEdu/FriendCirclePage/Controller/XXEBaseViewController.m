//
//  XXEBaseViewController.m
//  teacher
//
//  Created by codeDing on 16/8/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"
#import "MBProgressHUD.h"

@interface XXEBaseViewController ()

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation XXEBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.hud];
    
    UITapGestureRecognizer *cancellTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    [self.hud addGestureRecognizer:cancellTap];
}

- (void)tapView:(id)sender
{
    [self.hud hide:YES];
}


/** 只提示文字 */
- (void)showHudWithString:(NSString *)text
{
    if (self.hud) {
        self.hud.labelText = text;
        self.hud.mode = MBProgressHUDModeIndeterminate;
        [self.hud show:YES];
        [self.view bringSubviewToFront:self.hud];
    } else {
        self.hud = [[MBProgressHUD alloc]initWithView:self.view];
        self.hud.labelText = text;
        self.hud.mode = MBProgressHUDModeIndeterminate;
        [self.hud show:YES];
        [self.view bringSubviewToFront:self.hud];
    }
}
/** 提示文字多久之后消失 */
- (void)showHudWithString:(NSString *)text forSecond:(NSTimeInterval)seconds
{
    [self showHudWithString:text];
    [self hideHudAfterSeconds:seconds];
}

- (void)showString:(NSString *)text forSecond:(NSTimeInterval )seconds
{
    if (self.hud) {
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = text;
    
        [self.hud show:YES];
        [self.view bringSubviewToFront:self.hud];
        [self hideHudAfterSeconds:seconds];
    } else {
        self.hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:self.hud];
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = text;
        [self.hud show:YES];
        [self.view bringSubviewToFront:self.hud];
        [self hideHudAfterSeconds:seconds];
    }
}
/** 取消提示 */
- (void)hideHud
{
    [self.hud hide:YES];
}
- (void)hideHudAfterSeconds:(NSTimeInterval )interval
{
    [self.hud hide:YES afterDelay:interval];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

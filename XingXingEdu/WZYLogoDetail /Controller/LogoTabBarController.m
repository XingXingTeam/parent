//
//  LogoTabBarController.m
//  XingXingEdu
//
//  Created by Mac on 16/5/9.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "LogoTabBarController.h"
#import "IntroductionViewController.h"
#import "CourseViewController.h"
#import "SpeechViewController.h"


@interface LogoTabBarController ()

@end

@implementation LogoTabBarController


- (void)viewDidLoad{
    
        IntroductionViewController *vc1 = [[IntroductionViewController alloc] init];
        vc1.title = @"机构简介";
        UIImage *normalImage1 = [UIImage imageNamed:@"机构简介icon48x48@2x.png"];
      normalImage1 =  [normalImage1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *seletedImage1 = [UIImage imageNamed:@"机构简介(H01)icon48x48@2x.png"];
       seletedImage1 = [seletedImage1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc1.tabBarItem.image = normalImage1;
        vc1.tabBarItem.selectedImage = seletedImage1;
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    
    
        CourseViewController *vc2 = [[CourseViewController alloc] init];
        vc2.title = @"学校课程";
        UIImage *normalImage2 = [UIImage imageNamed:@"学校课程icon48x48@2x.png"];
       normalImage2 = [normalImage2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *seletedImage2 = [UIImage imageNamed:@"学校课程(H01)icon48x48@2x.png"];
      seletedImage2 =  [seletedImage2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc2.tabBarItem.image = normalImage2;
        vc2.tabBarItem.selectedImage = seletedImage2;
        UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    
        SpeechViewController *vc3 = [[SpeechViewController alloc] init];
        vc3.title = @"校长致辞";
        UIImage *normalImage3 = [UIImage imageNamed:@"校长致辞icon48x48@2x.png"];
       normalImage3 = [normalImage3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *seletedImage3 = [UIImage imageNamed:@"校长致辞(H01)icon48x48@2x.png"];
       seletedImage3 = [seletedImage3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc3.tabBarItem.image = normalImage3;
        vc3.tabBarItem.selectedImage = seletedImage3;
       UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:vc3];
        
        self.viewControllers = @[nav1, nav2, nav3];
    
//    if ([[UIDevice currentDevice].systemVersion floatValue]<8.0) {
//                [[UITabBarItem appearance] setTitleTextAttributes:
//                 [NSDictionary dictionaryWithObjectsAndKeys:
//                  [UIColor redColor], NSForegroundColorAttributeName, nil]
//                                                         forState:UIControlStateHighlighted];
//            }else
//            {
                [self.tabBar setTintColor:UIColorFromRGB(0, 170, 42)];
//
//            }

}

@end

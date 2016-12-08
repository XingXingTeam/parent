//
//  CommentsRootTabbarViewController.m
//  XingXingEdu
//
//  Created by codeDing on 16/5/4.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "CommentsRootTabbarViewController.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "CommentsRecordTableViewController.h"
#import "CommentRequestRecordViewController.h"
#import "flowerViewController.h"

@interface CommentsRootTabbarViewController ()

@end

@implementation CommentsRootTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CommentsRecordTableViewController *vc1 = [[CommentsRecordTableViewController alloc]init];
    vc1.title = @"点评历史";
    vc1.tabBarItem.image=[UIImage imageNamed:@"commenttab1.png"];
    vc1.tabBarItem.selectedImage=[UIImage imageNamed:@"commenttab1h.png"];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    
    CommentRequestRecordViewController *vc2 = [[CommentRequestRecordViewController alloc]init];
    
    vc2.title = @"请求点评";
    vc2.tabBarItem.image=[UIImage imageNamed:@"commenttab2.png"];
    vc2.tabBarItem.selectedImage=[UIImage imageNamed:@"commenttab2h.png"];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    
    
    flowerViewController *vc3 = [[flowerViewController alloc]init];
    vc3.flagStr = @"点评";
    vc3.title = @"小红花";
    vc3.tabBarItem.image=[UIImage imageNamed:@"commenttab3.png"];
    vc3.tabBarItem.selectedImage=[UIImage imageNamed:@"commenttab3h.png"];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:vc3];
    
    
    self.viewControllers = @[nav2,nav1,nav3];
    self.tabBar.backgroundColor =[UIColor whiteColor];
    
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<8.0) {
        [[UITabBarItem appearance] setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          UIColorFromRGB(0, 170, 42), NSForegroundColorAttributeName, nil]
                                                 forState:UIControlStateHighlighted];
    }else
    {
        [self.tabBar setTintColor:UIColorFromRGB(0, 170, 42)];
        
        
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
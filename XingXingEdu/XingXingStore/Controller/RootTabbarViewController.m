//
//  RootTabbarViewController.m
//  XingXingEdu
//
//  Created by codeDing on 16/2/29.
//  Copyright © 2016年 codeDing. All rights reserved.
//


#import "RootTabbarViewController.h"
#import "StoreHomePageViewController.h"
#import "StoreSettngViewController.h"
#import "ArticleCategoryViewController.h"
@interface RootTabbarViewController ()

@end

@implementation RootTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    StoreHomePageViewController *vc1 = [[StoreHomePageViewController alloc]init];
    vc1.title = @"商城";
    vc1.tabBarItem.image=[UIImage imageNamed:@"tab0_selected（0）"];
    vc1.tabBarItem.selectedImage=[UIImage imageNamed:@"tab0_selected"];
    
    ArticleCategoryViewController *vc2 = [[ArticleCategoryViewController alloc]init];
    vc2.title = @"分类";
    vc2.tabBarItem.image=[UIImage imageNamed:@"tab1_selected(1)"];
    vc2.tabBarItem.selectedImage=[UIImage imageNamed:@"tab1_selected"];
    

    
    StoreSettngViewController *vc3 = [[StoreSettngViewController alloc]init];
    vc3.title = @"我的";
    vc3.tabBarItem.image=[UIImage imageNamed:@"tab4_selected(4)"];
    vc3.tabBarItem.selectedImage=[UIImage imageNamed:@"tab4_selected"];

    
    
    self.viewControllers = @[vc1,vc2,vc3];
    self.tabBar.backgroundColor =[UIColor whiteColor];

    if ([[UIDevice currentDevice].systemVersion floatValue]<8.0) {
        [[UITabBarItem appearance] setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          [UIColor redColor], NSForegroundColorAttributeName, nil]
                                                 forState:UIControlStateHighlighted];
    }else
    {
        [self.tabBar setTintColor:UIColorFromRGB(71, 153, 65)];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

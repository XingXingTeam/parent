//
//  XXENavigationViewController.m
//  teacher
//
//  Created by codeDing on 16/8/5.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXENavigationViewController.h"

@interface XXENavigationViewController ()

@end

@implementation XXENavigationViewController

/**
 * 当第一次使用这个类的时候会调用一次
 */
+ (void)initialize
{
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"navigation_icon"] forBarMetrics:UIBarMetricsDefault];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                    NSFontAttributeName :[UIFont systemFontOfSize:18]
                                                                    };
}

/** 更改电池条颜色 */
- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

/**
 * 可以在这个方法中拦截所有push进来的控制器
 */
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if (self.childViewControllers.count > 0) { // 如果push进来的不是第一个控制器
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setTitle:@"返回" forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateHighlighted];
//        button.size = CGSizeMake(70, 30);
//        // 让按钮内部的所有内容左对齐
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        //        [button sizeToFit];
//        // 让按钮的内容往左边偏移10
//        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
//        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
//        
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//        
//        // 修改导航栏左边的item
//        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//        
//        // 隐藏tabbar
//        viewController.hidesBottomBarWhenPushed = YES;
//    }
//    
//    // 这句super的push要放在后面, 让viewController可以覆盖上面设置的leftBarButtonItem
//    [super pushViewController:viewController animated:animated];
//    
//}

- (void)back
{
    [self popViewControllerAnimated:YES];
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

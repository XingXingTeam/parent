//
//  XXETabBarViewController.m
//  XingXingEdu
//
//  Created by codeDing on 16/8/2.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "XXETabBarViewController.h"
#import "SchoolRecipesViewController.h"
#import "ClassAlbumViewController.h"
#import "XXEChatPageViewController.h"
#import "ClassSubjectViewController.h"
#import "ClassTelephoneViewController.h"
#import "HomepageViewController.h"
#import "RcRootTabbarViewController.h"
#import "MyHeadViewController.h"
#import "XXEFriendCirclePageViewController.h"

@interface XXETabBarViewController ()

@end

@implementation XXETabBarViewController

+ (void)initialize
{
    // 通过appearance统一设置所有UITabBarItem的文字属性
    // 后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tabBar setTintColor:UIColorFromRGB(0, 170, 42)];
    
    // 添加子控制器
    [self setupChildVc:[[HomepageViewController alloc] init] title:@"首页" image:@"主页icon48x48" selectedImage:@"主页(H01)icon48x48"];
    [self setupChildVc:[[XXEFriendCirclePageViewController alloc] init] title:@"圈子" image:@"圈子icon48x48" selectedImage:@"圈子（H01）icon48x48"];
    
    [self setupChildVc:[[XXEChatPageViewController alloc] init] title:@"猩课堂" image:@"Classicon48x48" selectedImage:@"猩课堂(H01)icon48x48"];
    [self setupChildVc:[[MyHeadViewController alloc] init] title:@"我的" image:@"我的icon48x48" selectedImage:@"我的(H01)icon48x48"];

}

- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置文字和图片
    vc.navigationItem.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    
    // 包装一个导航控制器, 添加导航控制器为tabbarcontroller的子控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
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

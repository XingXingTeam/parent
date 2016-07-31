//
//  MyTabBarController.m
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/4/14.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "MyTabBarController.h"
#import "SchoolRecipesViewController.h"
#import "ClassAlbumViewController.h"
#import "ClassHomeworkViewController.h"
#import "ClassSubjectViewController.h"
#import "ClassTelephoneViewController.h"
#import "HomepageViewController.h"
#import "RcRootTabbarViewController.h"
#import "MyHeadViewController.h"
#import "ViewController.h"
@interface MyTabBarController ()

@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self createViewControllers];
   [self.tabBar setTintColor:UIColorFromRGB(0, 170, 42)];
 
    // Do any additional setup after loading the view.
}
-(void)createViewControllers
{
    
NSArray*controllerNames=@[@"HomepageViewController",@"ViewController",@"ClassRoomHomePageViewController",@"MyHeadViewController"];
    NSArray *imageNames=@[@"主页icon48x48@2x",@"圈子icon48x48@2x",@"Classicon48x48@2x",@"我的icon48x48@2x"];
    NSArray *selectImageNames =@[@"主页(H01)icon48x48@2x",@"圈子（H01）icon48x48@2x",@"猩课堂(H01)icon48x48@2x",@"我的(H01)icon48x48@2x"];
   NSArray *titleNames=@[@"首页",@"圈子",@"猩课堂",@"我的"];
    
    NSMutableArray *array=[NSMutableArray array];
    
    for(int i=0;i<controllerNames.count;i++)
    {
        Class className=NSClassFromString(controllerNames[i]);
        UIViewController *controller=[[className alloc]init];
        controller.view.backgroundColor=[UIColor whiteColor];
        controller.tabBarItem.image=[UIImage imageNamed:imageNames[i]];
        controller.tabBarItem.selectedImage =[UIImage imageNamed:selectImageNames[i]];
        if (i==1) {
            controller.tabBarItem.badgeValue =[NSString stringWithFormat:@"%d",2];
        }
        controller.tabBarItem.selectedImage =[controller.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        controller.title=titleNames[i];
        UINavigationController *navi=[[UINavigationController alloc]initWithRootViewController:controller];
        [array addObject:navi];
        
    }
    self.viewControllers=array;
    
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

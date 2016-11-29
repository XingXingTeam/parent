//
//  CoursesViewController.m
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/2/3.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "CoursesViewController.h"
#import "HHControl.h"
@interface CoursesViewController ()

@end

@implementation CoursesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
       self.view.backgroundColor =  UIColorFromRGB(239, 239, 239);
    [self  createKTlbl];
}
- (void)createKTlbl{
    UILabel *courseLbl = [HHControl createLabelWithFrame:CGRectMake(10, 20, kWidth, 20) Font:10 Text:@"语文课:"];
    [self.view addSubview:courseLbl];


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



//
//  XXEXingCommunityCookingViewController.m
//  teacher
//
//  Created by Mac on 2016/12/15.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEXingCommunityCookingViewController.h"

@interface XXEXingCommunityCookingViewController ()
{
    UIWebView *webView;
    
}
@end

@implementation XXEXingCommunityCookingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    self.title = @"美食";
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,KScreenWidth,KScreenHeight)];
    NSURL *url = [NSURL URLWithString:XXEXingCommunityCooking];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [self.view addSubview:webView];}

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

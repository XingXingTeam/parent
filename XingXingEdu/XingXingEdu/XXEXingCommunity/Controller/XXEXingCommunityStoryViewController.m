

//
//  XXEXingCommunityStoryViewController.m
//  teacher
//
//  Created by Mac on 2016/12/15.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEXingCommunityStoryViewController.h"

@interface XXEXingCommunityStoryViewController ()
{
    UIWebView *webView;
    
}
@end

@implementation XXEXingCommunityStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    self.title = @"故事";
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,KScreenWidth,KScreenHeight)];
    NSURL *url = [NSURL URLWithString:XXEXingCommunityStory];
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

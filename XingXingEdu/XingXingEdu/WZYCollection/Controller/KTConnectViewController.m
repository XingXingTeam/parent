//
//  KTConnectViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/5/19.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "KTConnectViewController.h"

@interface KTConnectViewController ()
{
  UIWebView *myWebView;

}
@end

@implementation KTConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,kWidth,kHeight - 64 - 15)];
    NSURL *url = [NSURL URLWithString:@"http://www.xingxingedu.cn"];
    [myWebView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [self.view addSubview:myWebView];
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

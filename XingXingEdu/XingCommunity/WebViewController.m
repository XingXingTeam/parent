//
//  WebViewController.m
//  XingXingEdu
//
//  Created by super on 16/3/10.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "WebViewController.h"

#import <Foundation/Foundation.h>
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height
#define W(x) WinWidth*(x)/375.0
#define H(y) WinHeight*(y)/667.0
@interface WebViewController (){
    UIWebView *myWebView;
    NSTimer * timer;
}

@end

@implementation WebViewController

- (void)viewWillDisappear:(BOOL)animated{
    self.isExit=YES;
//    NSLog(@"WillDisappear");

}

- (void)viewDidDisappear:(BOOL)animated{
//    NSLog(@"DidDisappear");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,WinWidth,WinHeight)];
    NSURL *url = [NSURL URLWithString:self.url];
    [myWebView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [self.view addSubview:myWebView];
//    timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showInfo:) userInfo:nil repeats:YES];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [[NSRunLoop currentRunLoop]run];
//    });
}
-(void)showInfo:(NSTimer *)t{
    static int count=0;
    count++;
    NSLog(@"程序运行了%i秒",count);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(count) forKey:@"communityTime"];
    [defaults synchronize];

    
    if (self.isExit) {
    [t invalidate];//停止定时器
         NSLog(@"一共运行了%i秒",count);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@(count) forKey:@"communityTime"];
        [defaults synchronize];
        count=0;
     }
    
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

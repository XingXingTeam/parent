
//
//  XXEXingCommunityBabyCommunityViewController.m
//  teacher
//
//  Created by Mac on 16/9/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEXingCommunityBabyCommunityViewController.h"

@interface XXEXingCommunityBabyCommunityViewController (){
    UIWebView *myWebView;
    NSTimer * timer;
}

@end

@implementation XXEXingCommunityBabyCommunityViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isExit=YES;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
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


@end

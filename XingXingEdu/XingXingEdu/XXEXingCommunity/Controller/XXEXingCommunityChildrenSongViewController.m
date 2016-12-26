
//
//  XXEXingCommunityChildrenSongViewController.m
//  teacher
//
//  Created by Mac on 2016/12/15.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEXingCommunityChildrenSongViewController.h"




@interface XXEXingCommunityChildrenSongViewController ()
{
    UIWebView *webView;

}


@end

@implementation XXEXingCommunityChildrenSongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    self.title = @"儿歌";

    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,KScreenWidth,KScreenHeight)];
    NSURL *url = [NSURL URLWithString:XXEXingCommunityChildrenSong];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [self.view addSubview:webView];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

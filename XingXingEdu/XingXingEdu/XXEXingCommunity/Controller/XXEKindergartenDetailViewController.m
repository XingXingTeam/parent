

//
//  XXEKindergartenDetailViewController.m
//  teacher
//
//  Created by Mac on 2016/12/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEKindergartenDetailViewController.h"

@interface XXEKindergartenDetailViewController ()<UIWebViewDelegate>
{
    UIWebView *webView;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}


@end

@implementation XXEKindergartenDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    self.title = @"文章详情";
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
     //    1.设置请求路径
        NSString *urlStr=[NSString stringWithFormat:@"http://www.xingxingedu.cn/Xtd/article?cat=%@&id=%@",_cat,_articleId];
    
    NSURL *url=[NSURL URLWithString:urlStr];
    
    /*
     NSDictionary *params = @{@"appkey":APPKEY,
     @"backtype":BACKTYPE,
     @"xid":parameterXid,
     @"user_id":parameterUser_Id,
     @"user_type":USER_TYPE
     };

     */
    
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE
                             };

//    NSString *bodyShare = [NSString stringWithFormat: @"hID=%@", params];
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,KScreenWidth,KScreenHeight)];
    NSMutableURLRequest * requestShare = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
    [requestShare setHTTPMethod: @"POST"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];

    [requestShare setHTTPBody:data];
    [webView loadRequest:requestShare];

//    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [self.view addSubview:webView];
    
    
    
    /*
     UIWebView *webView = [[UIWebView alloc] init];

     NSMutableURLRequest * requestShare = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:self.urlStr]];
     [requestShare setHTTPMethod: @"POST"];
     [requestShare setHTTPBody: [bodyShare dataUsingEncoding: NSUTF8StringEncoding]];
     [webView loadRequest:requestShare];
     */

    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

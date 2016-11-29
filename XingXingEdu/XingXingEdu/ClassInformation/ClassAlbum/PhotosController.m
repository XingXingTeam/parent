//
//  PhotosController.m
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/1/20.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "PhotosController.h"
#import "MBProgressHUD.h"
#import <ShareSDKUI/ShareSDKUI.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "APOpenAPI.h"
#import "CoreUMeng.h"

#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "ReportPicViewController.h"
@interface PhotosController ()<UIActionSheetDelegate,UIScrollViewDelegate,UMSocialUIDelegate>
{
    UIImageView *imageview;
    UIScrollView *_scrollView;
    MBProgressHUD *HUD;
    MBProgressHUD *HUDH;
    UIButton *saveBtn;
}

/**
 *  面板
 */
@property (nonatomic, strong) UIView *panelView;

/**
 *  加载视图
 */
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property(nonatomic,retain) NSMutableArray *ittms;
@end

@implementation PhotosController
- (void)viewWillAppear:(BOOL)animated{
     self.navigationController.toolbarHidden =YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.toolbarHidden =YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollView =  [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    _scrollView.pagingEnabled =YES;
    _scrollView.showsHorizontalScrollIndicator =NO;
    [self.view addSubview:_scrollView];
    
    //加载等待视图
    self.panelView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.panelView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.panelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.loadingView.frame = CGRectMake((self.view.frame.size.width - self.loadingView.frame.size.width) / 2, (self.view.frame.size.height - self.loadingView.frame.size.height) / 2, self.loadingView.frame.size.width, self.loadingView.frame.size.height);
    self.loadingView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [self.panelView addSubview:self.loadingView];
    [self createToolbtn];
    
    _ittms = [[NSMutableArray alloc]init];
    _ittms =self.imageArr;
    self.title =@"照片";
    self.view.backgroundColor = UIColorFromRGB(255, 255, 255);
    
    for (int i=0; i<_ittms.count; i++) {
        UIImageView *imV = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth*i, 0, kWidth, kHeight)];
        imV.image =_ittms[i];
        [_scrollView addSubview:imV];
    }
    CGPoint contentOffset = _scrollView.contentOffset;
    contentOffset.x = self.s * kWidth;
    [_scrollView setContentOffset:contentOffset animated:YES];
    
    _scrollView.contentSize =CGSizeMake(_ittms.count*kWidth, kHeight-64);
    _scrollView.delegate =self;
    // Do any additional setup after loading the view.
}

- (void)createToolbtn{

    UIImageView *imageV= [[UIImageView alloc]initWithFrame:CGRectMake(0, kHeight-44, kWidth, 44)];
    imageV.backgroundColor = UIColorFromRGB(248, 144, 34 );
    [self.view addSubview:imageV];
    imageV.userInteractionEnabled =YES;
    
    UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth/2-20, 2, 40, 40)];
    [shareBtn setBackgroundColor:[UIColor orangeColor]];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
   [shareBtn addTarget:self action:@selector(shareButn:) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:shareBtn];
    
    UIButton *downBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 2, 40, 40)];
    [downBtn setBackgroundColor:[UIColor orangeColor]];
    [downBtn setTitle:@"下载" forState:UIControlStateNormal];
    [downBtn addTarget:self action:@selector(downButn:) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:downBtn];
    
    saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth-45, 2, 40, 40)];
    [saveBtn setBackgroundColor:[UIColor orangeColor]];
    [saveBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [imageV addSubview:saveBtn];
    [saveBtn addTarget:self action:@selector(saveBtn:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)saveBtn:(UIButton*)shareBtn{
    HUDH =[[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:HUDH];
    
    if (saveBtn.selected ==NO) {
        shareBtn.selected=YES;
        saveBtn=shareBtn;
         [saveBtn setBackgroundColor:[UIColor redColor]];
        HUDH.dimBackground =YES;
        HUDH.labelText =@"已收藏";
        [HUDH showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [HUDH removeFromSuperview];
            HUDH =nil;
        }];
    }
    else{
        shareBtn.selected=NO;
        saveBtn=shareBtn;
        HUDH.dimBackground =YES;
         [saveBtn setBackgroundColor:[UIColor orangeColor]];
        HUDH.labelText =@"取消收藏";
        [HUDH showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [HUDH removeFromSuperview];
            HUDH =nil;
        }];
    }
   
    
}

- (void)shareButn:(UIButton*)btn{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  
    UIAlertAction *action1 =[UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       [CoreUmengShare show:self text:@"为了孩子的未来,这里有你想要的一切,快点点击下载吧！https://itunes.apple.com/cn/app/jie-dian-qian-zhuan-ye-ban/id1112373854?mt=8&v0=WWW-GCCN-ITSTOP100-FREEAPPS&l=&ign-mpt=uo%3D4" image:[UIImage imageNamed:@"猩猩教室.png"]];
    
    }];
    UIAlertAction *action2 =[UIAlertAction actionWithTitle:@"举报 " style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ReportPicViewController *reportPicVC = [[ReportPicViewController alloc]init];
        [self.navigationController pushViewController:reportPicVC animated:YES];
        
    }];
    UIAlertAction *action3 =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (BOOL)isDirectShareInIconActionSheet{
    return YES;
}
- (void)downButn:(UIButton*)btn{
    HUD =[[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.dimBackground =YES;
    HUD.labelText =@"正在下载中.....";
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(3);
         HUD.labelText =@"下载成功!";
    } completionBlock:^{
        [HUD removeFromSuperview];
        HUD =nil;
        [self.navigationController popViewControllerAnimated:YES];
    }];

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

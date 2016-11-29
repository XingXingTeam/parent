//
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/1/13.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "FirstLaunchViewController.h"
#import "SchoolInfoViewController.h"
#import "LandingpageViewController.h"
@interface FirstLaunchViewController ()<UIScrollViewDelegate>
{
    UIScrollView * _scrollView;
    NSArray * imgs;
    UIPageControl * _control;
}
@end

@implementation FirstLaunchViewController
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden =YES;

}
- (void)viewWillDisappear:(BOOL)animated{
  self.navigationController.navigationBarHidden =NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator =NO;
    [self.view addSubview:_scrollView];
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth-255, kHeight-120, kWidth*136/375,  kHeight*37/667)];
    [btn setImage:[UIImage imageNamed:@"experience"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"experienceH"] forState:UIControlStateHighlighted];
    btn.layer.cornerRadius = 5;
//    btn.backgroundColor = [UIColor clearColor];
//    btn.titleLabel.font = [UIFont systemFontOfSize:30];
//    btn.layer.borderColor =[UIColor clearColor].CGColor;
//    btn.layer.borderWidth=2;
   [btn addTarget:self action:@selector(FirstPageVC) forControlEvents:UIControlEventTouchUpInside];
    NSArray * image =@[@"引导页01",@"引导页02",@"引导页03"];
    for (int i =0; i<image.count; i++) {
        UIImageView * imV = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth*i, 0, kWidth, kHeight)];
           imV.userInteractionEnabled = YES;
        imV.image = [UIImage imageNamed:image[i]];
        [_scrollView addSubview:imV];
        if (i==image.count-1) {
        [imV addSubview:btn];
            
//        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
//           
//            make.bottom.mas_equalTo(-kHeight*117/667);
//            make.centerX.equalTo(imV.mas_centerX).offset(0);
//            make.size.mas_equalTo(CGSizeMake(kWidth*272/375, kHeight*74/667));
//            
//        }];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(imV.mas_bottom).offset(-kHeight*137/667);  // .mas_equalTo(-kHeight*117/667);
                make.centerX.equalTo(imV.mas_centerX).offset(0);
                make.size.mas_equalTo(CGSizeMake(kWidth*272/375, kHeight*74/667));

            }];
            
        }
    }
    _scrollView.contentSize = CGSizeMake(image.count*kWidth, 0);
    _scrollView.delegate = self;
    _control = [[UIPageControl alloc]initWithFrame:CGRectMake(kWidth/2-50, kHeight-50, 100, 20)];
    _control.numberOfPages = image.count;
    _control.pageIndicatorTintColor = [UIColor clearColor];
    _control.currentPageIndicatorTintColor = [UIColor clearColor];
    [self.view addSubview:_control];
    
  
    
}
//  跳转首页
- (void)FirstPageVC{
   LandingpageViewController * infoVC =[[LandingpageViewController alloc]init];
    infoVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:infoVC animated:YES];
    
}

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset =  _scrollView.contentOffset;
    NSInteger index = offset.x/kWidth;
    _control.currentPage = index;
    if (offset.x>2*kWidth) {
        LandingpageViewController * infoVC =[[LandingpageViewController alloc]init];
        infoVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self.navigationController pushViewController:infoVC animated:YES];
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

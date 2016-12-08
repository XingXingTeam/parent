
//
//  XXEStarImageViewController.m
//  teacher
//
//  Created by codeDing on 16/8/5.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStarImageViewController.h"
#import "LandingpageViewController.h"

@interface XXEStarImageViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGR;
@property (nonatomic, strong) UIButton *starButton;
@property(nonatomic ,strong) UIPageControl *pageControl;
@end

@implementation XXEStarImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    NSLog(@"----启动图片----");
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame = self.view.frame;
    scrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    //添加图片到ScrollView
    CGFloat scrollW = scrollView.width;
    CGFloat scrollH = scrollView.height;
    NSInteger imageIndex = 7;
    if (scrollH < 500) {
        imageIndex = 4;
    }
    if (scrollH > 500 && scrollH < 600) {
        imageIndex = 5;
    }
    if (scrollH > 600 && scrollH < 700) {
        imageIndex = 6;
    }
    for (int i = 0; i < 5; i ++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.width = scrollW;
        imageView.height = scrollH;
        imageView.y = 0;
        imageView.x = i * scrollW;
        //显示图片
        NSString *name = [NSString stringWithFormat:@"qidongtu%d",i+1];
        NSLog(@"%@",name);
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        //如果是最后一个ImageView,就往里面加入左划手势
        if (i == 4) {
            [self setupLastImageView:imageView];
        }
    }
    scrollView.contentSize = CGSizeMake(5 * scrollW, 0);
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, KScreenHeight - 36, KScreenWidth, 30)];
    self.pageControl.numberOfPages = 5;
    [self.view addSubview:self.pageControl];
    
    UIButton *skipBtn = [UIButton buttonWithType:0];
    skipBtn.frame = CGRectMake(KScreenWidth - 87, 25, 80, 30);
    skipBtn.layer.cornerRadius = 2;
    skipBtn.layer.masksToBounds = YES;
    [skipBtn setTitle:@"跳过>" forState:UIControlStateNormal];
    skipBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [skipBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [skipBtn addTarget:self action:@selector(startClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:skipBtn];
    
}

- (void)setupLastImageView:(UIImageView *)imageView
{
    
    
    //开启交互
    imageView.userInteractionEnabled = YES;
    UIButton *startButton = [[UIButton alloc]initWithFrame:imageView.bounds];
    [startButton addTarget:self action:@selector(startClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startButton];
    
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffset_x = scrollView.contentOffset.x;
    self.pageControl.currentPage = (int)((contentOffset_x + KScreenWidth)/KScreenWidth) - 1;
}

- (void)startClick:(UIButton *)sender
{
    NSLog(@"-----进入主页------");
    LandingpageViewController *loginVC=[[LandingpageViewController alloc]init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = loginVC;
    [self.view removeFromSuperview];
    
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

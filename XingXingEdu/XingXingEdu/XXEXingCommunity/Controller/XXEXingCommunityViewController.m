

//
//  XXEXingCommunityViewController.m
//  teacher
//
//  Created by Mac on 16/9/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEXingCommunityViewController.h"
#import "QHNavSliderMenu.h"
#import "XXEXingCommunityKindergartenViewController.h"
#import "XXEXingCommunityPrimaryViewController.h"
#import "XXEXingCommunityHighSchoolViewController.h"
#import "XXEXingCommunityInstitutionsViewController.h"
#import "XXEXingCommunityBabyCommunityViewController.h"
#import "XXEXingCommunityBabyLibraryViewController.h"


@interface XXEXingCommunityViewController ()<QHNavSliderMenuDelegate, UIScrollViewDelegate>
{
    UIButton *topicButton;//今日话题
    UIButton *libraryButton;//育儿库内容
    UIButton *communityButton;//社区
    QHNavSliderMenu *navSliderMenu;
    QHNavSliderMenuType menuType;
    NSMutableDictionary  *listVCQueue;
    UIScrollView *contentScrollView;
    int menuCount;
    
    NSTimer * timer;
    int count;
    UILabel * topicLabel;
    UIButton * supportBtn;
    UIButton * unSupportBtn;
    BOOL isSupport;
    BOOL isUnsupport;
    BOOL isExit;

}


@end

@implementation XXEXingCommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = UIColorFromRGB(0, 170, 42);
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.title = @"猩天地";
    UIButton *backBtn = [HHControl createButtonWithFrame:CGRectMake(0, 0, 45, 19) backGruondImageName:@"comment_back_icon" Target:self Action:@selector(doback:) Title:nil];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    menuCount = 4;
    
    [self initView];
    
    [self createButton];

}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //    [[NSRunLoop currentRunLoop]run];
    
    timer =[NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(showInfo:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}


-(void)doback:(NSTimer *)t{
    
    isExit=YES;
    //    [SVProgressHUD showSuccessWithStatus:@"已用时间60秒，获得猩币50个"];
    //    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)showInfo:(NSTimer *)t{
    
    count++;
    //    NSLog(@"程序运行了%i秒",count);
    if (isExit) {
        [t invalidate];//停止定时器
        timer = nil;
//        NSLog(@"一共运行了%i秒",count);
        
        NSString *timeStr = [NSString stringWithFormat:@"已用时间%i秒，获得猩币%i个", count,count/2];
        
        [self showHudWithString:timeStr];
//        [self showHudWithString:timeStr forSecond:1.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });

        
        //        count=0;
    }
    
}

- (void)initView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    QHNavSliderMenuStyleModel *model = [QHNavSliderMenuStyleModel new];
    NSMutableArray *titles = [[NSMutableArray alloc] initWithObjects:@"幼儿园",@"小学",@"中学",@"培训机构",nil];
    
    model.menuTitles = [titles copy];
    model.menuWidth=screenWidth/4;
    model.sliderMenuTextColorForNormal = QHRGB(120, 120, 120);
    model.sliderMenuTextColorForSelect = QHRGB(0, 170, 42);
    model.titleLableFont               = defaultFont(16);
    navSliderMenu = [[QHNavSliderMenu alloc] initWithFrame:(CGRect){0,160 * kScreenRatioHeight,screenWidth,50 * kScreenRatioHeight} andStyleModel:model andDelegate:self showType:menuType];
    navSliderMenu.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:navSliderMenu];
    
    ///如果只需要一个菜单 下面这些都可以不要  以下是个添加page视图的例子
    
    //example 用于滑动的滚动视图
    contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navSliderMenu.bottom, screenWidth, screenHeight-navSliderMenu.bottom)];
    contentScrollView.contentSize = (CGSize){screenWidth*menuCount,contentScrollView.contentSize.height};
    contentScrollView.pagingEnabled = YES;
    contentScrollView.delegate      = self;
    contentScrollView.scrollsToTop  = NO;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:contentScrollView];
    
    [self addListVCWithIndex:0];
}

#pragma mark -QHNavSliderMenuDelegate
- (void)navSliderMenuDidSelectAtRow:(NSInteger)row {
    //让scrollview滚到相应的位置
    [contentScrollView setContentOffset:CGPointMake(row*screenWidth, contentScrollView.contentOffset.y)  animated:NO];
    
    //用scrollView的滑动大小与屏幕宽度取整数 得到滑动的页数
    [navSliderMenu selectAtRow:(int)((contentScrollView.contentOffset.x+screenWidth/2.f)/screenWidth) andDelegate:NO];
    //根据页数添加相应的视图
    [self addListVCWithIndex:(int)(contentScrollView.contentOffset.x/screenWidth)];
}


#pragma mark scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //用scrollView的滑动大小与屏幕宽度取整数 得到滑动的页数
    [navSliderMenu selectAtRow:(int)((scrollView.contentOffset.x+screenWidth/2.f)/screenWidth) andDelegate:NO];
    //根据页数添加相应的视图
    [self addListVCWithIndex:(int)(scrollView.contentOffset.x/screenWidth)];
}

#pragma mark -addVC

- (void)addListVCWithIndex:(NSInteger)index {
    if (!listVCQueue) {
        listVCQueue=[[NSMutableDictionary alloc] init];
    }
    if (index<0||index>=menuCount) {
        return;
    }
    //根据页数添加相对应的视图 并存入数组
    //幼儿园
    XXEXingCommunityKindergartenViewController *xingCommunityKindergartenVC =[[XXEXingCommunityKindergartenViewController alloc] init];
    [self addChildViewController:xingCommunityKindergartenVC];
    xingCommunityKindergartenVC.view.left = 0* screenWidth;
    xingCommunityKindergartenVC.view.top=0;
    [contentScrollView addSubview:xingCommunityKindergartenVC.view];
    [listVCQueue setObject:xingCommunityKindergartenVC forKey:@(0)];
    
    //小学
    XXEXingCommunityPrimaryViewController *xingCommunityPrimaryVC =[[XXEXingCommunityPrimaryViewController alloc]init];
    [self addChildViewController:xingCommunityPrimaryVC];
    xingCommunityPrimaryVC.view.left =1*screenWidth;
    xingCommunityPrimaryVC.view.top=0;
    [contentScrollView addSubview:xingCommunityPrimaryVC.view];
    [listVCQueue setObject:xingCommunityPrimaryVC forKey:@(1)];

    //中学包含 初中 和 高中
    XXEXingCommunityHighSchoolViewController *xingCommunityHighSchoolVC =[[XXEXingCommunityHighSchoolViewController alloc]init];
    [self addChildViewController:xingCommunityHighSchoolVC];
    xingCommunityHighSchoolVC.view.left =2*screenWidth;
    xingCommunityHighSchoolVC.view.top =0;
    [contentScrollView addSubview:xingCommunityHighSchoolVC.view];
    [listVCQueue setObject:xingCommunityHighSchoolVC forKey:@(2)];
    
    //机构
    XXEXingCommunityInstitutionsViewController *xingCommunityInstitutionsVC =[[XXEXingCommunityInstitutionsViewController alloc]init];
    [self addChildViewController:xingCommunityInstitutionsVC];
    xingCommunityInstitutionsVC.view.left =3*screenWidth;
    xingCommunityInstitutionsVC.view.top=0;
    [contentScrollView addSubview:xingCommunityInstitutionsVC.view];
    [listVCQueue setObject:xingCommunityInstitutionsVC forKey:@(3)];

}

-(void)createButton
{
    //今日话题
    topicButton = [HHControl createButtonWithFrame:CGRectMake(0, 10 * kScreenRatioHeight,WinWidth, 71 * kScreenRatioHeight) backGruondImageName:@"community9" Target:self Action:@selector(onClicktopicBtn:) Title:nil];

    topicButton.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topicButton];
    
    topicLabel=[HHControl createLabelWithFrame:CGRectMake(80 * kScreenRatioWidth, 51 * kScreenRatioHeight ,WinWidth-100 * kScreenRatioWidth, 21 * kScreenRatioHeight) Font:12 Text:@"孩子牛奶喝的多好不好,会影响什么？"];
    topicLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topicLabel];
    
    supportBtn=[HHControl createButtonWithFrame:CGRectMake(310 * kScreenRatioWidth , 56 * kScreenRatioHeight,13 * kScreenRatioWidth, 11 * kScreenRatioHeight) backGruondImageName:@"community13" Target:self Action:@selector(supportBtnClick:) Title:nil];
    [self.view addSubview:supportBtn];
    
    unSupportBtn=[HHControl createButtonWithFrame:CGRectMake(340 * kScreenRatioWidth, 56 * kScreenRatioHeight,13 * kScreenRatioWidth, 11 * kScreenRatioHeight) backGruondImageName:@"community15" Target:self Action:@selector(unSupportBtnClick:) Title:nil];
    [self.view addSubview:unSupportBtn];
    
    //内容库
    libraryButton = [HHControl createButtonWithFrame:CGRectMake(0, 88 * kScreenRatioHeight, WinWidth, 65 * kScreenRatioHeight) backGruondImageName:@"" Target:self Action:@selector(onClickbabycontentBtn:) Title:@"内容库"];
    libraryButton.backgroundColor = [UIColor whiteColor];
    [libraryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:libraryButton];

}



-(void)supportBtnClick:(UIButton *)button{
    
    if (isSupport) {
        [supportBtn setBackgroundImage:[UIImage imageNamed:@"community13"] forState:UIControlStateNormal];
    }else{
        [supportBtn setBackgroundImage:[UIImage imageNamed:@"community12"] forState:UIControlStateNormal];
    }
    isSupport=!isSupport;
}
-(void)unSupportBtnClick:(UIButton *)button{
    
    if (isSupport) {
        [unSupportBtn setBackgroundImage:[UIImage imageNamed:@"community15"] forState:UIControlStateNormal];
    }else{
        [unSupportBtn setBackgroundImage:[UIImage imageNamed:@"community14"] forState:UIControlStateNormal];
    }
    isUnsupport=! isUnsupport;
}

#pragma mark ********** //内容库 *************
-(void)onClickbabycontentBtn:(UIButton*)Btn
{
    XXEXingCommunityBabyLibraryViewController * xingCommunityBabyLibraryVC = [[XXEXingCommunityBabyLibraryViewController alloc]init ];
    [self.navigationController pushViewController:xingCommunityBabyLibraryVC animated:YES];
    
}
//婴儿问答社区
-(void)onClickcommunityBtn:(UIButton*)Btn
{
    XXEXingCommunityBabyCommunityViewController * xingCommunityBabyCommunityVC = [[XXEXingCommunityBabyCommunityViewController alloc]init];
    xingCommunityBabyCommunityVC.url=@"http://www.xingxingedu.cn";
    [self.navigationController pushViewController:xingCommunityBabyCommunityVC animated:YES];
}
//今日话题
-(void)onClicktopicBtn:(UIButton *)Btn
{
    XXEXingCommunityBabyCommunityViewController * xingCommunityBabyCommunityVC = [[XXEXingCommunityBabyCommunityViewController alloc]init];
    xingCommunityBabyCommunityVC.url=@"http://www.xingxingedu.cn";
    [self.navigationController pushViewController:xingCommunityBabyCommunityVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



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
#import "XXEKindergartenDetailViewController.h"

@interface XXEXingCommunityViewController ()<QHNavSliderMenuDelegate, UIScrollViewDelegate>
{
    //今日话题 背景
    UIView *topicBgView;
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
    //今日话题
    UILabel * topicLabel;
    //标题
    UILabel *titleLabel;
    //支持数
    UILabel *supportNumLabel;
    //反对数
    UILabel *unsupportNumLabel;
    UIButton * supportBtn;
    UIButton * unSupportBtn;
    BOOL isSupport;
    BOOL isUnsupport;
    BOOL isExit;
    
    NSDictionary *todayTopicDic;

    NSString *parameterXid;
    NSString *parameterUser_Id;

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
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }

    UIButton *backBtn = [HHControl createButtonWithFrame:CGRectMake(0, 0, 45, 19) backGruondImageName:@"返回icon90x38" Target:self Action:@selector(doback:) Title:nil];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    menuCount = 4;
    todayTopicDic = [[NSDictionary alloc] init];
    
    //获取 今日话题 数据
    [self fetchTodayTopicInfo];
    
    [self initView];
    
    [self createButton];

}

#pragma mark ======== 获取今日话题 数据
- (void)fetchTodayTopicInfo{
/*
 【单个话题】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Global/xtd_article_suboftalk
 */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/xtd_article_suboftalk";
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE
                             };

    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
//        NSLog(@"今日话题 == %@",responseObj);
        
        if ([responseObj[@"code"] integerValue] == 1) {
            todayTopicDic = responseObj[@"data"];
        }
        [self updateTodayTopicInfo];
    } failure:^(NSError *error) {
        //
        [SVProgressHUD showErrorWithStatus:@"获取数据失败!"];
    }];

}

#pragma mark ======= 更新 今日话题 数据 =======
- (void)updateTodayTopicInfo{
    //标题
    titleLabel.text = todayTopicDic[@"title"];
    //支持数
    supportNumLabel.text = todayTopicDic[@"zheng_num"];
    
    //反对数
    unsupportNumLabel.text = todayTopicDic[@"fan_num"];
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //    [[NSRunLoop currentRunLoop]run];
    
    timer =[NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(showInfo:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}


-(void)doback:(NSTimer *)t{
    
    isExit=YES;
    
}

-(void)showInfo:(NSTimer *)t{
    
    count++;
    //    NSLog(@"程序运行了%i秒",count);
    if (isExit) {
        [t invalidate];//停止定时器
        timer = nil;
//        NSLog(@"一共运行了%i秒",count);
        
        NSString *timeStr = [NSString stringWithFormat:@"已用时间%i秒，获得猩币%i个", count,count/2];
        
        [self showHudWithString:timeStr forSecond:2];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });

        
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
//    [self addListVCWithIndex:(int)(contentScrollView.contentOffset.x/screenWidth)];
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
    topicBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 90 * kScreenRatioHeight)];
    topicBgView.backgroundColor = [UIColor whiteColor];
    topicBgView.userInteractionEnabled = YES;
    [self.view addSubview:topicBgView];
    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [topicBgView addGestureRecognizer:tap];

    //今日话题
    CGFloat labelW = 100 * kScreenRatioWidth;
    CGFloat labelH = 30 * kScreenRatioHeight;
    CGFloat labelX = (KScreenWidth - labelW) / 2;
    CGFloat labelY = 10 * kScreenRatioHeight;
    topicLabel = [HHControl createLabelWithFrame:CGRectMake( labelX, labelY, labelW, labelH) Font:18 * kScreenRatioWidth Text:@"今日话题"];
    topicLabel.textAlignment = NSTextAlignmentCenter;
    [topicBgView addSubview:topicLabel];
    
    titleLabel = [HHControl createLabelWithFrame:CGRectMake(10, topicLabel.frame.origin.y + topicLabel.height, KScreenWidth - 20, 20) Font:12 * kScreenRatioWidth Text:@""];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [topicBgView addSubview:titleLabel];
    
    //支持 按钮
    supportBtn=[HHControl createButtonWithFrame:CGRectMake(KScreenWidth / 2 + 50 * kScreenRatioWidth , titleLabel.frame.origin.y + titleLabel.height + 5,13 * kScreenRatioWidth, 11 * kScreenRatioHeight) backGruondImageName:@"community13" Target:self Action:@selector(supportBtnClick:) Title:nil];
    [topicBgView addSubview:supportBtn];
    
    supportNumLabel = [HHControl createLabelWithFrame:CGRectMake(supportBtn.frame.origin.x + supportBtn.width, titleLabel.frame.origin.y + titleLabel.height, 60 * kScreenRatioWidth, 20) Font:12 * kScreenRatioWidth Text:@""];
    [topicBgView addSubview:supportNumLabel];
    
    //反对 按钮
    unSupportBtn=[HHControl createButtonWithFrame:CGRectMake(supportNumLabel.frame.origin.x + supportNumLabel.width,titleLabel.frame.origin.y + titleLabel.height + 5,13 * kScreenRatioWidth, 11 * kScreenRatioHeight) backGruondImageName:@"community15" Target:self Action:@selector(unSupportBtnClick:) Title:nil];
    [topicBgView addSubview:unSupportBtn];
    
    unsupportNumLabel = [HHControl createLabelWithFrame:CGRectMake(unSupportBtn.frame.origin.x + unSupportBtn.width, titleLabel.frame.origin.y + titleLabel.height, 60 * kScreenRatioWidth, 20) Font:12 * kScreenRatioWidth Text:@""];
    [topicBgView addSubview:unsupportNumLabel];
    
    //内容库
    libraryButton = [HHControl createButtonWithFrame:CGRectMake(0, topicBgView.frame.origin.y + topicBgView.height + 5, WinWidth, 65 * kScreenRatioHeight) backGruondImageName:@"" Target:self Action:@selector(onClickbabycontentBtn:) Title:@"内容库"];
    libraryButton.backgroundColor = [UIColor whiteColor];
    [libraryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:libraryButton];

}

- (void)tapClick:(UITapGestureRecognizer *)tap{
    XXEKindergartenDetailViewController *kindergartenDetailVC = [[XXEKindergartenDetailViewController alloc] init];
    /*
     cat	//分类,1:幼儿园  2:小学  3:中学  4:培训机构
     id	//文章id
     */
    kindergartenDetailVC.cat = todayTopicDic[@"class"];
    kindergartenDetailVC.articleId = todayTopicDic[@"id"];
    [self.navigationController pushViewController:kindergartenDetailVC animated:YES];

}


#pragma Mark ======= 支持 按钮 =========
-(void)supportBtnClick:(UIButton *)button{
    
    [self todaytopicVote:todayTopicDic[@"id"] vote_type:@"1"];
//    if (isSupport) {
//        [supportBtn setBackgroundImage:[UIImage imageNamed:@"community13"] forState:UIControlStateNormal];
//    }else{
//        [supportBtn setBackgroundImage:[UIImage imageNamed:@"community12"] forState:UIControlStateNormal];
//    }
//    isSupport=!isSupport;
}

#pragma Mark ****** 反对 按钮 *********
-(void)unSupportBtnClick:(UIButton *)button{
     [self todaytopicVote:todayTopicDic[@"id"] vote_type:@"2"];
//    if (isSupport) {
//        [unSupportBtn setBackgroundImage:[UIImage imageNamed:@"community15"] forState:UIControlStateNormal];
//    }else{
//        [unSupportBtn setBackgroundImage:[UIImage imageNamed:@"community14"] forState:UIControlStateNormal];
//    }
//    isUnsupport=! isUnsupport;
}

- (void)todaytopicVote:(NSString *)article_id vote_type:(NSString *)vote_type{
/*
 【话题投票】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Global/xtd_article_vote
 传参:
 article_id 	//文章id
 vote_type	//1:同意  2:反对
 */
   
    NSString *url = @"http://www.xingxingedu.cn/Global/xtd_article_vote";
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE,
                             @"article_id":article_id,
                             @"vote_type":vote_type
                             };
    [WZYHttpTool post:url params:params success:^(id responseObj) {
        //
        if ([responseObj[@"code"] integerValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"投票成功!"];
        }else if ([responseObj[@"code"] integerValue] == 5) {
            [SVProgressHUD showErrorWithStatus:@"您已经投过票!"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"投票失败!"];
        }
    
    } failure:^(NSError *error) {
        //
        [SVProgressHUD showErrorWithStatus:@"获取数据失败!"];
    }];

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

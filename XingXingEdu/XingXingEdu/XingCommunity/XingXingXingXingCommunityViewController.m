//
//  XingXingXingXingCommunityViewController.m
//  Homepage
//
//  Created by super on 16/2/1.
//  Copyright © 2016年 Edu. All rights reserved.
//

#import "XingXingXingXingCommunityViewController.h"
#import "HHControl.h"
#import "contentRepositoryViewController.h"
#import "kindergartenViewController.h"
#import "primarySchoolViewController.h"
#import "juniorHighSchoolViewController.h"
#import "trainingInstitutionsViewController.h"
#import "SVProgressHUD.h"
#import "QHNavSliderMenu.h"
#import "WebViewController.h"

@interface XingXingXingXingCommunityViewController ()<QHNavSliderMenuDelegate,UIScrollViewDelegate>

{
    UIImageView *viewImage;
    UIButton * babycontentBtn;//育儿内容库
    UIButton * communityBtn;//育儿问答社区
    UIButton * topicBtn;//今日话题
    QHNavSliderMenu *navSliderMenu;
    NSMutableDictionary  *listVCQueue;
    UIScrollView *contentScrollView;
    int menuCount;
    
    NSTimer * timer;
    int count;
    UILabel * topicLabel;
     UIButton * zanBtn;
    UIButton * caiBtn;
    BOOL isZan;
     BOOL iscai;


}
@property (nonatomic,retain) UIImageView *viewImage;
//@property (nonatomic,retain) UIButton *babycontentBtn;
//@property (nonatomic,retain) UIButton *communityBtn;
//@property (nonatomic,retain) UIButton *topicBtn;
@property (nonatomic)QHNavSliderMenuType menuType;
@property(nonatomic,assign)BOOL isExit;

@end

@implementation XingXingXingXingCommunityViewController


//首页90x38@2x
- (void)viewDidLoad {
    [super viewDidLoad];
   [[self navigationItem] setTitle:@"猩天地"];

    UIButton *backBtn = [HHControl createButtonWithFrame:CGRectMake(0, 0, 45, 19) backGruondImageName:@"首页90x38" Target:self Action:@selector(doback:) Title:nil];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    
    self.view.backgroundColor =[UIColor whiteColor];
    
    menuCount =4;
    [self initView];

    [self createButton];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    
    
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showInfo:) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop]run];

    timer =[NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(showInfo:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}


-(void)doback:(NSTimer *)t{
    
    self.isExit=YES;
//    [SVProgressHUD showSuccessWithStatus:@"已用时间60秒，获得猩币50个"];
//    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)showInfo:(NSTimer *)t{
    
    count++;
//    NSLog(@"程序运行了%i秒",count);
    
    
    if (self.isExit) {
        [t invalidate];//停止定时器
        timer = nil;
        NSLog(@"一共运行了%i秒",count);
        
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"已用时间%i秒，获得猩币%i个", count,count/2]];
        [self.navigationController popViewControllerAnimated:YES];
        
//        count=0;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    QHNavSliderMenuStyleModel *model = [QHNavSliderMenuStyleModel new];
    NSMutableArray *titles = [[NSMutableArray alloc] initWithObjects:@"幼儿园",@"小学",@"中学",@"培训机构", nil];
    
    model.menuTitles = [titles copy];
    model.menuWidth=screenWidth/4;
    model.sliderMenuTextColorForNormal = QHRGB(120, 120, 120);
    model.sliderMenuTextColorForSelect = QHRGB(0, 170, 42);
    model.titleLableFont               = defaultFont(16);
    navSliderMenu = [[QHNavSliderMenu alloc] initWithFrame:(CGRect){0,160,screenWidth,50} andStyleModel:model andDelegate:self showType:self.menuType];
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
}

#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //用scrollView的滑动大小与屏幕宽度取整数 得到滑动的页数
    [navSliderMenu selectAtRow:(int)((scrollView.contentOffset.x+screenWidth/2.f)/screenWidth) andDelegate:NO];
    //根据页数添加相应的视图
    [self addListVCWithIndex:(int)(scrollView.contentOffset.x/screenWidth)];
    [self addListVCWithIndex:(int)(scrollView.contentOffset.x/screenWidth)+1];
    
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
    
    
    kindergartenViewController *oneVC =[kindergartenViewController new];
    [self addChildViewController:oneVC];
    oneVC.view.left = 0* screenWidth;
    oneVC.view.top=0;
    [contentScrollView addSubview:oneVC.view];
    [listVCQueue setObject:oneVC forKey:@(0)];
    
    
    primarySchoolViewController *twoVC =[[primarySchoolViewController alloc]init];
    [self addChildViewController:twoVC];
    twoVC.view.left =1*screenWidth;
    twoVC.view.top=0;
    [contentScrollView addSubview:twoVC.view];
    [listVCQueue setObject:twoVC forKey:@(1)];
    
    
    juniorHighSchoolViewController *threeVC =[[juniorHighSchoolViewController alloc]init];
    [self addChildViewController:threeVC];
    threeVC.view.left =2*screenWidth;
    threeVC.view.top =0;
    [contentScrollView addSubview:threeVC.view];
    [listVCQueue setObject:threeVC forKey:@(2)];
    
    trainingInstitutionsViewController *fourVC =[[trainingInstitutionsViewController alloc]init];
    [self addChildViewController:fourVC];
    fourVC.view.left =3*screenWidth;
    fourVC.view.top=0;
    [contentScrollView addSubview:fourVC.view];
    [listVCQueue setObject:fourVC forKey:@(3)];
    

    
}

-(void)createButton
{
    UIImageView *img=[HHControl createImageViewWithFrame:CGRectMake(0, 0, WinWidth,160 ) ImageName:@"community4.png"];
    [self.view addSubview:img];
//
    babycontentBtn = [HHControl createButtonWithFrame:CGRectMake(0, 88, WinWidth/2, 65) backGruondImageName:@"community10.png" Target:self Action:@selector(onClickbabycontentBtn:) Title:nil];
    babycontentBtn.userInteractionEnabled = YES;
    [self.view addSubview:babycontentBtn];
//
    communityBtn = [HHControl createButtonWithFrame:CGRectMake(WinWidth/2+1, 88, WinWidth/2, 65) backGruondImageName:@"community11.png" Target:self Action:@selector(onClickcommunityBtn:) Title:nil];
    communityBtn.userInteractionEnabled = YES;
    [self.view addSubview:communityBtn];
    
   
    
//
    topicBtn = [HHControl createButtonWithFrame:CGRectMake(0, 10,WinWidth, 71) backGruondImageName:@"community9.png" Target:self Action:@selector(onClicktopicBtn:) Title:nil];
    topicBtn.userInteractionEnabled = YES;
    [self.view addSubview:topicBtn];
    
    topicLabel=[HHControl createLabelWithFrame:CGRectMake(80, 51,WinWidth-100, 21) Font:12 Text:@"孩子牛奶喝的多好不好,会影响什么？"];
    [self.view addSubview:topicLabel];
    
    zanBtn=[HHControl createButtonWithFrame:CGRectMake(300, 56,13, 11) backGruondImageName:@"community13.png" Target:self Action:@selector(zan) Title:nil];
    [self.view addSubview:zanBtn];
    
    caiBtn=[HHControl createButtonWithFrame:CGRectMake(330, 56,13, 11) backGruondImageName:@"community15.png" Target:self Action:@selector(cai) Title:nil];
    [self.view addSubview:caiBtn];
    
    
}

-(void)zan{
   
    if (isZan) {
        [zanBtn setBackgroundImage:[UIImage imageNamed:@"community13.png"] forState:UIControlStateNormal];
    }else{
       [zanBtn setBackgroundImage:[UIImage imageNamed:@"community12.png"] forState:UIControlStateNormal];
    }
     isZan=!isZan;
}
-(void)cai{
    
    if (iscai) {
        [caiBtn setBackgroundImage:[UIImage imageNamed:@"community15.png"] forState:UIControlStateNormal];
    }else{
        [caiBtn setBackgroundImage:[UIImage imageNamed:@"community14.png"] forState:UIControlStateNormal];
    }
    iscai=!iscai;
}

//婴儿内容库
-(void)onClickbabycontentBtn:(UIButton*)Btn
{
    contentRepositoryViewController * forVC = [[contentRepositoryViewController alloc]init ];
    [self.navigationController pushViewController:forVC animated:YES];
    //[self.navigationController pushViewController:forVC animated:YES];
    
}
//婴儿问答社区
-(void)onClickcommunityBtn:(UIButton*)Btn
{
    WebViewController * webVC = [[WebViewController alloc]init];
    webVC.url=@"http://www.xingxingedu.cn";
        [self.navigationController pushViewController:webVC animated:YES];
}
//今日话题
-(void)onClicktopicBtn:(UIButton *)Btn
{
    WebViewController * webVC = [[WebViewController alloc]init];
    webVC.url=@"http://www.xingxingedu.cn";
    [self.navigationController pushViewController:webVC animated:YES];
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

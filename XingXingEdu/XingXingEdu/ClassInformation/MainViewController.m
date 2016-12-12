//
//  MainViewController.m
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/1/14.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "MainViewController.h"
#import "CharactersViewController.h"
#import "ContactPersonViewController.h"
#import "KTCommentViewController.h"
#import "KTPicterViewController.h"
#import "KTConnectViewController.h"
#import "WZYSchoolCollectionViewController.h"
#import "WZYCoureseCollectionViewController.h"
#import "UtilityFunc.h"
@interface MainViewController ()<QHNavSliderMenuDelegate,UIScrollViewDelegate,UISearchBarDelegate>
{
    QHNavSliderMenu *navSliderMenu;
    NSMutableDictionary *listVCQueue;
    UIScrollView *contentScrollView;
    UISearchBar *searchBar;
    UISearchController *_searchDC;
    int menuCount;
}
@end

@implementation MainViewController
- (void)viewWillAppear:(BOOL)animated{
 [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0, 170, 42)];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"我的收藏";
    menuCount =7;
    self.view.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    [self initView];
    [self createRightBar];
    [self addListVCWithIndex:0];


}
- (void)createRightBar{
    //searchBar
    UIBarButtonItem *searchBa = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"NavBarIconSearch_blue@2x"] style:UIBarButtonItemStylePlain target:self action:@selector(searchB:)];
    self.navigationItem.rightBarButtonItem =searchBa;
   
    
}
- (void)searchB:(UIBarButtonItem*)btn{
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,20, kWidth, 44)];
    UIImage *backgroundImg = [UtilityFunc createImageWithColor:UIColorFromHex(0xf0eaf3) size:searchBar.frame.size];
    [searchBar setBackgroundImage:backgroundImg];
    searchBar.placeholder =@"请输入您想要查询的收藏内容";
    searchBar.tintColor = [UIColor blackColor];
    searchBar.delegate =self;
    _searchDC = [[UISearchController alloc]initWithSearchResultsController:self];
    [self.navigationItem.titleView sizeToFit];
    [self.navigationController.view addSubview:searchBar];
      searchBar.showsCancelButton =YES;
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    //搜尋結束後，恢復原狀
    return YES;
}
#pragma mark - search bar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchB{
    searchB.showsCancelButton = YES;
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchB{
    
    searchB.showsCancelButton = NO;
    [searchB resignFirstResponder];
    [searchB removeFromSuperview];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [searchBar endEditing:YES];
}

- (void)initView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    QHNavSliderMenuStyleModel *model = [QHNavSliderMenuStyleModel new];
    NSMutableArray *titles = [[NSMutableArray alloc] initWithObjects:@"小红花",@"用户",@"点评",@"图片",@"链接",@"学校",@"课程",nil];
    model.menuTitles = [titles copy];
    model.menuHorizontalSpacing = 1;
    model.donotScrollTapViewWhileScroll = YES;
    navSliderMenu = [[QHNavSliderMenu alloc] initWithFrame:(CGRect){0,64,kWidth,50} andStyleModel:model andDelegate:self showType:self.menuType];
    navSliderMenu.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:navSliderMenu];
    
    ///如果只需要一个菜单 下面这些都可以不要  以下是个添加page视图的例子
    
    //example 用于滑动的滚动视图
    contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navSliderMenu.bottom, kWidth, kHeight-navSliderMenu.bottom)];
    contentScrollView.contentSize = (CGSize){kWidth*menuCount,contentScrollView.contentSize.height};
    contentScrollView.pagingEnabled = YES;
    contentScrollView.delegate      = self;
    contentScrollView.scrollsToTop  = NO;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:contentScrollView];

}
#pragma mark -QHNavSliderMenuDelegate
- (void)navSliderMenuDidSelectAtRow:(NSInteger)row {
    //让scrollview滚到相应的位置
    [contentScrollView setContentOffset:CGPointMake(row*screenWidth, contentScrollView.contentOffset.y)  animated:NO];
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
   //@"小红花",@"用户",@"点评",@"图片",@"链接",@"学校",@"课程"
    //@"小红花"
    
//    NSLog(@"index === %ld", index);
    
    if (index == 0) {
        CharactersViewController *classAlbumVC =[[CharactersViewController alloc]init];
        [self addChildViewController:classAlbumVC];
        classAlbumVC.view.left = 0* screenWidth;
        classAlbumVC.view.top=0;
        
        [contentScrollView addSubview:classAlbumVC.view];
        [listVCQueue setObject:classAlbumVC forKey:@(0)];
    }else if (index == 1){
        //@"用户"
        ContactPersonViewController *classSubjectVC = [[ContactPersonViewController alloc]init];
        [self addChildViewController:classSubjectVC];
        classSubjectVC.view.left =1*screenWidth;
        classSubjectVC.view.top=0;
        [contentScrollView addSubview:classSubjectVC.view];
        [listVCQueue setObject:classSubjectVC forKey:@(1)];
    
    }else if (index == 2){
        //@"点评"
        KTCommentViewController *classTelephoneVC =[[KTCommentViewController alloc]init];
        [self addChildViewController:classTelephoneVC];
        classTelephoneVC.view.left =2*screenWidth;
        classTelephoneVC.view.top =0;
        [contentScrollView addSubview:classTelephoneVC.view];
        [listVCQueue setObject:classTelephoneVC forKey:@(2)];
        
    }else if (index == 3){
        //@"图片"
        KTPicterViewController *classHomeworkVC = [[KTPicterViewController alloc]init];
        [self addChildViewController:classHomeworkVC];
        classHomeworkVC.view.left =3*screenWidth;
        classHomeworkVC.view.top =0;
        [contentScrollView addSubview:classHomeworkVC.view];
        [listVCQueue setObject:classHomeworkVC forKey:@(3)];
        
    }else if (index == 4){
        //@"链接"
        KTConnectViewController *SchoolRecipesVC = [[KTConnectViewController alloc]init];
        [self addChildViewController:SchoolRecipesVC];
        SchoolRecipesVC.view.left =4*screenWidth;
        SchoolRecipesVC.view.top =0;
        [contentScrollView addSubview:SchoolRecipesVC.view];
        [listVCQueue setObject:SchoolRecipesVC forKey:@(4)];
        
    }else if (index == 5){
        //@"学校"
        WZYSchoolCollectionViewController *schoolCollectVC =[[WZYSchoolCollectionViewController alloc]init];
        [self addChildViewController:schoolCollectVC];
        schoolCollectVC.view.left =5*screenWidth;
        schoolCollectVC.view.top =0;
        [contentScrollView addSubview:schoolCollectVC.view];
        [listVCQueue setObject:schoolCollectVC forKey:@(5)];
        
    }else if (index == 6){
        //@"课程"
        WZYCoureseCollectionViewController *WZYCoureseCollectionVC = [[WZYCoureseCollectionViewController alloc]init];
        [self addChildViewController:WZYCoureseCollectionVC];
        WZYCoureseCollectionVC.view.left =6*screenWidth;
        WZYCoureseCollectionVC.view.top =0;
        [contentScrollView addSubview:WZYCoureseCollectionVC.view];
        [listVCQueue setObject:WZYCoureseCollectionVC forKey:@(6)];
    
    }

    
}


@end

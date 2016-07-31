//
//  ShoolInfoViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/3/17.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define tele 17081377258
#define    padding    20
#define    KTile    @"学校简介"
#import "ShoolInfoViewController.h"
#import "OrganInfoViewController.h"
#import "ShooClaViewController.h"
#import "PresidentMessageViewController.h"
#import "ClassRoomHomePageViewController.h"
#import "RegistTeacherViewController.h"
#import "StarRemarkViewController.h"
#import "MBProgressHUD.h"
#import "HHControl.h"
#import "ViewController.h"
@interface ShoolInfoViewController ()<QHNavSliderMenuDelegate,UIScrollViewDelegate>
{
    QHNavSliderMenu *navSliderMenu;
    NSMutableDictionary *listVCQueue;
    UIScrollView *contentScrollView;
    int menuCount;
    UIImageView *headimageview;
    UIButton *saveBtn;
    UIImageView *headbgimageview;
    MBProgressHUD *HUDH;

}
@end

@implementation ShoolInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =KTile;
      menuCount =3;
   self.view.backgroundColor = UIColorFromRGB(116,205, 169);
    // Do any additional setup after loading the view.
    [self createRightBar];
    
}
- (void)createRightBar{
    headbgimageview = [[UIImageView alloc] initWithFrame:CGRectMake(0,64, kWidth, 200)];
    headbgimageview.image = [UIImage imageNamed:@"note_bg.png"];
    headbgimageview.tag=10;
    headbgimageview.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:headbgimageview];
    headimageview = [[UIImageView alloc] initWithFrame:CGRectMake(130, 102, 108, 105)];
    headimageview.image = [UIImage imageNamed:@"beijing"];
    headbgimageview.userInteractionEnabled =YES;
    headimageview.contentMode = UIViewContentModeScaleAspectFill;
    headimageview.layer.masksToBounds = YES;
    headimageview.layer.cornerRadius = 50;
    [headbgimageview addSubview:headimageview];
    [self createPeopleInfo];
    [self initView];
    [self addSe];
    [self saveBtn];

}
- (void)saveBtn{
    saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(280, 80, 40, 40)];
    saveBtn.layer.cornerRadius =5;
    saveBtn.layer.masksToBounds =YES;
    [saveBtn setBackgroundColor:[UIColor orangeColor]];
    [saveBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [headbgimageview addSubview:saveBtn];
    [saveBtn addTarget:self action:@selector(shareB:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)shareB:(UIButton*)shareBtn{
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
- (void)addSe{
    UIImageView *manimage = [[UIImageView alloc]initWithFrame:CGRectMake(45, 80, 20, 20)];
    manimage.image = [UIImage imageNamed:@""];
    [headimageview addSubview:manimage];
    //
    //性别符号
    
}
- (void)initView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    QHNavSliderMenuStyleModel *model = [QHNavSliderMenuStyleModel new];
    NSMutableArray *titles = [[NSMutableArray alloc] initWithObjects:@"机构简介",@"学校课程",@"校长致辞",nil];
    
    model.menuTitles = [titles copy];
    model.menuHorizontalSpacing =60;
    
    navSliderMenu = [[QHNavSliderMenu alloc] initWithFrame:(CGRect){0,360,kWidth+100,30} andStyleModel:model andDelegate:self showType:self.menuType];
    navSliderMenu.backgroundColor = UIColorFromRGB(116,205, 169);
    //[UIColor groupTableViewBackgroundColor];
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
    
  OrganInfoViewController   *teleHomepageVC =[[OrganInfoViewController alloc]init];
    [self addChildViewController:teleHomepageVC];
    teleHomepageVC.view.left = 0* screenWidth;
    teleHomepageVC.view.top=0;
    [contentScrollView addSubview:teleHomepageVC.view];
    [listVCQueue setObject:teleHomepageVC forKey:@(0)];
    //
    //
   ShooClaViewController *coursesVC = [[ShooClaViewController alloc]init];
    [self addChildViewController:coursesVC];
    coursesVC.view.left =1*screenWidth;
    coursesVC.view.top=0;
    [contentScrollView addSubview:coursesVC.view];
    [listVCQueue setObject:coursesVC forKey:@(1)];
    //
    //
    PresidentMessageViewController *teacherAppearVC =[[PresidentMessageViewController alloc]init];
    [self addChildViewController:teacherAppearVC];
    teacherAppearVC.view.left =2*screenWidth;
    teacherAppearVC.view.top =0;
    [contentScrollView addSubview:teacherAppearVC.view];
    [listVCQueue setObject:teacherAppearVC forKey:@(2)];
    //
    
    
}
- (void)clickaddBtn{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)createPeopleInfo{
   
    UIButton *nametitleBtn =[HHControl createButtonWithFrame:CGRectMake(50,300, 170, 20) backGruondImageName:@"" Target:self Action:@selector(nameBtn) Title:@"注册教师: 20"];
    [self.view addSubview:nametitleBtn];
    
 
    UILabel *nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nametitleBtn.frame.origin.x+170, 300, 200, 20)];
    NSString *nickname = @" 注册学生: 1200";
    nicknameLabel.text = nickname;
    nicknameLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:nicknameLabel];
    //  星级评分
    UIButton *starBtn =[HHControl createButtonWithFrame:CGRectMake(30, 330, 90, 20) backGruondImageName:@"" Target:self Action:@selector(staBtn) Title:[NSString stringWithFormat:@"星级评分: %@",@"20"]];
    starBtn.titleLabel.font =[UIFont systemFontOfSize:15];
    [self.view addSubview:starBtn];
    
    
    
    UILabel *teletitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(150,330, kWidth-100, 20)];
    teletitleLabel.text = [NSString stringWithFormat:@"  浏览: %@           收藏: %@",@"100",@"1257"];
    teletitleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:teletitleLabel];
    

    NSArray *arr =[NSArray arrayWithObjects:@"北京大学",@"北京大学",@"北京大学",@"北京大学",@"北京大学", nil];
    
    UILabel *scoreLabel =[[UILabel alloc]initWithFrame:CGRectMake(150, 275, 200, 20)];
    NSString *score = arr[arc4random()%5];
    scoreLabel.text =score;
    [self.view addSubview:scoreLabel];
    
}
- (void)staBtn{
    StarRemarkViewController *starRemarkVC =[[StarRemarkViewController alloc]init];
    [self.navigationController pushViewController:starRemarkVC animated:YES];

}
- (void)nameBtn{
  
    RegistTeacherViewController *registTeacherVC =[[RegistTeacherViewController alloc]init];
    [self.navigationController pushViewController:registTeacherVC animated:YES];

}
- (void)firendBtn:(UIButton*)btn{

    
}
- (BOOL)isDirectShareInIconActionSheet{
    return YES;
}
- (void)shareBtn:(UIButton*)btn{
}
- (void)lookBtn:(UIButton*)btn{
    
    ViewController *viewVC = [ViewController new];
    viewVC.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:viewVC animated:NO];
    
}
//举报
- (void)chatBtn:(UIButton*)btn{
    
//    ReportPicViewController *reportVC =[[ReportPicViewController alloc]init];
//    [self.navigationController pushViewController:reportVC animated:YES];
//    
}
- (void)openBaiduUrl:(UIButton*)btn{
    // [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.baidu.com"]];
}

- (void)openUrl:(UIButton*)btn{
    
    //    NSString *telUrl =[NSString stringWithFormat:@"tel://%ld",tele];
    //    telUrl= [telUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //
    //    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:telUrl]];
    
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

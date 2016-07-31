//
//  TeleViewController.m
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/1/23.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define tele 17081377258
#define    padding    20
#import "TeleViewController.h"
#import "AuditSetViewController.h"
#import "TeacherAppearViewController.h"
#import "CoursesViewController.h"
#import "TeleHomepageViewController.h"
#import "ReportPicViewController.h"
#import "ShooClaViewController.h"
#import "MBProgressHUD.h"
#import "HHControl.h"

// UM
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
@interface TeleViewController ()<QHNavSliderMenuDelegate,UIScrollViewDelegate,UMSocialUIDelegate>
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

@implementation TeleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    menuCount =3;
    // Do any additional setup after loading the view.
    self.title = @"详细资料";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets= YES;
    
    self.view.backgroundColor = UIColorFromRGB(196, 213, 255);
    
    headbgimageview = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, kWidth, 200)];
    headbgimageview.image = [UIImage imageNamed:@"note_bg.png"];
    headbgimageview.tag=10;
    headbgimageview.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:headbgimageview];
    headimageview = [[UIImageView alloc] initWithFrame:CGRectMake(130, 102, 108, 105)];
    headimageview.image = [UIImage imageNamed:self.imagStr];
    headbgimageview.userInteractionEnabled =YES;
    headimageview.contentMode = UIViewContentModeScaleAspectFill;
    headimageview.layer.masksToBounds = YES;
    headimageview.layer.cornerRadius = 50;
    [headbgimageview addSubview:headimageview];
    [self createRightItem];
    [self createPeopleInfo];
    [self initView];
    [self addSe];
    [self saveBtn];
}
- (void)saveBtn{
    saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(250, 110, 40, 40)];
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
    manimage.image = [UIImage imageNamed:@"man"];
    [headimageview addSubview:manimage];
    //
    //性别符号
    
}
- (void)initView{
//    self.automaticallyAdjustsScrollViewInsets = YES;
    QHNavSliderMenuStyleModel *model = [QHNavSliderMenuStyleModel new];
    NSMutableArray *titles = [[NSMutableArray alloc] initWithObjects:@"主页",@"课程",@"教师风采",nil];
    
    model.menuTitles = [titles copy];
    model.menuHorizontalSpacing =60;
    model.sliderMenuTextColorForNormal = QHRGB(120, 120, 120);
    model.sliderMenuTextColorForSelect = QHRGB(255, 255, 255);
    model.titleLableFont               = defaultFont(16);
    navSliderMenu = [[QHNavSliderMenu alloc] initWithFrame:(CGRect){0,360,kWidth+100,30} andStyleModel:model andDelegate:self showType:self.menuType];
    navSliderMenu.backgroundColor =UIColorFromRGB(196, 213, 255);
    [self.view addSubview:navSliderMenu];
    
    ///如果只需要一个菜单 下面这些都可以不要  以下是个添加page视图的例子
    
    //example 用于滑动的滚动视图
    contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navSliderMenu.bottom, kWidth, kHeight-navSliderMenu.bottom-37)];
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
    
    TeleHomepageViewController *teleHomepageVC =[[TeleHomepageViewController alloc]init];
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
    TeacherAppearViewController *teacherAppearVC =[[TeacherAppearViewController alloc]init];
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


- (void)createRightItem{
    
    UIBarButtonItem *rightBtn =[[UIBarButtonItem alloc]initWithTitle:@"权限设置" style:UIBarButtonItemStylePlain target:self action:@selector(clickBtn:)];
    [self.navigationItem  setRightBarButtonItem:rightBtn];
    
}
- (void)clickBtn:(UIBarButtonItem*)btn{
    AuditSetViewController *auditSetVC =[[AuditSetViewController alloc]init];
    [self.navigationController pushViewController:auditSetVC animated:YES];
    
}
- (void)createPeopleInfo{
    //    UIButton *gradeBtn = [[UIButton alloc]initWithFrame:CGRectMake(80, 200, 80, 25)];
    //    [gradeBtn setImage:[UIImage imageNamed:@"upgrade_lv@2x"] forState:UIControlStateNormal];
    //    UIImageView *bgimage =(UIImageView*)[self.view viewWithTag:10];
    //    [bgimage addSubview:gradeBtn];
    //
    //    UIButton *panBtn = [[UIButton alloc]initWithFrame:CGRectMake(210, 200, 40, 40)];
    //    [panBtn setImage:[UIImage imageNamed:@"star_icon@2x"] forState:UIControlStateNormal];
    //
    //    [bgimage addSubview:panBtn];
    /**
     *nickname
     */
    UILabel *nametitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70,300, 70, 20)];
    nametitleLabel.text = @"个性签名:";
    nametitleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:nametitleLabel];
    
    UILabel *nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nametitleLabel.frame.origin.x+70, 300, 200, 20)];
    NSString *nickname = @" 好好学习，天天向上！";
    nicknameLabel.text = nickname;
    nicknameLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:nicknameLabel];
    
    
    UILabel *teletitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding,330, kWidth, 20)];
    teletitleLabel.text = [NSString stringWithFormat:@"            学生: %@   粉丝: %@   浏览: %@",@"20",@"100",@"1257"];
    teletitleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:teletitleLabel];
    NSArray *arr =[NSArray arrayWithObjects:@"⭐️⭐️",@"⭐️⭐️⭐️⭐️",@"初级",@"中级",@"特级", nil];
    //nickName
    UILabel *nicknameLab = [[UILabel alloc] initWithFrame:CGRectMake(130,275, 100, 20)];
    NSString *nickn = self.name;
    nicknameLab.text = nickn;
    nicknameLab.font = [UIFont boldSystemFontOfSize:15];
    [self.view addSubview:nicknameLab];
    UILabel *scoreLabel =[[UILabel alloc]initWithFrame:CGRectMake(190, 275, 200, 20)];
    NSString *score = arr[arc4random()%5];
    scoreLabel.text =score;
    [self.view addSubview:scoreLabel];
    
    
    UIButton *shareBtn = [HHControl createButtonWithFrame:CGRectMake(0, kHeight-37, kWidth/4, 37) backGruondImageName:nil Target:self Action:@selector(chatBtn:) Title:@"发起聊天"];
    shareBtn.backgroundColor =UIColorFromRGB(248, 144, 34);
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [shareBtn setTintColor:[UIColor whiteColor]];
    shareBtn.layer.cornerRadius = 5.0f;
    [self.view addSubview:shareBtn];
    
    UIButton *lookBtn = [HHControl createButtonWithFrame:CGRectMake(kWidth/4,kHeight-37,kWidth/4, 37) backGruondImageName:nil Target:self Action:@selector(lookBtn:) Title:@"查看圈子"];
    lookBtn.backgroundColor =UIColorFromRGB(248, 144, 34);
    lookBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [lookBtn setTintColor:[UIColor whiteColor]];
    lookBtn.layer.cornerRadius = 5.0f;
    [self.view addSubview:lookBtn];
    
    UIButton *chatBtn = [HHControl createButtonWithFrame:CGRectMake(kWidth/2, kHeight-37, kWidth/4, 37) backGruondImageName:nil Target:self Action:@selector(firendBtn:) Title:@"分享给好友"];
    chatBtn.backgroundColor =UIColorFromRGB(248, 144, 34);
    chatBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [chatBtn setTintColor:[UIColor whiteColor]];
    chatBtn.layer.cornerRadius = 5.0f;
    [self.view addSubview:chatBtn];
    
    
    UIButton *reportBtn = [HHControl createButtonWithFrame:CGRectMake(kWidth*3/4, kHeight-37, kWidth/4, 37) backGruondImageName:nil Target:self Action:@selector(chatBtn:) Title:@"举报"];
    reportBtn.backgroundColor =UIColorFromRGB(248, 144, 34);
    reportBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [reportBtn setTintColor:[UIColor whiteColor]];
    reportBtn.layer.cornerRadius = 5.0f;
    [self.view addSubview:reportBtn];
    
}

//分享
- (void)firendBtn:(UIButton*)btn{
    
    [UMSocialSnsService  presentSnsIconSheetView:self appKey:@"56d4096e67e58ef29300147c" shareText:@"keenteam" shareImage:[UIImage imageNamed:@"11111.png"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToQzone,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToSina,UMShareToQQ,nil] delegate:self];
    
}
- (BOOL)isDirectShareInIconActionSheet{
    return YES;
}
//查看圈子
- (void)lookBtn:(UIButton*)btn{
}
//聊天
- (void)chatBtn:(UIButton*)btn{
    
    //    ReportPicViewController *reportVC =[[ReportPicViewController alloc]init];
    //    [self.navigationController pushViewController:reportVC animated:YES];
    
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

//
//  TeleTeachInfoViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/4/8.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "TeleTeachInfoViewController.h"
#define tele 17081377258
#define    padding    20
#import "TeacherAppearViewController.h"
#import "TeleHomepageViewController.h"
#import "ReportPicViewController.h"
#import "ShooClaViewController.h"
#import "CoreUMeng.h"
//#import "UserViewController.h"
//#import "PersonCenterViewController.h"
#import "YSProgressView.h"

#define kUnderButtonH 64.0f
#define Kmarg 25.0f
#define KLabelW 60.0f
#define KheadViewH 80.0f
#define KDistance 10.0f

// UM
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"

#import "WMConversationViewController.h"



@interface TeleTeachInfoViewController ()<QHNavSliderMenuDelegate,UIScrollViewDelegate,UMSocialUIDelegate>
{
    QHNavSliderMenu *navSliderMenu;
    NSMutableDictionary *listVCQueue;
    UIScrollView *contentScrollView;
    int menuCount;
    UIImageView *headimageview;
    UIButton *saveBtn;
    UIImageView *headbgimageview;
    MBProgressHUD *HUDH;
    UIView *_personalInfo;
    
    NSMutableArray *headDetailArr;//头部详细资料
    NSMutableArray *subjectArr; //课程
    NSMutableArray *techerLifeArr;//教学风采
    NSMutableArray *teacher_pic_group;
    NSMutableArray *homePageArr;//主页
    NSString *_xid;
    BOOL isCollect;
    
//     YSProgressView *ysView;
    UIProgressView *progressView;
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
}
@end

@implementation TeleTeachInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone ;
    self.automaticallyAdjustsScrollViewInsets= NO;
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    menuCount =3;
    // Do any additional setup after loading the view.
    self.title = @"详细资料";
    self.view.backgroundColor = UIColorFromRGB(255, 255, 255);
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    [self createButtomBtn];
    
    [self getSubjectInfo:self.teacherId];
    
}
#pragma mark 网络 获取老师详情
//获取老师详细资料
- (void)getSubjectInfo:(NSString *)teacherId{

    headDetailArr = [NSMutableArray array];
    subjectArr  = [NSMutableArray array];
    techerLifeArr = [NSMutableArray array];
    teacher_pic_group = [NSMutableArray array];
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/xkt_teacher_detail";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"teacher_id":teacherId,
                           };
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//                 NSLog(@"~~~~~~~~~~_______________________%@",dict);
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] ){
             //1代表收藏过, 2代表未收藏
             if([[NSString stringWithFormat:@"%@",dict[@"data"][@"cheeck_collect"]] isEqualToString:@"1"]){
                 UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
                 [rightButton setImage:[UIImage imageNamed:@"commentInfo10.png"]forState:UIControlStateNormal];
                 [rightButton addTarget:self action:@selector(collectbtn:)forControlEvents:UIControlEventTouchUpInside];
                 UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
                 self.navigationItem.rightBarButtonItem= rightItem;
                 isCollect=YES;
                 
                 
             }else if([[NSString stringWithFormat:@"%@",dict[@"data"][@"cheeck_collect"]] isEqualToString:@"2"]){
                 UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
                 [rightButton setImage:[UIImage imageNamed:@"commentInfo9.png"]forState:UIControlStateNormal];
                 [rightButton addTarget:self action:@selector(collectbtn:)forControlEvents:UIControlEventTouchUpInside];
                 UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
                 self.navigationItem.rightBarButtonItem= rightItem;
                 isCollect=NO;
                 
             }
             //头像
             /*
              0 :表示 自己 头像 ，需要添加 前缀
              1 :表示 第三方 头像 ，不需要 添加 前缀
              //判断是否是第三方头像
              */

             NSString * head_img ;
             if ([dict[@"data"][@"head_img_type"] integerValue] == 0) {
                 head_img = [NSString stringWithFormat:@"%@%@", picURL, dict[@"data"][@"head_img"]];
             }else{
                 head_img = [NSString stringWithFormat:@"%@",dict[@"data"][@"head_img"]];
             }
             //老师名字
             NSString * tname = [NSString stringWithFormat:@"%@",dict[@"data"][@"tname"]];
             //个性签名
             NSString * personal_sign = [NSString stringWithFormat:@"%@",dict[@"data"][@"personal_sign"]];
             //学生
             NSString * baby_count = [NSString stringWithFormat:@"%@次",dict[@"data"][@"baby_count"]];
             //收藏
             NSString * collect_num = [NSString stringWithFormat:@"%@次",dict[@"data"][@"collect_num"]];
             //浏览
             NSString * read_num =[NSString stringWithFormat:@"%@",dict[@"data"][@"read_num"]];
             
             NSString *next_grade_coin = [NSString stringWithFormat:@"%@",dict[@"data"][@"next_grade_coin"]];
             NSString *coin_total = [NSString stringWithFormat:@"%@",dict[@"data"][@"coin_total"]];
             
            NSString *lv = [NSString stringWithFormat:@"%@",dict[@"data"][@"lv"]];
             //xid 收藏 取消收藏  聊天调用
             _xid = [NSString stringWithFormat:@"%@",dict[@"data"][@"xid"]];
             
             
             headDetailArr = [[NSMutableArray alloc] initWithObjects:head_img,tname,personal_sign,baby_count,collect_num,read_num,next_grade_coin,coin_total,lv,nil];
             //主页
             NSString * graduate_sch =[NSString stringWithFormat:@"%@",dict[@"data"][@"graduate_sch"]];
             NSString * teach_range =[NSString stringWithFormat:@"%@",dict[@"data"][@"teach_range"]];
             NSString * age =[NSString stringWithFormat:@"%@",dict[@"data"][@"age"]];
             NSString * certification =[NSString stringWithFormat:@"%@",dict[@"data"][@"certification"]];
             NSString * phone =[NSString stringWithFormat:@"%@",dict[@"data"][@"phone"]];
             NSString * qq =[NSString stringWithFormat:@"%@",dict[@"data"][@"qq"]];
             NSString * email =[NSString stringWithFormat:@"%@",dict[@"data"][@"email"]];
             
             homePageArr = [[NSMutableArray alloc] initWithObjects:graduate_sch,teach_range,age,certification,phone,qq,email, nil];
             
             //课程
             for (NSDictionary *dic in dict[@"data"][@"course_group"] ) {
                 
                 NSString * course_pic = [picURL stringByAppendingString:dic[@"course_pic"]];
                 NSString * course_name=dic[@"course_name"];
                 
                 NSMutableArray *teacher_tname_group=[NSMutableArray array];
                 for (NSString * name in dic[@"teacher_tname_group"]) {
                     [teacher_tname_group addObject:name];
                 }
                 NSString * need_num=[NSString stringWithFormat:@"%@人班",dic[@"need_num"]];
                 NSString *  now_num=[NSString stringWithFormat:@"%@",dic[@"now_num"]];
                 
                 NSString * original_price=[NSString stringWithFormat:@"%@",dic[@"original_price"]];
                 NSString *  now_price=[NSString stringWithFormat:@"%@",dic[@"now_price"]];
                 NSString * distance=[NSString stringWithFormat:@"%@.000",dic[@"distance"]];
                 
                 distance=[distance substringWithRange:NSMakeRange(0, 4)];
                 NSString * coin=[NSString stringWithFormat:@"%@",dic[@"coin"]];
                 NSString * allow_return=[NSString stringWithFormat:@"%@",dic[@"allow_return"]];
                 NSString *courseId = [NSString stringWithFormat:@"%@",dic[@"id"]];
       
                 NSMutableArray *arr=[NSMutableArray arrayWithObjects:course_pic, course_name,teacher_tname_group,need_num,now_num,original_price,now_price,coin,allow_return,courseId,nil];
                 [subjectArr addObject:arr];
             }
             
             //教学经历
             //教学经验
             NSString * teach_life =[NSString stringWithFormat:@"%@",dict[@"data"][@"teach_life"]];
             //教学感悟
             NSString * teach_feel =[NSString stringWithFormat:@"%@",dict[@"data"][@"teach_feel"]];
             techerLifeArr = [[NSMutableArray alloc] initWithObjects:teach_life,teach_feel, nil];
             //相册
             teacher_pic_group = dict[@"data"][@"teacher_pic_group"];
             
         }
         [self createPeopleInfo];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@""];
     }];
}

//创建头视图
- (void)createPeopleInfo{
    //头试图
    _personalInfo = [[UIView alloc] initWithFrame:CGRectMake(0,0, kWidth, 200)];
    [self.view addSubview:_personalInfo];
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"banner"]];
    [_personalInfo setBackgroundColor:bgColor];
    
    //头像
    headimageview = [[UIImageView alloc] initWithFrame:CGRectMake(Kmarg - 5, Kmarg, KheadViewH, KheadViewH)];
    [headimageview sd_setImageWithURL:[NSURL URLWithString:headDetailArr[0]] placeholderImage:[UIImage imageNamed:@"人物头像172x172"]];
    headbgimageview.userInteractionEnabled =YES;
    headimageview.contentMode = UIViewContentModeScaleAspectFill;
    headimageview.layer.cornerRadius= headimageview.bounds.size.width/2;
    headimageview.layer.masksToBounds=YES;
    [_personalInfo addSubview:headimageview];
    
    //nickName
    UILabel *nicknameLab = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(headimageview.frame) + KDistance, Kmarg, KLabelW, Kmarg) Font:15 Text:headDetailArr[1]];
    nicknameLab.textColor = [UIColor whiteColor];
    [_personalInfo addSubview:nicknameLab];
    
   UILabel *scoreLabel = [HHControl createLabelWithFrame:CGRectMake(nicknameLab.x + nicknameLab.size.width + KDistance, 27, 40 * kWidth / 375, 18 * kWidth / 375) Font:12 Text:[NSString stringWithFormat:@"LV%@",headDetailArr[8]]];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    scoreLabel.textColor = UIColorFromRGB(3, 169, 244);
    scoreLabel.backgroundColor = [UIColor whiteColor];
    scoreLabel.layer.cornerRadius = 5;
    scoreLabel.layer.masksToBounds = YES;
    [_personalInfo addSubview:scoreLabel];
    
    //个性签名
    UILabel *nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headimageview.frame) + KDistance,CGRectGetMaxY(nicknameLab.frame), kWidth - CGRectGetMaxX(headimageview.frame) - KDistance, Kmarg)];
    if ([headDetailArr[2] isEqualToString:@""]) {
        nicknameLabel.text = @"个性签名:这人很懒，什么都没写";
    }else{
        nicknameLabel.text =[NSString stringWithFormat:@"个性签名:%@",headDetailArr[2]] ;
    }
    nicknameLabel.textColor = [ UIColor whiteColor];
    nicknameLabel.font = [UIFont systemFontOfSize:12];
    [_personalInfo addSubview:nicknameLabel];
    
    // 学生人数 粉丝人数 浏览次数
    UILabel *teletitleLabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(headimageview.frame) + KDistance,CGRectGetMaxY(nicknameLabel.frame) - KDistance/2, kWidth - headimageview.x - headimageview.size.width, Kmarg) Font:12 Text:[NSString stringWithFormat:@"学生: %@   收藏: %@   浏览: %@",headDetailArr[3],headDetailArr[4],headDetailArr[5]]];
    teletitleLabel.textColor = [UIColor whiteColor];
    teletitleLabel.textAlignment = NSTextAlignmentLeft;
    [_personalInfo addSubview:teletitleLabel];
    
    
    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.frame =CGRectMake(teletitleLabel.x, CGRectGetMaxY(teletitleLabel.frame) + 5, 180, 1);
    // 设置已过进度部分的颜色
    progressView.progressTintColor = UIColorFromRGB(229, 229, 229);
    // 设置未过进度部分的颜色
    progressView.trackTintColor = UIColorFromRGB(67, 181, 59);
    progressView.progress = [headDetailArr[7] floatValue] / [headDetailArr[6] floatValue];
    
    
    [self.view addSubview:progressView];
    
    QHNavSliderMenuStyleModel *model = [QHNavSliderMenuStyleModel new];
    NSMutableArray *titles = [[NSMutableArray alloc] initWithObjects:@"主页",@"课程",@"教师风采",nil];
    model.menuTitles = [titles copy];
    model.menuHorizontalSpacing = 60;
    model.donotScrollTapViewWhileScroll = YES;
    model.sliderMenuTextColorForNormal = QHRGB(120, 120, 120);       
    model.sliderMenuTextColorForSelect = QHRGB(255, 255, 255);
    model.titleLableFont               = defaultFont(14);
    navSliderMenu = [[QHNavSliderMenu alloc] initWithFrame:(CGRect){0,_personalInfo.size.height - 65,kWidth,65} andStyleModel:model andDelegate:self showType:self.menuType];
    [_personalInfo addSubview:navSliderMenu];
    
    contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navSliderMenu.bottom - 10, kWidth, kHeight - navSliderMenu.bottom-37-65)];
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
    teleHomepageVC.homePageArr = homePageArr;
    [self addChildViewController:teleHomepageVC];
    teleHomepageVC.view.left = 0* screenWidth;
    teleHomepageVC.view.top=0;
    [contentScrollView addSubview:teleHomepageVC.view];
    [listVCQueue setObject:teleHomepageVC forKey:@(0)];
    
    ShooClaViewController *coursesVC = [[ShooClaViewController alloc]init];
    coursesVC.subjectArray = subjectArr;
    [self addChildViewController:coursesVC];
    coursesVC.view.left =1*screenWidth;
    coursesVC.view.top=0;
    [contentScrollView addSubview:coursesVC.view];
    [listVCQueue setObject:coursesVC forKey:@(1)];
    
    TeacherAppearViewController *teacherAppearVC =[[TeacherAppearViewController alloc]init];
    teacherAppearVC.teacher_pic_group = teacher_pic_group;
    teacherAppearVC.techerLifeArr = techerLifeArr;
    [self addChildViewController:teacherAppearVC];
    teacherAppearVC.view.left =2*screenWidth;
    teacherAppearVC.view.top =0;
    [contentScrollView addSubview:teacherAppearVC.view];
    [listVCQueue setObject:teacherAppearVC forKey:@(2)];
}



-(void)collectbtn:(UIButton *)btn{
    
    if (isCollect== NO) {
        
        [self collectArticle];
        
    }
    else  if (isCollect== YES) {
        [self deleteCollectArticle];
    }

}

//收藏老师
- (void)collectArticle
{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/collect";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"collect_id":_xid,
                           @"collect_type":@"3",
                           
                           };
    //    NSLog(@"%@",dict);
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             [SVProgressHUD showSuccessWithStatus:@"收藏课程成功"];
             UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
             [rightButton setBackgroundImage:[UIImage imageNamed:@"commentInfo10.png"] forState:UIControlStateNormal];
             UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
             self.navigationItem.rightBarButtonItem= rightItem;
             [rightButton addTarget:self action:@selector(collectbtn:)forControlEvents:UIControlEventTouchUpInside];
             isCollect=!isCollect;
             
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@""];
     }];
}

//取消收藏老师
- (void)deleteCollectArticle
{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/deleteCollect";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"collect_id":_xid,
                           @"collect_type":@"3",
                           
                           };
    //    NSLog(@"%@",dict);
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] ){
             [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];
             UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
             [rightButton setBackgroundImage:[UIImage imageNamed:@"commentInfo9.png"] forState:UIControlStateNormal];
             UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
             self.navigationItem.rightBarButtonItem= rightItem;
             [rightButton addTarget:self action:@selector(collectbtn:)forControlEvents:UIControlEventTouchUpInside];
             isCollect=!isCollect;
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@""];
         
     }];
}
//创建底部button
-(void)createButtomBtn {
    //底部按钮
    UIView *underButton = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 64 - 49, kWidth, 64)];
//    underButton.backgroundColor = [UIColor blueColor];
    [self.view addSubview:underButton];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, kWidth, 1)];
    line.backgroundColor = UIColorFromRGB(239, 232, 233);
    [underButton addSubview:line];
    //发起聊天
    UIButton *talkBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 1, kWidth/4, kUnderButtonH)];
    [talkBtn setImage:[UIImage imageNamed:@"发起聊天icon48x48@2x.png"] forState:UIControlStateNormal];
    [talkBtn setImage:[UIImage imageNamed:@"发起聊天(H)icon48x48@2x.png"] forState:UIControlStateHighlighted];
    talkBtn.imageEdgeInsets = UIEdgeInsetsMake(5,(talkBtn.frame.size.width - 24)/2,30,(talkBtn.frame.size.width - 24)/2);
    talkBtn.imageView.frame = CGRectMake(0, 0, 24, 24);
    [talkBtn setTitle:@"发起聊天" forState:UIControlStateNormal];
    [talkBtn setTitleColor:UIColorFromRGB(159,159,159) forState:UIControlStateNormal];
    [talkBtn setTitleColor:UIColorFromRGB(0,172,54) forState:UIControlStateHighlighted];
    talkBtn.titleEdgeInsets = UIEdgeInsetsMake(20, -talkBtn.titleLabel.bounds.size.width - 25, 0, 0);
    talkBtn.backgroundColor =[UIColor clearColor];
    talkBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [talkBtn addTarget:self action:@selector(clickchatBtn:) forControlEvents:UIControlEventTouchUpInside];
    [underButton addSubview:talkBtn];
    
    // 查看我的圈子
    
    UIButton *lookBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth/4,1,kWidth/4, kUnderButtonH)];
    [lookBtn setImage:[UIImage imageNamed:@"查看我的圈子icon48x48@2x.png"] forState:UIControlStateNormal];
    [lookBtn setImage:[UIImage imageNamed:@"查看我的圈子(H)icon48x48@2x.png"] forState:UIControlStateHighlighted];
    lookBtn.imageEdgeInsets = UIEdgeInsetsMake(5,(talkBtn.frame.size.width - 18)/2,30,(talkBtn.frame.size.width - 24)/2);
    lookBtn.imageView.frame = CGRectMake(0, 0, 24, 24);
    [lookBtn setTitle:@"查看圈子" forState:UIControlStateNormal];
    [lookBtn setTitleColor:UIColorFromRGB(159,159,159) forState:UIControlStateNormal];
    [lookBtn setTitleColor:UIColorFromRGB(0,172,54) forState:UIControlStateHighlighted];
    lookBtn.titleEdgeInsets = UIEdgeInsetsMake(20, - lookBtn.titleLabel.bounds.size.width - 20, 0, 0);
    lookBtn.backgroundColor =[UIColor clearColor];
    lookBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [lookBtn addTarget:self action:@selector(clickLookBtn:) forControlEvents:UIControlEventTouchUpInside];
    [underButton addSubview:lookBtn];
    
    //分享
    
    UIButton *shareBtn= [[UIButton alloc]initWithFrame:CGRectMake(kWidth/2, 1, kWidth/4, kUnderButtonH)];
    [shareBtn setImage:[UIImage imageNamed:@"分享icon48x48@2x.png"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"分享(H)icon48x48@2x.png"] forState:UIControlStateHighlighted];
    shareBtn.imageEdgeInsets = UIEdgeInsetsMake(5,(talkBtn.frame.size.width - 24)/2,30,(talkBtn.frame.size.width - 24)/2);
    shareBtn.imageView.frame = CGRectMake(0, 0, 24, 24);
    [shareBtn setTitle:@"分享好友" forState:UIControlStateNormal];
    [shareBtn setTitleColor:UIColorFromRGB(159,159,159) forState:UIControlStateNormal];
    [shareBtn setTitleColor:UIColorFromRGB(0,172,54) forState:UIControlStateHighlighted];
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(20, - shareBtn.titleLabel.bounds.size.width - 20, 0, 0);
    shareBtn.backgroundColor = [UIColor clearColor];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [shareBtn addTarget:self action:@selector(clickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    [underButton addSubview:shareBtn];
    
    //举报
    UIButton *reportBtn= [[UIButton alloc]initWithFrame:CGRectMake(kWidth*3/4, 1, kWidth/4, kUnderButtonH)];
    [reportBtn setImage:[UIImage imageNamed:@"举报icon48x48@2x.png"] forState:UIControlStateNormal];
    [reportBtn setImage:[UIImage imageNamed:@"举报(H)icon48x48@2x.png"] forState:UIControlStateHighlighted];
    reportBtn.imageEdgeInsets = UIEdgeInsetsMake(5,(talkBtn.frame.size.width - 24)/2,30,(talkBtn.frame.size.width - 24)/2);
    reportBtn.imageView.frame = CGRectMake(0, 0, 24, 24);
    [reportBtn setTitle:@"举报" forState:UIControlStateNormal];
    [reportBtn setTitleColor:UIColorFromRGB(159,159,159) forState:UIControlStateNormal];
    [reportBtn setTitleColor:UIColorFromRGB(0,172,54) forState:UIControlStateHighlighted];
    reportBtn.titleEdgeInsets = UIEdgeInsetsMake(20, - reportBtn.titleLabel.bounds.size.width - 25 , 0, 0);
    reportBtn.backgroundColor = [UIColor clearColor];
    reportBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    reportBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter;
    [reportBtn addTarget:self action:@selector(clickReportBtn:) forControlEvents:UIControlEventTouchUpInside];
    [underButton addSubview:reportBtn];
    
    for (NSUInteger i = 1; i < 4; i++) {
        UIImageView *line=[HHControl createImageViewFrame:CGRectMake(i* kWidth/4 + 2,5, 1, 40) imageName:nil color:[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3]];
        [underButton addSubview:line];
        
    }
    
}

- (BOOL)isDirectShareInIconActionSheet{
    return YES;
}

//发起聊天
- (void)clickchatBtn:(UIButton*)btn{
//    NSLog(@"聊聊");
//    PersonCenterViewController *chatVC =[[PersonCenterViewController alloc] init];

    
    NSString * userId = [XXEUserInfo user].user_id;
    
    NSString * userNickName = [XXEUserInfo user].nickname;
    
    NSString * userPortraitUri = [XXEUserInfo user].user_head_img;
    
    RCUserInfo *_currentUserInfo =
    [[RCUserInfo alloc] initWithUserId:userId
                                  name:userNickName
                              portrait:userPortraitUri];
    [RCIM sharedRCIM].currentUserInfo = _currentUserInfo;
    
    WMConversationViewController *vc = [[WMConversationViewController alloc] init];
    
    vc.conversationType = ConversationType_PRIVATE;
    vc.targetId = _xid;
    vc.title = headDetailArr[1];
    [self.navigationController pushViewController:vc animated:YES];
}

//查看朋友圈
- (void)clickLookBtn:(UIButton*)btn{
    NSLog(@"我来看你啦");
//        UserViewController *lookVC =[[UserViewController alloc]init];
//        lookVC.xidStr = _xid;
//        [self.navigationController pushViewController:lookVC animated:YES];
}
- (void)clickShareBtn:(UIButton*)btn{
    
    [CoreUmengShare show:self text:@"为了孩子的未来,这里有你想要的一切,快点点击下载吧！https://itunes.apple.com/cn/app/jie-dian-qian-zhuan-ye-ban/id1112373854?mt=8&v0=WWW-GCCN-ITSTOP100-FREEAPPS&l=&ign-mpt=uo%3D4" image:[UIImage imageNamed:@"猩猩教室.png"] ];
}
//举报
- (void)clickReportBtn:(UIButton*)btn{
    
    ReportPicViewController *reportVC =[[ReportPicViewController alloc]init];
    
    //举报 人 来源
//    reportVC.other_xidStr = _teacherId;
    NSString *str;
    if (_teacherXid != nil) {
        str = _teacherXid;
    }else if (_managerXid != nil){
        str = _managerXid;
    }
    reportVC.other_xidStr = str;
//    NSLog(@"%@", str);
    
    [self.navigationController pushViewController:reportVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickaddBtn{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Umeng delegate
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        [SVProgressHUD showInfoWithStatus:@"分享成功"];
    } else {
        [SVProgressHUD showInfoWithStatus:@"分享失败"];
    }
}


@end

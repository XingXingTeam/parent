
//  HomepageViewController.m
//  Homepage
//
//  Created by super on 16/1/14.
//  Copyright © 2016年 Edu. All rights reserved.
//
#import "HomepageViewController.h"
#define SCHOOL_NAME  @"学校名称"
#define GRADE_CLASS  @"年级班级"
#define EDIT_CLASS   @"编辑班级"
#define DATA_URL     @"http://www.xingxingedu.cn/Parent/home_data"
#import "HHControl.h"
#import "shezhiViewController.h"
#import "flowerViewController.h"
#import "CPTextViewPlaceholder.h"
#import "WJCommboxView.h"

#import "XingXingXingXingCommunityViewController.h"
#import "noticeViewController.h"
#import "addbabyViewController.h"
#import "StoreHomePageViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import "BMKMapViewController.h"
#import "CommentsRootTabbarViewController.h"

#import "CheckInViewController.h"
#import "WZYBabyCenterViewController.h"
#import "MainViewController.h"
#import "VideoMonitorViewController.h"
#import "XXEFriendMyCircleViewController.h"
#import "MyHeadViewController.h"
#import "OtherPeopleViewController.h"
#import "ClassEditInfoViewController.h"
#import "ClassEditViewController.h"
//#import "ClassSubjectTimeTableViewController.h"
#import "FlowerBasketViewController.h"
#import "RcRootTabbarViewController.h"
#import "RootTabbarViewController.h"
#import "MyTabBarController.h"
#import "AFNetworking.h"
#import "ClassAlbumViewController.h"
//#import "ClassSubjectViewController.h"
#import "ClassTelephoneViewController.h"
#import "ClassHomeworkViewController.h"
#import "SchoolRecipesViewController.h"
#import "LogoTabBarController.h"
#import "AuthenticationViewController.h"
#import "WZYAddBabyViewController.h"
#import "LandingpageViewController.h"
#import "XXEUserInfo.h"
#import <RongIMKit/RongIMKit.h>

#import "ClassEditViewController.h"
//课程表
#import "XXESchoolTimetableViewController.h"

//首页  头像
#import "ZJCircularBtn.h"

#import "RCDataManager.h"

#import "RCUserInfo+Addition.h"

#import "XXENewCourseView.h"

@interface HomepageViewController ()<UIScrollViewDelegate, ZJCircularBtnDelegate, UIAlertViewDelegate>
{

    //最上面 背景
    UIImageView *upBackgroundImageView;
    
    //中间
    UIView *middleBackgroundView;
    
    //下面
    UIImageView *downBackgroundImageView;
    
    //头像 滚动头像
    UIView *headView;
    
    UIButton *flowerBtn;
    UIButton *flowersBtn;
    UIButton *xingbiBtn;
    UIButton *hurnBtn;
    UIImageView *UserImage;
    UIImageView *BackImage;
    UILabel *nameLabel;
    UILabel *ageLabel;
    UILabel *numberLabel;
    UILabel *levelLabel;
    UILabel *titleLabel;
    
    UILabel *fnumberLabel;
    UILabel *xnumberLabel;
    UILabel *fsnumberLabel;
    UIImageView *manimage;

    UIScrollView * _scrollView;

    MyTabBarController *_tbBar;
    NSString *coin_able;
    NSString *fbasket_able;
    NSString *flower_able;
    NSString *lv;
    NSString *baby_id1;
    NSString *coin_total;
    NSString *next_grade_coin;

    
    //孩子id数组
    NSMutableArray *baby_idArray;
    //孩子 头像
    NSMutableArray *head_imgArray;
    //孩子年龄
    NSMutableArray *ageArray;
    //孩子 名称
    NSMutableArray *tnameArray;
    //个性签名
    NSMutableArray *personl_signArray;
    //孩子上的学校
    NSMutableArray *school_infoArray;
    //孩子 班级 信息
    NSMutableArray *classInfoArray;
    
    //班级 信息
    NSMutableArray *classNameArray;
    NSMutableArray *classIdArray;
    
    //孩子 家人 信息
    NSMutableArray *family_memberArray;
    
    //根据 头像 滑动 偏移量 判断 是哪个宝贝
    NSInteger offSet;
    
    //下拉框  宝贝 学校 数组
    NSMutableArray *commboxSchoolArray;
    NSMutableArray *commboxSchoolIdArray;
    
    //下拉框  宝贝 年级 数组
    NSMutableArray *commboxGradeAndClassArray;
    NSMutableArray *commboxIDArray;
    
    //左边 选中 学校 的是第几行
    NSInteger didSelectedSchoolRow;
    //右边 选中 的班级 是第几行
    NSInteger didSelectedClassRow;
    
    
    NSArray *buttonPicArray;
    
    //logo 图片
    NSMutableArray *logoPicArray;
    
    UIImageView *logoImageView;
    //进度条
    YSProgressView *ysView;
    //宝贝 性别 数组
    NSMutableArray *babySexArray;
    
    //请求参数
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
}



@property(nonatomic,strong) WJCommboxView *schoolNameCombox;
@property (nonatomic,strong) WJCommboxView *gradeAndClassbox;

//学校id
@property (nonatomic, copy) NSString *schoolId;
//年级
@property (nonatomic, copy) NSString *gradeStr;
//班级
@property (nonatomic, copy) NSString *classStr;

//首页 头像 宝贝

@property(nonatomic,strong)ZJCircularBtn *btn;
@property (nonatomic, strong) UIView *dimBackgroundView;
@property (nonatomic, strong) NSMutableArray *pictureArray;


@end

@implementation HomepageViewController


//首页 长按 宝贝 头像 出现 阴影 重写方法
//重写 方法
- (UIView *)dimBackgroundView{
    if (!_dimBackgroundView) {
        self.dimBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        _dimBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];

    }
    
    return _dimBackgroundView;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden =YES;
    self.navigationItem.hidesBackButton =YES;
    self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0, 170, 42);
     [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    flower_able = @"";
    fbasket_able = @"";
    coin_able = @"";
    
    [self createData];
    
    //花数
    fnumberLabel.text = [NSString stringWithFormat:@": %@", flower_able];
    
    //花篮数
    fsnumberLabel.text = [NSString stringWithFormat:@": %@", fbasket_able];
    
    //星币
    xnumberLabel.text = [NSString stringWithFormat:@": %@", coin_able];
    
    
    [_schoolNameCombox.listTableView reloadData];
    [_gradeAndClassbox.listTableView reloadData];
    [self initNewCourseView];

}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.schoolNameCombox.textField removeObserver:self forKeyPath:@"text"];
    [self.gradeAndClassbox.textField removeObserver:self forKeyPath:@"text"];
    
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden =NO;
    
    if (baby_id1 == nil && baby_idArray.count != 0) {
        baby_id1 = baby_idArray[0];
        
    }
    
    [DEFAULTS setObject:baby_id1 forKey:@"BABYID"];
    
//    NSLog(@"%@", baby_id1);
    
    [DEFAULTS setObject:_schoolId forKey:@"SCHOOL_ID"];
    
    [DEFAULTS setObject:_gradeStr forKey:@"GRADE"];
    
    [DEFAULTS setObject:_classStr forKey:@"CLASS"];
    
    //学校
    [DEFAULTS setObject:_schoolNameCombox.textField.text forKey:@"SCHOOLNAME"];
    
    [DEFAULTS setObject:_gradeAndClassbox.textField.text forKey:@"GRADEANDCLASS"];
    
//    NSString *str = [DEFAULTS objectForKey:@"CLASS_ID"];
    
//    NSLog(@"CLASS_ID == %@", str);
    
    [DEFAULTS synchronize];
    
    
//    NSLog(@"%@ == %@ == %@", [DEFAULTS objectForKey:@"SCHOOL_ID"], [DEFAULTS objectForKey:@"CLASS"], [DEFAULTS objectForKey:@"BABYID"]);
}

//创建通知
-(void)creatNotification{
    UILocalNotification *n = [[UILocalNotification alloc] init];
    n.fireDate = [NSDate dateWithTimeIntervalSinceNow:100000000000000];
    n.repeatInterval = 0;
    n.alertBody = @"生日快乐！";
//@"生日快乐";
    n.applicationIconBadgeNumber = [UIApplication sharedApplication].scheduledLocalNotifications.count + 1;
    n.userInfo = @{@"notiId":@"1"};
    [[UIApplication sharedApplication] scheduleLocalNotification:n];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }

    buttonPicArray = [[NSArray alloc] initWithObjects:@"实时监控icon98x134", @"相册icon98x134", @"课程表icon98x134", @"通讯录icon98x134", @"聊天icon98x134", @"点评icon98x134", @"作业icon98x134", @"食谱icon98x134", @"猩天地icon98x134", @"猩猩商城icon98x134", @"", @"", nil];
    
    //设置 背景图片
    [self settingBackgroundImageView];
    
    //创建 通知
    [self creatNotification];
    
    [self createLabels];
    
    //学校 年级 下拉框
    [self createWJCommboxViews];
//    融云的初始化
   [self connectionFromRongServer];
    
}

//MARK: - 新手教程
-(void)initNewCourseView{
    
    NSUserDefaults *first = [NSUserDefaults standardUserDefaults];
    NSString *isFirst = [first objectForKey:@"isFirst"];
    
    if (!isFirst) {
        UIWindow *window = [[UIApplication sharedApplication] windows][1];
        XXENewCourseView *newCourseView = [[XXENewCourseView alloc] init];
        [window addSubview:newCourseView];
    }
    
    isFirst = @"NO";
    [first setObject:isFirst  forKey:@"isFirst"];
    [first synchronize];
    
    
}

- (void)connectionFromRongServer
{
    
    if ([XXEUserInfo user].login) {
        [[RCIM sharedRCIM]initWithAppKey:@"4z3hlwrv3t0dt"];
        //登录融云服务器//
        
        //        NSString *token = [DEFAULTS objectForKey:@"RCUserToken"];
        
        NSString *token = [XXEUserInfo user].token;
        
        NSString *userId = [XXEUserInfo user].user_id;
        
        NSString *userNickName = [XXEUserInfo user].nickname;
        
        NSString *userPortraitUri = [XXEUserInfo user].user_head_img;
        
        RCUserInfo *_currentUserInfo =
        [[RCUserInfo alloc] initWithUserId:userId
                                      name:userNickName
                                  portrait:userPortraitUri];
        [RCIM sharedRCIM].currentUserInfo = _currentUserInfo;
        
        //    NSLog(@"_currentUserInfo -- %@", _currentUserInfo);
        
        [[RCIM sharedRCIM]connectWithToken:token success:^(NSString *userId) {
            NSLog(@"登陆成功当前用户ID为%@",userId);
            
            [[RCDataManager shareManager] loginRongCloudWithUserInfo:[[RCUserInfo alloc] initWithUserId:userId name:userNickName portrait:userPortraitUri QQ:nil sex:nil] withToken:token];
            //            [[RCDataManager shareManager] loginRongCloudWithUserInfo:_currentUserInfo withToken:token];
            
        } error:^(RCConnectErrorCode status) {
            NSLog(@"登录错误%ld",(long)status);
        } tokenIncorrect:^{
            NSLog(@"token错误");
        }];
        
    }
    
}


- (void)settingBackgroundImageView{

    //BGGROUDIMAGE  上面 绿色 背景 （学校Logo 等）
    upBackgroundImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 275 * kWidth / 375)];
    upBackgroundImageView.backgroundColor =UIColorFromRGB(0, 170, 42);
    upBackgroundImageView.userInteractionEnabled = YES;
//    [Image addSubview:upBackgroundImageView];
    [self.view addSubview:upBackgroundImageView];
    
    //创建 上面 绿色 背景 的内容
    [self createUpBackgroundContent];
    
    /**
     *  BGView  中间 花篮 星币 小红花 通知
     **/
    
    middleBackgroundView =[[UIView alloc]initWithFrame:CGRectMake(0, upBackgroundImageView.frame.origin.y + upBackgroundImageView.frame.size.height, kWidth, 46 * kWidth / 375)];
    
    //分界线条
    UIView *ling11=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 3)];
    ling11.backgroundColor =UIColorFromRGB(241, 242, 241);
    
    [middleBackgroundView addSubview:ling11];
    
    UIView *ling12=[[UIView alloc]initWithFrame:CGRectMake(0, middleBackgroundView.frame.size.height - 3, kWidth, 3)];
    ling12.backgroundColor =UIColorFromRGB(241, 242, 241);
    [middleBackgroundView addSubview:ling12];
    
    middleBackgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:middleBackgroundView];
    
    //创建  中间 绿色 背景 的内容
    [self createMiddleBackgroundContent];
    
    //BGGROUDIMAGE 下面 十二宫格 背景
    downBackgroundImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, middleBackgroundView.frame.origin.y + middleBackgroundView.frame.size.height, kWidth, kHeight - middleBackgroundView.frame.origin.y - middleBackgroundView.frame.size.height - 49)];
    downBackgroundImageView.backgroundColor = UIColorFromRGB(222, 222, 222);
    downBackgroundImageView.userInteractionEnabled = YES;

    [self.view addSubview:downBackgroundImageView];
    //创建 十个 按钮
    [self  createButtons];
    
}


- (void)createUpBackgroundContent{

    if (![XXEUserInfo user].login){
    
        /**
         * 快速注册
         */
        UIButton *registerBtn = [HHControl createButtonWithFrame:CGRectMake(kWidth-45, 37 * kWidth / 375 , 31 * kWidth / 375 , 31 * kHeight / 667) backGruondImageName:@"快速注册62x62" Target:self Action:@selector(onClickRegister) Title:nil];
        
        [upBackgroundImageView addSubview:registerBtn];
        
    }

     [self createCircleHeadImageView];

}


- (void)createCircleHeadImageView{
    
    //头像bgView
    headView = [[UIView alloc] initWithFrame:CGRectMake(35 * kWidth / 375, upBackgroundImageView.centerY - 30, 120 * kWidth / 375, 120 * kHeight / 667)];
    
    headView.userInteractionEnabled =YES;
    headView.layer.cornerRadius = headView.frame.size.width / 2;
    headView.layer.masksToBounds =YES;
    headView.backgroundColor = [UIColor whiteColor];
    //    [self.view addSubview:headView];
    [upBackgroundImageView addSubview:headView];
    
    //头像ScrollView
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(35 * kWidth / 375, upBackgroundImageView.centerY - 30, 120 * kWidth / 375, 120 * kHeight / 667)];
    _scrollView.layer.cornerRadius = headView.frame.size.width / 2;
    _scrollView.layer.masksToBounds =YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate =self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator =NO;
    [upBackgroundImageView addSubview:_scrollView];
    
}


//加载数据
- (void)createData{
    
    //路径
    NSString *urlStr = DATA_URL;
    
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE
                             };
    
//    NSLog(@"params === %@", params);
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
//        NSLog(@"首页  数据 ==== %@", responseObj);
        
        if ([[NSString stringWithFormat:@"%@", [responseObj objectForKey:@"code"]] isEqualToString:@"1"]) {
            NSDictionary *dict =[responseObj objectForKey:@"data"];
            
//            NSLog(@"首页 === %@", dict);
                        //星币//花篮  //红花 //等级
            
            if ([dict[@"coin_able"]  length] >= 5) {
            
                            CGFloat coinNum = [dict[@"coin_able"] floatValue] / 10000;
                            coin_able = [NSString stringWithFormat:@"%.2f万", coinNum];
            
                        }else if(dict[@"coin_able"] != nil){
                             coin_able =dict[@"coin_able"];
                        }else{
                             coin_able = @"";
                        }
            
            if (dict[@"fbasket_able"] == nil) {
                fbasket_able = @"";
            }else{
                fbasket_able = dict[@"fbasket_able"];
            }
            
            if (dict[@"flower_able"] == nil) {
                flower_able = @"";
            }else{
                flower_able = dict[@"flower_able"];
            }
                        lv =dict[@"lv"];
                        coin_total =dict[@"coin_total"];
                        next_grade_coin =dict[@"next_grade_coin"];
                        //宝贝信息  里面是一个个字典 每个孩子的具体信息
                        NSArray *baby_infoArr =dict[@"baby_info"];
            
            //            NSLog(@"aaaaa%@", baby_infoArr);

                        //孩子 id
                        baby_idArray = [[NSMutableArray alloc] init];
                        //孩子 头像
                        head_imgArray =[[NSMutableArray alloc]init];
                        //孩子 年龄
                        ageArray = [[NSMutableArray alloc] init];
                        //孩子 名称
                        tnameArray = [[NSMutableArray alloc] init];
                        //孩子 签名
                        personl_signArray = [[NSMutableArray alloc] init];
                        //孩子 上的学校
                        school_infoArray = [[NSMutableArray alloc] init];
                        //孩子 家人
                        family_memberArray = [[NSMutableArray alloc] init];
            
                        //孩子 性别
                        babySexArray = [[NSMutableArray alloc] init];
            
                       if (baby_infoArr.count != 0) {
                           for (NSDictionary *dic in baby_infoArr) {
                               
                               //baby_id
                               [baby_idArray addObject:dic[@"baby_id"]];
                               //宝贝 头像
                               //关系人头像类型,0代表用户上传的头像,1代表第三方头像(不需拼接),区别在于url头部
                               NSString * head_img;
                               //                if([[NSString stringWithFormat:@"%@",dic[@"head_img_type"]]isEqualToString:@"0"]){
                               head_img=[picURL stringByAppendingString:dic[@"head_img"]];
                               //                }else{
                               //                    head_img=dic[@"head_img"];
                               //                }
                               [head_imgArray addObject:head_img];
                               
                               //宝贝 年龄
                               [ageArray addObject:dic[@"age"]];
                               
                               //名称
                               [tnameArray addObject:dic[@"tname"]];
                               
                               //个人签名
                               [personl_signArray addObject:dic[@"personal_sign"]];
                               
                               //学校 信息
                               //                            if ([dic[@"school_info"] count] != 0) {
                               [school_infoArray addObject:dic[@"school_info"]];
                               //                             NSLog(@"*** %@", school_infoArray);
                               //                            }
                               //                            [school_infoArray addObject:@[]];
                               
                               [family_memberArray addObject:dic[@"family_member"]];
                               
                               //孩子 性别
                               [babySexArray addObject:dic[@"sex"]];
                           }

                        }
            
            
                    }
                    //刷新放在主线程执行
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self updateLabelInfo];

                        [self updateBayInfomaion:offSet];
                    
                    });
        
       
        
    } failure:^(NSError *error) {
        //
        
        NSLog(@"%@", error);
        
    }];

    
}

- (void)updateLabelInfo{
    
        //宝贝 名称
    if (tnameArray.count != 0) {
        nameLabel.text = [NSString stringWithFormat:@"%@",tnameArray[0]];
    }
    

        //宝贝 等级
    levelLabel.text = [NSString stringWithFormat:@"LV%@", lv];
    
        //宝贝 年龄
    if (ageArray.count != 0) {
        ageLabel.text = [NSString stringWithFormat:@"年龄:%@岁",ageArray[0]];
    }
    
    
       //签名
//    tit.text = [NSString stringWithFormat:@"签名:%@",personl_signArray[0]];

    //进度条
    float t =  [coin_total floatValue]/[next_grade_coin floatValue];
    ysView.progressValue = t * ysView.frame.size.width;
    
    //花数
    fnumberLabel.text = [NSString stringWithFormat:@": %@",flower_able];

    //花篮数
    fsnumberLabel.text = [NSString stringWithFormat:@": %@",fbasket_able];
    
    //星币
    xnumberLabel.text = [NSString stringWithFormat:@": %@",coin_able];
    
    //头像
    //    NSLog(@"head_imgArray -- %@", head_imgArray);
    NSArray * image =head_imgArray;
    
    //scrollView
    _scrollView.contentSize =CGSizeMake(120 * kWidth / 375 *(image.count+1), 0);
    
    for (int a =0; a<(image.count+1); a++) {
        //添加➕号
        if (a==image.count) {
            
//            if (UserImage == nil) {

                UserImage =[[UIImageView alloc]initWithFrame:CGRectMake(0 +image.count*(120 * kWidth / 375), 0, 120 * kWidth / 375, 120 * kWidth / 375)];
                UserImage.image =[UIImage imageNamed:@"headplace240x240"];
                [_scrollView addSubview:UserImage];
                UserImage.userInteractionEnabled = YES;
                UserImage.layer.cornerRadius = 60 * kWidth / 375;
                UserImage.layer.masksToBounds = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickUserIm:)];
                [UserImage addGestureRecognizer:tap];
//            }
    
        }else {
            
            if (UserImage == nil) {
            UserImage = [[UIImageView alloc]initWithFrame:CGRectMake(0 +a*(120 * kWidth / 375 ), 0, 120 * kWidth / 375, 120 * kWidth / 375)];
                //            NSLog(@"宝贝 头像 %@", head_imgArray);
                [UserImage sd_setImageWithURL:[NSURL URLWithString:head_imgArray[a]] placeholderImage:[UIImage imageNamed:@"头像"]];
                [_scrollView addSubview:UserImage];
                UserImage.userInteractionEnabled = YES;
                UserImage.layer.cornerRadius = 60 * kWidth / 375;
                UserImage.layer.masksToBounds = YES;
                UserImage.tag = 100 + a;
                //性别符号
                manimage = [[UIImageView alloc] initWithFrame:CGRectMake(50 * kWidth / 375 , 95 * kWidth / 375, 20 * kWidth / 375 , 20 * kWidth / 375)];
                //            manimage.image = [UIImage imageNamed:@"man"];
                NSString *sexString = babySexArray[a];
                
                if ([sexString isEqualToString:@"男"]) {
                    
                    manimage.image = [UIImage imageNamed:@"男"];
                    
                }else if ([sexString isEqualToString:@"女"]){
                    
                    manimage.image = [UIImage imageNamed:@"女"];
                }
                
                manimage.layer.cornerRadius = 8 * kWidth / 375 ;
                manimage.layer.masksToBounds = YES;
                [UserImage addSubview:manimage];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickUserImage:)];
                [UserImage addGestureRecognizer:tap];
                //长按headImage
                UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(clickWithLongTap:)];
                [UserImage addGestureRecognizer:longTap];
            }
        

        }
        
    }


}



- (void)createWJCommboxViews{
    
// NSLog(@"----====---  %@", [NSNumber numberWithBool:[XXEUserInfo user].login]);
    
    if (![XXEUserInfo user].login){
        //学校选择
        self.schoolNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(60 * kWidth / 375, 37 * kWidth / 375, 120 * kWidth / 375, 30 * kHeight / 667)];
    }else{
    
        //学校选择
        self.schoolNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(60 * kWidth / 375, 37 * kWidth / 375, 150 * kWidth / 375, 30 * kHeight / 667)];
    }
    
    //获取 学校 班级 信息
    [self createSchoolInfo:offSet];
    
    if (commboxSchoolArray.count != 0) {
        self.schoolNameCombox.dataArray = commboxSchoolArray;
    }
    
//    self.schoolNameCombox.textField.placeholder = SCHOOL_NAME;
    self.schoolNameCombox.textField.text = self.schoolNameCombox.dataArray[0];
    self.schoolNameCombox.textField.textAlignment = NSTextAlignmentCenter;
    self.schoolNameCombox.textField.tag = 102;
    self.schoolNameCombox.textField.layer.cornerRadius =15 * kWidth / 375;
    self.schoolNameCombox.textField.layer.masksToBounds =YES;
    
    self.schoolNameBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth,kHeight+300)];
    
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden)];
    [self.schoolNameBackView addGestureRecognizer:singleTouch];
    
    //默认 第0个
    if (offSet < ageArray.count) {
        _schoolId = commboxSchoolIdArray[didSelectedSchoolRow];
    }
    
    
    [DEFAULTS setObject:_schoolId forKey:@"SCHOOL_ID"];
    [DEFAULTS synchronize];
    
    
    //监听 学校名称 改变
    [self.schoolNameCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"1"];

    [upBackgroundImageView addSubview:self.schoolNameCombox];
    
    
    if (![XXEUserInfo user].login) {
    
        //班级选择
        self.gradeAndClassbox = [[WJCommboxView alloc]initWithFrame:CGRectMake(self.schoolNameCombox.frame.origin.x + self.schoolNameCombox.frame.size.width + 5,  37 * kWidth /375 , self.schoolNameCombox.frame.size.width, self.schoolNameCombox.frame.size.height)];
    }else{
    
        //班级选择
        self.gradeAndClassbox = [[WJCommboxView alloc]initWithFrame:CGRectMake(self.schoolNameCombox.frame.origin.x + self.schoolNameCombox.frame.size.width + 5,  37 * kWidth /375 , self.schoolNameCombox.frame.size.width, self.schoolNameCombox.frame.size.height)];
    }

    
    if (commboxGradeAndClassArray.count != 0) {
        
    self.gradeAndClassbox.dataArray = commboxGradeAndClassArray[didSelectedSchoolRow];

    }
 
    self.gradeAndClassbox.textField.text = self.gradeAndClassbox.dataArray[0];
    
    _classStr = self.gradeAndClassbox.textField.text;
    
    [DEFAULTS setObject:_classStr forKey:@"CLASS"];
    [DEFAULTS synchronize];
    
    self.gradeAndClassbox.textField.textAlignment = NSTextAlignmentCenter;
    self.gradeAndClassbox.textField.tag = 101;
    self.gradeAndClassbox.textField.layer.cornerRadius =15 * kWidth / 375;
    self.gradeAndClassbox.textField.layer.masksToBounds =YES;
    self.gradeAndClassView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight+300)];
    UITapGestureRecognizer *bingleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(classHidden)];
    [self.gradeAndClassView addGestureRecognizer:bingleTouch];
    
    
    //监听 学校名称 改变
    [self.gradeAndClassbox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"2"];
    
    [upBackgroundImageView addSubview:self.gradeAndClassbox];
    /**
     *  添加班级监听
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(classAction:) name:@"commboxNotice"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(classAction2:) name:@"commboxNotice2"object:nil];
    
    /**
     *  学校 logo
     */
    
        logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, _schoolNameCombox.centerY - 35 / 2 * kWidth / 375, 35 * kWidth / 375, 35 * kWidth / 375)];
        logoImageView.userInteractionEnabled = YES;
        logoImageView.layer.cornerRadius = logoImageView.frame.size.width / 2;
        logoImageView.layer.masksToBounds = YES;
    
        UITapGestureRecognizer *logoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(logoTap:)];
        [logoImageView addGestureRecognizer:logoTap];
        
        [self.view addSubview:logoImageView];
}

- (void)logoTap:(UITapGestureRecognizer *)logoTap{
    
    LogoTabBarController *logoViewController = [[LogoTabBarController alloc] init];
    logoViewController.hidesBottomBarWhenPushed = YES;
    
    [self presentViewController:logoViewController animated:NO completion:nil];
    
}


- (void)createSchoolInfo:(NSInteger) index{
    
    logoPicArray = [[NSMutableArray alloc] init];
    commboxSchoolArray = [[NSMutableArray alloc] init];
    commboxSchoolIdArray = [[NSMutableArray alloc] init];
    classInfoArray = [[NSMutableArray alloc] init];
    commboxGradeAndClassArray = [[NSMutableArray alloc] init];
    commboxIDArray = [[NSMutableArray alloc] init];
    
//    NSLog(@"%@", school_infoArray);
    if (school_infoArray.count != 0) {
        if ([school_infoArray[index] count] == 0) {
            commboxSchoolArray = [NSMutableArray arrayWithCapacity:0];
            self.schoolNameCombox.textField.text = @"";
            self.schoolNameCombox.textField.placeholder = SCHOOL_NAME;
            self.schoolNameCombox.textField.enabled = NO;
            
            commboxGradeAndClassArray = [NSMutableArray arrayWithCapacity:0];
            self.gradeAndClassbox.textField.text = @"";
            self.gradeAndClassbox.textField.placeholder = GRADE_CLASS;
            self.gradeAndClassbox.textField.enabled = NO;
            
            logoImageView.image = [UIImage imageNamed:@"schoollogo(1)172x172"];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请完善该宝贝学校信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            [alert show];
            
        }else{
            for (NSDictionary *dic in school_infoArray[index]) {
                
                NSString *logoStr = [NSString stringWithFormat:@"%@%@", picURL, dic[@"logo"]];
                
                [logoPicArray addObject:logoStr];
                
                [commboxSchoolArray addObject:dic[@"name"]];
                
                [commboxSchoolIdArray addObject:dic[@"school_id"]];
                
                classInfoArray = dic[@"class_info"];
                
                classNameArray = [[NSMutableArray alloc] init];
                classIdArray = [[NSMutableArray alloc] init];
                
                for (NSDictionary *dicItem in classInfoArray) {
                    
                    [classIdArray addObject:dicItem[@"class_id"]];
                    [classNameArray addObject:dicItem[@"class_name"]];
                    
                }
                [classNameArray addObject:@"编辑班级"];
                [commboxGradeAndClassArray addObject:classNameArray];
                
                [commboxIDArray addObject:classIdArray];
                
            }
            
        }

    }
    
    
    
}

#pragma mark -
#pragma mark delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            //取消
//            offSet = 0;
//            [self createData];
//
//            CGPoint contentOffset = _scrollView.contentOffset;
//            contentOffset.x = offSet;
//            [_scrollView setContentOffset:contentOffset animated:NO];

            
            break;
        case 1:
        {
            //确定
            ClassEditViewController *classEditVC = [[ClassEditViewController alloc] init];
            classEditVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:classEditVC animated:YES];
            
            break;
        }
    }
}

//学校 信息 监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    NSString *str = [NSString stringWithFormat:@"%@",context];
    
    if ([str integerValue] == 1) {
        if ([object isKindOfClass:[UITextField class]]){
            //如果 改变 左边 学校 ——》自动关联到 右边的年级班级信息
            //取出name的旧值和新值
            NSString * newNameOne=[change objectForKey:@"new"];
            //            NSLog(@"object:%@,new:%@",object,newNameOne);
            
            if (commboxSchoolArray.count != 0 && commboxGradeAndClassArray.count != 0) {
                didSelectedSchoolRow =[commboxSchoolArray indexOfObject:newNameOne];
                self.gradeAndClassbox.textField.text = commboxGradeAndClassArray[didSelectedSchoolRow][0];
                
                if ([commboxGradeAndClassArray[didSelectedSchoolRow] count] != 0) {
                    
                    self.gradeAndClassbox.dataArray = commboxGradeAndClassArray[didSelectedSchoolRow];
                    
                    [logoImageView sd_setImageWithURL:[NSURL URLWithString:logoPicArray[didSelectedSchoolRow]] placeholderImage:[UIImage imageNamed:@"schoollogo(1)172x172"]];
                    
                }
            }
            
            if (commboxSchoolIdArray.count != 0) {
                _schoolId = commboxSchoolIdArray[didSelectedSchoolRow];
            }else{
            
            _schoolId = @"";
            }
            [DEFAULTS setObject:_schoolId forKey:@"SCHOOL_ID"];
            [DEFAULTS synchronize];
            
//            NSLog(@"1--- %@", commboxIDArray);
//            
//            NSLog(@"2------%@", commboxIDArray[didSelectedSchoolRow]);
//            
//            NSLog(@"3========%@", commboxIDArray[didSelectedSchoolRow][didSelectedClassRow]);
            
            if (commboxIDArray.count != 0) {
                NSArray *arr = commboxIDArray[didSelectedSchoolRow];
                
                _classStr = arr[didSelectedClassRow];
            }else{
            _classStr = @"";
            }
            
//            NSLog(@"_classStr ***** %@", _classStr);
            
           [DEFAULTS setObject:_classStr forKey:@"CLASS_ID"];
            
           [DEFAULTS synchronize];

        [self.gradeAndClassbox.listTableView reloadData];
            
        }
        return;
    }else if ([str integerValue] == 2){
        if ([object isKindOfClass:[UITextField class]]){
            //如果 改变 右边的年级班级信息  ——》自动关联到 左边 学校
            //取出name的旧值和新值
            NSString * newNameTwo=[change objectForKey:@"new"];
            if([newNameTwo isEqualToString:@"编辑班级"]){
                // 添加班级 // 添加班级 // 添加班级 // 添加班级 // 添加班级  // 添加班级
                ClassEditInfoViewController *classEditVC =[[ClassEditInfoViewController alloc]init];
                
                if (baby_id1 == nil) {
                    baby_id1 = baby_idArray[0];
                    
                }
                classEditVC.babyId = baby_id1;
                classEditVC.hidesBottomBarWhenPushed =YES;
                [self.navigationController pushViewController:classEditVC animated:YES];
                
                
            }else{
                
//                NSLog(@"%@", commboxGradeAndClassArray);
                
//                NSLog(@"%ld", [commboxGradeAndClassArray indexOfObject:newNameTwo]);
            
                if (commboxGradeAndClassArray.count != 0) {
                    didSelectedClassRow =[commboxGradeAndClassArray[didSelectedSchoolRow] indexOfObject:newNameTwo];
                    if (commboxIDArray.count != 0) {
                        NSArray *arr = commboxIDArray[didSelectedSchoolRow];
                        
                        _classStr = arr[didSelectedClassRow];
                    }else{
                        _classStr = @"";
                    }
                    
                    NSLog(@"_classStr ***** %@", _classStr);
                    
                    [DEFAULTS setObject:_classStr forKey:@"CLASS_ID"];
                    
                    [DEFAULTS synchronize];
                }
            
            }
        }
    
    }
    
}


#pragma mark - UIScrollView

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    didSelectedSchoolRow = 0;
    didSelectedClassRow = 0;
    CGPoint contentOffset =scrollView.contentOffset;
    
    CGFloat f =contentOffset.x/headView.frame.size.width ;
    //四舍五入
    NSInteger i = (int)(f + 0.5);
    offSet = i;
//    NSLog(@"/////%ld", i);
    
    [self updateBayInfomaion:i];
}
/**
 * 滑动baby头像
 * 更新baby信息
 */
- (void)updateBayInfomaion:(NSInteger)i{
    
    if (i>=ageArray.count) {
        
        //学校 年级 下拉框 无信息
        commboxSchoolArray = [NSMutableArray arrayWithCapacity:0];
        self.schoolNameCombox.textField.text = @"";
        self.schoolNameCombox.textField.placeholder = SCHOOL_NAME;
        self.schoolNameCombox.textField.enabled = NO;
        
        commboxGradeAndClassArray = [NSMutableArray arrayWithCapacity:0];
        self.gradeAndClassbox.textField.text = @"";
        self.gradeAndClassbox.textField.placeholder = GRADE_CLASS;
        self.gradeAndClassbox.textField.enabled = NO;
        
        logoImageView.image = [UIImage imageNamed:@"schoollogo(1)172x172"];
        
        ageLabel.text = [NSString stringWithFormat:@"年龄:%@",@""];
        nameLabel.text =[NSString stringWithFormat:@"%@",@""];
        titleLabel.text =[NSString stringWithFormat:@"签名:%@",@""];
    }
    else{
        self.schoolNameCombox.textField.enabled = YES;
        
        self.gradeAndClassbox.textField.enabled = YES;

        //获取 学校 班级 信息
        [self createSchoolInfo:offSet];
        
        if (commboxSchoolArray.count != 0) {
            _schoolNameCombox.dataArray = commboxSchoolArray;
            self.schoolNameCombox.textField.text = self.schoolNameCombox.dataArray[0];
            [_schoolNameCombox.listTableView reloadData];
        }

//        NSLog(@"%@", _gradeAndClassbox.dataArray[0]);
        if (commboxGradeAndClassArray.count != 0) {
            _gradeAndClassbox.dataArray = commboxGradeAndClassArray[didSelectedSchoolRow];
            _gradeAndClassbox.textField.text = _gradeAndClassbox.dataArray[0];
            
            [_gradeAndClassbox.listTableView reloadData];
        }
        

        
        if (logoPicArray.count != 0) {
        [logoImageView sd_setImageWithURL:[NSURL URLWithString:logoPicArray[didSelectedSchoolRow]] placeholderImage:[UIImage imageNamed:@"schoollogo(1)172x172"]];
        }else{
            logoImageView.image = [UIImage imageNamed:@"schoollogo(1)172x172"];
        
        }
        

        ageLabel.text = [NSString stringWithFormat:@"年龄:%@岁",ageArray[i]];
        nameLabel.text =[NSString stringWithFormat:@"%@",tnameArray[i]];
        titleLabel.text =[NSString stringWithFormat:@"签名:%@",personl_signArray[i]];
//        NSLog(@"%@", baby_idArray);
       
//        NSLog(@"%@", baby_idArray[i]);
        
        baby_id1 =baby_idArray[i];
        [DEFAULTS setObject:baby_id1 forKey:@"BABYID"];
        [DEFAULTS synchronize];
    }
}


//班级//学校
- (void)classAction:(NSNotification *)notif{
    switch ([notif.object integerValue]) {
        case 101://年级 班级

            [self.self.gradeAndClassbox removeFromSuperview];
            [self.view addSubview:self.gradeAndClassView];
            [self.view addSubview:self.gradeAndClassbox];
            
            break;
        case 102://学校
            
            [self.self.schoolNameCombox removeFromSuperview];
            [self.view addSubview:self.schoolNameBackView];
            [self.view addSubview:self.schoolNameCombox];
            break;
        default:
            break;
    }
    
}
//*************学校下拉视图隐藏
- (void)commboxAction2:(NSNotification *)notif{
//    [self.comBackView removeFromSuperview];
    [self.schoolNameBackView removeFromSuperview];
}
//<<<<<<<<<<<<<班级下拉视图隐藏
- (void)classAction2:(NSNotification *)notif{
//    [self.classView removeFromSuperview];
    [self.gradeAndClassView removeFromSuperview];
    
}
//>>>>>>>>>>>>>学校下拉框隐藏
- (void)commboxHidden{
    
    [self.schoolNameBackView removeFromSuperview];
    [self.schoolNameCombox setShowList:NO];
    self.schoolNameCombox.listTableView.hidden = YES;
    CGRect sf = self.schoolNameCombox.frame;
    sf.size.height = 30;
    self.schoolNameCombox.frame = sf;
    CGRect frame = self.schoolNameCombox.listTableView.frame;
    frame.size.height = 0;
    self.schoolNameCombox.listTableView.frame = frame;
    [self.schoolNameCombox removeFromSuperview];
    [self.view addSubview:self.schoolNameCombox];
}
//************班级下拉框隐藏
- (void)classHidden{
    [self.gradeAndClassView removeFromSuperview];
    [self.gradeAndClassbox setShowList:NO];
    self.gradeAndClassbox.listTableView.hidden = YES;
    CGRect sf = self.gradeAndClassbox.frame;
    sf.size.height = 30;
    self.gradeAndClassbox.frame = sf;
    CGRect frame = self.gradeAndClassbox.listTableView.frame;
    frame.size.height = 0;
    self.gradeAndClassbox.listTableView.frame = frame;
    [self.gradeAndClassbox removeFromSuperview];
    [self.view addSubview:self.gradeAndClassbox];
}

#pragma amrk - 创建 中间 背景上 的内容--------------------------
- (void)createMiddleBackgroundContent{
    
    CGFloat Width = kWidth / 4;
    /**
     *  花篮
     */
    flowersBtn = [HHControl createButtonWithFrame:CGRectMake( Width / 2 - 32 * kWidth / 375 - 5, 5, 32 * kWidth / 375, 32 * kWidth / 375) backGruondImageName:@"花篮52x56" Target:self Action:@selector(oncliCkFlowers:) Title:nil];
    [middleBackgroundView addSubview:flowersBtn];
    
    /**
     *  小红花
     */
    flowerBtn = [HHControl createButtonWithFrame:CGRectMake(Width + Width / 2 - 35 * kWidth / 375 - 5, 5, 31 * kWidth / 375, 31 * kWidth / 375) backGruondImageName:@"xiaohonghua45x45" Target:self Action:@selector(onClickflower:) Title:nil];
    [middleBackgroundView addSubview:flowerBtn];
    
    /**
     *  猩币
     */
    xingbiBtn = [HHControl createButtonWithFrame:CGRectMake(Width * 2 + Width / 2 - 35 * kWidth / 375 - 5, 5, 35 * kWidth / 375, 31 * kWidth / 375) backGruondImageName:@"猩币52x46" Target:self Action:@selector(onClickxingbi:) Title:nil];
    [middleBackgroundView addSubview:xingbiBtn];
    
    
    /**
     *  通知
     */
    hurnBtn = [HHControl createButtonWithFrame:CGRectMake(Width * 3 + Width / 2 - 25 * kWidth / 375 / 2, 5, 25 * kWidth / 375, 32 * kWidth / 375) backGruondImageName:@"通知38x50" Target:self Action:@selector(onClickhurn:) Title:nil];
    [middleBackgroundView addSubview:hurnBtn];

    
}


#pragma mark - createButtons---------------------------------------
- (void)createButtons{

    //创建 十二宫格  三行、四列
    int totalLine = 4;
    int buttonCount = 12;
    int margin = 1;
    
    
    CGFloat buttonWidth = (kWidth - 3 * margin) / 4;
    CGFloat buttonHeight = (downBackgroundImageView.frame.size.height  - 2 * margin)/ 3;
    
    for (int i = 0; i < buttonCount; i++) {
        
        //行
        int buttonRow = i / totalLine;
        
        //列
        int buttonLine = i % totalLine;
        
        CGFloat buttonX = (buttonWidth + margin) * buttonLine;
        CGFloat buttonY = (buttonHeight + margin) * buttonRow;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
        button.backgroundColor = [UIColor whiteColor];
        [button setImage: [UIImage imageNamed:buttonPicArray[i]] forState:UIControlStateNormal];
        
        if (i == 0) {
            //实时监控
            [button addTarget:self action:@selector(onClicksj:) forControlEvents:UIControlEventTouchUpInside];
        }else if (i == 1){
            //班级相册
            [button addTarget:self action:@selector(onClickbx:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if (i == 2){
            //课程表
            [button addTarget:self action:@selector(onClicklt:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if (i == 3){
            //通讯录
            [button addTarget:self action:@selector(onClickwq:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if (i == 4){
            //聊天
            [button addTarget:self action:@selector(onClickxt:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if (i == 5){
            //点评
            [button addTarget:self action:@selector(onClickld:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if (i == 6){
            //作业
            [button addTarget:self action:@selector(onClickAplace:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if (i == 7){
            //食谱
            [button addTarget:self action:@selector(tecentBtn:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if (i == 8){
            //猩天地
            [button addTarget:self action:@selector(onClickfx:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if (i == 9){
            //猩商城
            [button addTarget:self action:@selector(onClickxs:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        [downBackgroundImageView addSubview:button];
        
    }

}


- (void)onClickRegister{
    
  LandingpageViewController *registerVC=[[LandingpageViewController alloc]init];
    registerVC.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:registerVC animated:NO];

}
- (void)onClickAplace:(UIButton*)btn{
    
    ClassHomeworkViewController *classHomeVC =[[ClassHomeworkViewController alloc]init];
    classHomeVC.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:classHomeVC animated:NO];
    
}
- (void)tecentBtn:(UIButton*)btn{

    SchoolRecipesViewController *schoolRecipeVC =[[SchoolRecipesViewController alloc]init];
    schoolRecipeVC.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:schoolRecipeVC animated:NO];
    
}

- (void)shezhi{

    MyHeadViewController * forVC=[[MyHeadViewController alloc]init];
    forVC.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:forVC animated:NO];
    
}

- (void)onClicksj:(UIButton *)button
{
    VideoMonitorViewController *videoMonitorVC =[VideoMonitorViewController new];
    videoMonitorVC.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:videoMonitorVC animated:NO];
}
- (void)onClickxs:(UIButton *)button
{
    RootTabbarViewController *rootTabbarVC =[[RootTabbarViewController alloc]init];
    rootTabbarVC.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:rootTabbarVC animated:NO];

}
- (void)onClickbx:(UIButton *)button
{
    ClassAlbumViewController *classAlbumVC =[[ClassAlbumViewController alloc]init];
    classAlbumVC.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:classAlbumVC animated:NO];

}
- (void)onClickfx:(UIButton *)button
{
    XingXingXingXingCommunityViewController *forVC = [[XingXingXingXingCommunityViewController alloc]init];
    forVC.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:forVC animated:NO];
}
- (void)onClickld:(UIButton *)button
{
    CommentsRootTabbarViewController *commentHomeVC =[[CommentsRootTabbarViewController alloc]init];
    commentHomeVC.hidesBottomBarWhenPushed =YES;
    [self presentViewController:commentHomeVC animated:NO completion:^{
        
    }];
}
/**
 *  课程表
 */
- (void)onClicklt:(UIButton *)button
{
    
    XXESchoolTimetableViewController *schoolTimetableVC = [[XXESchoolTimetableViewController alloc] init];
    schoolTimetableVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:schoolTimetableVC animated:YES];

}

//通讯录
- (void)onClickwq:(UIButton*)button{
    ClassTelephoneViewController *classTeleVC =[[ClassTelephoneViewController alloc]init];
    classTeleVC.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:classTeleVC animated:NO];
}
- (void)onClickxt:(UIButton *)button
{

//    NSLog(@"----====---  %@", [NSNumber numberWithBool:[XXEUserInfo user].login]);
    
    if ([XXEUserInfo user].login) {
        RcRootTabbarViewController *classRoomVC =[[RcRootTabbarViewController alloc]init];
        classRoomVC.hidesBottomBarWhenPushed =YES;
        [self.navigationController pushViewController:classRoomVC animated:NO];
    }else {
        [SVProgressHUD showInfoWithStatus:@"请用账号登录"];
    }
}
-(void)onClickflower:(UIButton *)button
{
    flowerViewController * forVC=[[flowerViewController alloc]init];
    forVC.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:forVC animated:NO];

}
-(void)oncliCkFlowers:(UIButton *)button
{
    FlowerBasketViewController *flowerBasketVC =[[FlowerBasketViewController alloc]init];
    flowerBasketVC.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:flowerBasketVC animated:NO];
}

-(void)onClickxingbi:(UIButton *)button
{  
    CheckInViewController *storeHomeVC =[[CheckInViewController alloc]init];
    storeHomeVC.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:storeHomeVC animated:NO];
}
#pragma mark =========== 通知 ====================
-(void)onClickhurn:(UIButton *)button
{
    
     noticeViewController * forVC = [[noticeViewController alloc]init];
    forVC.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:forVC animated:NO];
}
//LOGO
-(void)onClickLOGO:(UIButton *)button
{
    LogoTabBarController *logoViewController = [[LogoTabBarController alloc] init];
    logoViewController.hidesBottomBarWhenPushed = YES;
    [self presentViewController:logoViewController animated:NO completion:nil];
    
}



#pragma mark - createLabels--------------------------------

-(void)createLabels
{
    //宝贝 名称
   nameLabel = [HHControl createLabelWithFrame:CGRectMake(kWidth / 2 , 100 * kWidth / 375 , 60 * kWidth / 375, 30 * kHeight / 667) Font:16 * kWidth / 375 Text:@""];
    nameLabel.textColor =UIColorFromRGB(255, 255, 255);
    [upBackgroundImageView addSubview:nameLabel];
    
    //家长 等级
    NSString *lvString = [NSString stringWithFormat:@"LV%@", lv];
   levelLabel = [HHControl createLabelWithFrame:CGRectMake(nameLabel.frame.origin.x + nameLabel.frame.size.width + 10 ,nameLabel.centerY - 20 * kHeight / 667 / 2 , 35 * kWidth / 375, 20 * kHeight / 667) Font:12 * kWidth / 375 Text:lvString];
    levelLabel.textColor = UIColorFromRGB(3, 169, 244);
    levelLabel.textAlignment = NSTextAlignmentCenter;
    levelLabel.backgroundColor = [UIColor whiteColor];
    levelLabel.layer.cornerRadius = 5;
    levelLabel.layer.masksToBounds = YES;
    [upBackgroundImageView addSubview:levelLabel];
    
    
    //宝贝 年龄
    ageLabel =[HHControl createLabelWithFrame:CGRectMake(kWidth / 2 , nameLabel.frame.origin.y + nameLabel.frame.size.height , 160 * kWidth / 375, 30 * kHeight / 667) Font:16 * kWidth / 375 Text:@""];
    ageLabel.textColor =UIColorFromRGB(255, 255, 255);
    [upBackgroundImageView addSubview:ageLabel];
    
    //签名
    titleLabel =[HHControl createLabelWithFrame:CGRectMake(kWidth / 2 , ageLabel.frame.origin.y + ageLabel.frame.size.height, 160 * kWidth / 375, 40 * kHeight / 667) Font:16 * kWidth / 375 Text:@""];
    titleLabel.numberOfLines=0;
    titleLabel.textColor =UIColorFromRGB(255, 255, 255);
    [upBackgroundImageView addSubview:titleLabel];
    
    //滚动条
    ysView = [[YSProgressView alloc] initWithFrame:CGRectMake(kWidth / 2, titleLabel.frame.origin.y + titleLabel.frame.size.height + 5, 160 * kWidth / 375, 10 * kHeight / 667)];
    ysView.progressHeight = 2;
    ysView.progressTintColor = [UIColor colorWithRed:0.0 / 255 green:0.0 / 255 blue:0.0 / 255 alpha:0.5];
    ysView.trackTintColor = [UIColor whiteColor];
  
    [self.view addSubview:ysView];
    
    
    CGFloat Width = kWidth / 4;
    
    //花篮数
    fsnumberLabel = [HHControl createLabelWithFrame:CGRectMake(Width / 2 , 5 * kWidth / 375, Width / 2, 30 * kWidth / 375) Font:16 * kWidth / 375 Text:@""];
    [middleBackgroundView addSubview:fsnumberLabel];
    
    //花数  Width + Width / 2 - 35 * kWidth / 375
    fnumberLabel = [HHControl createLabelWithFrame:CGRectMake(Width + Width / 2, 5 * kWidth / 375, Width / 2, 30 *kWidth / 375) Font:16 * kWidth / 375 Text:@""];
    [middleBackgroundView addSubview:fnumberLabel];
    
    //星币
    xnumberLabel = [HHControl createLabelWithFrame:CGRectMake(Width * 2 + Width / 2, 5 * kWidth / 375, Width / 2 + 40, 30 * kWidth / 375) Font:16 * kWidth / 375 Text:@""];
    [middleBackgroundView addSubview:xnumberLabel];



 
}


#pragma mark - 首页 宝贝 头像 动画--------------------------
//******************************首页 宝贝 头像 动画***************

//点击宝贝头像 跳转
-(void)onClickUserImage:(UITapGestureRecognizer *)tap
{
    WZYBabyCenterViewController *WZYBabyCenterVC = [[WZYBabyCenterViewController alloc] init];
//    NSLog(@"baby_idArray  --  %@", baby_idArray);
    
    if (baby_id1 == nil) {
        baby_id1 = baby_idArray[0];
        
    }
    WZYBabyCenterVC.babyId = baby_id1;
    WZYBabyCenterVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:WZYBabyCenterVC animated:NO];
    
}


//添加 宝贝
- (void)onClickUserIm:(UITapGestureRecognizer*)tap{
    WZYAddBabyViewController *addBayVC =[[WZYAddBabyViewController alloc]init];
    addBayVC.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:addBayVC animated:YES];
    
}

//长按 头像
- (void)clickWithLongTap:(UILongPressGestureRecognizer *)longPressTap{
    
    NSInteger t = longPressTap.view.tag - 100;
//    NSLog(@"长按 头像 tag  %ld", t);
    
    [self.view addSubview:self.dimBackgroundView];
    _dimBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundView)];
    [self.dimBackgroundView addGestureRecognizer:tap];
    
    self.btn = [[ZJCircularBtn alloc]init];
    
    self.btn.delegate = self;

    [self.btn createCircularBtnWithBtnNum:[family_memberArray[t] count]center:self.view.center raiuds:120 btnRaiuds:80 btnImages:family_memberArray[t] titleArray:nil superView:self.dimBackgroundView];
}

-(void)clickCircularBtnNum:(NSInteger)num{
    
    OtherPeopleViewController *otherPeopleVC =[[OtherPeopleViewController alloc]init];
    otherPeopleVC.familyIdStr = [NSString stringWithFormat:@"%ld", (long)num];
    
    if (baby_id1 == nil) {
        baby_id1 = baby_idArray[0];
        
    }
    otherPeopleVC.babyIdStr = baby_id1;
    otherPeopleVC.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:otherPeopleVC animated:YES];
    
}

- (void)tapBackgroundView{

    [_dimBackgroundView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_dimBackgroundView removeFromSuperview];
    
}


@end

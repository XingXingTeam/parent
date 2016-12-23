//
//  ClassEditViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/3/21.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define  kDropDownListTag 1000
#import "ClassEditViewController.h"
#import "LMContainsLMComboxScrollView.h"
#import "HomepageViewController.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"
#import "WJCommboxView.h"
#import "LMComBoxView.h"
#import "AppDelegate.h"
#import "UtilityFunc.h"
#import "HHControl.h"
#import "XXETabBarViewController.h"

#import "WZYSearchSchoolViewController.h"

@interface ClassEditViewController ()<LMComBoxViewDelegate,UISearchBarDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    LMContainsLMComboxScrollView *bgScrollView;
    NSMutableDictionary *addressDict;
    NSDictionary *areaDict;
    //省
    NSMutableArray *provinceArr;
    //省 ID
    NSMutableArray *provinceIDArray;
    NSString *provinceStr;
    
    //市
    NSMutableArray *cityArr;
    //市 ID
    NSMutableArray *cityIDArray;
    NSString *cityStr;
    
    //区
    NSMutableArray *areaArr;
    //区 ID
    NSMutableArray *areaIDArray;
    NSString *areaStr;
    
    //学校 类型
    NSString *schoolTypeStr;
    
    //学校 ID
    NSMutableArray *schoolIdArray;
    NSString *schoolIdStr;
    
    //年级
    NSString *gradeStr;
    
    //课程  ID
    NSMutableArray *courseIdArray;
    NSString *courseIdStr;
    
    //班级 ID
    NSMutableArray *classIdArray;
    NSString *classIdStr;
    
    //审核 人员
    NSMutableArray *auditorIdArray;
    NSMutableArray *auditorNameArray;
    NSString *auditorIdStr;
    
    NSMutableArray *searchArray;
    
    NSString *selectProvinceStr;
    NSString *selectCityStr;
    NSString *selectAreaStr;
    UILabel *trainAgencyLbl;
    UIView *bgView;
    //判断 该学校是否 存在 的提示框
    UIAlertView *_alert;
    //
    UIAlertView *_perfectAlert;
    MBProgressHUD *HUD;
    NSString *babyId;
    //
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
}
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)UISearchController *searchDC;
@property(nonatomic,strong)UIView *schoolTypeView;
@property(nonatomic,strong)NSMutableArray *schoolNameArr;
@property(nonatomic,strong)NSMutableArray *schoolTypeArr;
@property(nonatomic,strong)UIView *schoolNameView;
@property(nonatomic,strong)NSMutableArray *gradeNameArr;
@property(nonatomic,strong)UIView *gradeNameView;
@property(nonatomic,strong)NSMutableArray *classNameArr;
@property(nonatomic,strong)UIView *classNameView;
@property(nonatomic,strong)NSMutableArray *trainAgencyArr;
@property(nonatomic,strong)UIView *trainAgencyView;
@property(nonatomic,strong)NSMutableArray *auditPeopleArr;
@property(nonatomic,strong)UIView *auditPeopleView;

@property(nonatomic,strong)WJCommboxView *provinceCombox;
@property(nonatomic,strong)WJCommboxView *cityCombox;
@property(nonatomic,strong)WJCommboxView *areaCombox;

@property(nonatomic,strong)UIView *provinceView;
@property(nonatomic,strong)UIView *cityView;
@property(nonatomic,strong)UIView *areaView;

@property(nonatomic,strong)WJCommboxView *schoolTypeCombox;
@property(nonatomic,strong)WJCommboxView *schoolNameCombox;
@property(nonatomic,strong)WJCommboxView *gradeNameCombox;
@property(nonatomic,strong)WJCommboxView *classNameCombox;
@property(nonatomic,strong)WJCommboxView *trainSubjectCombox;
@property(nonatomic,strong)WJCommboxView *auditNameCombox;

@property(nonatomic,strong)UILabel * auditNameLabel;
@property(nonatomic,strong)UILabel * schoolNameLabel;
@property(nonatomic,strong)UILabel * trainNameLabel;
@property(nonatomic,strong)UILabel *trainLabel;
@end

@implementation ClassEditViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self createSchoolTypeCombox];
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor],
//                                               NSFontAttributeName :[UIFont systemFontOfSize:18]
//                                               };
//    [self.navigationController.navigationBar setTintColor:UIColorFromRGB(0, 170, 42)];
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
    
//    NSLog(@"%@ == %@ ", parameterXid, parameterUser_Id);
    
    searchArray = [[NSMutableArray alloc] init];
    //请求参数  无
    if (_addBabyId) {
        babyId = _addBabyId;
    }else{
        babyId  = [[NSUserDefaults standardUserDefaults] objectForKey:@"BABYID"];
    }

    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    

    if ([[XXEUserInfo user].login_times integerValue] == 1) {
    self.title =@"完善信息";
        if ([_fromPerfectInfo isEqualToString:@"fromPerfectInfo"]) {
                [self performSelector:@selector(pickup) withObject:self afterDelay:1];
        }
    }else{
        
    self.title =@"添加班级";
    
    }
    
    bgScrollView = [[LMContainsLMComboxScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    bgScrollView.backgroundColor = UIColorFromRGB(255, 255, 255);
    bgScrollView.showsHorizontalScrollIndicator =NO;
    bgScrollView.showsVerticalScrollIndicator =NO;
    [self.view addSubview:bgScrollView];
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    bgView.backgroundColor =UIColorFromRGB(222, 225, 226);
    [bgScrollView addSubview:bgView];
    
    
    [self fetchProvinceData];
    
    [self commBoxInfo];
    bgView.userInteractionEnabled = YES;
    [self createRightBar];

}

- (void)pickup{
        
    _perfectAlert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否完善信息赚取100猩币?" delegate:self cancelButtonTitle:@"跳过" otherButtonTitles:@"完善", nil];
    _perfectAlert.delegate =self;
    [_perfectAlert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView == _perfectAlert) {
        switch (buttonIndex) {
            case 0:
            {
                //HomepageViewController
                HomepageViewController *homepageVC =[[HomepageViewController alloc]init];
                [self presentViewController:homepageVC animated:YES completion:nil];
//                MyTabBarController *myTableVC =[[MyTabBarController alloc]init];
//                [self presentViewController:myTableVC animated:YES completion:nil];
//                MyTabBarController *tabBarControllerConfig = [[MyTabBarController alloc]init];
//                UIWindow *window = [UIApplication sharedApplication].keyWindow;
//                window.rootViewController = tabBarControllerConfig;
//                [self.view removeFromSuperview];
            }
                break;
            case 1:
            {
                NSLog(@"完善");
            }
                break;
            default:
                break;
        }

    }
    
    
}

- (void)createRightBar{
    
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(-10,0,22,22)];
    [rightButton setImage:[UIImage imageNamed:@"搜索icon44x44"]  forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(searchprogram) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
}

/**
 *  搜索  从 搜索界面返回过来的数组 中 至少有一个元素 “formWZYSearchSchool” ,标志位 判断是否是从搜索界面跳转过来的依据
 */
- (void)searchprogram{

    WZYSearchSchoolViewController *WZYSearchSchoolVC = [[WZYSearchSchoolViewController alloc] init];
    
    [WZYSearchSchoolVC returnArray:^(NSMutableArray *mArr) {
        
//        searchArray = [NSArray arrayWithArray:mArr];
        searchArray = mArr;
        
        //
//        NSLog(@"hhhhh%@", mArr);
        /*
         hhhhh[
         上海市,   //省
         上海市,   //市
         奉贤区,   //区
         4,       //学校 类型 //幼儿园/小学/中学/培训机构 1/2/3/4
         上海梅花琴行   //学校 名称
         ]
         */
        
//        NSInteger index = [mArr[3] integerValue] - 1;
        //省/市/区/学校类型/学校名称/学校ID/formWZYSearchSchool
        _provinceCombox.textField.text = mArr[0];
        _provinceCombox.textField.enabled = NO;
        
    }];
    
    [self.navigationController pushViewController:WZYSearchSchoolVC animated:YES];

}




-(void)commBoxInfo{
    
    UILabel *areaLable = [[UILabel alloc]initWithFrame:CGRectMake(30 * kWidth / 375,70 * kWidth / 375, 92 * kWidth / 375, 30 * kWidth / 375)];
    areaLable.textAlignment = NSTextAlignmentLeft;
    areaLable.text = @"区     域";
    areaLable.font = [UIFont systemFontOfSize:14 * kWidth / 375];
    [bgScrollView addSubview:areaLable];
    UIImageView *starImgV =[[UIImageView alloc]initWithFrame:CGRectMake(5 * kWidth / 375,73 * kWidth / 375, 20 * kWidth / 375, 20 * kWidth / 375)];
    starImgV.image =[UIImage imageNamed:@"必填符号38x38"];
    [bgScrollView addSubview:starImgV];
    
    /**省   98  */
    [self createProvinceCombox];
//    [self fetchProvinceData];
    
    /**市   99  */
    [self createCityCombox];

    /**区   100  */
    [self createAreaCombox];
    
    //学校类型 101
    [self createSchoolTypeCombox];
    
    /**
     学校名称 102
     */
    [self createSchoolNameCombox];

    /**
     年级信息 103
     */
    [self createGradeNameCombox];

    
    /**
     班级信息 104
     */
    [self createClassNameCombox];
    
    
    /**
     审核人员  105
     */
    
    [self createAuditNameCombox];
    
    
    /**
     确定按钮
     */
    [self createDefineBtn];

    
}
/**
 *  创建 省 下拉框 10
 */
- (void)createProvinceCombox{
    self.provinceCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(100 * kWidth / 375+(80+10)*0, 70 * kWidth / 375, 80 * kWidth / 375, 30 * kWidth / 375)];
    CGRect rect =  self.provinceCombox.listTableView.frame;
    rect = CGRectMake(rect.origin.x - 20 * kScreenRatioWidth, rect.origin.y , rect.size.width + 40 * kScreenRatioWidth, rect.size.height);
    self.provinceCombox.listTableView.frame = rect;
    
    self.provinceCombox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
    self.provinceCombox.textField.placeholder= @"省";
    self.provinceCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.provinceCombox.textField.tag = 98;
    self.provinceCombox.dataArray = provinceArr;
    [self.provinceCombox.listTableView reloadData];
    //    }
    
    [bgScrollView addSubview:self.provinceCombox];
    
    self.provinceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight+300)];
    self.provinceView.backgroundColor = [UIColor clearColor];
    self.provinceView.alpha = 0.5;
    UITapGestureRecognizer *provinceTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden)];
    [self.provinceView addGestureRecognizer:provinceTouch];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction:) name:@"commboxNotice"object:nil];
    
    [self.provinceCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"10"];


}


/**
 *  创建 市 下拉框 11
 */
- (void)createCityCombox{

    self.cityCombox = [[WJCommboxView alloc]initWithFrame:CGRectMake((100+(80+10)*1) * kWidth / 375, 70 * kWidth / 375, 80 * kWidth / 375, 30 * kWidth / 375)];
    
    CGRect rect =  self.cityCombox.listTableView.frame;
    rect = CGRectMake(rect.origin.x - 20 * kScreenRatioWidth, rect.origin.y , rect.size.width + 40 * kScreenRatioWidth, rect.size.height);
    self.cityCombox.listTableView.frame = rect;
    
    self.cityCombox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
    self.cityCombox.textField.placeholder= @"市";
    self.cityCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.cityCombox.textField.tag = 99;
    [bgScrollView addSubview:self.cityCombox];
    
    self.cityView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight+300)];
    self.cityView.backgroundColor = [UIColor clearColor];
    self.cityView.alpha = 0.5;
    UITapGestureRecognizer *cityTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden)];
    [self.cityView addGestureRecognizer:cityTouch];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction:) name:@"commboxNotice"object:nil];
    
    [self.cityCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"11"];

}

/**
 *  创建 区 下拉框 12
 */
- (void)createAreaCombox{

    self.areaCombox = [[WJCommboxView alloc]initWithFrame:CGRectMake((100+(80+10)*2) * kWidth / 375, 70 * kWidth / 375, 80 * kWidth / 375, 30 * kWidth / 375)];
    
    CGRect rect =  self.areaCombox.listTableView.frame;
    rect = CGRectMake(rect.origin.x - 30 * kScreenRatioWidth, rect.origin.y , rect.size.width + 40 * kScreenRatioWidth, rect.size.height);
    self.areaCombox.listTableView.frame = rect;
    
    self.areaCombox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
    
    self.areaCombox.textField.placeholder= @"区";
    
    self.areaCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.areaCombox.textField.tag = 100;
    [bgScrollView addSubview:self.areaCombox];
    
    self.areaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight+300)];
    self.areaView.backgroundColor = [UIColor clearColor];
    self.areaView.alpha = 0.5;
    UITapGestureRecognizer *areaTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden)];
    [self.areaView addGestureRecognizer:areaTouch];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction:) name:@"commboxNotice"object:nil];
    
    [self.areaCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"12"];


}

// 学校 类型 13
- (void)createSchoolTypeCombox{
    //(幼儿园/小学/中学/培训机构 1/2/3/4)
    self.schoolTypeArr = [[NSMutableArray alloc]initWithObjects:@"幼儿园",@"小学",@"初中",@"培训机构",nil];
    UILabel * schoolTypeLabel=[[UILabel alloc]initWithFrame:CGRectMake(30 * kWidth / 375, 132 * kWidth / 375, 92 * kWidth / 375, 30 * kWidth / 375)];
    schoolTypeLabel.text=@"学校类型";
    schoolTypeLabel.font = [UIFont systemFontOfSize:14 * kWidth / 375];
    [bgScrollView addSubview:schoolTypeLabel];
    
    UIImageView *starImV =[[UIImageView alloc]initWithFrame:CGRectMake(5 * kWidth / 375,135 * kWidth / 375, 20 * kWidth / 375, 20 * kWidth / 375)];
    starImV.image =[UIImage imageNamed:@"必填符号38x38"];
    [bgScrollView addSubview:starImV];
    self.schoolTypeCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(100 * kWidth / 375, 132 * kWidth / 375, 260 * kWidth / 375, 30 * kWidth / 375)];
    self.schoolTypeCombox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
    
    self.schoolTypeCombox.textField.placeholder= @"学校类型";
    
    self.schoolTypeCombox.textField.textAlignment = NSTextAlignmentCenter;
    
    self.schoolTypeCombox.textField.tag = 101;
    
    self.schoolTypeCombox.dataArray = self.schoolTypeArr;
    
    [bgScrollView addSubview:self.schoolTypeCombox];
    
    self.schoolTypeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight+300)];
    self.schoolTypeView.backgroundColor = [UIColor clearColor];
    self.schoolTypeView.alpha = 0.5;
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden)];
    [self.schoolTypeView addGestureRecognizer:singleTouch];
    
    [self.schoolTypeCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"13"];
}

//学校 名称 14
- (void)createSchoolNameCombox{

//    self.schoolNameArr = [[NSArray alloc]initWithObjects:@"华高小学",@"希望中学",@"北京大学",@"清华大学",nil];
    _schoolNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(30 * kWidth / 375, 194 * kWidth / 375, 92 * kWidth / 375, 30 * kWidth / 375)];
    _schoolNameLabel.text=@"学校名称";
    _schoolNameLabel.font = [UIFont systemFontOfSize:14 * kWidth / 375];
    [bgScrollView addSubview:_schoolNameLabel];
    
    
    UIImageView *starIgV =[[UIImageView alloc]initWithFrame:CGRectMake(5 * kWidth / 375,197 * kWidth / 375, 20 * kWidth / 375, 20 * kWidth / 375)];
    starIgV.image =[UIImage imageNamed:@"必填符号38x38"];
    [bgScrollView addSubview:starIgV];
    self.schoolNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(100 * kWidth / 375, 194 * kWidth / 375, 260 * kWidth / 375, 30 * kWidth / 375)];
    
    self.schoolNameCombox.textField.textAlignment = NSTextAlignmentCenter;
    self.schoolNameCombox.textField.tag = 102;
//    self.schoolNameCombox.textField.delegate = self;
    self.schoolNameCombox.textField.placeholder =@"学校名称";
    
//    self.schoolNameCombox.dataArray = self.schoolNameArr;
    [bgScrollView addSubview:self.schoolNameCombox];
    self.schoolNameView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight+300)];
    self.schoolNameView.backgroundColor = UIColorFromRGB(246, 246, 246);
    self.schoolNameView.alpha = 0.5;
    
    [self.schoolNameCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"14"];

}



//年级 15
- (void)createGradeNameCombox{

    UILabel * gradeNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(30 * kWidth / 375, 256 * kWidth / 375, 92 * kWidth / 375, 30 * kWidth / 375)];
    gradeNameLabel.text=@"班级信息";
    gradeNameLabel.font = [UIFont systemFontOfSize:14 * kWidth / 375];
    [bgScrollView addSubview:gradeNameLabel];
    
    
    self.gradeNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(100 * kWidth / 375, 256 * kWidth / 375, 120 * kWidth / 375, 30 * kWidth / 375)];
    self.gradeNameCombox.textField.placeholder = @"年级";
    self.gradeNameCombox.textField.textAlignment = NSTextAlignmentCenter;
    self.gradeNameCombox.textField.tag = 103;

    CGRect gradeRect = _gradeNameCombox.listTableView.frame;
    gradeRect = CGRectMake(gradeRect.origin.x - 20 * kScreenRatioWidth, gradeRect.origin.y, gradeRect.size.width + 40 * kScreenRatioWidth, gradeRect.size.height);
    _gradeNameCombox.listTableView.frame = gradeRect;
    
    [bgScrollView addSubview:self.gradeNameCombox];
    self.gradeNameView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight+300)];
    self.gradeNameView.backgroundColor = UIColorFromRGB(246, 246, 246);
    self.gradeNameView.alpha = 0.5;
    
    [self.gradeNameCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"15"];


}

//班级 16
- (void)createClassNameCombox{
    self.classNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(240 * kWidth / 375, 256 * kWidth / 375, 120 * kWidth / 375, 30 * kWidth / 375)];
    self.classNameCombox.textField.placeholder = @"班级";
    self.classNameCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.classNameCombox.textField.tag = 104;
//    self.classNameCombox.textField.delegate = self;
//    self.classNameCombox.dataArray = self.classNameArr;
    [bgScrollView addSubview:self.classNameCombox];
    self.classNameView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight+300)];
    self.classNameView.backgroundColor = UIColorFromRGB(246, 246, 246);
    self.classNameView.alpha = 0.5;
    
    [self.classNameCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"16"];


}

//审核人员 17
- (void)createAuditNameCombox{

//    self.auditPeopleArr = [[NSArray alloc]initWithObjects:@"张老师",@"王老师",@"李老师",@"平台审核",nil];
    self.auditNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(30 * kWidth / 375, 318 * kWidth / 375, 92 * kWidth / 375, 30 * kWidth / 375)];
    self.auditNameLabel.text=@"审核人员";
    _auditNameLabel.font = [UIFont systemFontOfSize:14 * kWidth / 375];
    [bgScrollView addSubview:self.auditNameLabel];
    
    self.auditNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(100 * kWidth / 375, 318 * kWidth / 375, 260 * kWidth / 375, 30 * kWidth / 375)];
    self.auditNameCombox.textField.placeholder = @"请选择审核人员";
    self.auditNameCombox.textField.textAlignment = NSTextAlignmentCenter;
    self.auditNameCombox.textField.tag = 105;
//    self.auditNameCombox.textField.delegate = self;
//    self.auditNameCombox.dataArray = self.auditPeopleArr;
    [bgScrollView addSubview:self.auditNameCombox];
    
    self.auditPeopleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight+300)];
    self.auditPeopleView.backgroundColor = UIColorFromRGB(246, 246, 246);
    self.auditPeopleView.alpha = 0.5;
    
    [self.auditNameCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"17"];
    self.auditNameCombox.textField.tag = 17;
    
//    UIButton *btn = [HHControl createButtonWithFrame:CGRectMake(335 * kWidth / 375, 318 * kWidth / 375, 30 * kWidth / 375, 30 * kWidth / 375) backGruondImageName:@"" Target:self Action:@selector(tip:) Title:@"?"];
    
//    [bgScrollView addSubview:btn];


}

//确定 按钮
- (void)createDefineBtn{

    CGFloat buttonW = 325 * kScreenRatioWidth;
    CGFloat buttonH = 42 * kScreenRatioHeight;
    CGFloat buttonX = (KScreenWidth - buttonW) / 2;
    CGFloat buttonY = KScreenHeight - 150 * kScreenRatioHeight;
    
    
    UIButton * defineBtn= [HHControl createButtonWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH) backGruondImageName:@"按钮big650x84" Target:self Action:@selector(defineBtnPressed:) Title:@"确    定"];
    [defineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bgScrollView addSubview:defineBtn];

}


//- (void)tip:(UIButton*)btn{
////    NSLog(@"??????");
//    [SVProgressHUD showInfoWithStatus:@"如果审核人员中没有您熟悉的老师,您可以选择平台审核,提交我们平台处理."];
//}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{

    switch ([[NSString stringWithFormat:@"%@",context] integerValue]) {
        case 10:
        {
            //省
            if ([keyPath isEqualToString:@"text"]) {
                NSString * newName=[change objectForKey:@"new"];
                if (newName) {
                    provinceStr = newName;
                }
                
                //如果从 搜索界面 跳转过来  重新赋值
                if (searchArray.count != 0) {
                    _cityCombox.textField.text = searchArray[1];
                    _cityCombox.textField.enabled = NO;
                }else{
                    //获取 城市 数据
                    [self fetchCityData];
                
                }
            }else{
            
            
            }
            
        }
            break;
        case 11:
        {
            //市
            
            if (_provinceCombox.textField.text) {
                if ([keyPath isEqualToString:@"text"]) {
                    NSString * newName=[change objectForKey:@"new"];
                    if (newName) {
                        cityStr = newName;
                    }
                    
                    //如果从 搜索界面 跳转过来  重新赋值
                    if (searchArray.count != 0) {
                        _areaCombox.textField.text = searchArray[2];
                        _areaCombox.textField.enabled = NO;
                    }else{
                    
                    //获取 区 数据
                    [self fetchAreaData];
                    }
                }
            }else{
            
                [SVProgressHUD showInfoWithStatus:@"请先完善“省”信息"];
            }
            
        }
            break;
            case 12:
        {
            //区
            
            if (_cityCombox.textField.text) {
                if ([keyPath isEqualToString:@"text"]) {
                    NSString * newName=[change objectForKey:@"new"];
                    if (newName) {
                        areaStr = newName;
                    }
                    
                    //如果从 搜索界面 跳转过来  重新赋值
                    if (searchArray.count != 0) {
                        
                        NSString *str;
//                        幼儿园/小学/中学/培训机构 1/2/3/4
                        if ([searchArray[3] isEqualToString:@"1"]) {
                            str = @"幼儿园";
                        }else if ([searchArray[3] isEqualToString:@"2"]){
                            str = @"小学";
                        }else if ([searchArray[3] isEqualToString:@"3"]){
                            str = @"初中";
                            
                        }else if ([searchArray[3] isEqualToString:@"4"]){
                            str = @"培训机构";
                            
                        }else if ([searchArray[3] isEqualToString:@"5"]){
                            str = @"高中";
                            
                        }
                        
                        _schoolTypeCombox.textField.text = str;
                        _schoolTypeCombox.textField.enabled = NO;
                    }else{
                        

                    }
                    
                }
            }else{
                
                [SVProgressHUD showInfoWithStatus:@"请先完善“市”信息"];
                
            }
        }
            break;
            
            case 13:
        {
            
        //用户选择 学校 类型
            
            if (_areaCombox.textField.text) {
                
            
            NSString *str1 = self.schoolTypeCombox.textField.text;
            
            if (str1) {
                
//                if (searchArray.count != 0) {
//                    self.schoolTypeCombox.textField.text = _schoolTypeArr[[searchArray[3] integerValue]];
//                   
//                }else{
                
                    NSInteger index = [_schoolTypeArr indexOfObject: str1];
                    
                    NSString *newStr = [NSString stringWithFormat:@"%ld", index + 1];
                    
                    schoolTypeStr = newStr;
                    
                    
                    if (provinceStr != nil && cityStr != nil && areaStr != nil) {
                        //获取 学校 名称 数据
                        [self fetchSchoolNameData];
                        
                    }else{
                        
                        [SVProgressHUD showInfoWithStatus:@"请完善前面信息"];
                        
                    }
//                }
                
            }
            }else{
                
            [SVProgressHUD showInfoWithStatus:@"请先完善“区”信息"];
            
            }
        }
            break;
            
            case 14:
        {
        //学校 名称
            
            if (_schoolTypeCombox.textField.text) {
            
            NSString *str1 = self.schoolNameCombox.textField.text;
            
            if (str1) {

                if (searchArray.count != 0) {
                    schoolIdStr = searchArray[5];
                }else{
                NSInteger index = [_schoolNameArr indexOfObject: str1];
                    
                schoolIdStr = [NSString stringWithFormat:@"%@", schoolIdArray[index]];
                
                }
                
                //获取 年级 数据
                [self fetchGradeData];
            }
            }else{
            
                [SVProgressHUD showInfoWithStatus:@"请先完善“学校类型”信息"];
                
            }
            
        }
            break;
            
        case 15:
        {
            //年级
            
            if (_schoolNameCombox.textField.text) {
            
            gradeStr = self.gradeNameCombox.textField.text;
            
            if (gradeStr) {
                
                NSInteger index = [_gradeNameArr indexOfObject: gradeStr];
                
                courseIdStr = [NSString stringWithFormat:@"%@", courseIdArray[index]];
                //获取 班级 数据
                [self fetchClassData];
            
            }
            }else{
            
                [SVProgressHUD showInfoWithStatus:@"请先完善“学校名称”信息"];
            
            }
            
        }
            break;
            
        case 16:
        {
            //班级
            
            if (_gradeNameCombox.textField.text) {
            
            NSString *classStr = self.classNameCombox.textField.text;
            
            if (classStr) {
                NSInteger index = [_classNameArr indexOfObject: classStr];
                
//                NSString *newStr = [NSString stringWithFormat:@"%ld", index + 1];
                
//                NSLog(@"auditorIdArray === %@", classIdArray);
                classIdStr = classIdArray[index];
                
                //获取 审核人员 数据
                [self fetchAuditData];
            
            }
            }else{
            
                [SVProgressHUD showInfoWithStatus:@"请先完善“年级”信息"];
            
            }
            
        }
            break;
        case 17:
        {
            //审核人员
            
            if (_gradeNameCombox.textField.text) {
            
            NSString *auditorNameStr = self.auditNameCombox.textField.text;
            
            if (auditorNameStr) {
                NSInteger index = [auditorNameArray indexOfObject: auditorNameStr];

                auditorIdStr = auditorIdArray[index];
                
            }
            }else{
            
                [SVProgressHUD showInfoWithStatus:@"请先完善“班级”信息"];
            
            }
            
        }
            break;
  
            
            
        default:
            break;
    }


}




- (void)commboxAction:(NSNotification *)notif{
    switch ([notif.object integerValue]) {
        case 101:
            [self.self.schoolTypeCombox removeFromSuperview];
            [bgScrollView addSubview:self.schoolTypeView];
            [bgScrollView addSubview:self.schoolTypeCombox];
            break;
        case 102:
            [self.self.schoolNameCombox removeFromSuperview];
            [bgScrollView addSubview:self.schoolNameCombox];
            [bgScrollView addSubview:self.schoolNameCombox];
            break;
        case 105:
            [self.self.trainSubjectCombox removeFromSuperview];
            [bgScrollView addSubview:self.trainSubjectCombox];
            [bgScrollView addSubview:self.trainSubjectCombox];
            break;
        default:
            break;
    }
    
}
- (void)commboxHidden{
    [self.schoolTypeView removeFromSuperview];
    [self.schoolTypeCombox setShowList:NO];
    self.schoolTypeCombox.listTableView.hidden = YES;
    CGRect sf = self.schoolTypeCombox.frame;
    sf.size.height = 30;
    self.schoolTypeCombox.frame = sf;
    CGRect frame = self.schoolTypeCombox.listTableView.frame;
    frame.size.height = 0;
    self.schoolTypeCombox.listTableView.frame = frame;
    [self.schoolTypeCombox removeFromSuperview];
    [bgScrollView addSubview:self.schoolTypeCombox];
    
    [self.schoolNameView removeFromSuperview];
    [self.schoolNameCombox setShowList:NO];
    self.schoolNameCombox.listTableView.hidden = YES;
    CGRect sf2 = self.schoolNameCombox.frame;
    sf2.size.height = 30;
    self.schoolNameCombox.frame = sf2;
    CGRect frame2 = self.schoolTypeCombox.listTableView.frame;
    frame2.size.height = 0;
    self.schoolNameCombox.listTableView.frame = frame2;
    [self.schoolNameCombox removeFromSuperview];
    [bgScrollView addSubview:self.schoolNameCombox];
    
}
-(void)defineBtnPressed:(id)sender{
    /*
     baby_id		//孩子id
     school_id	//学校id
     sch_type	//学校类型代号 (幼儿园/小学/初中/培训机构/高中 1/2/3/4/5)
     class_id	//班级id
     examine_id	//审核老师的id
     */
    if ([self.schoolTypeCombox.textField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"学校类型不能为空!"];
        return;
    }
    if ([self.schoolNameCombox.textField.text isEqualToString:@""]) {
           [SVProgressHUD showErrorWithStatus:@"学校名称不能为空!"];
        return;
    }
    if ([self.gradeNameCombox.textField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"年级名称不能为空!"];
        return;
    }
    if ([self.classNameCombox.textField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"班级名称不能为空!"];
        return;
    }
    if ([self.auditNameCombox.textField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"审核人员不能为空!"];
        return;
    }
    

    
//    if (_isFromAddBaby) {
//        [self upLoadBabyInfo];
//    }else{
    
        [self uploadSchoolInfo];
//    }

    HUD =[[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.mode =MBProgressHUDModeText;
    HUD.dimBackground =YES;
}


//- (void)upLoadBabyInfo{
//    ///*
//    // 【添加孩子】
//    //
//    // ★注:后面紧跟着的添加班级,请用baby_study_sch接口
//    //
//    // 接口:
//    // http://www.xingxingedu.cn/Parent/add_baby
//    //
//    // 传参:
//    //	baby_nickname		//孩子昵称
//    //	tname			//真实姓名
//    //	id_card			//身份证
//    //	passport		//护照
//    //	age			//年龄
//    //	sex			//性别
//    //	relation		//关系
//    //	pdescribe		//个人描述
//    //	file			//上传头像
//    // */
//        //        //路径
//        NSString *urlStr = @"http://www.xingxingedu.cn/Parent/add_baby";
//
//    
//    ClassEditViewController *ClassEditVC = [[ClassEditViewController alloc] init];
//    
//    //    [self.view endEditing:YES];
//    
//    
//    //请求参数
//    
//    NSDictionary *params = [[NSDictionary alloc] init];
//    
//    if (_codeFlag == YES) {
//        //护照
//        params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":XID, @"user_id":USER_ID, @"user_type":USER_TYPE, @"baby_nickname":_babyInfoArray[0], @"tname":_babyInfoArray[1], @"passport":_babyInfoArray[2], @"relation":_babyInfoArray[3]};
//        
//    }else if (_codeFlag == NO){
//        
//        //身份证 信息
//        
//        params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":XID, @"user_id":USER_ID, @"user_type":USER_TYPE, @"baby_nickname":_babyInfoArray[0], @"tname":_babyInfoArray[1], @"id_card":_babyInfoArray[2], @"relation":_babyInfoArray[3], @"sex":_babyInfoArray[4], @"age":_babyInfoArray[5]};
//        
//    }
//    
//        [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
//            NSDictionary *dict =responseObj;
//    //         NSLog(@"添加孩子*****data======================%@",dict);
//            if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
//            {
//
//              [self uploadSchoolInfo];
//    
//            }else if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"3"]){
//                //该宝贝 已存在
//                [SVProgressHUD showErrorWithStatus:@"这个孩子已存在,并且您已经与这个孩子建立过关系!"];
//    
//            }else if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"50"]){
//                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",dict[@"msg"]]];
//            }
//            
//        } failure:^(NSError *error) {
////               NSLog(@"error====error=================================");
//            
//            NSLog(@"%@", error);
//        }];
//    
//
//
//}


- (void)uploadSchoolInfo{

/*
 【补全孩子上学的班级信息(第一次登陆的时候,首页添加班级和孩子个人中心新增孩子都用这个接口)】
 
 接口:
 http://www.xingxingedu.cn/Parent/baby_study_sch
 
 传参:
 baby_id	//孩子id
 school_id	//学校id
 sch_type	//学校类型代号 (幼儿园/小学/中学/培训机构 1/2/3/4)
 class_id	//班级id
 examine_id	//审核老师的id
 */
    
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/baby_study_sch";
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"school_id":schoolIdStr, @"sch_type":schoolTypeStr, @"class_id":classIdStr, @"examine_id":auditorIdStr, @"baby_id":babyId};
//    NSLog(@" params --  %@", params);
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
    
//    NSLog(@"rrrrrrtttttyyyuiujk---   %@", responseObj);

    NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
    
    if ([codeStr isEqualToString:@"1"]) {
        [SVProgressHUD showSuccessWithStatus:@"您的信息已经提交成功,请耐心等待审核,谢谢您的支持!"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            XXETabBarViewController *tabBarControllerConfig = [[XXETabBarViewController alloc]init];
            [self presentViewController:tabBarControllerConfig animated:YES completion:nil];

        });
       //上海
    }else if([codeStr isEqualToString:@"5"]){
        
        [SVProgressHUD showErrorWithStatus:@"您已申请过,正在审核中!"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            XXETabBarViewController *tabBarControllerConfig = [[XXETabBarViewController alloc]init];
            [self presentViewController:tabBarControllerConfig animated:YES completion:nil];
            
        });
    }else{
        [SVProgressHUD showErrorWithStatus:@"您的信息提交失败,请重新提交!"];
        
    }
    
    
     } failure:^(NSError *error) {
    //
//    NSLog(@"%@", error);
         [SVProgressHUD showErrorWithStatus:@"获取数据失败!"];
    }];
    
    
}


/**
 *  省
 */
- (void)fetchProvinceData{
/*
 【获取省,城市,区】
 接口:
 http://www.xingxingedu.cn/Global/provinces_city_area
 传参:
	action_type	//执行类型 1:获取省 , 2:获取城市, 3:获取区
	fatherID	//父级id, 获取市和区需要, 获取省不需要
 */
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/provinces_city_area";
    
    //请求参数  无
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"action_type":@"1"};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        provinceArr = [[NSMutableArray alloc] init];
        provinceIDArray = [[NSMutableArray alloc] init];
        //
//        NSLog(@"省---responseObj --- %@", responseObj);
        NSArray *dataSource = responseObj[@"data"];
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            for (NSDictionary *dic in dataSource) {
            
                [provinceArr addObject:dic[@"province"]];
                [provinceIDArray addObject:dic[@"provinceID"]];
            }
            
        }else{
        
        
        }

        
//     [self createProvinceCombox];
        
//        NSLog(@"%@", provinceArr);
        self.provinceCombox.dataArray = provinceArr;
        [self.provinceCombox.listTableView reloadData];

    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];
}

/**
 *  市
 */
- (void)fetchCityData{

    /*
     【获取省,城市,区】
     接口:
     http://www.xingxingedu.cn/Global/provinces_city_area
     传参:
     action_type	//执行类型 1:获取省 , 2:获取城市, 3:获取区
     fatherID	//父级id, 获取市和区需要, 获取省不需要
     */
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/provinces_city_area";
    
    //请求参数
    NSUInteger index;
    NSString *fatherID;
    
    if (provinceStr) {
        index = [provinceArr indexOfObject:provinceStr];
        fatherID = provinceIDArray[index];
    }
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"action_type":@"2", @"fatherID":fatherID};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        
        cityArr = [[NSMutableArray alloc] init];
        cityIDArray = [[NSMutableArray alloc] init];
        //
//        NSLog(@"市----responseObj --- %@", responseObj);
        NSArray *dataSource = responseObj[@"data"];
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            for (NSDictionary *dic in dataSource) {
                
                [cityArr addObject:dic[@"city"]];
                [cityIDArray addObject:dic[@"cityID"]];
            }
            
        }else{
            
            
        }
        self.cityCombox.dataArray = cityArr;
        [self.cityCombox.listTableView reloadData];
        
//        //如果从 搜索界面 跳转过来  重新赋值
//        if (searchArray.count != 0) {
//         _cityCombox.textField.text = searchArray[1];
//         _cityCombox.textField.enabled = NO;
//        }
        
    
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];

}

/**
 *  区
 */
- (void)fetchAreaData{

//    /*
//     【获取省,城市,区】
//     接口:
//     http://www.xingxingedu.cn/Global/provinces_city_area
//     传参:
//     action_type	//执行类型 1:获取省 , 2:获取城市, 3:获取区
//     fatherID	//父级id, 获取市和区需要, 获取省不需要
//     */
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/provinces_city_area";
    NSUInteger index;
    NSString *fatherID;
    
    if (cityStr) {
        index = [cityArr indexOfObject:cityStr];
        fatherID = cityIDArray[index];
    }
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"action_type":@"3", @"fatherID":fatherID};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        
        areaArr = [[NSMutableArray alloc] init];
        areaIDArray = [[NSMutableArray alloc] init];
        //
//                NSLog(@"区---responseObj --- %@", responseObj);
        NSArray *dataSource = [NSArray array];
        dataSource = responseObj[@"data"];
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            for (NSDictionary *dic in dataSource) {
                [areaArr addObject:dic[@"area"]];
                [areaIDArray addObject:dic[@"areaID"]];
            }
            
        }else{
            
            
        }
        
        self.areaCombox.dataArray = areaArr;
        [self.areaCombox.listTableView reloadData];
        
//        //如果从 搜索界面 跳转过来  重新赋值
//        if (searchArray.count != 0) {
//            _areaCombox.textField.text = searchArray[2];
//            _areaCombox.textField.enabled = NO;
//        }
        
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];
}

/**
 *  学校 名称
 */
- (void)fetchSchoolNameData{
    
        /*
         【通过学校类型地区获取学校】
         接口:
         http://www.xingxingedu.cn/Global/get_school_info
         传参:
         school_type 	//学校类型,请传数字代号:幼儿园/小学/中学/培训机构 1/2/3/4
         province  	//省
         city		//城市
         district	//区
         search_words	//搜索关键词(搜索的时候上面4个传参不需要,传上面4个时,搜索词不需要)
         */
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/get_school_info";
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"school_type":schoolTypeStr, @"province":provinceStr, @"city":cityStr , @"district": areaStr};
    
//    NSLog(@"%@", params);
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        _schoolNameArr = [[NSMutableArray alloc] init];
        schoolIdArray = [[NSMutableArray alloc] init];
        //
//                        NSLog(@"学校 名称 ---responseObj --- %@", responseObj);

        NSArray *dataSource = responseObj[@"data"];
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            for (NSDictionary *dic in dataSource) {
                
                [_schoolNameArr addObject:dic[@"name"]];
                [schoolIdArray addObject:dic[@"id"]];
            }
            
        }else{
            
            
        }
        
        self.schoolNameCombox.dataArray = _schoolNameArr;
        [self.schoolNameCombox.listTableView reloadData];
        
        //如果从 搜索界面 跳转过来  重新赋值
        if (searchArray.count != 0) {
            _schoolNameCombox.textField.text = searchArray[4];
            _schoolNameCombox.textField.enabled = NO;
        }
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];
}

/**
 *  年级
 */
- (void)fetchGradeData{
    
    /*
     【通过学校获取年级】
     接口:
     http://www.xingxingedu.cn/Global/give_school_get_grade
     传参:
     school_id	//学校id
     school_type 	//学校类型,请传数字代号:幼儿园/小学/中学/培训机构 1/2/3/4
     */
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/give_school_get_grade";
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"school_type":schoolTypeStr, @"school_id":schoolIdStr};
    
//    NSLog(@"年级 *******   %@", params);
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        _gradeNameArr = [[NSMutableArray alloc] init];
       courseIdArray  = [[NSMutableArray alloc] init];
        //
//        NSLog(@"学校 id -responseObj --- %@", responseObj);
        NSArray *dataSource = responseObj[@"data"];
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
//            if ([schoolTypeStr isEqualToString:@"1"]) {
//                //幼儿园
//                
//                
//            }else if ([schoolTypeStr isEqualToString:@"2"] || [schoolTypeStr isEqualToString:@"3"]){
//            //小学 初中
                for (NSDictionary *dic in dataSource) {
                    
                    [_gradeNameArr addObject:dic[@"grade"]];
                    [courseIdArray addObject:dic[@"course_id"]];
                }

                
//            }else if ([schoolTypeStr isEqualToString:@"4"]){
//            //培训 机构
//            
//            }
            
            
        }else{
            
            
        }
        
        self.gradeNameCombox.dataArray = _gradeNameArr;
        [self.gradeNameCombox.listTableView reloadData];
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];
}


//获取 班级
- (void)fetchClassData{
    
    /*
     【通过年级获取班级】
     接口:
     http://www.xingxingedu.cn/Global/give_grade_get_class
     传参:
     school_id	//学校id
     grade 		//年级
     course_id		//课程id
     */
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/give_grade_get_class";
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"course_id":courseIdStr, @"school_id":schoolIdStr, @"grade":gradeStr};
    
//    NSLog(@"班级  -----=====  %@", params);
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        _classNameArr = [[NSMutableArray alloc] init];
        classIdArray  = [[NSMutableArray alloc] init];
//                NSLog(@"班级 -responseObj --- %@", responseObj);
        NSArray *dataSource = responseObj[@"data"];
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            for (NSDictionary *dic in dataSource) {
                
                [_classNameArr addObject:dic[@"class"]];
                [classIdArray addObject:dic[@"class_id"]];
            }
            
        }else{
            
            
        }
        
        self.classNameCombox.dataArray = _classNameArr;
        [self.classNameCombox.listTableView reloadData];
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];
}



- (void)fetchAuditData{
    /*
     【获取审核老师】
     接口:
     http://www.xingxingedu.cn/Parent/get_examine_teacher
     传参:
     school_id 	//学校id
     class_id	//班级id
     */

    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/get_examine_teacher";
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"class_id":classIdStr, @"school_id":schoolIdStr};
    
//    NSLog(@"传参 === %@", params);
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        auditorIdArray = [[NSMutableArray alloc] init];
        auditorNameArray  = [[NSMutableArray alloc] init];
//            NSLog(@"审核 人员 -responseObj --- %@", responseObj);
        NSArray *dataSource = responseObj[@"data"];
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            for (NSDictionary *dic in dataSource) {
                
                [auditorIdArray addObject:dic[@"id"]];
                [auditorNameArray addObject:dic[@"tname"]];
            }
            
        }else{
            
            
        }
        
        self.auditNameCombox.dataArray = auditorNameArray;
        [self.auditNameCombox.listTableView reloadData];
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];
}

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.provinceCombox.textField removeObserver:self forKeyPath:@"text"];
    
    [self.cityCombox.textField removeObserver:self forKeyPath:@"text"];
    
    [self.areaCombox.textField removeObserver:self forKeyPath:@"text"];
    
    [self.schoolTypeCombox.textField removeObserver:self forKeyPath:@"text"];
    
    [self.schoolNameCombox.textField removeObserver:self forKeyPath:@"text"];
    
    [self.gradeNameCombox.textField removeObserver:self forKeyPath:@"text"];
    
    [self.classNameCombox.textField removeObserver:self forKeyPath:@"text"];
    
  
    //[self.auditNameCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"17"];
    [self.auditNameCombox.textField removeObserver:self forKeyPath:@"text"];
    
}


@end


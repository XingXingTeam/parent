


//
//  WZYNewBabyDetailViewController.m
//  XingXingEdu
//
//  Created by Mac on 16/5/16.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "WZYNewBabyDetailViewController.h"
#import "WJCommboxView.h"
#import "MBProgressHUD.h"
#import "UtilityFunc.h"
#import "LMComBoxView.h"
#import "LMContainsLMComboxScrollView.h"

#import "HomepageViewController.h"


#define kScreenWidth self.view.frame.size.width
#define kScreenHeight self.view.frame.size.height
#define  kDropDownListTag 1000


@interface WZYNewBabyDetailViewController ()<UISearchBarDelegate, UITextFieldDelegate, LMComBoxViewDelegate, UISearchBarDelegate>

{
    LMContainsLMComboxScrollView *bgScrollView;
    NSMutableDictionary *addressDict;
    NSDictionary *areaDict;
    NSArray *provinceArr;
    NSArray *cityArr;
    NSArray *districtArr;
    NSString *selectProvinceStr;
    NSString *selectCityStr;
    NSString *selectAreaStr;
    UILabel *trainAgencyLbl;
    UIImageView *bgView;
    
    NSString *OneStr;
    UITextField *textFiel;
    NSMutableDictionary *kindDict;
    NSMutableDictionary *auditDict;
    NSString *ID;
    NSString *gradeStr;
    NSString *classStr;

}

@property(nonatomic,strong)NSArray *schoolTypeArr;

//搜索
@property (nonatomic, strong) UISearchBar *searchBar;

@property(nonatomic,strong)UISearchController *searchDC;


//市
@property(nonatomic,strong)WJCommboxView *cityCombox;
//区
@property(nonatomic,strong)WJCommboxView *areaCombox;
//路
@property(nonatomic,strong)WJCommboxView *roadCombox;
//学校类型
@property(nonatomic,strong)WJCommboxView *schoolTypeCombox;
//学校名称
@property(nonatomic,strong)WJCommboxView *schoolNameCombox;
//年级
@property(nonatomic,strong)WJCommboxView *gradeCombox;
//班级
@property(nonatomic,strong)WJCommboxView *classCombox;
//审核人员
@property(nonatomic,strong)WJCommboxView *checkCombox;

@property (nonatomic,strong) UIView *cityComboxBackView;
@property (nonatomic,strong) UIView *areaComboxBackView;
@property (nonatomic,strong) UIView *roadComboxBackView;
@property (nonatomic,strong) UIView *schoolTypeComboxBackView;
@property (nonatomic,strong) UIView *schoolNameComboxBackView;
@property (nonatomic,strong) UIView *gradeComboxBackView;
@property (nonatomic,strong) UIView *classComboxBackView;
@property (nonatomic,strong) UIView *checkComboxBackView;


//左边 label 数据信息
@property (nonatomic) NSMutableArray *labelArray;

@property (nonatomic) NSDictionary *areaDict;


//省
@property (nonatomic) NSArray *prvoinceComboxArray;

//市
@property (nonatomic) NSMutableArray *cityComboxArray;

//区
@property (nonatomic) NSMutableArray *areaComboxArray;



//学校类型
@property (nonatomic) NSMutableArray *schoolTypeComboxArray;
@property (nonatomic, copy) NSString *sch_type;


//学校名称
@property (nonatomic) NSMutableArray *schoolNameComboxArray;

//年级
@property (nonatomic) NSMutableArray *gradeComboxArray;

//班级
@property (nonatomic) NSMutableArray *classComboxArray;

//审核人员
@property (nonatomic) NSMutableArray *checkComboxArray;

@property (nonatomic, strong) MBProgressHUD *HUDDone;

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UITextField *schoolNameTextField;

@end

@implementation WZYNewBabyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    self.title = @"添加学生2/2";
    
    self.labelArray = [[NSMutableArray alloc] initWithObjects:@"区域", @"学校类型", @"学校名称", @"班级信息", @"审核人员", nil];
    
    self.prvoinceComboxArray = [[NSMutableArray alloc] initWithObjects:@"北京", @"上海", @"广东", nil];
    self.cityComboxArray = [[NSMutableArray alloc] initWithObjects:@"北京", @"上海", @"广州", nil];
    self.areaComboxArray = [[NSMutableArray alloc] initWithObjects:@"虹口区", @"金水区", @"中原区", nil];

    self.schoolTypeComboxArray = [[NSMutableArray alloc] initWithObjects:@"幼儿园", @"小学", @"初中", @"培训机构", nil];
    self.schoolNameComboxArray = [[NSMutableArray alloc] initWithObjects:@"华高小学", @"光明小学", @"希望小学", nil];
    self.gradeComboxArray = [[NSMutableArray alloc] initWithObjects:@"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级", nil];
    self.classComboxArray = [[NSMutableArray alloc] initWithObjects:@"一班", @"二班", @"三班", nil];
    self.checkComboxArray = [[NSMutableArray alloc] initWithObjects:@"校长", @"管理人员", @"老师", nil];
    
    //设置 navigationBar 左边 返回
    UIImage *backImage = [UIImage imageNamed:@"返回icon90x38"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage: backImage  style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    
    [self reloadD];
    bgScrollView = [[LMContainsLMComboxScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    bgScrollView.backgroundColor = UIColorFromRGB(229, 232, 233);
    bgScrollView.userInteractionEnabled =YES;
    bgScrollView.showsHorizontalScrollIndicator =NO;
    bgScrollView.showsVerticalScrollIndicator =NO;
    [self.view addSubview:bgScrollView];
    
    [self setBgScrollView];
    
    //0、设置搜索栏
    [self createSearchBar];

    //设置 中间 标题
    [self createLabel];
    //设置 左边 必填项 图标
    [self createImage];

    //设置 右边 下拉选项框
    [self createWJCommboxViews];
}


- (void)createSearchBar{

    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kWidth, 44)];
    UIImage *backgroundImg = [UtilityFunc createImageWithColor:UIColorFromRGB(229, 232, 233) size:_searchBar.frame.size];
    [_searchBar setBackgroundImage:backgroundImg];
//    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 44)];
    _searchBar.placeholder =@"请输入你要查询的学校";
//    _searchBar.tintColor = [UIColor blackColor];
    
    _searchBar.delegate =self;
//    _searchBar.showsCancelButton = YES;
//    [self.view addSubview:_searchBar];
    
    _searchDC = [[UISearchController alloc]initWithSearchResultsController:self];
    
    
    [bgScrollView addSubview:_searchBar];

}

//- (void)createSearchBar{
//    UIBarButtonItem *searchBar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"NavBarIconSearch_blue"] style:UIBarButtonItemStylePlain target:self action:@selector(searchB:)];
//    self.navigationItem.rightBarButtonItem =searchBar;
//}
//- (void)searchB:(UIBarButtonItem*)btn{
//    
//    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,20, kWidth, 44)];
//    UIImage *backgroundImg = [UtilityFunc createImageWithColor:UIColorFromHex(0xf0eaf3) size:_searchBar.frame.size];
//    [_searchBar setBackgroundImage:backgroundImg];
//    _searchBar.placeholder =@"输入你想要查询的联系人";
//    _searchBar.tintColor = [UIColor blackColor];
//    _searchBar.delegate =self;
//    _searchDC = [[UISearchController alloc]initWithSearchResultsController:self];
//    [self.navigationItem.titleView sizeToFit];
//    [self.navigationController.view addSubview:_searchBar];
//    _searchBar.showsCancelButton =YES;
//    
//}



   //设置 左边 必填项 图标
- (void)createImage{

    for (int i = 0; i < 3; i ++) {
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 140 + (20 + 30)* i - 64, 20, 20)];
        myImageView.image = [UIImage imageNamed:@"必填符号60x60"];
        [bgScrollView addSubview:myImageView];
    }

}

 //设置 中间 标题
- (void)createLabel{
    for (int i = 0; i < 5; i++) {
      
        UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 140 + (20 + 30) * i - 64, 60, 20)];
        myLabel.text = self.labelArray[i];
        myLabel.font = [UIFont systemFontOfSize:14];
        [bgScrollView addSubview:myLabel];
    }
}


- (void)reloadD{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    areaDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *components = [areaDict allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [NSMutableArray array];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[areaDict objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    
    provinceArr = [NSArray arrayWithArray:provinceTmp];
    
    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [provinceArr objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[areaDict objectForKey:index]objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    cityArray = [NSArray arrayWithArray:[cityDic allKeys]];
    
    selectCityStr = [cityArray objectAtIndex:0];
    districtArr = [NSArray arrayWithArray:[cityDic objectForKey:selectCityStr]];
    
    addressDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                   provinceArr,@"province",
                   cityArray,@"city",
                   districtArr,@"area",nil];
    
    selectProvinceStr = [provinceArr objectAtIndex:0];
    selectAreaStr = [districtArr objectAtIndex:0];
    
}

- (void)setBgScrollView{
  
    NSArray *keys = [NSArray arrayWithObjects:@"province",@"city",@"area", nil];
    
    for(NSInteger i=0;i<3;i++)
    {
        LMComBoxView *comBox = [[LMComBoxView alloc]initWithFrame:CGRectMake(110 +(80 + 5)*i, 76, 80, 30)];
        comBox.backgroundColor = [UIColor whiteColor];
        comBox.arrowImgName =@"narrow";
        //titleLabel.font = [UIFont systemFontOfSize:11];
        
        //@"down_dark0.png";
        NSMutableArray *itemsArray = [NSMutableArray arrayWithArray:[addressDict objectForKey:[keys objectAtIndex:i]]];
        comBox.layer.cornerRadius = 15;
        [comBox.layer setMasksToBounds:YES];
        comBox.titlesList = itemsArray;
        comBox.delegate = self;
        comBox.supView = bgScrollView;
        [comBox defaultSettings];
        comBox.tag = kDropDownListTag + i;
        
        [bgScrollView addSubview:comBox];
        [bgScrollView bringSubviewToFront:comBox];
        
    }
}
#pragma mark -LMComBoxViewDelegate
-(void)selectAtIndex:(int)index inCombox:(LMComBoxView *)_combox
{
    NSInteger tag = _combox.tag - kDropDownListTag;
    switch (tag) {
        case 0:
        {
            selectProvinceStr =  [[addressDict objectForKey:@"province"]objectAtIndex:index];
            //字典操作
            NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDict objectForKey: [NSString stringWithFormat:@"%d", index]]];
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectProvinceStr]];
            NSArray *cityArray = [dic allKeys];
            NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
                
                if ([obj1 integerValue] > [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;//递减
                }
                
                if ([obj1 integerValue] < [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;//上升
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int i=0; i<[sortedArray count]; i++) {
                NSString *index = [sortedArray objectAtIndex:i];
                NSArray *temp = [[dic objectForKey: index] allKeys];
                [array addObject: [temp objectAtIndex:0]];
            }
            cityArr = [NSArray arrayWithArray:array];
            
            NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
            districtArr = [NSArray arrayWithArray:[cityDic objectForKey:[cityArr objectAtIndex:0]]];
            //刷新市、区
            addressDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           provinceArr,@"province",
                           cityArr,@"city",
                           districtArr,@"area",nil];
            LMComBoxView *cityCombox = (LMComBoxView *)[bgScrollView viewWithTag:tag + 1 + kDropDownListTag];
            cityCombox.titlesList = [NSMutableArray arrayWithArray:[addressDict objectForKey:@"city"]];
            [cityCombox reloadData];
            
            LMComBoxView *areaCombox = (LMComBoxView *)[bgScrollView viewWithTag:tag + 2 + kDropDownListTag];
            areaCombox.titlesList = [NSMutableArray arrayWithArray:[addressDict objectForKey:@"area"]];
            [areaCombox reloadData];
            
            selectCityStr = [cityArr objectAtIndex:0];
            selectAreaStr = [districtArr objectAtIndex:0];
            break;
        }
        case 1:
        {
            selectCityStr = [[addressDict objectForKey:@"city"]objectAtIndex:index];
            
            NSString *provinceIndex = [NSString stringWithFormat: @"%ld", [provinceArr indexOfObject: selectProvinceStr]];
            NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDict objectForKey: provinceIndex]];
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectProvinceStr]];
            NSArray *dicKeyArray = [dic allKeys];
            NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
                
                if ([obj1 integerValue] > [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                
                if ([obj1 integerValue] < [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: index]]];
            NSArray *cityKeyArray = [cityDic allKeys];
            districtArr = [NSArray arrayWithArray:[cityDic objectForKey:[cityKeyArray objectAtIndex:0]]];
            //刷新区
            addressDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           provinceArr,@"province",
                           cityArr,@"city",
                           districtArr,@"area",nil];
            LMComBoxView *areaCombox = (LMComBoxView *)[bgScrollView viewWithTag:tag + 1 + kDropDownListTag];
            areaCombox.titlesList = [NSMutableArray arrayWithArray:[addressDict objectForKey:@"area"]];
            [areaCombox reloadData];
            
            selectAreaStr = [districtArr objectAtIndex:0];
            break;
        }
        case 2:
        {
            selectAreaStr = [[addressDict objectForKey:@"area"]objectAtIndex:index];
            break;
        }
        case 100:
        {
            //tag==1100
            OneStr = [self.schoolTypeArr objectAtIndex:index];
            NSLog(@"OneStr:%@",OneStr);
            break;
        }
        default:
            break;
    }
}



//设置 右边 下拉选项框
- (void)createWJCommboxViews{

    //学校类型
    self.schoolTypeCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(110 , 135 + (20 + 30) * 1 - 64, 250, 30)];
    
    self.schoolTypeCombox.textField.text = @"学校类型";
    self.schoolTypeCombox.textField.textColor = [UIColor lightGrayColor];
    self.schoolTypeCombox.textField.textAlignment = NSTextAlignmentCenter;
    self.schoolTypeCombox.textField.font = [UIFont systemFontOfSize:13];
    self.schoolTypeCombox.textField.borderStyle = UITextBorderStyleNone;
    self.schoolTypeCombox.textField.backgroundColor = [UIColor whiteColor];
    
    self.schoolTypeCombox.textField.layer.cornerRadius = 15;
    self.schoolTypeCombox.textField.layer.masksToBounds = YES;
    self.schoolTypeCombox.textField.clipsToBounds = YES;
    
    self.schoolTypeCombox.textField.leftViewMode = UITextFieldViewModeAlways;
    
    self.schoolTypeCombox.dataArray = self.schoolTypeComboxArray;
    self.schoolTypeCombox.backgroundColor = [UIColor clearColor];
    [bgScrollView addSubview:self.schoolTypeCombox];
    
    self.schoolTypeComboxBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight + 300)];
    self.schoolTypeComboxBackView.backgroundColor = [UIColor clearColor];
    self.schoolTypeComboxBackView.alpha = 0.5;
    

    
    _schoolNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(110 , 135 + (20 + 30) * 2 - 64, 250, 30)];
    _schoolNameTextField.borderStyle = UITextBorderStyleNone;
    _schoolNameTextField.layer.cornerRadius = 15;
    _schoolNameTextField.layer.masksToBounds = YES;
    _schoolNameTextField.delegate = self;
    _schoolNameTextField.font = [UIFont systemFontOfSize:13];
    _schoolNameTextField.textAlignment = NSTextAlignmentCenter;
    _schoolNameTextField.backgroundColor = [UIColor whiteColor];
    _schoolNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [bgScrollView addSubview:_schoolNameTextField];
    
    //年级
    self.gradeCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(110 , 135 + (20 + 30) * 3 - 64, 120, 30)];
    
    self.gradeCombox.textField.text = @"年级";
    self.gradeCombox.textField.textColor = [UIColor lightGrayColor];
    self.gradeCombox.textField.textAlignment = NSTextAlignmentCenter;
    self.gradeCombox.textField.font = [UIFont systemFontOfSize:13];
    self.gradeCombox.textField.borderStyle = UITextBorderStyleNone;
    self.gradeCombox.textField.backgroundColor = [UIColor whiteColor];
    
    self.gradeCombox.textField.layer.cornerRadius = 15;
    self.gradeCombox.textField.layer.masksToBounds = YES;
    self.gradeCombox.textField.clipsToBounds = YES;
    
    self.gradeCombox.textField.leftViewMode = UITextFieldViewModeAlways;
    
    self.gradeCombox.dataArray = self.gradeComboxArray;
    self.gradeCombox.backgroundColor = [UIColor clearColor];
    [bgScrollView addSubview:self.gradeCombox];
    
    self.gradeComboxBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight + 300)];
    self.gradeComboxBackView.backgroundColor = [UIColor clearColor];
    self.gradeComboxBackView.alpha = 0.5;
    
    //班级
    self.classCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(110 + (140) * 1, 135 + (20 + 30) * 3 - 64, 110, 30)];
    
    self.classCombox.textField.text = @"班级";
    self.classCombox.textField.textColor = [UIColor lightGrayColor];
    self.classCombox.textField.textAlignment = NSTextAlignmentCenter;
    self.classCombox.textField.font = [UIFont systemFontOfSize:13];
    self.classCombox.textField.borderStyle = UITextBorderStyleNone;
    self.classCombox.textField.backgroundColor = [UIColor whiteColor];
    
    self.classCombox.textField.layer.cornerRadius = 15;
    self.classCombox.textField.layer.masksToBounds = YES;
    self.classCombox.textField.clipsToBounds = YES;
    
    self.classCombox.textField.leftViewMode = UITextFieldViewModeAlways;
    
    self.classCombox.dataArray = self.classComboxArray;
    self.classCombox.backgroundColor = [UIColor clearColor];
    [bgScrollView addSubview:self.classCombox];
    
    self.classComboxBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight + 300)];
    self.classComboxBackView.backgroundColor = [UIColor clearColor];
    self.classComboxBackView.alpha = 0.5;
    
    //审核人员
    self.checkCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(110 , 135 + (20 + 30) * 4 - 64, 250, 30)];
    
    self.checkCombox.textField.text = @"审核人员";
    self.checkCombox.textField.textColor = [UIColor lightGrayColor];
    self.checkCombox.textField.textAlignment = NSTextAlignmentCenter;
    self.checkCombox.textField.font = [UIFont systemFontOfSize:13];
    self.checkCombox.textField.borderStyle = UITextBorderStyleNone;
    self.checkCombox.textField.backgroundColor = [UIColor whiteColor];
    
    self.checkCombox.textField.layer.cornerRadius = 15;
    self.checkCombox.textField.layer.masksToBounds = YES;
    self.checkCombox.textField.clipsToBounds = YES;
    
    self.checkCombox.textField.leftViewMode = UITextFieldViewModeAlways;
    
    self.checkCombox.dataArray = self.checkComboxArray;
    self.checkCombox.backgroundColor = [UIColor clearColor];
    [bgScrollView addSubview:self.checkCombox];
    
    self.checkComboxBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight + 300)];
    self.checkComboxBackView.backgroundColor = [UIColor clearColor];
    self.checkComboxBackView.alpha = 0.5;

    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(kScreenWidth / 2 - 325 / 2, 135 + (20 + 30) * 6 - 64, 325, 42);
    [doneButton setBackgroundImage:[UIImage imageNamed:@"按钮big650x84"] forState:UIControlStateNormal];
    [doneButton setTitle:@"确定" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgScrollView addSubview:doneButton];
    
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //    取消第一响应者
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [_searchBar endEditing:YES];
    [bgScrollView endEditing:YES];
    
}





- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
//    NSArray *array = self.navigationController.viewControllers;
//    for (id controller in array) {
//        if ([controller isKindOfClass:[HomepageViewController class]]) {
//            [self.navigationController popToViewController:controller animated:YES];
//            
//        }
//    }
//    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (void)doneBtnClick{
    //学校类型
    if ([self.schoolTypeCombox.textField.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请输入学校类型"];
        return;
    }else if ([_schoolNameTextField.text isEqualToString:@""]){
    
        [SVProgressHUD showInfoWithStatus:@"请输入学校名称"];
        return;
    }
    
    self.HUDDone = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUDDone];
    self.HUDDone.dimBackground = YES;
    self.HUDDone.labelText = @"完成";
    
    [self.HUDDone showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [self.HUDDone removeFromSuperview];
        self.HUDDone = nil;
        
        [self upLoadNetData];

        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }];

}

- (void)upLoadNetData{
    
    /*
     【补全孩子上学的班级信息(第一次登陆的时候,首页添加班级和孩子个人中心新增孩子都用这个接口)】
     
     接口:
     http://www.xingxingedu.cn/Parent/baby_study_sch
     
     传参:
     baby_id		//孩子id
     course_id	//如果是机构,需要上传课程id,此id是这个接口get_grade_class获得的.
     school_id	//学校id
     sch_type	//学校类型代号 (幼儿园/小学/中学/培训机构 1/2/3/4)
     grade		//年级
     class		//班级
     examine_id	//审核老师的id,如果老师不存在,需要平台审核,就不用传值了
     */
    //        //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/baby_study_sch";
    
    //请求参数
    
    NSDictionary *params = [[NSDictionary alloc] init];
    
    if ([self.schoolTypeCombox.textField.text isEqualToString:@"幼儿园"]) {
       _sch_type = @"1";
    }else if ([self.schoolTypeCombox.textField.text isEqualToString:@"小学"]) {
        _sch_type = @"2";
    }else if ([self.schoolTypeCombox.textField.text isEqualToString:@"中学"]) {
        _sch_type = @"3";
    }else if ([self.schoolTypeCombox.textField.text isEqualToString:@"培训机构"]) {
        _sch_type = @"4";
    }
    
    ////////////////////////////????????????????????baby_id??????????????
    
   params = @{@"appkey":@"U3k8Dgj7e934bh5Y", @"backtype":@"json", @"xid":@"18884982", @"user_id":@"1", @"user_type":@"1", @"sch_type":_sch_type, @"grade":self.gradeCombox.textField.text, @"class":self.classCombox.textField.text};
        
    
    //    NSLog(@"昵称%@------名称%@------身份证或者护照%@------关系%@---性别%@--------年龄%@----", _rightTextField1.text, _rightTextField2.text, _rightTextField3.text, self.relationCombox.textField.text, sexStr, ageStr);
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        NSDictionary *dict =responseObj;
//                 NSLog(@"data=====================================%@",dict);
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
            
        }
        else if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"50"]){
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",dict[@"msg"]]];
        }
        
    } failure:^(NSError *error) {
        //   NSLog(@"error====error=================================");
        
        //        NSLog(@"%@", error);
    }];
    
    
    
}


// searchbar 点击上浮，完毕复原
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    //搜尋結束後，恢復原狀
    return YES;
}
#pragma mark - search bar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    _searchBar.showsCancelButton = YES;
    
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [_searchBar resignFirstResponder];
}


- (void)viewWillDisappear:(BOOL)animated{
    // self.navigationController.navigationBar.barTintColor =UIColorFromRGB(248, 248, 248);
    [super viewWillDisappear:animated];
    _searchBar.text=nil;
    _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
}



@end

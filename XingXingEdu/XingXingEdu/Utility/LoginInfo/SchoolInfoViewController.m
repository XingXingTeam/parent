//
//  SchoolInfoViewController.m
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/1/14.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#import "SchoolInfoViewController.h"

#define GET_SCHOOL_Url @"http://www.xingxingedu.cn/Parent/get_school_info"
#define Audit_TEACHER_URL @"http://www.xingxingedu.cn/Parent/get_examine_teacher"
#define  kDropDownListTag 1000
#import "LMContainsLMComboxScrollView.h"
#import "HomepageViewController.h"
#import "SVProgressHUD.h"
#import "WJCommboxView.h"
#import "LMComBoxView.h"
#import "AppDelegate.h"
#import "UtilityFunc.h"
#import "HHControl.h"
#import "MyTabBarController.h"
@interface SchoolInfoViewController ()<LMComBoxViewDelegate,UISearchBarDelegate,UITextFieldDelegate,UIAlertViewDelegate>
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
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)UISearchController *searchDC;
@property(nonatomic,strong)UIView *schoolTypeView;
@property(nonatomic,strong)NSArray *schoolNameArr;

@property(nonatomic,strong)NSArray *schoolTypeArr;
@property(nonatomic,strong)UIView *schoolNameView;
@property(nonatomic,strong)NSArray *gradeNameArr;
@property(nonatomic,strong)UIView *gradeNameView;
@property(nonatomic,strong)NSArray *classNameArr;
@property(nonatomic,strong)UIView *classNameView;
@property(nonatomic,strong)NSArray *trainAgencyArr;
@property(nonatomic,strong)UIView *trainAgencyView;
@property(nonatomic,strong)NSArray *auditPeopleArr;
@property(nonatomic,strong)UIView *auditPeopleView;

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

@implementation SchoolInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"完善信息";
    [self performSelector:@selector(pickup) withObject:self afterDelay:1];
    
    //searchBar
    UIBarButtonItem *searchBar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"NavBarIconSearch_blue@2x"] style:UIBarButtonItemStylePlain target:self action:@selector(searchB:)];

    self.navigationItem.rightBarButtonItem =searchBar;
     [self reloadD];
    bgScrollView = [[LMContainsLMComboxScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    bgScrollView.backgroundColor = UIColorFromRGB(255, 255, 255);
    bgScrollView.userInteractionEnabled =YES;
    bgScrollView.showsHorizontalScrollIndicator =NO;
    bgScrollView.showsVerticalScrollIndicator =NO;
    [self.view addSubview:bgScrollView];
    bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    bgView.backgroundColor =UIColorFromRGB(229, 232, 233);
    [bgScrollView addSubview:bgView];
    [self setBgScrollView];
    [self commBoxInfo];
    bgView.userInteractionEnabled = YES;
    [bgView addSubview:_searchBar];
    
}
- (void)searchB:(UIBarButtonItem*)btn{
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,20, kWidth, 44)];
    UIImage *backgroundImg = [UtilityFunc createImageWithColor:UIColorFromHex(0xf0eaf3) size:_searchBar.frame.size];
    [_searchBar setBackgroundImage:backgroundImg];
    _searchBar.placeholder =@"请输入你要查询的学校";
    _searchBar.tintColor = [UIColor blackColor];
    _searchBar.delegate =self;
    _searchDC = [[UISearchController alloc]initWithSearchResultsController:self];
    [self.navigationItem.titleView sizeToFit];
    [self.navigationController.view addSubview:_searchBar];
    _searchBar.showsCancelButton =YES;
}

- (void)pickup{
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否完善信息赚取200猩币?" delegate:self cancelButtonTitle:@"跳过" otherButtonTitles:@"完善", nil];
    alert.delegate =self;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
        {
            MyTabBarController *myTableVC =[[MyTabBarController alloc]init];
            [self presentViewController:myTableVC animated:YES completion:nil];
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

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    //搜尋結束後，恢復原狀
    return YES;
}
#pragma mark - search bar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    [searchBar resignFirstResponder];
   
    [searchBar removeFromSuperview];
}
/*递归*/
//（深度优先算法）
-(void)allview:(UIView *)rootview indent:(NSInteger)indent
{
    indent++;
    for (UIView *aview in rootview.subviews)
    {
        /**
         在这里还可以遍历得到 UISearchBarTextField，即搜索输入框，
         */
        
        [self allview:aview indent:indent];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_searchBar endEditing:YES];
    [self.view endEditing:YES];
}
//  加载Pist
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
    UILabel *areaLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, 130, 30)];
    
    areaLable.textAlignment = NSTextAlignmentCenter;
    areaLable.text = @"学生就读信息：";
    [bgScrollView addSubview:areaLable];
    
    NSArray *keys = [NSArray arrayWithObjects:@"province",@"city",@"area", nil];
    
    for(NSInteger i=0;i<3;i++)
    {
        LMComBoxView *comBox = [[LMComBoxView alloc]initWithFrame:CGRectMake(127+(60+12)*i, 60, 65, 30)];
        comBox.backgroundColor = UIColorFromRGB(246, 246, 246);
        comBox.arrowImgName =@"narrow.jpg";
        //@"down_dark0.png";
        NSMutableArray *itemsArray = [NSMutableArray arrayWithArray:[addressDict objectForKey:[keys objectAtIndex:i]]];
        comBox.layer.cornerRadius = 5;
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
            
            NSString *provinceIndex = [NSString stringWithFormat: @"%ld", (unsigned long)[provinceArr indexOfObject: selectProvinceStr]];
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
        
            OneStr = [self.schoolTypeArr objectAtIndex:index];
            NSLog(@"OneStr:%@",OneStr);
            break;
        }
        default:
            break;
    }
}

-(void)commBoxInfo{
    
    //学校类型
    self.schoolTypeArr = [[NSArray alloc]initWithObjects:@"幼儿园",@"小学",@"初中",@"培训机构",nil];
    UILabel * schoolTypeLabel=[[UILabel alloc]initWithFrame:CGRectMake(16, 122, 102, 30)];
    schoolTypeLabel.text=@"学校类型：";
    [bgScrollView addSubview:schoolTypeLabel];
    self.schoolTypeCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(127, 122, 165, 30)];
    self.schoolTypeCombox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
    self.schoolTypeCombox.textField.placeholder = @"请选择学校类型";
    self.schoolTypeCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.schoolTypeCombox.textField.tag = 1100;
    self.schoolTypeCombox.dataArray = self.schoolTypeArr;
    [bgScrollView addSubview:self.schoolTypeCombox];
    
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden)];
    [self.schoolTypeView addGestureRecognizer:singleTouch];
    
    [self.schoolTypeCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
 
    /**
     学校名称
     */
       self.schoolNameArr =[[NSArray alloc]init];
    _schoolNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(16, 184, 102, 30)];
    _schoolNameLabel.text=@"学校名称：";
    [bgScrollView addSubview:_schoolNameLabel];
    self.schoolNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(127, 184, 165, 30)];
       self.schoolNameCombox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
    self.schoolNameCombox.textField.placeholder = @"请选择学校";
    self.schoolNameCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.schoolNameCombox.textField.tag = 100;
    self.schoolNameCombox.dataArray = self.schoolNameArr;
    [bgScrollView addSubview:self.schoolNameCombox];

    UITapGestureRecognizer *singleTouc = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidde)];
    [self.schoolTypeView addGestureRecognizer:singleTouc];
    
    /**
     年级信息
     */
    UILabel * gradeNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(16, 246, 102, 30)];
    self.gradeNameArr = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",nil];
    gradeNameLabel.text=@"班级信息：";
    [bgScrollView addSubview:gradeNameLabel];
    self.gradeNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(127, 246, 80, 30)];
      self.gradeNameCombox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
    self.gradeNameCombox.textField.placeholder = @"年级";
    self.gradeNameCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.gradeNameCombox.textField.tag = 1300;
    self.gradeNameCombox.dataArray = self.gradeNameArr;
    [bgScrollView addSubview:self.gradeNameCombox];

    UITapGestureRecognizer *singleTou = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidd)];
    [self.schoolTypeView addGestureRecognizer:singleTou];
    /**
     班级信息
     */
    self.classNameArr = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",nil];
    self.classNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(210, 246, 80, 30)];
      self.classNameCombox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
    self.classNameCombox.textField.placeholder = @"班级";
    self.classNameCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.classNameCombox.textField.tag = 1400;
    self.classNameCombox.dataArray = self.classNameArr;
    [bgScrollView addSubview:self.classNameCombox];

    UITapGestureRecognizer *singleTo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHid)];
    [self.schoolTypeView addGestureRecognizer:singleTo];
    /**
     培训机构科目
     */
    /**
     审核人员
     */
    self.auditPeopleArr = [[NSArray alloc]init];
   
    self.auditNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(16, 308, 102, 30)];
    self.auditNameLabel.text=@"审核人员：";
    [bgScrollView addSubview:self.auditNameLabel];
    
    self.auditNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(127, 308, 165, 30)];
     self.auditNameCombox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
    self.auditNameCombox.textField.placeholder = @"请选择审核人员";
    self.auditNameCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.auditNameCombox.textField.tag = 1500;
    self.auditNameCombox.dataArray = self.auditPeopleArr;
    [bgScrollView addSubview:self.auditNameCombox];
//
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction:) name:@"commboxNotice"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction2:) name:@"commboxNotice2"object:nil];
    
    
    UIButton *btn = [HHControl createButtonWithFrame:CGRectMake(300, 158, 30, 330) backGruondImageName:@"" Target:self Action:@selector(tip:) Title:@"?"];
    [bgScrollView addSubview:btn];
    
    /**
     确定按钮
     */
    UIButton * defineBtn =[HHControl createButtonWithFrame:CGRectMake(25, 410, self.view.frame.size.width-50, 42) backGruondImageName:@"按钮big650x84" Target:self Action:@selector(defineBtnPressed:) Title:@"确定"];
    defineBtn.layer.cornerRadius =2;
    [defineBtn.layer setMasksToBounds:YES];
    
     [bgScrollView addSubview:defineBtn];
}
- (void)tip:(UIButton*)btn{
    
    [SVProgressHUD showSuccessWithStatus:@"如果审核人员中没有您熟悉的老师,您可以选择平台审核,提交我们平台处理."];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    //如果被观察者的对象是_playList
    if ([object isKindOfClass:[UITextField class]]) {
        
        NSLog(@"keyPath:%@",keyPath);
        
        //如果是name属性值发生变化
        if ([keyPath isEqualToString:@"text"]) {
            //取出name的旧值和新值
            NSString * newName=[change objectForKey:@"new"];
            NSLog(@"object:%@,new:%@",object,newName);
            if([newName isEqualToString:@"幼儿园"]){
                //获取数据 上海理想幼儿园
                //创建一个Url
                NSURL *url =[NSURL URLWithString:GET_SCHOOL_Url];
                //创建请求
                NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
                
                request.HTTPMethod =@"POST";
                request.timeoutInterval =10;
                NSString *parm =[NSString stringWithFormat:@"appkey=%@&backtype=%@&school_type=%d&province=%@&city=%@&district=%@",@"U3k8Dgj7e934bh5Y",@"json",1,selectProvinceStr,selectCityStr,selectAreaStr];
                //NSString -->NSData
                request.HTTPBody =[parm dataUsingEncoding:NSUTF8StringEncoding];
                //发送请求duilie
                NSOperationQueue *queue =[NSOperationQueue mainQueue];
                [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                    if (connectionError||data ==nil) {
                        return ;
                    }
                    
                    NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    
                    NSLog(@"dict:%@",dict);
                    NSLog(@"dict:%@",dict[@"msg"]);
                    NSLog(@"dict:%@",dict[@"code"]);
                    NSLog(@"dict[data]:%@",dict[@"data"]);
                    //创建一个空数组
                    NSMutableArray *array =[[NSMutableArray alloc]init];
                    NSMutableArray *kindIDArr =[[NSMutableArray alloc]init];
                    kindDict =[[NSMutableDictionary alloc]init];
                    
                    if ([[NSString stringWithFormat:@"%@",dict[@"code"]]  isEqualToString:@"1"]) {
                        NSArray *arr =dict[@"data"];
                        if ([arr count]!=0) {
                            
                            NSLog(@"arr.count:%ld",arr.count);
                            NSLog(@"[arr[0] objectForKey:name]:%@",[arr[0] objectForKey:@"name"]);
                            NSLog(@"[arr[0] objectForKey:id]:%@",[arr[0] objectForKey:@"id"]);
                            
                            for (int i=0 ; i<arr.count; i++) {
                                NSLog(@"%@",[arr[i] objectForKey:@"name"]);
                                NSLog(@"%@",[arr[i] objectForKey:@"id"]);
                                [array addObject:[arr[i] objectForKey:@"name"]];
                                [kindIDArr addObject:[arr[i] objectForKey:@"id"]];
                                [kindDict setObject:kindIDArr[i] forKey:array[i]];
                            }
                            
                        //选择幼儿园
                            self.schoolNameArr =array;
                            for (id obj in self.schoolNameArr) {
                                NSLog(@"%@",obj);
                            }
                            self.schoolNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(127, 184, 165, 30)];
                            self.schoolNameCombox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
                            self.schoolNameCombox.textField.placeholder = @"请选择学校";
                            self.schoolNameCombox.textField.textAlignment = NSTextAlignmentLeft;
                            self.schoolNameCombox.textField.tag = 1200;
                            self.schoolNameCombox.dataArray = self.schoolNameArr;
                            [bgScrollView addSubview:self.schoolNameCombox];
                          
                        }
                  

                    }
                    
                }];
                
            }
            else if ([newName isEqualToString:@"小学"]){
                //获取数据 上海露露小学  上海康达小学
                //创建一个Url
                NSURL *url =[NSURL URLWithString:GET_SCHOOL_Url];
                //创建请求
                NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
                
                request.HTTPMethod =@"POST";
                request.timeoutInterval =10;
                NSString *parm =[NSString stringWithFormat:@"appkey=%@&backtype=%@&school_type=%d&province=%@&city=%@&district=%@",@"U3k8Dgj7e934bh5Y",@"json",2,selectProvinceStr,selectCityStr,selectAreaStr];
                //NSString -->NSData
                request.HTTPBody =[parm dataUsingEncoding:NSUTF8StringEncoding];
                //发送请求duilie
                NSOperationQueue *queue =[NSOperationQueue mainQueue];
                [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                    if (connectionError||data ==nil) {
                        return ;
                    }
                    
                    NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    
                    NSLog(@"dict:%@",dict);
                    NSLog(@"dict:%@",dict[@"msg"]);
                    NSLog(@"dict:%@",dict[@"code"]);
                    NSLog(@"dict[data]:%@",dict[@"data"]);
                    //创建一个空数组
                    NSMutableArray *array =[[NSMutableArray alloc]init];
                    NSMutableArray *kindIDArr =[[NSMutableArray alloc]init];
                   kindDict =[[NSMutableDictionary alloc]init];
                    if ([[NSString stringWithFormat:@"%@",dict[@"code"]]  isEqualToString:@"1"]) {
                        NSArray *arr =dict[@"data"];
                        if ([arr count]!=0) {
                            
                            NSLog(@"arr.count:%ld",arr.count);
                            NSLog(@"[arr[0] objectForKey:name]:%@",[arr[0] objectForKey:@"name"]);
                            
                            for (int i=0 ; i<arr.count; i++) {
                                NSLog(@"%@",[arr[i] objectForKey:@"name"]);
                                NSLog(@"%@",[arr[i] objectForKey:@"id"]);
                                [array addObject:[arr[i] objectForKey:@"name"]];
                                [kindIDArr addObject:[arr[i] objectForKey:@"id"]];
                                [kindDict setObject:kindIDArr[i] forKey:array[i]];
                                
                            }
                            //小学
                            self.schoolNameArr =array;
                            for (id obj in self.schoolNameArr) {
                                NSLog(@"%@",obj);
                            }
                            self.schoolNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(127, 184, 165, 30)];
                            self.schoolNameCombox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
                            self.schoolNameCombox.textField.placeholder = @"请选择学校";
                            self.schoolNameCombox.textField.textAlignment = NSTextAlignmentLeft;
                            self.schoolNameCombox.textField.tag = 2000;
                            self.schoolNameCombox.dataArray = self.schoolNameArr;
                            [bgScrollView addSubview:self.schoolNameCombox];                        }
                        
                    }
                }];
                
            
            }
            else if ([newName isEqualToString:@"初中"]){
                
                //获取数据
                //创建一个Url
                NSURL *url =[NSURL URLWithString:GET_SCHOOL_Url];
                //创建请求
                NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
                
                request.HTTPMethod =@"POST";
                request.timeoutInterval =10;
                NSString *parm =[NSString stringWithFormat:@"appkey=%@&backtype=%@&school_type=%d&province=%@&city=%@&district=%@",@"U3k8Dgj7e934bh5Y",@"json",3,selectProvinceStr,selectCityStr,selectAreaStr];
                //NSString -->NSData
                request.HTTPBody =[parm dataUsingEncoding:NSUTF8StringEncoding];
                //发送请求duilie
                NSOperationQueue *queue =[NSOperationQueue mainQueue];
                [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                    if (connectionError||data ==nil) {
                        return ;
                    }
                    
                    NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    
                    NSLog(@"dict:%@",dict);
                    NSLog(@"dict:%@",dict[@"msg"]);
                    NSLog(@"dict:%@",dict[@"code"]);
                    NSLog(@"dict[data]:%@",dict[@"data"]);
                    //创建一个空数组
                    NSMutableArray *array =[[NSMutableArray alloc]init];
                    NSMutableArray *kindIDArr =[[NSMutableArray alloc]init];
                   kindDict =[[NSMutableDictionary alloc]init];
                    if ([[NSString stringWithFormat:@"%@",dict[@"code"]]  isEqualToString:@"1"]) {
                        NSArray *arr =dict[@"data"];
                        if ([arr count]!=0) {
                            
                            NSLog(@"arr.count:%ld",arr.count);
                            NSLog(@"[arr[0] objectForKey:name]:%@",[arr[0] objectForKey:@"name"]);
                            
                            for (int i=0 ; i<arr.count; i++) {
                                NSLog(@"%@",[arr[i] objectForKey:@"name"]);
                            
                                [array addObject:[arr[i] objectForKey:@"name"]];
                                [kindIDArr addObject:[arr[i] objectForKey:@"id"]];
                                [kindDict setObject:kindIDArr[i] forKey:array[i]];
                                
                                
                            }
                            self.schoolNameArr =array;
                            self.schoolNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(127, 184, 165, 30)];
                            self.schoolNameCombox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
                            self.schoolNameCombox.textField.placeholder = @"请选择学校";
                            self.schoolNameCombox.textField.textAlignment = NSTextAlignmentLeft;
                            self.schoolNameCombox.textField.tag = 3000;
                            self.schoolNameCombox.dataArray = self.schoolNameArr;
                            [bgScrollView addSubview:self.schoolNameCombox];
                    
                        }
                        
                    }
                }];
                
            
            }
            else  if([newName isEqualToString:@"培训机构"]){
                //获取数据
                //创建一个Url
                NSURL *url =[NSURL URLWithString:GET_SCHOOL_Url];
                //创建请求
                NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
                
                request.HTTPMethod =@"POST";
                request.timeoutInterval =10;
                NSString *parm =[NSString stringWithFormat:@"appkey=%@&backtype=%@&school_type=%d&province=%@&city=%@&district=%@",@"U3k8Dgj7e934bh5Y",@"json",4,selectProvinceStr,selectCityStr,selectAreaStr];
                //NSString -->NSData
                request.HTTPBody =[parm dataUsingEncoding:NSUTF8StringEncoding];
                //发送请求duilie
                NSOperationQueue *queue =[NSOperationQueue mainQueue];
                [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                    if (connectionError||data ==nil) {
                        return ;
                    }
                    
                    NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    
                    NSLog(@"dict:%@",dict);
                    NSLog(@"dict:%@",dict[@"msg"]);
                    NSLog(@"dict:%@",dict[@"code"]);
                    NSLog(@"dict[data]:%@",dict[@"data"]);
                    //创建一个空数组
                    NSMutableArray *array =[[NSMutableArray alloc]init];
                    NSMutableArray *kindIDArr =[[NSMutableArray alloc]init];
                  kindDict =[[NSMutableDictionary alloc]init];
                    if ([[NSString stringWithFormat:@"%@",dict[@"code"]]  isEqualToString:@"1"]) {
                        NSArray *arr =dict[@"data"];
                        if ([arr count]!=0) {
                            
                            NSLog(@"arr.count:%ld",(unsigned long)arr.count);
                            NSLog(@"[arr[0] objectForKey:name]:%@",[arr[0] objectForKey:@"name"]);
                            
                            for (int i=0 ; i<arr.count; i++) {
                                NSLog(@"%@",[arr[i] objectForKey:@"name"]);
                                [array addObject:[arr[i] objectForKey:@"name"]];
                                [kindIDArr addObject:[arr[i] objectForKey:@"id"]];
                                 [kindDict setObject:kindIDArr[i] forKey:array[i]];
                            }
                            self.schoolNameArr =array;
                            self.schoolNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(127, 184, 165, 30)];
                            self.schoolNameCombox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
                            self.schoolNameCombox.textField.placeholder = @"请选择学校";
                            self.schoolNameCombox.textField.textAlignment = NSTextAlignmentLeft;
                            self.schoolNameCombox.textField.tag = 4000;
                            self.schoolNameCombox.dataArray = self.schoolNameArr;
                            [bgScrollView addSubview:self.schoolNameCombox];
                            
                        }
                        
                    }
                }];
                
           }
        }
       
    }
   
}

- (void)commboxAction:(NSNotification *)notif{

    switch ([notif.object integerValue]) {
        case 1100:
            [self.self.schoolTypeCombox removeFromSuperview];
            [bgScrollView addSubview:self.schoolTypeView];
            [bgScrollView addSubview:self.schoolTypeCombox];
            break;
        case 1200:
            [self.self.schoolNameCombox removeFromSuperview];
           [bgScrollView addSubview:self.schoolNameView];
            self.schoolNameCombox.dataArray =self.schoolNameArr;
            [bgScrollView addSubview:self.schoolNameCombox];
          
            break;
        case 1300:
            [self.self.gradeNameCombox removeFromSuperview];
          [bgScrollView addSubview:self.gradeNameView];
            [bgScrollView addSubview:self.gradeNameCombox];
           
            break;
        case 1400:
            [self.self.classNameCombox removeFromSuperview];
         [bgScrollView addSubview:self.classNameView];
            [bgScrollView addSubview:self.classNameCombox];
           
            break;
        case 1500:
        {
            [self.self.auditNameCombox removeFromSuperview];
         
            //创建一个Url
            NSURL *url =[NSURL URLWithString:Audit_TEACHER_URL];
            //创建请求
            NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
            
            request.HTTPMethod =@"POST";
            request.timeoutInterval =10;
            NSString *parm =[NSString stringWithFormat:@"appkey=%@&backtype=%@&school_id=%@&grade=%@&class=%@",@"U3k8Dgj7e934bh5Y",@"json",ID, gradeStr, classStr];
            //NSString -->NSData
            request.HTTPBody =[parm dataUsingEncoding:NSUTF8StringEncoding];
            //发送请求duilie
            NSOperationQueue *queue =[NSOperationQueue mainQueue];
            [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                if (connectionError||data ==nil) {
                    return ;
                }
                
                NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"dict:%@",dict);
                NSLog(@"dict:%@",dict[@"msg"]);
                NSLog(@"dict:%@",dict[@"code"]);
                NSLog(@"dict[data]:%@",dict[@"data"]);
                //创建一个空数组
                NSMutableArray *array =[[NSMutableArray alloc]init];
                NSMutableArray *kindIDArr =[[NSMutableArray alloc]init];
                auditDict =[[NSMutableDictionary alloc]init];
                
                if ([[NSString stringWithFormat:@"%@",dict[@"code"]]  isEqualToString:@"1"]) {
                    NSArray *arr =dict[@"data"];
                    if ([arr count]!=0) {
                        
                        NSLog(@"arr.count:%ld",(unsigned long)arr.count);
                        NSLog(@"[arr[0] objectForKey:name]:%@",[arr[0] objectForKey:@"name"]);
                        NSLog(@"[arr[0] objectForKey:id]:%@",[arr[0] objectForKey:@"id"]);
                        
                        for (int i=0 ; i<arr.count; i++) {
                            NSLog(@"%@",[arr[i] objectForKey:@"name"]);
                            NSLog(@"%@",[arr[i] objectForKey:@"id"]);
                            [array addObject:[arr[i] objectForKey:@"name"]];
                            [kindIDArr addObject:[arr[i] objectForKey:@"id"]];
                            [auditDict setObject:kindIDArr[i] forKey:array[i]];
                        }

                    }

                }
                
            }];
         
            for (id obj in self.auditPeopleArr) {
                NSLog(@"%@",obj);
            }
            self.auditNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(127, 308, 165, 30)];
            self.auditNameCombox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
            self.auditNameCombox.textField.placeholder = @"请选择审核人员";
            self.auditNameCombox.textField.textAlignment = NSTextAlignmentLeft;
            self.auditNameCombox.textField.tag = 5000;
            self.auditNameCombox.dataArray = @[@"高老师",@"顾老师",@"梁老师"];
            [bgScrollView addSubview:self.auditNameCombox];

            break;
        }
        default:
            break;
    }
    
}
- (void)commboxAction2:(NSNotification*)nofi{

    NSLog(@"%ld",[nofi.object integerValue]);
    
    switch ([nofi.object integerValue]) {
        case 1100:
              [self.schoolTypeView removeFromSuperview];
           textFiel =(UITextField*)[self.view viewWithTag:1100];//学校类型
            NSLog(@"学校类型textFiel.text%@",textFiel.text);
            if ([textFiel.text isEqualToString:@"幼儿园"]) {
                int i=1;
                NSLog(@"i%d",i);
            }
            else if ([textFiel.text isEqualToString:@"小学"]){
              int i=2;
                  NSLog(@"i%d",i);
            }
            else if ([textFiel.text isEqualToString:@"初中"]){
                int i=3;
                  NSLog(@"i%d",i);
            }
            else if ([textFiel.text isEqualToString:@"培训机构"]){
                int i=4;
                  NSLog(@"i%d",i);
            }
            break;
        case 1200:
        {
            [self.schoolNameView removeFromSuperview];
            textFiel =(UITextField*)[self.view viewWithTag:1200];//学校名称
            NSLog(@"textFiel.text:%@",textFiel.text);
            ID =[kindDict objectForKey:[NSString stringWithFormat:@"%@",textFiel.text]];
            NSLog(@"ID%@",ID);
            break;
        }
        case 1300:
        {
            [self.gradeNameView removeFromSuperview];
            textFiel =(UITextField*)[self.view viewWithTag:1300];//年级信息
            NSLog(@"年级textFiel.text%@",textFiel.text);
            gradeStr =textFiel.text;
            break;
        }
        case 1400:
        {
             [self.classNameView removeFromSuperview];
            textFiel =(UITextField*)[self.view viewWithTag:1400];//班级信息
            NSLog(@"班级textFiel.text%@",textFiel.text);
            classStr =textFiel.text;
            break;
        }
        case 1500:
        {
             [self.auditPeopleView removeFromSuperview];
            textFiel =(UITextField*)[self.view viewWithTag:1500];//审核人员
            NSLog(@"审核textFiel.text%@",textFiel.text);
            //网络请求
            
    
            break;
        }
        case 2000:
            [self.auditPeopleView removeFromSuperview];
            textFiel =(UITextField*)[self.view viewWithTag:2000];//人员
            NSLog(@"textFiel.text%@",textFiel.text);
            ID =[kindDict objectForKey:[NSString stringWithFormat:@"%@",textFiel.text]];
            NSLog(@"ID%@",ID);
            break;
        case 3000:
            [self.auditPeopleView removeFromSuperview];
            textFiel =(UITextField*)[self.view viewWithTag:3000];//人员
            NSLog(@"textFiel.text%@",textFiel.text);
            ID =[kindDict objectForKey:[NSString stringWithFormat:@"%@",textFiel.text]];
            NSLog(@"ID%@",ID);
            break;
        case 4000:
            [self.auditPeopleView removeFromSuperview];
            textFiel =(UITextField*)[self.view viewWithTag:4000];//人员
            NSLog(@"textFiel.text%@",textFiel.text);
            ID =[kindDict objectForKey:[NSString stringWithFormat:@"%@",textFiel.text]];
            NSLog(@"ID%@",ID);
            break;
        case 5000:
            [self.auditPeopleView removeFromSuperview];
            textFiel =(UITextField*)[self.view viewWithTag:5000];//人员
            NSLog(@"textFiel.text%@",textFiel.text);
            ID =[auditDict objectForKey:[NSString stringWithFormat:@"%@",textFiel.text]];
            NSLog(@"ID%@",ID);
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

}
- (void)commboxHidde{
    //
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
- (void)commboxHidd{
    [self.gradeNameView removeFromSuperview];
    [self.gradeNameCombox setShowList:NO];
    self.gradeNameCombox.listTableView.hidden = YES;
    CGRect sf2 = self.gradeNameCombox.frame;
    sf2.size.height = 30;
    self.gradeNameCombox.frame = sf2;
    CGRect frame2 = self.gradeNameCombox.listTableView.frame;
    frame2.size.height = 0;
    self.gradeNameCombox.listTableView.frame = frame2;
    [self.gradeNameCombox removeFromSuperview];
    [bgScrollView addSubview:self.gradeNameCombox];

}
- (void)commboxHid{
    //
    [self.classNameView removeFromSuperview];
    [self.classNameCombox setShowList:NO];
    self.classNameCombox.listTableView.hidden = YES;
    CGRect sf2 = self.classNameCombox.frame;
    sf2.size.height = 30;
    self.classNameCombox.frame = sf2;
    CGRect frame2 = self.classNameCombox.listTableView.frame;
    frame2.size.height = 0;
    self.classNameCombox.listTableView.frame = frame2;
    [self.classNameCombox removeFromSuperview];
    [bgScrollView addSubview:self.classNameCombox];

}
- (void)commboxHi{
    //
    [self.auditPeopleView removeFromSuperview];
    [self.auditNameCombox setShowList:NO];
    self.auditNameCombox.listTableView.hidden = YES;
    CGRect sf2 = self.auditNameCombox.frame;
    sf2.size.height = 30;
    self.auditNameCombox.frame = sf2;
    CGRect frame2 = self.auditNameCombox.listTableView.frame;
    frame2.size.height = 0;
    self.auditNameCombox.listTableView.frame = frame2;
    [self.auditNameCombox removeFromSuperview];
    [bgScrollView addSubview:self.auditNameCombox];

}
-(void)defineBtnPressed:(id)sender{

    MyTabBarController *myTableVC =[[MyTabBarController alloc]init];
    [self presentViewController:myTableVC animated:YES completion:nil];}

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

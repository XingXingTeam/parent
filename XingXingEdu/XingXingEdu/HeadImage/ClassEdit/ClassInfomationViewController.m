//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  ClassInfomationViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/3/23.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define  kDropDownListTag 1000
#import "ClassInfomationViewController.h"
#import "LMContainsLMComboxScrollView.h"
#import "HomepageViewController.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"
#import "WJCommboxView.h"
#import "LMComBoxView.h"
#import "AppDelegate.h"
#import "UtilityFunc.h"
#import "HHControl.h"
@interface ClassInfomationViewController ()<LMComBoxViewDelegate,UISearchBarDelegate,UIAlertViewDelegate>
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
    UIView *bgView;
    UIAlertView *_alert;
    MBProgressHUD *HUD;
  
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

@implementation ClassInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =self.titleStr;
    self.view.backgroundColor = UIColorFromRGB(116,205, 169);
    
    [self reloadD];
    bgScrollView = [[LMContainsLMComboxScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    bgScrollView.backgroundColor = UIColorFromRGB(255, 255, 255);
    bgScrollView.showsHorizontalScrollIndicator =NO;
    bgScrollView.showsVerticalScrollIndicator =NO;
    [self.view addSubview:bgScrollView];
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    bgView.backgroundColor =UIColorFromRGB(222, 225, 226);
    [bgScrollView addSubview:bgView];
    [self setBgScrollView];
    [self commBoxInfo];
    bgView.userInteractionEnabled = YES;
    [bgView addSubview:_searchBar];
    [self createRightBar];
    
}
- (void)createRightBar{
    UIButton *deleteBtn =[HHControl createButtonWithFrame:CGRectMake(251, 0, 17, 21) backGruondImageName:@"删除icon34x42" Target:self Action:@selector(rightBar) Title:nil];
    UIBarButtonItem *rightBar =[[UIBarButtonItem alloc]initWithCustomView:deleteBtn];
    self.navigationItem.rightBarButtonItem =rightBar;

}
- (void)rightBar{
    NSLog(@"删除");
    _alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要删除该课程吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [_alert show];


}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    switch (buttonIndex) {
        case 0:
            NSLog(@"取消");
            break;
        case 1:
            [self.navigationController popViewControllerAnimated:YES];
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
    
    // [searchBar setShowsCancelButton:YES animated:YES];
    _searchBar.showsCancelButton = YES;
    [self  allview:searchBar indent:0];
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}
/*递归*/
//（深度优先算法）
-(void)allview:(UIView *)rootview indent:(NSInteger)indent
{
    //    NSLog(@"[%2d] %@",indent, rootview);
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
    UILabel *areaLable = [[UILabel alloc]initWithFrame:CGRectMake(30,70, 92, 30)];
    areaLable.textAlignment = NSTextAlignmentLeft;
    areaLable.text = @"区     域";
    [bgScrollView addSubview:areaLable];
    UIImageView *starImgV =[[UIImageView alloc]initWithFrame:CGRectMake(5,73, 20, 20)];
    starImgV.image =[UIImage imageNamed:@"必填符号38x38"];
    [bgScrollView addSubview:starImgV];
    NSArray *keys = [NSArray arrayWithObjects:@"province",@"city",@"area", nil];
    for(NSInteger i=0;i<3;i++)
    {
        LMComBoxView *comBox = [[LMComBoxView alloc]initWithFrame:CGRectMake(127+(60+12)*i, 70, 65, 30)];
        comBox.backgroundColor = UIColorFromRGB(246, 246, 246);
        comBox.arrowImgName = @"narrow.jpg";
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
        default:
            break;
    }
}
-(void)commBoxInfo{
    
    //学校类型
    self.schoolTypeArr = [[NSArray alloc]initWithObjects:@"幼儿园",@"小学",@"初中",@"培训机构",nil];
    UILabel * schoolTypeLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 132, 92, 30)];
    schoolTypeLabel.text=@"学校类型";
    [bgScrollView addSubview:schoolTypeLabel];
    UIImageView *starImV =[[UIImageView alloc]initWithFrame:CGRectMake(5,135, 20, 20)];
    starImV.image =[UIImage imageNamed:@"必填符号38x38"];
    [bgScrollView addSubview:starImV];
    self.schoolTypeCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(127, 132, 165, 30)];
    self.schoolTypeCombox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
    
    self.schoolTypeCombox.textField.text= @"培训机构";
    
    self.schoolTypeCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.schoolTypeCombox.textField.tag = 101;
    self.schoolTypeCombox.dataArray = self.schoolTypeArr;
    [bgScrollView addSubview:self.schoolTypeCombox];
    
    self.schoolTypeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight+300)];
    self.schoolTypeView.backgroundColor = [UIColor clearColor];
    self.schoolTypeView.alpha = 0.5;
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden)];
    [self.schoolTypeView addGestureRecognizer:singleTouch];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction:) name:@"commboxNotice"object:nil];
    
    [self.schoolTypeCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    /**
     学校名称
     */
    self.schoolNameArr = [[NSArray alloc]initWithObjects:@"华高小学",@"希望中学",@"北京大学",@"清华大学",nil];
    _schoolNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 194, 92, 30)];
    _schoolNameLabel.text=@"学校名称";
    [bgScrollView addSubview:_schoolNameLabel];
    UIImageView *starIgV =[[UIImageView alloc]initWithFrame:CGRectMake(5,197, 20, 20)];
    starIgV.image =[UIImage imageNamed:@"必填符号38x38"];
    [bgScrollView addSubview:starIgV];
    self.schoolNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(127, 194, 165, 30)];
    self.schoolNameCombox.textField.text = self.dataStr;
    self.schoolNameCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.schoolNameCombox.textField.tag = 102;
    self.schoolNameCombox.dataArray = self.schoolNameArr;
    [bgScrollView addSubview:self.schoolNameCombox];
    self.schoolNameView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight+300)];
    self.schoolNameView.backgroundColor = UIColorFromRGB(246, 246, 246);
    self.schoolNameView.alpha = 0.5;
    
    /**
     年级信息
     */
    UILabel * gradeNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 256, 92, 30)];
    self.gradeNameArr = [[NSArray alloc]initWithObjects:@"小班",@"中班",@"大班",@"一年级",@"二年级",@"三年级",@"四年级",@"五年级",@"六年级",nil];
    gradeNameLabel.text=@"班级信息";
    [bgScrollView addSubview:gradeNameLabel];
    self.gradeNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(127, 256, 80, 30)];
    self.gradeNameCombox.textField.text = self.titleStr;
    self.gradeNameCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.gradeNameCombox.textField.tag = 103;
    self.gradeNameCombox.dataArray = self.gradeNameArr;
    [bgScrollView addSubview:self.gradeNameCombox];
    self.gradeNameView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight+300)];
    self.gradeNameView.backgroundColor = UIColorFromRGB(246, 246, 246);
    self.gradeNameView.alpha = 0.5;
    
    /**
     班级信息
     */
    self.classNameArr = [[NSArray alloc]initWithObjects:@"1班",@"2班",@"3班",@"4班",@"5班",@"6班",nil];
    self.classNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(210, 256, 80, 30)];
    self.classNameCombox.textField.text = @"2班";
    self.classNameCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.classNameCombox.textField.tag = 104;
    self.classNameCombox.dataArray = self.classNameArr;
    [bgScrollView addSubview:self.classNameCombox];
    self.classNameView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight+300)];
    self.classNameView.backgroundColor = UIColorFromRGB(246, 246, 246);
    self.classNameView.alpha = 0.5;
    self.auditPeopleArr = [[NSArray alloc]initWithObjects:@"张老师",@"王老师",@"李老师",@"平台审核",nil];
    self.auditNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 318, 92, 30)];
    self.auditNameLabel.text=@"审核人员";
    [bgScrollView addSubview:self.auditNameLabel];
    
    self.auditNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(127, 318, 165, 30)];
    self.auditNameCombox.textField.placeholder = @"请选择审核人员";
    self.auditNameCombox.textField.text =self.auditStr;
    self.auditNameCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.auditNameCombox.textField.tag = 106;
    self.auditNameCombox.textField.userInteractionEnabled =NO;
    self.auditNameCombox.dataArray = self.auditPeopleArr;
    [bgScrollView addSubview:self.auditNameCombox];
    
    self.auditPeopleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight+300)];
    self.auditPeopleView.backgroundColor = UIColorFromRGB(246, 246, 246);
    self.auditPeopleView.alpha = 0.5;
    
    
    UIButton *btn = [HHControl createButtonWithFrame:CGRectMake(300, 168, 30, 330) backGruondImageName:@"" Target:self Action:@selector(tip:) Title:@"?"];
    [bgScrollView addSubview:btn];
    
    /**
     确定按钮
     */
    UIButton * defineBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 420, self.view.frame.size.width-20, 36)];
    [defineBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [defineBtn setTitleColor:UIColorFromRGB(255, 255, 255) forState:UIControlStateNormal];
    defineBtn.backgroundColor = UIColorFromRGB(0, 169, 66);
    defineBtn.layer.cornerRadius =18;
    defineBtn.layer.masksToBounds =YES;
    [defineBtn addTarget:self action:@selector(defineBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bgScrollView addSubview:defineBtn];
    
}
- (void)tip:(UIButton*)btn{
    NSLog(@"??????");
    [SVProgressHUD showInfoWithStatus:@"如果审核人员中没有您熟悉的老师,您可以选择平台审核,提交我们平台处理."];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    //如果被观察者的对象是_playList
    if ([object isKindOfClass:[UITextField class]]) {
        //如果是name属性值发生变化
        if ([keyPath isEqualToString:@"text"]) {
            //取出name的旧值和新值
            
            NSString * newName=[change objectForKey:@"new"];
            NSLog(@"object:%@,new:%@",object,newName);
            if([newName isEqualToString:@"幼儿园"]||[newName isEqualToString:@"小学"]||[newName isEqualToString:@"初中"]){
                _trainNameLabel.hidden=YES;
                _schoolNameLabel.hidden=NO;
                self.classNameCombox.hidden=NO;
                self.gradeNameCombox.hidden=NO;
                self.trainSubjectCombox.hidden=YES;
                self.auditNameCombox.hidden=NO;
                self.auditNameLabel.hidden=NO;
                trainAgencyLbl.hidden=YES;
                
            }
            else  if([newName isEqualToString:@"培训机构"]){
                // self.schoolNameCombox.hidden = YES;
                _schoolNameLabel.hidden=YES;
                _trainLabel.hidden =YES;
                self.auditNameCombox.hidden=NO;
                self.auditNameLabel.hidden=NO;
                self.trainSubjectCombox.hidden=NO;
                /**
                 培训机构科目
                 */
                trainAgencyLbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 194, 92, 30)];
                trainAgencyLbl.text=@"培训机构";
                [bgScrollView addSubview:trainAgencyLbl];
                
                
                self.gradeNameCombox.hidden=YES;
                self.classNameCombox.hidden=NO;
                self.classNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(127, 256, 80, 30)];
                self.classNameArr = [[NSArray alloc]initWithObjects:@"美术班",@"舞蹈班",@"武术班",@"绘画班",@"写作班",@"乐器班",nil];
                self.classNameCombox.dataArray = self.classNameArr;
                self.classNameCombox.textField.placeholder = @"辅导班";
                [bgScrollView addSubview:self.classNameCombox];
                
                self.auditNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(127, 318, 165, 30)];
                self.auditPeopleArr = [[NSArray alloc]initWithObjects:@"张老师",@"王老师",@"李老师",@"平台审核",nil];
                self.auditNameCombox.dataArray = self.auditPeopleArr;
                self.auditNameCombox.textField.placeholder = @"请选择审核人员";
                self.auditNameCombox.textField.textAlignment = NSTextAlignmentLeft;
                
                [bgScrollView addSubview:self.auditNameCombox];
            }
        }
        
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
    
    HUD =[[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.mode =MBProgressHUDModeText;
    HUD.dimBackground =YES;
    _alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"你的信息已经提交成功,我们会在第一时间进行审核,谢谢您的支持!" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [_alert show];
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(3);
    } completionBlock:^{
        [HUD removeFromSuperview];
        HUD =nil;
        [_alert dismissWithClickedButtonIndex:0 animated:NO];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
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
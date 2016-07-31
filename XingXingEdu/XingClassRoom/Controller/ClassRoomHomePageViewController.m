//
//  ClassRoomHomePageViewController.m
//  XingXingStore
//
//  Created by codeDing on 16/1/27.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "ClassRoomHomePageViewController.h"
#import "ClassTeacherTableViewCell.h"
#import "ClassSubjectTableViewCell.h"
#import "ClassSchoolTableViewCell.h"
#import "ClassRoomSearchViewController.h"
//#import "TeleViewController.h"
#import "ClassRoomSubjectInfoViewController.h"
#import "ShoolInfoViewController.h"
#import "TeleTeachInfoViewController.h"
#import "SchoolTeachInfoViewController.h"
#import "LogoTabBarController.h"
#import "XingXingTool.h"
#import "DXLocationManager.h"
#import "WJDropdownMenu.h"

@interface ClassRoomHomePageViewController ()<UITableViewDelegate,UITableViewDataSource,WJMenuDelegate>{
    UISegmentedControl *segMent;
    NSInteger  segMentIndex;
    UITableView * myTableView;
    //老师
    NSMutableArray  * teacherArray;
    //课程
    NSMutableArray * subjectArray;
    //机构
    NSMutableArray * schoolArray;
    
    NSString *indexStr;
    BOOL isCollect;
    int teacherFootRefresh;
    int subjectFootRefresh;
    int schoolFootRefresh;
    //一级类目数组
    NSMutableArray *_oneFirstArr;
    NSMutableArray *_oneFirstKeyArr;
    //二级类目数组
    NSMutableArray *_twoSecondArr;
    //三级类目数组
    NSMutableArray *_threeThirdArr;
    //点击三级类目请求传参
    NSString *_class_str;
    
}
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,weak)WJDropdownMenu *menu;


@property (nonatomic, copy) NSString *schoolIdStr;

@end

@implementation ClassRoomHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"猩课堂";
    self.tabBarController.tabBar.hidden = NO;
    
    _schoolIdArray = [[NSMutableArray alloc] init];
    _oneFirstArr = [NSMutableArray array];
    _twoSecondArr = [NSMutableArray array];
    _threeThirdArr = [NSMutableArray array];
    _oneFirstKeyArr = [NSMutableArray array];
    
    [self getCategoryData];
    
    [self getTeacherInfo:@"1" class_str:@"" appoint_order:0 filter_distance:@""];
    
    [self creatFieldset];
    
    myTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MJloadMoreData)];
    

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0, 170, 42);
}


-(void)MJloadMoreData{
    segMentIndex=segMent.selectedSegmentIndex;
    if(segMentIndex==0){
        teacherFootRefresh ++;
        [self getTeacherInfo:[NSString stringWithFormat:@"%i",teacherFootRefresh] class_str:@"" appoint_order:0 filter_distance:@""];
    }
    else if(segMentIndex==1){
        subjectFootRefresh++;
        [self getSubjectInfo:[NSString stringWithFormat:@"%i",subjectFootRefresh] class_str:@"" appoint_order:0 filter_distance:@""];
    }
    else if(segMentIndex==2){
        schoolFootRefresh++;
        [self getSchoolInfo:[NSString stringWithFormat:@"%i",schoolFootRefresh] class_str:@"" appoint_order:0 filter_distance:@""];
    }
    [myTableView.footer endRefreshing];
}


-(void)creatFieldset
{
    segMentIndex=0;
    teacherFootRefresh=1;
    subjectFootRefresh=1;
    schoolFootRefresh=1;
    
    schoolArray = [NSMutableArray array];
    subjectArray = [NSMutableArray array];
    teacherArray = [NSMutableArray array];
    
    //分段控件
    segMent=[[UISegmentedControl alloc] initWithFrame:CGRectMake(70.0f, 5.0f, 180.0f, 34.0f) ];
    [segMent insertSegmentWithTitle:@"老师" atIndex:0 animated:YES];
    [segMent insertSegmentWithTitle:@"课程" atIndex:1 animated:YES];
    [segMent insertSegmentWithTitle:@"机构" atIndex:2 animated:YES];
    segMent.momentary = NO;  //设置在点击后是否恢复原样
    segMent.multipleTouchEnabled=NO;  //可触摸
    segMent.selectedSegmentIndex =0;   //指定索引
    segMent.tintColor =[UIColor whiteColor];
    [segMent addTarget:self action:@selector(segMentClick:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segMent;
    
    //tableView
    myTableView = [[UITableView alloc] init];
    myTableView.frame = CGRectMake(0, 40, WinWidth, WinHeight);
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置分割线距边界的距离
    myTableView.separatorInset = UIEdgeInsetsMake(10, 5, 10, 5);
    myTableView.separatorColor = [UIColor grayColor];
    myTableView.delegate=self;
    myTableView.dataSource=self;
    [self.view addSubview:myTableView];
    UINib *nib = [UINib nibWithNibName:@"ClassTeacherTableViewCell" bundle:nil];
    [myTableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
//    //下拉选择框
    WJDropdownMenu *menu = [[WJDropdownMenu alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 40)];
    menu.delegate = self;         //  设置代理
    [self.view addSubview:menu];
    
    self.menu = menu;
    menu.menuTitleFont = 14;                   //  设置menuTitle字体大小    不设置默认是  11
    menu.tableTitleFont = 12;                  //  设置tableTitle字体大小   不设置默认是  10
    menu.cellHeight = 38;                      //  设置tableViewcell高度   不设置默认是  40
    menu.menuArrowStyle = menuArrowStyleSolid; //  旋转箭头的样式(空心箭头 or 实心箭头)
    menu.tableViewMaxHeight = 200;             //  tableView的最大高度(超过此高度就可以滑动显示)
    
    menu.CarverViewColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];//设置遮罩层颜色
    menu.selectedColor = UIColorFromRGB(0, 172, 54);  //  选中的字体颜色
    menu.unSelectedColor = [UIColor grayColor];//  未选中的字体颜色
    
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(-10,0,22,22)];
    [rightButton setImage:[UIImage imageNamed:@"搜索icon44x44"]  forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(searchprogram) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
}
////获取类目网络请求
-(void)getCategoryData{
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/xkt_category";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           };
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
//       NSLog(@"—————————————————————————————课程详情———%@",dict);
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             
             //firstArrOne
             NSMutableDictionary *oneArrClass = dict[@"data"][@"class1_group"];
             for (NSDictionary *dic in oneArrClass) {
                 NSString *name = [NSString stringWithFormat:@"%@",dic[@"name"]];
//                 NSString *keyNum = [NSString stringWithFormat:@"%@",dic[@"class1"]];
                 [_oneFirstArr addObject:name];
//                 [_oneFirstKeyArr addObject:keyNum];
             }
             //secondArrOne
             NSMutableDictionary *twoClass = dict[@"data"][@"class2_group"];
             NSMutableArray *twoClass1 = [NSMutableArray array];
             NSMutableArray *twoClass2 = [NSMutableArray array];
             NSMutableArray *twoClass3 = [NSMutableArray array];
             NSMutableArray *twoClass4 = [NSMutableArray array];
             NSMutableArray *twoClass5 = [NSMutableArray array];
             NSMutableArray *twoClass6 = [NSMutableArray array];
             twoClass1 = twoClass[@"1"];
             twoClass2 = twoClass[@"45"];
             twoClass3 = twoClass[@"83"];
             twoClass4 = twoClass[@"95"];
             twoClass5 = twoClass[@"52"];
             twoClass6 = twoClass[@"130"];
             
             NSMutableArray *twoClassArr1 = [NSMutableArray array];
             for (int i = 0 ; i < twoClass1.count ;i ++) {
                 [twoClassArr1 addObject:[twoClass1[i] objectForKey:@"name"]];
             }
            
             NSMutableArray *twoClassArr2 = [NSMutableArray array];
             for (int i = 0 ; i < twoClass2.count ;i ++) {
                 [twoClassArr2 addObject:[twoClass2[i] objectForKey:@"name"]];
             }
             
             NSMutableArray *twoClassArr3 = [NSMutableArray array];
             for (int i = 0 ; i < twoClass3.count ;i ++) {
                 [twoClassArr3 addObject:[twoClass3[i] objectForKey:@"name"]];
             }
             
             NSMutableArray *twoClassArr4 = [NSMutableArray array];
             for (int i = 0 ; i < twoClass4.count ;i ++) {
                 [twoClassArr4 addObject:[twoClass4[i] objectForKey:@"name"]];
             }
             
             NSMutableArray *twoClassArr5 = [NSMutableArray array];
             for (int i = 0 ; i < twoClass5.count ;i ++) {
                 [twoClassArr5 addObject:[twoClass5[i] objectForKey:@"name"]];
             }
             
             NSMutableArray *twoClassArr6 = [NSMutableArray array];
             for (int i = 0 ; i < twoClass6.count ;i ++) {
                 [twoClassArr6 addObject:[twoClass6[i] objectForKey:@"name"]];
             }
             _twoSecondArr = [[NSMutableArray alloc] initWithObjects:twoClassArr1,twoClassArr2,twoClassArr3,twoClassArr5,twoClassArr4,twoClassArr6, nil];

//            //thirdArrOne
            NSMutableDictionary *thirdClass = dict[@"data"][@"class3_group"];
             NSMutableArray *thirdClass1 = [NSMutableArray array];
             NSMutableArray *thirdClass2 = [NSMutableArray array];
             NSMutableArray *thirdClass3 = [NSMutableArray array];
             NSMutableArray *thirdClass4 = [NSMutableArray array];
             NSMutableArray *thirdClass5 = [NSMutableArray array];
             NSMutableArray *thirdClass6 = [NSMutableArray array];
             NSMutableArray *thirdClass7 = [NSMutableArray array];
             NSMutableArray *thirdClass8 = [NSMutableArray array];
             NSMutableArray *thirdClass9 = [NSMutableArray array];
             NSMutableArray *thirdClass10 = [NSMutableArray array];
             NSMutableArray *thirdClass11 = [NSMutableArray array];
             NSMutableArray *thirdClass12 = [NSMutableArray array];
             NSMutableArray *thirdClass13 = [NSMutableArray array];
             NSMutableArray *thirdClass14 = [NSMutableArray array];
             NSMutableArray *thirdClass15 = [NSMutableArray array];
             NSMutableArray *thirdClass16 = [NSMutableArray array];
             NSMutableArray *thirdClass17 = [NSMutableArray array];
             NSMutableArray *thirdClass18 = [NSMutableArray array];
              NSMutableArray *thirdClass19 = [NSMutableArray array];
             thirdClass1 = thirdClass[@"63"];
             thirdClass2 = thirdClass[@"2"];
             thirdClass3 = thirdClass[@"68"];
             thirdClass4 = thirdClass[@"53"];
             thirdClass5 = thirdClass[@"84"];
             thirdClass6 = thirdClass[@"58"];
             thirdClass7 = thirdClass[@"85"];
             thirdClass8 = thirdClass[@"96"];
             thirdClass9 = thirdClass[@"131"];
             thirdClass10 = thirdClass[@"86"];
             thirdClass11 = thirdClass[@"132"];
             thirdClass12 = thirdClass[@"38"];
             thirdClass13 = thirdClass[@"17"];
             thirdClass14 = thirdClass[@"97"];
             thirdClass15 = thirdClass[@"28"];
             thirdClass16 = thirdClass[@"98"];
             thirdClass17 = thirdClass[@"73"];
             thirdClass18 = thirdClass[@"46"];
             thirdClass19 = thirdClass[@"78"];
             
             NSMutableArray *thirdClassArr1 = [NSMutableArray array];
             for (int i = 0 ; i < thirdClass1.count ;i ++) {
                 [thirdClassArr1 addObject:[thirdClass1[i] objectForKey:@"name"]];
             }
             
             NSMutableArray *thirdClassArr2 = [NSMutableArray array];
             for (int i = 0 ; i < thirdClass2.count ;i ++) {
                 [thirdClassArr2 addObject:[thirdClass2[i] objectForKey:@"name"]];
             }
             
             NSMutableArray *thirdClassArr3 = [NSMutableArray array];
             for (int i = 0 ; i < thirdClass3.count ;i ++) {
                 [thirdClassArr3 addObject:[thirdClass3[i] objectForKey:@"name"]];
             }
             
             NSMutableArray *thirdClassArr4 = [NSMutableArray array];
             for (int i = 0 ; i < thirdClass4.count ;i ++) {
                 [thirdClassArr4 addObject:[thirdClass4[i] objectForKey:@"name"]];
             }
             
             NSMutableArray *thirdClassArr5 = [NSMutableArray array];
             for (int i = 0 ; i < thirdClass5.count ;i ++) {
                 [thirdClassArr5 addObject:[thirdClass5[i] objectForKey:@"name"]];
             }
             
             NSMutableArray *thirdClassArr6 = [NSMutableArray array];
             for (int i = 0 ; i < thirdClass6.count ;i ++) {
                 [thirdClassArr6 addObject:[thirdClass6[i] objectForKey:@"name"]];
             }
             NSMutableArray *thirdClassArr7 = [NSMutableArray array];
             for (int i = 0 ; i < thirdClass7.count ;i ++) {
                 [thirdClassArr7 addObject:[thirdClass7[i] objectForKey:@"name"]];
             }
             
             NSMutableArray *thirdClassArr8 = [NSMutableArray array];
             for (int i = 0 ; i < thirdClass8.count ;i ++) {
                 [thirdClassArr8 addObject:[thirdClass8[i] objectForKey:@"name"]];
             }
             
             NSMutableArray *thirdClassArr9 = [NSMutableArray array];
             for (int i = 0 ; i < thirdClass9.count ;i ++) {
                 [thirdClassArr9 addObject:[thirdClass9[i] objectForKey:@"name"]];
             }
             
             NSMutableArray *thirdClassArr10 = [NSMutableArray array];
             for (int i = 0 ; i < thirdClass10.count ;i ++) {
                 [thirdClassArr10 addObject:[thirdClass10[i] objectForKey:@"name"]];
             }
             
             NSMutableArray *thirdClassArr11 = [NSMutableArray array];
             for (int i = 0 ; i < thirdClass11.count ;i ++) {
                 [thirdClassArr11 addObject:[thirdClass11[i] objectForKey:@"name"]];
             }
             
             NSMutableArray *thirdClassArr12 = [NSMutableArray array];
             for (int i = 0 ; i < thirdClass12.count ;i ++) {
                 [thirdClassArr12 addObject:[thirdClass12[i] objectForKey:@"name"]];
             }
             NSMutableArray *thirdClassArr13 = [NSMutableArray array];
             for (int i = 0 ; i < thirdClass13.count ;i ++) {
                 [thirdClassArr13 addObject:[thirdClass13[i] objectForKey:@"name"]];
             }
             
             NSMutableArray *thirdClassArr14 = [NSMutableArray array];
             for (int i = 0 ; i < thirdClass14.count ;i ++) {
                 [thirdClassArr14 addObject:[thirdClass14[i] objectForKey:@"name"]];
             }
             
             NSMutableArray *thirdClassArr15 = [NSMutableArray array];
             for (int i = 0 ; i < thirdClass15.count ;i ++) {
                 [thirdClassArr15 addObject:[thirdClass15[i] objectForKey:@"name"]];
             }
             
             NSMutableArray *thirdClassArr16 = [NSMutableArray array];
             for (int i = 0 ; i < thirdClass16.count ;i ++) {
                 [thirdClassArr16 addObject:[thirdClass16[i] objectForKey:@"name"]];
             }
             
             NSMutableArray *thirdClassArr17 = [NSMutableArray array];
             for (int i = 0 ; i < thirdClass17.count ;i ++) {
                 [thirdClassArr17 addObject:[thirdClass17[i] objectForKey:@"name"]];
             }
             
             NSMutableArray *thirdClassArr18 = [NSMutableArray array];
             for (int i = 0 ; i < thirdClass18.count ;i ++) {
                 [thirdClassArr18 addObject:[thirdClass18[i] objectForKey:@"name"]];
             }
             
             NSMutableArray *thirdClassArr19 = [NSMutableArray array];
             for (int i = 0 ; i < thirdClass19.count ;i ++) {
                 [thirdClassArr19 addObject:[thirdClass19[i] objectForKey:@"name"]];
             }
          
             _threeThirdArr = [[NSMutableArray alloc] initWithObjects:thirdClassArr2,thirdClassArr13,thirdClassArr15,thirdClassArr12,
                               thirdClassArr18,
                               thirdClassArr5,thirdClassArr7,thirdClassArr10,
                               thirdClassArr3,thirdClassArr17,thirdClassArr19,
                               thirdClassArr4,thirdClassArr6,thirdClassArr1,
                               thirdClassArr8,thirdClassArr14,thirdClassArr16,
                               thirdClassArr9,thirdClassArr11, nil];

       
         }
         
         // 一次性导入所有菜单数据
         [self createAllMenuData];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}


- (void)createAllMenuData{
    NSArray *threeMenuTitleArray =  @[@"全部科目",@"智能顺序",@"附近"];
    //  创建第一个菜单的first数据second数据
//    NSArray *firstArrOne = [NSArray arrayWithObjects:@"课程",@"舞蹈",@"乐器",@"美术", nil];
//    NSArray *secondArrOne = @[@[@"全部科目", @"早教", @"小学语文", @"小学数学"],@[@"全部", @"拉丁舞", @"古典舞"],@[@"素描", @"速写", @"水彩画", @"漫画"],@[@"二胡", @"琵琶", @"笛子", @"钢琴", @"古筝"]];
//    NSArray *thirdArrOne = @[@[@"全部科目", @"早教", @"小学语文", @"小学数学", @"小学英语", @"初中语文", @"初中数学", @"初中英语", @"初中物理", @"初中化学",@"其他"],@[@"全部", @"拉丁舞", @"古典舞", @"芭蕾舞", @"儿童舞蹈", @"其他"],@[@"B三级菜单21-1",@"B三级菜单21-2"],@[@"全部", @"素描", @"速写", @"水彩画", @"漫画", @"其他"],@[@"全部", @"二胡", @"琵琶", @"笛子", @"钢琴", @"古筝"],@[@"全部", @"二胡", @"琵琶", @"笛子", @"钢琴", @"古筝"],@[@"全部", @"二胡", @"琵琶", @"笛子", @"钢琴", @"古筝"],@[@"全部", @"二胡", @"琵琶", @"笛子", @"钢琴", @"古筝"],@[@"全部", @"二胡", @"琵琶", @"笛子", @"钢琴", @"古筝"],@[@"全部", @"二胡", @"琵琶", @"笛子", @"钢琴", @"古筝"],@[@"全部", @"二胡", @"琵琶", @"笛子", @"钢琴", @"古筝"],@[@"全部", @"二胡", @"琵琶", @"笛子", @"钢琴", @"古筝"],@[@"全部", @"二胡", @"琵琶", @"笛子", @"钢琴", @"古筝"],@[@"全部", @"二胡", @"琵琶", @"笛子", @"钢琴", @"古筝"],@[@"全部", @"二胡", @"琵琶", @"笛子", @"钢琴", @"古筝"],@[@"全部", @"二胡", @"琵琶", @"笛子", @"钢琴", @"古筝"],@[@"全部", @"二胡", @"琵琶", @"笛子", @"钢琴", @"古筝"]];

     NSArray *firstMenu = [NSArray arrayWithObjects:_oneFirstArr,_twoSecondArr,_threeThirdArr, nil];
    
    //  创建第二个菜单的first数据second数据
    NSArray *firstArrTwo = [NSArray arrayWithObjects:@"智能排序", @"离我最近", @"评价最高", @"最新发布", @"人气最高", @"价格最低", @"价格最高",  @"最近开课", nil];
    NSArray *secondMenu = [NSArray arrayWithObject:firstArrTwo];
    
    //  创建第三个菜单的first数据second数据
    NSArray *firstArrThree = [NSArray arrayWithObjects:@"附近", @"0.5KM", @"1.0KM", @"1.5KM",@"2.0KM", @"2.5KM", @"3.0KM", nil];
    NSArray *threeMenu = [NSArray arrayWithObjects:firstArrThree,nil];
    
    [self.menu createThreeMenuTitleArray:threeMenuTitleArray FirstArr:firstMenu SecondArr:secondMenu threeArr:threeMenu];
}

-(void)searchprogram{
    ClassRoomSearchViewController *classRoomVC =[[ClassRoomSearchViewController alloc]init];
    classRoomVC.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:classRoomVC animated:YES];
}


//toolbar点击事件
-(void)segMentClick:(UISegmentedControl *)segment{
    
    segMentIndex=segment.selectedSegmentIndex;
    
    if(segMentIndex==0){
        UINib *nib = [UINib nibWithNibName:@"ClassTeacherTableViewCell" bundle:nil];
        [myTableView registerNib:nib forCellReuseIdentifier:@"cell"];
         teacherArray = [NSMutableArray array];
        [self getTeacherInfo:@"1" class_str:@"" appoint_order:0 filter_distance:@""];
    }
    else if(segMentIndex==1){
        UINib *nib = [UINib nibWithNibName:@"ClassSubjectTableViewCell" bundle:nil];
        [myTableView registerNib:nib forCellReuseIdentifier:@"subjectCell"];
        subjectArray = [NSMutableArray array];
        [self getSubjectInfo:@"1" class_str:@"" appoint_order:0 filter_distance:@""];
    }
    else if(segMentIndex==2){
        UINib *nib = [UINib nibWithNibName:@"ClassSchoolTableViewCell" bundle:nil];
        [myTableView registerNib:nib forCellReuseIdentifier:@"schoolCell"];
        schoolArray = [NSMutableArray array];
        [self getSchoolInfo:@"1" class_str:@"" appoint_order:0 filter_distance:@""];
        
    }
    [myTableView reloadData];
}

#pragma mark  tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (segMentIndex==0) {
        return teacherArray.count;
    }
    else if (segMentIndex==1) {
        return subjectArray.count;
    }
    else  if (segMentIndex==2){
        return schoolArray.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (segMentIndex==0) {
        ClassTeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell==nil){
            cell=[[ClassTeacherTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        NSArray * tmp = teacherArray[indexPath.row];
        [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:tmp[0]] placeholderImage:[UIImage imageNamed:@"sdimg1.png"]];
        cell.NameLabel.text=tmp[1];
        cell.agelabel.text=tmp[2];
        cell.gradeLabel.text=[NSString stringWithFormat:@"%@分",tmp[3]];;
        cell.courseLabel.text=tmp[4];
        cell.distanceLabel.text=[NSString stringWithFormat:@"%@KM",tmp[5]];
        cell.infoLabel.text=tmp[6];
        if([[NSString stringWithFormat:@"%@",tmp[7]]isEqualToString:@"1"]){
            cell.attestationImg.image=[UIImage imageNamed:@"专业认证icon36x32"];
        }else{
            cell.attestationImg.hidden=YES;
        }
        
        cell.collect.hidden=YES;
        return cell;
        
        
    }
    else if (segMentIndex==1) {
        
        ClassSubjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subjectCell"];
        if(cell==nil){
            cell=[[ClassSubjectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"subjectCell"];
        }
        
        NSArray * tmp=subjectArray[indexPath.row];
        cell.iconImg.layer.cornerRadius= cell.iconImg.bounds.size.width/2;
        cell.iconImg.layer.masksToBounds=YES;
        [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:tmp[0]] placeholderImage:[UIImage imageNamed:@"sdimg1.png"]];
        
        cell.nameLabel.text=tmp[1];
  
        NSString *teacherName;
        for (NSString * name in tmp[2]) {
            teacherName = name;
        }
        
        cell.teacherLabel.text = [NSString stringWithFormat:@"授课老师:%@",teacherName];
        cell.peopleNumLabel.text = tmp[3];
        cell.beginDateLabel.text= [NSString stringWithFormat:@"还剩 %@ 人",tmp[4]];
        cell.priceNewLabel.text= [NSString stringWithFormat:@"原价: %@        限时抢购价: %@",tmp[5],tmp[6]];
        
        cell.distanceLabel.text=[NSString stringWithFormat:@"%@KM",tmp[7]];
        
        if([[NSString stringWithFormat:@"%@",tmp[8]]isEqualToString:@"1"]){
            [cell.moneyXing  setBackgroundImage:[UIImage imageNamed:@"猩币icon28x30.png"] forState:UIControlStateNormal];
        }else{
            cell.moneyXing.hidden=YES;
        }
        if([[NSString stringWithFormat:@"%@",tmp[9]]isEqualToString:@"1"]){
            [cell.moveBack  setBackgroundImage:[UIImage imageNamed:@"退icon28x30.png"] forState:UIControlStateNormal];
        }else{
            cell.moveBack.hidden=YES;
        }
        return cell;
        
    }
    else if (segMentIndex==2){
        
        ClassSchoolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"schoolCell"];
        if(cell==nil){
            cell=[[ClassSchoolTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"schoolCell"];
        }
        NSArray * tmp=schoolArray[indexPath.row];
        
        cell.iconImg.layer.cornerRadius= cell.iconImg.bounds.size.width/2;
        cell.iconImg.layer.masksToBounds=YES;
        [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:tmp[0]] placeholderImage:[UIImage imageNamed:@"sdimg1.png"]];
        cell.nameLabel.text=tmp[1];
        cell.gradeLabel.text=[NSString stringWithFormat:@"%@分",tmp[2]];
        cell.studentLabel.text = [NSString stringWithFormat:@"%@   %@",tmp[3],tmp[4]];
        cell.distanceLabel.text=[NSString stringWithFormat:@"%@KM",tmp[6]];
        cell.addressLabel.text= [NSString stringWithFormat:@"地址: %@",tmp[7]];
        cell.addressLabel.adjustsFontSizeToFitWidth=YES;
        cell.addressLabel.minimumScaleFactor=0.1;
        
        return cell;
        
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (segMentIndex==0) {
        TeleTeachInfoViewController *teleTeachVC =[[TeleTeachInfoViewController alloc]init];
        teleTeachVC.hidesBottomBarWhenPushed =YES;
        teleTeachVC.teacherId = teacherArray[indexPath.row][8];
        [self.navigationController pushViewController:teleTeachVC animated:YES];
        
    }
    else if (segMentIndex==1) {
        
        ClassRoomSubjectInfoViewController *subjectVC =[[ClassRoomSubjectInfoViewController alloc]init];
        
        subjectVC.hidesBottomBarWhenPushed =YES;
        subjectVC.courseId = subjectArray[indexPath.row][10];
        [self.navigationController pushViewController:subjectVC animated:YES];
    }
    else  if (segMentIndex==2){
        
        LogoTabBarController *logoViewController = [[LogoTabBarController alloc] init];
        logoViewController.hidesBottomBarWhenPushed = YES;
        _schoolIdStr = _schoolIdArray[indexPath.row];
        
        [DEFAULTS setObject:_schoolIdStr forKey:@"SCHOOL_ID"];
        
        [DEFAULTS synchronize];
        [self presentViewController:logoViewController animated:YES completion:nil];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(segMentIndex==0){
        return 110;
    }
    else if (segMentIndex==1){
        
        return 110;
    }
    return 110;
}


//#pragma mark -- 代理方法 返回点击时对应的index
//- (void)menuCellDidSelected:(NSInteger)MenuTitleIndex firstIndex:(NSInteger)firstIndex secondIndex:(NSInteger)secondIndex thirdIndex:(NSInteger)thirdIndex{
//        NSLog(@"菜单数:%ld      一级菜单数:%ld      二级子菜单数:%ld  三级子菜单:%ld",(long)MenuTitleIndex,(long)firstIndex,(long)secondIndex,(long)thirdIndex);
//    
//};
//
//#pragma mark -- 代理方法 返回点击时对应的内容
//- (void)menuCellDidSelected:(NSString *)MenuTitle firstContent:(NSString *)firstContent secondContent:(NSString *)secondContent thirdContent:(NSString *)thirdContent{
//    
//        NSLog(@"菜单title:%@       一级菜单:%@         二级子菜单:%@    三级子菜单:%@",MenuTitle,firstContent,secondContent,thirdContent);
//
//    
//};

#pragma mark -- 代理方法 返回点击时对应的内容和index(合并了方法1和方法2)
- (void)menuCellDidSelected:(NSString *)MenuTitle menuIndex:(NSInteger)menuIndex firstContent:(NSString *)firstContent firstIndex:(NSInteger)firstIndex secondContent:(NSString *)secondContent secondIndex:(NSInteger)secondIndex thirdContent:(NSString *)thirdContent thirdIndex:(NSInteger)thirdIndex{
//        NSLog(@"菜单title:%@  titleIndex:%ld,一级菜单:%@    一级菜单Index:%ld,     二级子菜单:%@   二级子菜单Index:%ld   三级子菜单:%@  三级子菜单Index:%ld",MenuTitle,(long)menuIndex,firstContent,(long)firstIndex,secondContent,(long)secondIndex,thirdContent,(long)thirdIndex);
    _class_str = [NSString stringWithFormat:@"%@,%@,%@,",firstContent,secondContent,thirdContent];

    switch (menuIndex) {
        case 0:
            if (segMentIndex == 0) {
                teacherArray = [NSMutableArray array];
                [self getTeacherInfo:@"1" class_str:_class_str appoint_order:0 filter_distance:@""];
                
            }else if (segMentIndex == 1){
                subjectArray = [NSMutableArray array];
                [self getSubjectInfo:@"1" class_str:_class_str appoint_order:0 filter_distance:@""];
                
            }else if (segMentIndex == 2){
                schoolArray = [NSMutableArray array];
                [self getSchoolInfo:@"1" class_str:_class_str appoint_order:0 filter_distance:@""];
            }
            break;
        case 1:
            
            if (segMentIndex == 0) {
                teacherArray = [NSMutableArray array];
                [self getTeacherInfo:@"1" class_str:@"" appoint_order:firstIndex filter_distance:@""];
                
            }else if (segMentIndex == 1){
                subjectArray = [NSMutableArray array];
                [self getSubjectInfo:@"1" class_str:@"" appoint_order:firstIndex filter_distance:@""];
                
            }else if (segMentIndex == 2){
                schoolArray = [NSMutableArray array];
                [self getSchoolInfo:@"1" class_str:@"" appoint_order:firstIndex filter_distance:@""];
            }
            break;
        case 2:

            
            if (segMentIndex == 0) {
                teacherArray = [NSMutableArray array];
                [self getTeacherInfo:@"1" class_str:@"" appoint_order:0 filter_distance:MenuTitle];
                
            }else if (segMentIndex == 1){
                subjectArray = [NSMutableArray array];
                [self getSubjectInfo:@"1" class_str:@"" appoint_order:0 filter_distance:MenuTitle];
                
            }else if (segMentIndex == 2){
                schoolArray = [NSMutableArray array];
                [self getSchoolInfo:@"1" class_str:@"" appoint_order:0 filter_distance:MenuTitle];
            }

            break;
        default:
            break;
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 获取经纬度
-(void)getlocation{
    if (TARGET_IPHONE_SIMULATOR){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"注意" message:@"请在真机中运行" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [DXLocationManager getlocationWithBlock:^(double longitude, double latitude) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"位置信息" message:[NSString stringWithFormat:@"经度:%f \n纬度:%f",longitude,latitude] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
    
}

#pragma mark 网络 获取老师列表
//获取老师列表
- (void)getTeacherInfo:(NSString *)page class_str:(NSString *)classStr appoint_order:(NSInteger)appoint_order filter_distance:(NSString *)filter_distance
{
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/xkt_teacher";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"page":page,
                           @"user_lng":@"121.616636",
                           @"user_lat":@"31.285725",
                           @"appoint_order":[NSString stringWithFormat:@"%ld",appoint_order],
                           @"class_str":classStr,
                           @"filter_distance":filter_distance,
                           
                           
                           };
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
//                 NSLog(@"~~~~~~~~~~~~~~~~~~~~%@",dict);
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             for (NSDictionary *dic in dict[@"data"] ) {
                 //判断是否是第三方头像
                 NSString * head_img;
                 if([[NSString stringWithFormat:@"%@",dic[@"head_img_type"]]isEqualToString:@"0"]){
                     head_img=[picURL stringByAppendingString:dic[@"head_img"]];
                 }else{
                     head_img=dic[@"head_img"];
                 }
                 NSString * tname=dic[@"tname"];
                 NSString * age=[NSString stringWithFormat:@"%@岁",dic[@"age"]];
                 NSString *  score_num=[NSString stringWithFormat:@"%@",dic[@"score_num"]];
                 score_num=[score_num substringWithRange:NSMakeRange(0, 4)];
                 
                 
                 NSString * teach_range=dic[@"teach_range"];
                 NSString * distance=[NSString stringWithFormat:@"%@.000",dic[@"distance"]];
                 
                 distance=[distance substringWithRange:NSMakeRange(0, 4)];
                 NSString * exper_year=[NSString stringWithFormat:@"教龄:%@年",dic[@"exper_year"]];
                 NSString * certification=[NSString stringWithFormat:@"%@",dic[@"certification"]];
                                  NSString *teacherId = dic[@"id"];
                 NSMutableArray *arr=[NSMutableArray arrayWithObjects:head_img,tname,age,score_num,teach_range,distance,exper_year,certification,teacherId,nil];
                 
                 [teacherArray addObject:arr];
             }
             [myTableView reloadData];
         }else{
             
             [SVProgressHUD showErrorWithStatus:@"没有更多数据了"];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}


#pragma mark 网络 获取课程列表
//获取课程列表
- (void)getSubjectInfo:(NSString *)page class_str:(NSString *)classStr appoint_order:(NSInteger)appoint_order filter_distance:(NSString *)filter_distance
{
   
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/xkt_course";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"page":page,
                           @"user_lng":@"121.616636",
                           @"user_lat":@"31.285725",
                           @"appoint_order":[NSString stringWithFormat:@"%ld",appoint_order],
                           @"class_str":classStr,
                           @"filter_distance":filter_distance,
                           
                           };
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
//                  NSLog(@"—————————————————————————————课程详情———%@",dict);
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             
             for (NSDictionary *dic in dict[@"data"] ) {
                 
                 NSString * pic = [picURL stringByAppendingString:dic[@"pic"]];
                 NSString * course_name = dic[@"course_name"];
                 
                 NSMutableArray *teacher_tname_group=[NSMutableArray array];
                 for (NSString * name in dic[@"teacher_tname_group"]) {
                     [teacher_tname_group addObject:name];
                 }
                 NSString * need_num=[NSString stringWithFormat:@"%@人班",dic[@"need_num"]];
                 NSString *  now_num=[NSString stringWithFormat:@"%@",dic[@"now_num"]];
                 
                 NSString * original_price=[NSString stringWithFormat:@"%@",dic[@"original_price"]];
                 NSString *  now_price=[NSString stringWithFormat:@"%@",dic[@"now_price"]];
                 NSString * distance=[NSString stringWithFormat:@"%@.00",dic[@"distance"]];
                 
                 distance=[distance substringWithRange:NSMakeRange(0, 4)];
                 NSString * coin=[NSString stringWithFormat:@"%@",dic[@"coin"]];
                 NSString * allow_return=[NSString stringWithFormat:@"%@",dic[@"allow_return"]];
                 NSString *courseId = [NSString stringWithFormat:@"%@",dic[@"id"]];
                 
                 NSMutableArray *arr=[NSMutableArray arrayWithObjects:pic, course_name,teacher_tname_group,need_num,now_num,original_price,now_price,distance,coin,allow_return,courseId,nil];
                 
                 [subjectArray addObject:arr];
             }
             
             [myTableView reloadData];
             
         }else{
             
             [SVProgressHUD showErrorWithStatus:@"没有更多数据了"];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}



#pragma mark 网络 获取机构列表
//获取机构列表
- (void)getSchoolInfo:(NSString *)page class_str:(NSString *)classStr appoint_order:(NSInteger)appoint_order filter_distance:(NSString *)filter_distance
{
   
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/xkt_school";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"page":page,
                           @"user_lng":@"121.616636",
                           @"user_lat":@"31.285725",
                           @"appoint_order":[NSString stringWithFormat:@"%ld",appoint_order],
                           @"class_str":classStr,
                           @"filter_distance":filter_distance,
                           
                           };
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
//             NSLog(@"机构列表================%@",dict);
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             
             for (NSDictionary *dic in dict[@"data"] ) {
                 
                 NSString *schoolId = dic[@"id"];
                 [_schoolIdArray addObject:schoolId];
                 
                 NSString * logo=[picURL stringByAppendingString:dic[@"logo"]];
                 NSString * name=dic[@"name"];
                 NSString * score_num=[NSString stringWithFormat:@"%@",dic[@"score_num"]];
                 score_num=[score_num substringWithRange:NSMakeRange(0, 4)];
                 NSString *  baby_count=[NSString stringWithFormat:@"%@位学生",dic[@"baby_count"]];
                 
                 NSString * teacher_count=[NSString stringWithFormat:@"%@位老师",dic[@"teacher_count"]];
                 NSString *  comment_num=[NSString stringWithFormat:@"%@条评论",dic[@"comment_num"]];
                 NSString * distance=[NSString stringWithFormat:@"%@.000",dic[@"distance"]];
                 
                 distance=[distance substringWithRange:NSMakeRange(0, 4)];
                 
                 NSString * address=[NSString string];
                 address=[address stringByAppendingString:dic[@"province"]];
                 address=[address stringByAppendingString:dic[@"city"]];
                 address=[address stringByAppendingString:dic[@"district"]];
                 address=[address stringByAppendingString:dic[@"address"]];
                 
                 
                 NSMutableArray *arr=[NSMutableArray arrayWithObjects:logo,name,score_num,baby_count, teacher_count,comment_num,distance,address,nil];
                 
                 [schoolArray addObject:arr];
             }
             
             [myTableView reloadData];
             
             //使用沙河存储 _schoolIdArray
             [[NSUserDefaults standardUserDefaults] setObject:_schoolIdArray forKey:@"_schoolIdArray"];
         }else{
             
             [SVProgressHUD showErrorWithStatus:@"没有更多数据了"];
         }

     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}



@end

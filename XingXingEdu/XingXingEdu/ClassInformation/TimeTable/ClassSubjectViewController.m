//
//  ClassSubjectViewController.m
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/1/18.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define STAG 10000000
#define kTheme_CONST_ONE_WEEK_WIDTH     7
#import "ClassSubjectViewController.h"
#import "SubjectInfoViewController.h"
#import "LMContainsLMComboxScrollView.h"
#import "StrechyParallaxScrollView.h"
#import "WJCommboxView.h"
#import "LMComBoxView.h"
#import "YZZUtilities.h"
#import "HHControl.h"
#import "ClassSubjectTimeTableViewController.h"
@interface ClassSubjectViewController ()<UIScrollViewDelegate,UITextFieldDelegate,WJCommboxViewDelegate>
{
    NSMutableDictionary *_dataDict;
    StrechyParallaxScrollView *strechy;
    NSArray *classNameArr;
    NSArray *dataArr;
    UIButton *exchangeBtn;
    UIView *classView;
    UIButton *classBtn;
    NSString *babyId;
    NSString *urlStr;
    NSMutableArray *detailMArr;
    NSMutableDictionary *classDic;
    NSDictionary *headDic;
    NSMutableArray *btnArr;
    NSMutableArray *weekMArr;
    NSMutableArray *tmMArr;
    NSMutableArray *nameMArr;
    UIScrollView *_scrollView;
    WJCommboxView *titleCombox;
    UITextField * textFiel;
    NSString *weekStr;
    NSInteger weekday;
    NSInteger _number;
    NSInteger _page;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@property (nonatomic, strong) UIView *bgView;

@end

@implementation ClassSubjectViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [titleCombox.textField removeObserver:self forKeyPath:@"text"];
}
- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden =YES;
    self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0, 170, 42);
    babyId =[[NSUserDefaults standardUserDefaults] objectForKey:@"BABYID"];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden =NO;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"TT"];
    self.view.backgroundColor = UIColorFromRGB(116,205, 169);
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
//    _isTradition = NO;
    if (_isTradition == NO) {
         _number = 0;
        
    }else{
        _number = _weekNumStr;

        [_scrollView setContentOffset:CGPointMake(0, kHeight * _number)];
        
        titleCombox.textField.text = classNameArr[_number];

    }

    
    
    headDic =[[NSDictionary alloc]initWithObjectsAndKeys:@"1",@"本周",@"2",@"第2周",@"3",@"第3周",@"4",@"第4周",@"5",@"第5周",@"6",@"第6周",@"7",@"第7周",@"8",@"第8周",@"9",@"第9周",@"10",@"第10周",@"11",@"第11周",@"12",@"第12周",@"13",@"第13周",@"14",@"第14周",@"15",@"第15周",@"16",@"第16周",@"17",@"第17周",@"18",@"第18周",@"19",@"第19周",@"20",@"第20周",nil];
    _dataDict=[[NSMutableDictionary alloc]init];
    classDic=[[NSMutableDictionary alloc]init];
    weekMArr =[[NSMutableArray alloc]init];
    
    
    [self createRightBar];
    [self loadMoreData];
    
}
- (void)loadMoreData{
    /**
     *  异步加载网络数据
     */
    urlStr =@"http://www.xingxingedu.cn/Parent/schedule_week_date";
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE
                             };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
            NSDictionary *dict =responseObj;
            if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"])
            {
                weekMArr =dict[@"data"];
            }
            /**
             *  异步加载网络数据
             */
            dispatch_async(dispatch_get_main_queue(), ^{
                [self configUI:weekMArr[_weekNumStr]];
                
            });
        } failure:^(NSError *error) {
            
        }];
    });
}
- (void)configUI:(NSString*)str{
    
    weekStr = str;
    
    urlStr =@"http://www.xingxingedu.cn/Parent/schedule_tradition";
    NSDictionary *pragram =@{
                             @"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE,
                             @"baby_id":@"3",
                             @"week_date":weekStr
                             };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [WZYHttpTool  post:urlStr params:pragram success:^(id responseObj) {
            NSDictionary *dict =responseObj;
//                         NSLog(@"===========dataArr=========================%@",dict);
            if ([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"]) {
                dataArr =dict[@"data"];
                
                nameMArr = [NSMutableArray array];
                detailMArr = [NSMutableArray array];
                
                for (int i=0; i<dataArr.count; i++) {
                    
                    for (int j=0; j<[dataArr[i] count]; j++) {
                        if ([dataArr[i][j] count]>0) {
                            NSString *nameStr;
                            
                            for (int a=0; a< [dataArr[i][j] count] ; a++) {
                                NSString *newStr =[dataArr[i][j][a] objectForKey:@"name"];
                                
                                if (!nameStr) {
                                    
                                    nameStr =[NSString stringWithFormat:@"%@",newStr];
                                }
                                else{
                                    
                                    nameStr =[NSString stringWithFormat:@"%@&%@",nameStr,newStr];
                                }
                                
                            }
                            [detailMArr addObject:dataArr[i][j]];
                            [nameMArr addObject:nameStr];
                        }
                        else{
                            
                            [detailMArr addObject:@"..."];
                            [nameMArr addObject:@" "];
                        }
                        
                    }
                    
                }
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self configUI];
                
            });
            
        } failure:^(NSError *error) {
            
        }];
        
        
    });
    
}

- (void)createRightBar{
    
    _bgView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    _bgView.backgroundColor =UIColorFromRGB(0, 170, 42);
    _bgView.userInteractionEnabled =YES;
    
    [self.view addSubview:_bgView];
    
    UIButton *backBtn =[HHControl createButtonWithFrame:CGRectMake(10, 34, 45, 19) backGruondImageName:@"返回icon90x38" Target:self Action:@selector(backBtn) Title:@""];
    [_bgView addSubview:backBtn];
    
    UIButton *rightBar =[HHControl createButtonWithFrame:CGRectMake(kWidth-36, 30, 26, 26) backGruondImageName:@"exchengeBtn" Target:self Action:@selector(landClick:) Title:@""];
    [_bgView addSubview:rightBar];
    
    classNameArr = [[NSArray alloc]initWithObjects:@"本周",@"第2周",@"第3周",@"第4周",@"第5周",@"第6周",@"第7周",@"第8周",@"第9周",@"第10周",@"第11周",@"第12周",@"第13周",@"第14周",@"第15周",@"第16周",@"第17周",@"第18周",@"第19周",@"第20周",nil];
   titleCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake((kWidth - 90)/2, 30, 90, 30)];
    [_bgView addSubview:titleCombox];
    
    //边框
    titleCombox.textField.backgroundColor =UIColorFromRGB(0, 170, 42);
    titleCombox.textField.text =classNameArr[_weekNumStr];
    titleCombox.textField.font =[UIFont systemFontOfSize:18];
    [titleCombox.textField setTextColor:[UIColor whiteColor]];
    titleCombox.textField.hidden = NO;
    titleCombox.delegate = self;
    titleCombox.textField.layer.borderColor =[UIColor colorWithRed:92 green:162 blue:87 alpha:1].CGColor;
    
    //    监听方法
    //    [titleCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    
    //重写图片
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15,21)];
    imageView.image = [UIImage imageNamed:@"nextList"];
    titleCombox.textField.rightView =imageView;
    titleCombox.textField.textAlignment = NSTextAlignmentCenter;
    titleCombox.textField.tag = 1000;
    titleCombox.dataArray = classNameArr;
    titleCombox.listTableView.frame =CGRectMake((kWidth - 90)/2, 64, 90, 60);
    titleCombox.listTableView.separatorStyle =UITableViewCellSelectionStyleNone;
    titleCombox.listTableView.userInteractionEnabled =YES;
    [self.view addSubview:titleCombox.listTableView];
    
}
- (void)backBtn{
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}
- (void)sendSelectCellNum:(NSInteger)num{
    
    _number = num;
    
    _weekNumStr = num;
    NSString *wekStr =[weekMArr objectAtIndex: num];
    [_scrollView setContentOffset:CGPointMake(0, kHeight * num)];
 
    titleCombox.textField.text = classNameArr[num];
    /**
     *切换时间表 传weekStr
     */
    [self configUI:wekStr];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
     _page = scrollView.contentOffset.y / kHeight;
    _weekNumStr = _page;
    titleCombox.textField.text = classNameArr[_page];
}

- (void)landClick:(UIBarButtonItem*)editBtn{
    if ([XXEUserInfo user].login) {
        ClassSubjectTimeTableViewController *timeTableVC = [[ClassSubjectTimeTableViewController alloc]init];
        timeTableVC.weekNumStr = _weekNumStr;
        timeTableVC.isTime = YES;
        [self.navigationController pushViewController:timeTableVC animated:NO];
    }else{
        [SVProgressHUD showInfoWithStatus:@"请用账号登录后查看"];
    }

    
}
#pragma UIView实现动画

- (void)configUI{
    
    if (_scrollView) {
        [_scrollView removeFromSuperview];
    }
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64,kWidth, kHeight)];
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(kWidth, kHeight*classNameArr.count);
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    _scrollView.userInteractionEnabled = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_scrollView];
    
    float itemStartY = 0;
    for (int kti=0 ; kti<= classNameArr.count; kti++) {
        UILabel *monthLbl =[HHControl createLabelWithFrame:CGRectMake(1, 0+itemStartY, 26, 40) Font:10 Text:@"8月"];
        monthLbl.backgroundColor =UIColorFromRGB(195, 239, 251);
        [monthLbl setTextAlignment:NSTextAlignmentCenter];
        [_scrollView addSubview:monthLbl];
        [_scrollView addSubview:[self scrollViewItemWithY:itemStartY+0 andNumber:kti]];
        itemStartY += kHeight;
    }
     [_scrollView setContentOffset:CGPointMake(0, _number * kHeight)];
}

- (UIView *)scrollViewItemWithY:(CGFloat)y andNumber:(int)num {
    
    classView = [[UIView alloc] initWithFrame:CGRectMake(0, y, kWidth, kHeight)];
    
//    NSLog(@"====================>%f",y);
    [self createData];
    classView.userInteractionEnabled =YES;
    return classView;
}


#pragma mark - UIScrollView
- (void)createData {
    
    int o=0;
    for (int j=1; j<=dataArr.count; j++) {
        
        for (int d=1; d<=7; d++) {
            [_dataDict setValue:nameMArr[o] forKey:[NSString stringWithFormat:@"%d%d",j,d]];
            o++;
        }
    }
    
    NSMutableDictionary *weekDayDic =[[NSMutableDictionary alloc]init];
    NSDictionary *weekDic =[[NSDictionary alloc]initWithObjectsAndKeys:@"周一",@"1",@"周二",@"2",@"周三",@"3",@"周四",@"4",@"周五",@"5",@"周六",@"6",@"周日",@"7", nil];
    
    for (NSUInteger weekday=1 ; weekday<=kTheme_CONST_ONE_WEEK_WIDTH; ++weekday) {
        
        NSString *title = [weekDic objectForKey:[NSString stringWithFormat:@"%ld",(unsigned long)weekday]];
        UILabel *dayLabel =[[UILabel alloc]initWithFrame:CGRectMake(27 + (weekday - 1)*((kWidth - 25)/7), 1,((kWidth - 25)/7) - 2, 30)];
        dayLabel.text = title;
        dayLabel.font = [UIFont systemFontOfSize:10];
        dayLabel.backgroundColor = UIColorFromRGB(195, 239, 251);
        [dayLabel setTextAlignment:NSTextAlignmentCenter];
        [classView addSubview:dayLabel];
        [weekDayDic setObject:dayLabel forKey:[NSString stringWithFormat:@"%ld",weekday]];
    }
    weekday = [YZZUtilities queryWeekday];
    weekday = ((weekday -1)==0? 7:(weekday-1));
    UILabel *weekLabel = [weekDayDic objectForKey:[NSString stringWithFormat:@"%d",weekday]];
    [weekLabel setBackgroundColor:UIColorFromRGB(255, 163, 195)];
    
    
    for (int j=1; j<=dataArr.count; j++) {
        [classDic setValue:[NSString stringWithFormat:@"%d",j] forKey:[NSString stringWithFormat:@"%d",j]];
        
    }
    
    for (NSUInteger classNum=1; classNum<=dataArr.count; classNum++) {
        NSString *numTile =[classDic objectForKey:[NSString stringWithFormat:@"%ld",(unsigned long)classNum]];
        UILabel *classLabel  =[[UILabel alloc]initWithFrame:CGRectMake(1, 41+(classNum-1)*40, 26, 39)];
        classLabel.text = numTile;
        classLabel.font = [UIFont systemFontOfSize:8];
        classLabel.backgroundColor = UIColorFromRGB(195, 239, 251);
        [classLabel setTextAlignment:NSTextAlignmentCenter];
        [classView addSubview:classLabel];
    }
    
    btnArr = [[NSMutableArray alloc]init];
    for (NSInteger ikt =1; ikt<=dataArr.count; ikt++) {
        for (NSInteger jkt =1; jkt<=7; jkt++) {
            classBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [classBtn setFrame:CGRectMake(28 + (jkt - 1)*((kWidth - 25)/7), 48+(ikt-1)*40, ((kWidth - 30)/7) - 2, 25)];
            classBtn.layer.cornerRadius = 5;
            [classBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [classBtn setTag:[[NSString stringWithFormat:@"%ld%ld",(long)ikt,(long)jkt] intValue]];
            [btnArr addObject:classBtn];
            //分割
            NSArray *array = [[_dataDict objectForKey:[NSString stringWithFormat:@"%ld",(long)classBtn.tag]] componentsSeparatedByString:@"&"];
            [classBtn setTitle:[NSString stringWithFormat:@"%@",array[0]] forState:UIControlStateNormal];
            classBtn.titleLabel.font =[UIFont boldSystemFontOfSize:13];
            //匹配字符串
            if ([[_dataDict objectForKey:[NSString stringWithFormat:@"%ld",(long)classBtn.tag]] rangeOfString:@"&"].location !=NSNotFound) {
                
                UIButton *redBtn = [[UIButton alloc]initWithFrame:CGRectMake(classBtn.bounds.size.width - 10,- 6, 14, 14) ];
                [redBtn setTitle:[NSString stringWithFormat:@"%ld",(unsigned long)array.count] forState:UIControlStateNormal];
                [redBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                redBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                redBtn.titleLabel.font = [UIFont systemFontOfSize:9.0f];
                redBtn.backgroundColor = [UIColor whiteColor];
                
                [redBtn.layer setMasksToBounds:YES];   //设置yes
                [redBtn.layer setCornerRadius:7.5f];   //弧度等于宽度的一半 就是圆角
                
                //边框宽度
                [redBtn.layer setBorderWidth:2];
                [redBtn.layer setBorderColor:[[UIColor redColor] CGColor]];
                [classBtn addSubview:redBtn];
            }
            
            
            if (weekday==jkt) {
                
                [classBtn setBackgroundImage:[UIImage imageNamed:@"科目按钮(H)80x60"] forState:UIControlStateNormal] ;
            }
            else{
                [classBtn setBackgroundImage:[UIImage imageNamed:@"科目按钮灰色80x60"] forState:UIControlStateNormal];
            }
            
            [classBtn addTarget:self action:@selector(showEditPopover:) forControlEvents:UIControlEventTouchUpInside];
            [classView addSubview:classBtn];
        }
        
    }
    [self.view bringSubviewToFront:titleCombox.listTableView];
    [self.view bringSubviewToFront:_bgView];
    [self.view bringSubviewToFront:titleCombox.listTableView];
}
- (UIColor *)randomColor {
    
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (void)showEditPopover:(UIButton*)btn{
    
    UIButton *ktBtn =(UIButton *)btn;
    NSUInteger ikey =ktBtn.tag;
    NSInteger detail =(ikey/10-1)*7 + ikey%10 -1;
    
    SubjectInfoViewController *subjectInfoVC=[[SubjectInfoViewController alloc]init];
    subjectInfoVC.ClassTag =ikey;
    subjectInfoVC.weekStr = weekStr;
    subjectInfoVC.detailMArr = detailMArr[detail];
    subjectInfoVC.className = [NSString stringWithFormat:@"%@",[_dataDict objectForKey:[NSString stringWithFormat:@"%ld",(long)btn.tag]]];
    [subjectInfoVC returnText:^(NSString *classText) {
        
    }];
    [self.navigationController pushViewController:subjectInfoVC animated:YES];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
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




//
//  ClassHomeworkViewController.m
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/1/18.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define KT @"yyyy年MM月dd日 HH:MM:ss"
#define kPData     @"ClassHomeWorkCell"
#import "ClassHomeworkViewController.h"
#import "ClassHomeInfoMationViewController.h"
#import "LMContainsLMComboxScrollView.h"
#import "ClassHomeWorkCell.h"
#import "WJCommboxView.h"
#import "LMComBoxView.h"
#import "LandingpageViewController.h"

@interface ClassHomeworkViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIView *bgScrollView;
    //    UITableView *_tableView;
    NSMutableArray *_dataArray;
    //data
    NSMutableArray *classMArr;
    NSMutableArray *conditMArr;
    NSMutableArray *data_end_tmMArr;
    NSMutableArray *date_tmMArr;
    NSMutableArray *gradeMArr;
    NSMutableArray *head_imgMArr;
    NSMutableArray *head_img_typeMArr;
    NSMutableArray *idMArr;
    NSMutableArray *monthMArr;
    NSMutableArray *school_idMArr;
    NSMutableArray *teach_courseMArr;
    NSMutableArray *tidMArr;
    NSMutableArray *titleMArr;
    NSMutableArray *tnameMArr;
    NSDictionary *picDict;
    NSArray *monthArr;
    NSArray *teachArr;
    NSArray *KTMonthArr;
    NSArray *KTTeachArr;
    UIView *Headview;
    NSArray *dataArr;
    NSString * classNameStr;
    NSString * dateNameStr;
    NSDateFormatter *fomatter;
    NSString *confromTimespStr;
    NSString *urlStr;
    NSInteger x;
    int k;
    NSInteger page;
}

@property (nonatomic, strong) UITableView *myTabelView;

@property(nonatomic,strong)WJCommboxView *classNameCombox;
@property(nonatomic,strong)WJCommboxView *dateNameCombox;
@property(nonatomic,strong)UIView *schoolTypeView;
@property(nonatomic,strong)UIView *classTypeView;
@property(nonatomic,strong)NSArray *cityArray;
@property(nonatomic,strong)NSArray *mothArray;
@end

@implementation ClassHomeworkViewController


- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden =NO;
    [_myTabelView reloadData];
    [self.navigationController.navigationBar setTintColor:UIColorFromRGB(255, 255, 255)];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_myTabelView.header beginRefreshing];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.classNameCombox.textField removeObserver:self forKeyPath:@"text"];
    [self.dateNameCombox.textField removeObserver:self forKeyPath:@"text"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    classMArr =[[NSMutableArray alloc]init];
    conditMArr =[[NSMutableArray alloc]init];
    data_end_tmMArr =[[NSMutableArray alloc]init];
    date_tmMArr =[[NSMutableArray alloc]init];
    gradeMArr =[[NSMutableArray alloc]init];
    head_imgMArr =[[NSMutableArray alloc]init];
    head_img_typeMArr =[[NSMutableArray alloc]init];
    idMArr =[[NSMutableArray alloc]init];
    monthMArr =[[NSMutableArray alloc]init];
    school_idMArr =[[NSMutableArray alloc]init];
    teach_courseMArr =[[NSMutableArray alloc]init];
    tidMArr =[[NSMutableArray alloc]init];
    titleMArr =[[NSMutableArray alloc]init];
    tnameMArr =[[NSMutableArray alloc]init];
    
    
    page = 0;
    
    classNameStr = @"0";
    dateNameStr = @"0";
    KTMonthArr = [[NSArray alloc]init];
    KTTeachArr = [[NSArray alloc]init];
    k=0;
    fomatter =[[NSDateFormatter alloc]init];
    [fomatter setDateStyle:NSDateFormatterMediumStyle];
    [fomatter setTimeStyle:NSDateFormatterShortStyle];
    [fomatter setDateFormat:KT];
    picDict =[[NSDictionary alloc]initWithObjectsAndKeys:@"急98c98",@"1",@"写98c98",@"2",@"新98c98",@"3",@"结98c98",@"4",nil];
    self.cityArray = [[NSArray alloc]initWithObjects:@"全部",@"英语",@"数学",@"语文",nil];
    self.mothArray = [[NSArray alloc]initWithObjects:@"全部",@"6",@"7",@"8",@"9",@"10",@"11",nil];
    self.title =@"作业";
    self.view.backgroundColor = UIColorFromRGB(196, 213, 255);
    
    [self createTable];
    [self initUI];
    
}

- (void)createData{
    /*
     【班级作业】
     
     接口:
     http://www.xingxingedu.cn/Parent/class_homework_list
     
     传参:
     school_id	//学校id (测试值:1)
     class_id		//班级 (测试值:1)
     page		//页码(加载更多,不传值默认1,测试时每页加载6个)
     teach_course	//科目,筛选用,例如:英语
     month		//月份,筛选用,例如:3
     
     注:筛选时,学校id,年级,班级3个传参都不能少
     */
    
    
    urlStr = @"http://www.xingxingedu.cn/Parent/class_homework_list";
    
    NSString *class_idStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"CLASS_ID"];
    NSString *schoolIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"SCHOOL_ID"];
    
    NSString *pageStr = [NSString stringWithFormat:@"%ld", (long)page];
    NSString *parameterXid;
    NSString *parameterUser_Id;
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    NSDictionary *pragm = @{   @"appkey":APPKEY,
                               @"backtype":BACKTYPE,
                               @"xid":parameterXid,
                               @"user_id":parameterUser_Id,
                               @"user_type":USER_TYPE,
                               @"school_id":schoolIdStr,
                               @"class_id":class_idStr,
                               @"teach_course":classNameStr,
                               @"month":dateNameStr,
                               @"page": pageStr
                               };
    
    
    //        NSLog(@"传参  --  %@", pragm);
    
    [WZYHttpTool post:urlStr params:pragm success:^(id responseObj) {
        
        //                NSLog(@"请求 数据 %@", responseObj);
        
        NSDictionary *dict =responseObj;
        
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
            dataArr =[dict[@"data"] objectForKey:@"homework_list"];
            
            if (dataArr.count!=0) {
                for (int i=0; i<dataArr.count; i++) {
                    
                    [conditMArr addObject:[dataArr[i] objectForKey:@"condit"]];
                    [data_end_tmMArr addObject:[dataArr[i] objectForKey:@"date_end_tm"]];
                    [date_tmMArr addObject:[dataArr[i] objectForKey:@"date_tm"]];
                    [head_imgMArr addObject:[dataArr[i] objectForKey:@"head_img"]];
                    [head_img_typeMArr addObject:[dataArr[i] objectForKey:@"head_img_type"]];
                    [idMArr addObject:[dataArr[i] objectForKey:@"id"]];
                    [monthMArr addObject:[dataArr[i] objectForKey:@"month"]];
                    [school_idMArr addObject:[dataArr[i] objectForKey:@"school_id"]];
                    [teach_courseMArr addObject:[dataArr[i] objectForKey:@"teach_course"]];
                    [tidMArr addObject:[dataArr[i] objectForKey:@"tid"]];
                    [titleMArr addObject:[dataArr[i] objectForKey:@"title"]];
                    [tnameMArr addObject:[dataArr[i] objectForKey:@"tname"]];
                    
                }
            }
            
            monthArr =[dict[@"data"]objectForKey:@"month_group"];
            teachArr =[dict[@"data"]objectForKey:@"teach_course_group"];
        }
        [self customContent];
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}


// 有数据 和 无数据 进行判断
- (void)customContent{
    
    if (monthArr.count == 0) {
        
        _myTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // 1、无数据的时候
        UIImage *myImage = [UIImage imageNamed:@"人物"];
        CGFloat myImageWidth = myImage.size.width;
        CGFloat myImageHeight = myImage.size.height;
        
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - myImageWidth / 2, (kHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
        myImageView.image = myImage;
        [self.view addSubview:myImageView];
        
    }else{
        //2、有数据的时候
        [_myTabelView reloadData];
        
    }
    
}


- (void)createTable{
    
    _myTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    _myTabelView.dataSource =self;
    _myTabelView.delegate =self;
    
    _myTabelView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _myTabelView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooterNewData)];
    
    // 隐藏状态
    _myTabelView.footer.state = YES;
    
    [self.view addSubview:_myTabelView];
    
}


-(void)loadNewData{
    
    [self createData];
    [ _myTabelView.header endRefreshing];
}
-(void)endRefresh{
    [_myTabelView.header endRefreshing];
    [_myTabelView.footer endRefreshing];
}

- (void)loadFooterNewData{
    page ++ ;
    
    [self createData];
    [ _myTabelView.footer endRefreshing];
    
}


- (void)initUI{
    bgScrollView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth,34)];
    bgScrollView.backgroundColor = UIColorFromRGB(240, 240, 240);
    _myTabelView.tableHeaderView =bgScrollView;
    bgScrollView.userInteractionEnabled =YES;
    
    KTTeachArr =teachArr;
    self.classNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(0, 2, kWidth/2, 30)];
    self.classNameCombox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
    self.classNameCombox.textField.placeholder = @"科目";
    self.classNameCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.classNameCombox.textField.tag = 1001;
    self.classNameCombox.dataArray = self.cityArray;
    [bgScrollView addSubview:self.classNameCombox];
    //监听
    [self.classNameCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"1"];
    
    self.schoolTypeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,165,kHeight+300)];
    self.schoolTypeView.backgroundColor = [UIColor clearColor];
    self.schoolTypeView.alpha = 0.5;
    
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden)];
    [self.schoolTypeView addGestureRecognizer:singleTouch];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction:) name:@"commboxNotice"object:nil];
    KTMonthArr =monthArr;
    //年级区域
    self.dateNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(kWidth/2, 2, kWidth/2, 30)];
    self.dateNameCombox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
    self.dateNameCombox.textField.placeholder =@"月份";
    self.dateNameCombox.textField.textAlignment =NSTextAlignmentLeft;
    self.dateNameCombox.textField.tag =1002;
    self.dateNameCombox.dataArray =self.mothArray;
    [bgScrollView addSubview:self.dateNameCombox];
    //监听
    [self.dateNameCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"2"];
    self.classTypeView = [[UIView alloc]initWithFrame:CGRectMake(165, 0, kWidth-165,kHeight+300)];
    self.classTypeView.backgroundColor = [UIColor clearColor];
    self.classTypeView.alpha = 0.5;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHi)];
    [self.classTypeView addGestureRecognizer:singleTap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction:) name:@"commboxNotice"object:nil];
    
}
- (void)commboxAction:(NSNotification *)notif{
    switch ([notif.object integerValue]) {
        case 1001:
        {
            
            [self.classNameCombox removeFromSuperview];
            
            [_myTabelView addSubview:self.schoolTypeView];
            [_myTabelView addSubview:self.classNameCombox];
        }
            break;
        case 1002:
        {
            
            [self.dateNameCombox removeFromSuperview];
            [_myTabelView addSubview:self.classTypeView];
            [_myTabelView addSubview:self.dateNameCombox];
        }
            break;
        default:
            break;
    }
    
}

- (void)commboxHidden{
    
    [self.schoolTypeView removeFromSuperview];
    [self.classNameCombox setShowList:NO];
    self.classNameCombox.listTableView.hidden = YES;
    CGRect sf = self.classNameCombox.frame;
    sf.size.height = 30;
    self.classNameCombox.frame = sf;
    CGRect frame = self.classNameCombox.listTableView.frame;
    frame.size.height = 0;
    self.classNameCombox.listTableView.frame = frame;
    [self.classNameCombox removeFromSuperview];
    [bgScrollView addSubview:self.classNameCombox];
}
- (void)commboxHi{
    
    [self.classTypeView removeFromSuperview];
    [self.dateNameCombox setShowList:NO];
    self.dateNameCombox.listTableView.hidden = YES;
    CGRect s = self.dateNameCombox.frame;
    s.size.height = 30;
    self.dateNameCombox.frame = s;
    CGRect fram = self.dateNameCombox.listTableView.frame;
    fram.size.height = 0;
    self.dateNameCombox.listTableView.frame = fram;
    [self.dateNameCombox removeFromSuperview];
    [bgScrollView addSubview:self.dateNameCombox];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    [classMArr removeAllObjects];
    [conditMArr removeAllObjects];
    [data_end_tmMArr removeAllObjects];
    [date_tmMArr removeAllObjects];
    [gradeMArr removeAllObjects];
    [head_imgMArr removeAllObjects];
    [head_img_typeMArr removeAllObjects];
    [idMArr removeAllObjects];
    [monthMArr removeAllObjects];
    [school_idMArr removeAllObjects];
    [teach_courseMArr removeAllObjects];
    [tidMArr removeAllObjects];
    [titleMArr removeAllObjects];
    [tnameMArr removeAllObjects];
    
    //筛选的时候 让 page =  1
    page = 1;
    switch ([[NSString stringWithFormat:@"%@",context] integerValue]) {
        case 1:
        {
            if ([keyPath isEqualToString:@"text"]) {
                NSString * newName=[change objectForKey:@"new"];
                
                
                
                if ([newName isEqualToString:@"全部"]) {
                    classNameStr = @"0";
                }
                else{
                    classNameStr = newName;
                }
                
                [self createData];
            }
            
        }
            break;
        case 2:
        {
            if ([keyPath isEqualToString:@"text"]) {
                NSString * newName=[change objectForKey:@"new"];
                
                
                if ([newName isEqualToString:@"全部"]) {
                    dateNameStr = @"0";
                }
                else{
                    dateNameStr = newName;
                }
                
                [self createData];
            }
            
        }
            break;
        default:
            break;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  idMArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 96;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassHomeWorkCell *cell = (ClassHomeWorkCell*)[tableView dequeueReusableCellWithIdentifier:kPData];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:kPData owner:[ClassHomeWorkCell class] options:nil];
        cell = (ClassHomeWorkCell*)[nib objectAtIndex:0];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    cell.icon.layer.cornerRadius =5;
    cell.icon.clipsToBounds =YES;
    
    if (idMArr.count!=0) {
        cell.name.text = [NSString stringWithFormat:@"%@",tnameMArr[indexPath.row]];
        
        NSString *timeStr = [WZYTool dateStringFromNumberTime:data_end_tmMArr[indexPath.row]];
        cell.time.text = [NSString stringWithFormat:@"截止时间:%@", timeStr];
        
        cell.newstar.image =[UIImage imageNamed:[picDict objectForKey:[NSString stringWithFormat:@"%@",conditMArr[indexPath.row]]]];
        
        [cell.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picURL,head_imgMArr[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"picterPlace"]];
        cell.intro.text = teach_courseMArr[indexPath.row];
        cell.address.text = titleMArr[indexPath.row];
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([XXEUserInfo user].login) {
        ClassHomeInfoMationViewController *classHomeInfoVC = [[ClassHomeInfoMationViewController alloc]init];
        classHomeInfoVC.idStr =idMArr[indexPath.row];
        [self.navigationController pushViewController:classHomeInfoVC animated:YES];
        
    }else{
        [SVProgressHUD showInfoWithStatus:@"请用账号登录后查看"];
         }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}



@end

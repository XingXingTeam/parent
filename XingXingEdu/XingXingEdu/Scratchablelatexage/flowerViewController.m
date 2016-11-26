//
//  flowerViewController.m
//  Homepage
//
//  Created by super on 16/1/22.
//  Copyright © 2016年 Edu. All rights reserved.
//

#define KT @"yyyy年MM月dd日 HH:MM:ss"
#import "flowerViewController.h"
#import "SunDerTableViewCell.h"
#import "detailedViewController.h"
#import "WJCommboxView.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "RootTabbarViewController.h"
#import "MoneyHistoryTableViewController.h"
#import "LandingpageViewController.h"

#define kScreenWidth self.view.frame.size.width
#define kScreenHeight self.view.frame.size.height

#define kmagr 10.0f
#define klabelH 30.0f

@interface flowerViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    NSArray *teacherArray ;//老师
    NSMutableArray *picterArray ;//头像
    
    NSMutableArray *timeArray  ;//时间
    NSMutableArray *resultArray ;//理由
    NSMutableArray *schoolArray;//学校
    NSMutableArray *classArray;//班级
    NSMutableArray *subjectArray;//课程
    NSMutableArray *reasonArray;//内容
    NSMutableArray*flowersArray;//花
    //    MBProgressHUD *HUDH;
    NSString *flower_coin;
    NSString *flower_num;
    NSMutableArray *class_idMArr;
    NSMutableArray *conMArr;
    NSMutableArray *date_tmMArr;
    NSMutableArray *class_nameMArr;
    NSMutableArray *head_imgMArr;
    NSMutableArray *school_nameMArr;
    NSMutableArray *teach_coursMArr;
    NSMutableArray *tnameMArr;
    NSString *school_type;
    NSMutableArray *school_typeMArr;
    NSDateFormatter *fomatter;
    NSString *confromTimespStr;
    NSMutableArray *picMArr;
    NSMutableArray *collectConditMArr;
    NSMutableArray *idKTMArr;
    NSInteger x;
    
    NSInteger page;
    
    
    
}

@property (weak, nonatomic) IBOutlet UILabel *fnumber;
@property (weak, nonatomic) IBOutlet UILabel *xnumber;
@property (strong, nonatomic) IBOutlet UITableView *jiluTabelView;
@property(nonatomic,strong)WJCommboxView *cityCombox;
@property (strong ,nonatomic)NSMutableArray * dataArray;
@property (weak, nonatomic) IBOutlet UIButton *coinButton;
//已赠花数量
@property (nonatomic, copy) NSString *give_num;
//剩余花数量
@property (nonatomic, copy) NSString *flower_able;



@end

@implementation flowerViewController


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.cityCombox.textField removeObserver:self forKeyPath:@"text"];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initArray];
    
    page = 1;
    _give_num = @"";
    _flower_able = @"";

    [self.jiluTabelView reloadData];
    
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0, 170, 42)];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.jiluTabelView.header beginRefreshing];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    school_type =@"0";
    [self.navigationController.navigationBar setTintColor:UIColorFromRGB(255, 255, 255)];

    self.title =@"小红花";
    
    [self setNavigationBar];
    
    self.jiluTabelView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];

    
    self.jiluTabelView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooterNewData)];
    
    
    //猩币
    [self.coinButton addTarget:self action:@selector(coinButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.jiluTabelView.delegate=self;
    self.jiluTabelView.dataSource = self;
    UINib *nib = [UINib nibWithNibName:@"SunDerTableViewCell" bundle:nil];
    [self.jiluTabelView registerNib:nib forCellReuseIdentifier:@"cell"];
    self.cityArray = [[NSArray alloc]initWithObjects:@"全部",@"学校",@"培训机构",nil];
    self.saveBtnBackgroundImage = [UIImage imageNamed:@"收藏36x32"];
    //设置下拉菜单
    [self customcityCombox];
    
}

- (void)initArray{

    idKTMArr =[[NSMutableArray alloc]init];
    picMArr =[[NSMutableArray alloc]init];
    school_typeMArr =[[NSMutableArray alloc]init];
    flowersArray =[[NSMutableArray alloc]init];
    reasonArray=[[NSMutableArray alloc]init];
    subjectArray=[[NSMutableArray alloc]init];
    resultArray =[[NSMutableArray alloc]init];
    classArray=[[NSMutableArray alloc]init];
    schoolArray =[[NSMutableArray alloc]init];
    timeArray =[[NSMutableArray alloc]init];
    picterArray =[[NSMutableArray alloc]init];
    class_idMArr= [[NSMutableArray alloc]init];
    conMArr =[[NSMutableArray alloc]init];
    date_tmMArr =[[NSMutableArray alloc]init];
    class_nameMArr =[[NSMutableArray alloc]init];
    head_imgMArr =[[NSMutableArray alloc]init];
    school_nameMArr =[[NSMutableArray alloc]init];
    teach_coursMArr =[[NSMutableArray alloc]init];
    tnameMArr=[[NSMutableArray alloc]init];
    collectConditMArr =[[NSMutableArray alloc]init];
}


-(void)loadNewData{
    
    [self fetchNetData];
    [ _jiluTabelView.header endRefreshing];
}


- (void)loadFooterNewData{
    page ++ ;
    
    [self fetchNetData];
    [ _jiluTabelView.footer endRefreshing];
    
}

- (void)setNavigationBar{
    
    if ([self.flagStr isEqualToString:@"点评"]) {
        //1、设置 navigationBar 左边 返回
        UIImage *backImage = [UIImage imageNamed:@"首页90x38"];
        backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage: backImage  style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    }
    //    2、设置 navigationBar 标题 颜色
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
}
//返回
- (void)backClick{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)fetchNetData{
    /*
     【获得小红花赠送赠言记录】(详情页没有做接口,由前端页面之间传递)
     
     接口:
     http://www.xingxingedu.cn/Parent/take_flower_msg
     
     传参:
     
     baby_id		//孩子id
     school_type	//学校类型 0:查询所有 1:公立学校,2:机构
     */
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/take_flower_msg";
    
    //请求参数
    //获取宝贝id
    NSString *baby_idStr = [DEFAULTS objectForKey:@"BABYID"];
    
//    NSLog(@"%@", baby_idStr);
    
    NSString *pageStr = [NSString stringWithFormat:@"%ld", page];
    NSString *parameterXid;
    NSString *parameterUser_Id;
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"baby_id":baby_idStr, @"school_type":school_type, @"page":pageStr};

//    NSLog(@"传参  --  %@", params);
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
//        NSLog(@"请求 结果  -- %@", responseObj);
        
        if([[NSString stringWithFormat:@"%@",responseObj[@"code"]]isEqualToString:@"1"] ){
            [self initArray];
            
             NSDictionary *dict = responseObj[@"data"];
            
            if (dict[@"flower_coin"] == nil) {
                _give_num = @"";
            }else{
                _give_num = [NSString stringWithFormat:@"%@",dict[@"flower_coin"]];
            }
            
            if (dict[@"flower_num"] == nil) {
                _flower_able = @"";
            }else{
                _flower_able = [NSString stringWithFormat:@"%@",dict[@"flower_num"]];
            }

            NSArray * flowerArr =dict[@"list"];
            for (NSDictionary *dic in flowerArr) {
                [idKTMArr addObject:dic[@"id"]];
                
                //[collect_condit] => 1			//1:是收藏过这个商品  2:未收藏过
                [collectConditMArr addObject:dic[@"collect_condit"]];
                //小红花 里面 的图片 (可多张,用逗号拼接 )
                [picMArr addObject:dic[@"pic"]];
                [class_idMArr addObject:dic[@"class_id"]];
                [class_nameMArr addObject:dic[@"class_name"]];
                [conMArr addObject:dic[@"con"]];
                NSString *dateStr = [WZYTool dateStringFromNumberTimer:dic[@"date_tm"]];
                [date_tmMArr addObject:dateStr];
                
                NSString * head_img;
                if([[NSString stringWithFormat:@"%@",dic[@"head_img_type"]]isEqualToString:@"0"]){
                    head_img=[picURL stringByAppendingString:dic[@"head_img"]];
                }else{
                    head_img=dic[@"head_img"];
                }
                
                [head_imgMArr addObject:head_img];
                [school_nameMArr addObject:dic[@"school_name"]];
                [teach_coursMArr addObject:dic[@"teach_course"]];
                [tnameMArr addObject:dic[@"tname"]];
                [school_typeMArr addObject:dic[@"school_type"]];
                
            }
        }
        
        [self customContent];
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
        
        [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
        
    }];
    
    
}



// 有数据 和 无数据 进行判断
- (void)customContent{
    
    _fnumber.text = _give_num;
    _xnumber.text = _flower_able;
    
    if (school_nameMArr.count == 0) {
        
        // 1、无数据的时候
        UIImage *myImage = [UIImage imageNamed:@"人物"];
        CGFloat myImageWidth = myImage.size.width;
        CGFloat myImageHeight = myImage.size.height;
        
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - myImageWidth / 2, (kHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
        myImageView.image = myImage;
        [self.view addSubview:myImageView];
        
    }else{
        //2、有数据的时候
        
    }
    [_jiluTabelView reloadData];

}



//设置下拉菜单
- (void)customcityCombox{
    self.cityCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(kmagr, kmagr/2, 120, klabelH)];
    
    //右边图片
    UIImageView *myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(- kmagr/2, kmagr, kmagr,kmagr)];
    myImageView.image = [UIImage imageNamed:@"下拉键24x18.png"];
    //    self.cityCombox.textField.rightView = myImageView;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(125, 5, 12, 30)];
    self.cityCombox.textField.rightView = paddingView;
    [paddingView addSubview:myImageView];
    self.cityCombox.textField.background = [UIImage imageNamed:@"线框270x60.png"];
    self.cityCombox.textField.rightViewMode = UITextFieldViewModeAlways;
    self.cityCombox.textField.adjustsFontSizeToFitWidth=YES;
    self.cityCombox.textField.contentScaleFactor=1;
    self.cityCombox.textField.placeholder = @"全部";
    
    [self.cityCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    
    self.cityCombox.textField.textAlignment = NSTextAlignmentCenter;
    self.cityCombox.textField.tag = 101;
    self.cityCombox.textField.borderStyle = UITextBorderStyleNone;
    self.cityCombox.textField.layer.cornerRadius = 15;
    self.cityCombox.textField.layer.masksToBounds = YES;
    self.cityCombox.dataArray = self.cityArray;
    self.cityCombox.listTableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.cityCombox];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    
    [idKTMArr removeAllObjects];
    [picMArr removeAllObjects];
    [school_typeMArr removeAllObjects];
    [flowersArray removeAllObjects];
    [reasonArray removeAllObjects];
    [subjectArray removeAllObjects];
    [resultArray removeAllObjects];
    [classArray removeAllObjects];
    [schoolArray removeAllObjects];
    [timeArray removeAllObjects];
    [picterArray removeAllObjects];
    [class_idMArr removeAllObjects];
    [conMArr removeAllObjects];
    [date_tmMArr removeAllObjects];
    [class_nameMArr removeAllObjects];
    [head_imgMArr removeAllObjects];
    [school_nameMArr removeAllObjects];
    [teach_coursMArr removeAllObjects];
    [tnameMArr removeAllObjects];
    [collectConditMArr removeAllObjects];
    
    page = 1;
    
    if ([keyPath isEqualToString:@"text"]) {
        NSString * newName=[change objectForKey:@"new"];
        if ([newName isEqualToString:@"全部"]) {
            
            school_type=@"0";
            
            [self fetchNetData];
        }
        else if ([newName isEqualToString:@"学校"]){
            school_type=@"1";
            [self fetchNetData];
            
        }
        else{
            school_type=@"2";
            [self fetchNetData];
        }
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    return school_nameMArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.jiluTabelView) {
        SunDerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell==nil){
            cell=[[SunDerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            
        }
        [cell.Rphone sd_setImageWithURL:[NSURL URLWithString:head_imgMArr[indexPath.row]] placeholderImage:[UIImage imageNamed:@"人物头像172x172"]];
        
        cell.Rphone.layer.cornerRadius = cell.Rphone.frame.size.width / 2;
        cell.Rphone.layer.masksToBounds = YES;
        cell.TLabel.text = [NSString stringWithFormat:@"%@ / %@ / %@",tnameMArr[indexPath.row],teach_coursMArr[indexPath.row],class_nameMArr[indexPath.row]];
        
        cell.TimeLabel.text =[NSString stringWithFormat:@"%@",date_tmMArr[indexPath.row]];
        
        cell.reasonLabel.text = [NSString stringWithFormat:@"赠言: %@",conMArr[indexPath.row]];
        
//        NSLog(@"%ld", indexPath.row);
//        
//        NSLog(@"收藏  -- %@", collectConditMArr[indexPath.row]);
        
        if ([collectConditMArr[indexPath.row] isEqualToNumber:@1]) {
            
            [cell.saveBtn setBackgroundImage:[UIImage imageNamed:@"commentCollecthigh36"] forState:UIControlStateNormal ];
        }
        else if ([collectConditMArr[indexPath.row] isEqualToNumber:@2])
        {
            [cell.saveBtn setBackgroundImage:[UIImage imageNamed:@"commentCollect36"] forState:UIControlStateNormal ];
            
        }
        
        return cell;
    }else if (tableView == self.cityCombox.listTableView){
        
        
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([XXEUserInfo user].login) {

    if (tableView == self.jiluTabelView) {
             
        detailedViewController *detailVC =[[detailedViewController alloc]init];
        detailVC.name =tnameMArr[indexPath.row];
        detailVC.time = date_tmMArr[indexPath.row];
        detailVC.schoolName =school_nameMArr[indexPath.row];
        detailVC.className =class_nameMArr[indexPath.row];
        detailVC.couseName =teach_coursMArr[indexPath.row];
        detailVC.text =conMArr[indexPath.row];
        detailVC.imageName =head_imgMArr[indexPath.row];
        detailVC.imageStr =picMArr[indexPath.row];
        detailVC.i =collectConditMArr[indexPath.row];
        detailVC.idKT =idKTMArr[indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}else{
        [SVProgressHUD showInfoWithStatus:@"请用账号登录后查看"];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}


//猩币 跳转
- (void)coinButtonClick{
    if ([XXEUserInfo user].login) {
        //    //猩猩商城返回出问题
        MoneyHistoryTableViewController *moneyHistoryTableVC =[[MoneyHistoryTableViewController alloc]init];
        moneyHistoryTableVC.hidesBottomBarWhenPushed =YES;
        [self.navigationController pushViewController:moneyHistoryTableVC animated:YES];

    }else{
        [SVProgressHUD showInfoWithStatus:@"请用账号登录后查看"];
    }
    
}


@end

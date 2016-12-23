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
#import "XXERedFlowerModel.h"

#define kScreenWidth self.view.frame.size.width
#define kScreenHeight self.view.frame.size.height

#define kmagr 10.0f
#define klabelH 30.0f

@interface flowerViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    NSString *flower_coin;
    NSString *flower_num;
    NSString *school_type;
    NSDateFormatter *fomatter;
    NSString *confromTimespStr;
    NSMutableArray *picMArr;
    NSInteger x;
    
    NSInteger page;
    UIImageView *placeholderImageView;
    
    //
    NSMutableArray *dataSourceArray;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
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
    
    page = 0;
    _give_num = @"";
    _flower_able = @"";
    if (dataSourceArray.count != 0) {
        [dataSourceArray removeAllObjects];
    }

    [self.jiluTabelView reloadData];
    
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0, 170, 42)];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.jiluTabelView.header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    dataSourceArray = [[NSMutableArray alloc] init];
    self.cityArray = [[NSArray alloc]initWithObjects:@"全部",@"学校",@"培训机构",nil];
    school_type =@"0";
    [self.navigationController.navigationBar setTintColor:UIColorFromRGB(255, 255, 255)];

    self.title =@"小红花";
    
    [self setNavigationBar];
    
    //设置 tableview
    self.jiluTabelView.delegate=self;
    self.jiluTabelView.dataSource = self;
    UINib *nib = [UINib nibWithNibName:@"SunDerTableViewCell" bundle:nil];
    [self.jiluTabelView registerNib:nib forCellReuseIdentifier:@"cell"];
    self.jiluTabelView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.jiluTabelView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooterNewData)];
    
    //猩币
    [self.coinButton addTarget:self action:@selector(coinButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.saveBtnBackgroundImage = [UIImage imageNamed:@"收藏36x32"];
    //设置下拉菜单
    [self customcityCombox];
    
}


-(void)loadNewData{
    page ++ ;
    [self fetchNetData];
    [ _jiluTabelView.header endRefreshing];
}


- (void)loadFooterNewData{
    page ++ ;
    
    [self fetchNetData];
    [ _jiluTabelView.footer endRefreshing];
    
}

-(void)endRefresh{
    [_jiluTabelView.header endRefreshing];
    [_jiluTabelView.footer endRefreshing];
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
     page		//加载更多
     */
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/take_flower_msg";
    
    //请求参数
    //获取宝贝id
    NSString *baby_idStr = [DEFAULTS objectForKey:@"BABYID"];
    
//    NSLog(@"%@", baby_idStr);
    
    NSString *pageStr = [NSString stringWithFormat:@"%ld", page];

    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"baby_id":baby_idStr, @"school_type":school_type, @"page":pageStr};

//    NSLog(@"传参  --  %@", params);
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
//        NSLog(@"请求 结果  -- %@", responseObj);
        
        if([[NSString stringWithFormat:@"%@",responseObj[@"code"]]isEqualToString:@"1"] ){
           
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

            _fnumber.text = _give_num;
            _xnumber.text = _flower_able;
            
            NSArray * flowerArr =dict[@"list"];
            
            if (flowerArr.count != 0) {
                NSArray *arr = [[NSArray alloc] init];
                arr = [XXERedFlowerModel parseResondsData:flowerArr];
                [dataSourceArray addObjectsFromArray:arr];
            }
        }
        
        
        [self customContent];
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
        
    }];
    
    
}



// 有数据 和 无数据 进行判断
- (void)customContent{
    // 如果 有占位图 先 移除
    [self removePlaceholderImageView];
    
    if (dataSourceArray.count == 0) {
        _jiluTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 1、无数据的时候
        [self createPlaceholderView];
        
    }else{
        //2、有数据的时候
    }
    
    [_jiluTabelView reloadData];
    
}


//没有 数据 时,创建 占位图
- (void)createPlaceholderView{
    // 1、无数据的时候
    UIImage *myImage = [UIImage imageNamed:@"人物"];
    CGFloat myImageWidth = myImage.size.width;
    CGFloat myImageHeight = myImage.size.height;
    
    placeholderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - myImageWidth / 2, (kHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
    placeholderImageView.image = myImage;
    [self.view addSubview:placeholderImageView];
}

//去除 占位图
- (void)removePlaceholderImageView{
    if (placeholderImageView != nil) {
        [placeholderImageView removeFromSuperview];
    }
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
    
    [dataSourceArray removeAllObjects];

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
    
    return dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.jiluTabelView) {
        SunDerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell==nil){
            cell=[[SunDerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            
        }
        XXERedFlowerModel *model = dataSourceArray[indexPath.row];
        
//        NSLog(@"model /// %@", model);
        
        /*
         0 :表示 自己 头像 ，需要添加 前缀
         1 :表示 第三方 头像 ，不需要 添加 前缀
         //判断是否是第三方头像
         */
        NSString *headImage;
        
        if ([model.head_img_type integerValue] == 0) {
            headImage = [NSString stringWithFormat:@"%@%@", picURL, model.head_img];
        }else if ([model.head_img_type integerValue] == 1){
            headImage = [NSString stringWithFormat:@"%@", model.head_img];
        }
    
        [cell.Rphone sd_setImageWithURL:[NSURL URLWithString:headImage] placeholderImage:[UIImage imageNamed:@"人物头像172x172"]];
        
        cell.Rphone.layer.cornerRadius = cell.Rphone.frame.size.width / 2;
        cell.Rphone.layer.masksToBounds = YES;
        cell.TLabel.text = [NSString stringWithFormat:@"%@ / %@ / %@",model.tname,model.teach_course,model.class_name];
        
        cell.TimeLabel.text =[NSString stringWithFormat:@"%@",[WZYTool dateStringFromNumberTimer:model.date_tm]];
        
        cell.reasonLabel.text = [NSString stringWithFormat:@"赠言:%@",model.con];
        
//        NSLog(@"model.collect_codit == %@", model.collect_codit);
        
        if ([model.collect_condit integerValue] == 1) {
            
            [cell.saveBtn setBackgroundImage:[UIImage imageNamed:@"commentCollecthigh36"] forState:UIControlStateNormal ];
        }
        else if ([model.collect_condit integerValue] == 2)
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
        XXERedFlowerModel *model = dataSourceArray[indexPath.row];

        detailVC.model = model;
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

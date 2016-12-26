

//
//  XXEXingCommunityKindergartenViewController.m
//  teacher
//
//  Created by Mac on 16/9/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEXingCommunityKindergartenViewController.h"
#import "XXEXingCommunityClassesTableViewCell.h"
#import "XXEXingCommunityClassesModel.h"
#import "XXEKindergartenDetailViewController.h"


@interface XXEXingCommunityKindergartenViewController ()<UITableViewDelegate, UITableViewDataSource>
{

    UITableView *_myTableView;
    NSMutableArray *_dataSourceArray;
    
    UIImageView *placeholderImageView;
    
    NSInteger page;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;

}


@end

@implementation XXEXingCommunityKindergartenViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (_dataSourceArray.count == 0) {
        [_dataSourceArray removeAllObjects];
    }
    page = 1;
    
//    NSLog(@"page == %ld", page);
    
    //获取 数据
    [self fetchNetData];

    [_myTableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    
    _dataSourceArray = [[NSMutableArray alloc] init];
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    [self createTableView];
    
}


#pragma mark ======== 获取数据 ============
- (void)fetchNetData{
/*
 【文章列表页】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Global/xtd_article_list
 传参:
 //1:幼儿园  2:小学  3:初中  4:培训机构  5:高中  不传默认1
	page	//分页,不传默认1
 */
    //幼儿园
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/xtd_article_list";
    NSString *pageStr = [NSString stringWithFormat:@"%ld", page];
    
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE,
                             @"class":@"1",
                             @"page":pageStr
                             };
    
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
//        NSLog(@"幼儿园 数据 === %@", responseObj);
        
        if ([responseObj[@"code"] integerValue] == 1) {
            NSArray *modelArray = [NSArray array];
           modelArray = [XXEXingCommunityClassesModel parseResondsData:responseObj[@"data"]];
            
            [_dataSourceArray addObjectsFromArray:modelArray];
        }
        [self customContent];
        
    } failure:^(NSError *error) {
        //
        [self showString:@"获取数据失败!" forSecond:1.5];
    }];
    
    
}


// 有数据 和 无数据 进行判断
- (void)customContent{
    // 如果 有占位图 先 移除
    [self removePlaceholderImageView];
    
    if (_dataSourceArray.count == 0) {
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 1、无数据的时候
        [self createPlaceholderView];
        
    }else{
        //2、有数据的时候
    }
    
    [_myTableView reloadData];
    
}


//没有 数据 时,创建 占位图
- (void)createPlaceholderView{
    // 1、无数据的时候
    UIImage *myImage = [UIImage imageNamed:@"人物"];
    CGFloat myImageWidth = myImage.size.width;
    CGFloat myImageHeight = myImage.size.height;
    
    placeholderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - myImageWidth / 2, (kHeight - 210 * kScreenRatioHeight) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
    placeholderImageView.image = myImage;
    [self.view addSubview:placeholderImageView];
}

//去除 占位图
- (void)removePlaceholderImageView{
    if (placeholderImageView != nil) {
        [placeholderImageView removeFromSuperview];
    }
}

- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 220 * kScreenRatioHeight) style:UITableViewStyleGrouped];
    
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    
    [self.view addSubview:_myTableView];
    
    _myTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    _myTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooterNewData)];
}

-(void)loadNewData{
    page ++;
    
    [self fetchNetData];
    [ _myTableView.header endRefreshing];
}
-(void)endRefresh{
    [_myTableView.header endRefreshing];
    [_myTableView.footer endRefreshing];
}

- (void)loadFooterNewData{
    page ++ ;
    
    [self fetchNetData];
    [ _myTableView.footer endRefreshing];
    
}


#pragma mark
#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataSourceArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXEXingCommunityClassesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[XXEXingCommunityClassesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    XXEXingCommunityClassesModel *model = _dataSourceArray[indexPath.row];
    
    NSString *coursePicStr = [NSString stringWithFormat:@"%@%@", kXXEPicURL, model.pic];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:coursePicStr] placeholderImage:[UIImage imageNamed:@"书icon80x80"]];

    cell.titleLabel.text = model.title;
    
    cell.summaryLabel.text = model.summary;

    cell.timeLabel.text = [WZYTool dateStringFromNumberTimer:model.date_tm];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 95;
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XXEKindergartenDetailViewController *kindergartenDetailVC = [[XXEKindergartenDetailViewController alloc] init];
    XXEXingCommunityClassesModel *model = _dataSourceArray[indexPath.row];
    /*
     cat	//分类,1:幼儿园  2:小学  3:中学  4:培训机构
     id	//文章id
     */
    kindergartenDetailVC.cat = @"1";
    kindergartenDetailVC.articleId = model.articleId;
    [self.navigationController pushViewController:kindergartenDetailVC animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

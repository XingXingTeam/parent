//
//  FlowerBasketViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/3/24.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define KT @"yyyy年MM月dd日 HH:MM:ss"
#define kPData  @"FlowerBascketCell"
#import "FlowerBasketViewController.h"
#import "FlowersPresentViewController.h"
#import "FlowersBuyViewController.h"
#import "FlowerBascketCell.h"
#import "SendFlowerBaskerDetailController.h"
#import "XXEFlowerbasketModel.h"


@interface FlowerBasketViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
//    NSInteger x;
//    NSMutableArray *_dateMArr;
    //花篮 赠送 明细 model 数组
    NSMutableArray *_dataSourceArray;

    NSString *confromTimespStr;
    NSInteger j;
    NSString *fbasketStr;
    NSString *basketStr;
    UILabel *leftLb;
    UILabel *overLb;
    NSString *flowersNum;
    //没有数据的时候 占位图
    UIImageView *placeholderImageView;
    
    NSInteger page;
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
}
@end

@implementation FlowerBasketViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_dataSourceArray.count != 0) {
        [_dataSourceArray removeAllObjects];
    }
    page = 0;
    [self fetchNetData];
    //获取 花篮赠送/购买 数据
    [self fetchBasketInfo];
    [_tableView reloadData];
    [_tableView.header beginRefreshing];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    _dataSourceArray = [[NSMutableArray alloc] init];
    
    self.title =@"花篮";

     [self createHeaderView];
    
     [self createTableView];
    

}


#pragma mark ====== //获取 花篮赠送/购买 数据 ======
- (void)fetchBasketInfo{
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/getUserGlobalInfo";
    NSDictionary *params = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"field":@"fbasket_able,fbasket_total",
                           };
    
//    NSLog(@"params == %@", params);
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        
//        NSLog(@"花篮kkk  == %@", responseObj);
        
        if([[NSString stringWithFormat:@"%@",responseObj[@"code"]]isEqualToString:@"1"] )
        {
            
            NSDictionary *dict =responseObj[@"data"];
            leftLb.text=[NSString stringWithFormat:@"剩余花篮数: %@", dict[@"fbasket_able"]];
            flowersNum =[NSString stringWithFormat:@"%@", dict[@"fbasket_able"]];
            overLb.text =[NSString stringWithFormat:@"已赠花篮数: %ld",[dict[@"fbasket_total"] integerValue] - [dict[@"fbasket_able"] integerValue]];
            
//            [_tableView reloadData];
        }
       
        
    } failure:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"获取数据失败!"];
    }];
    
}

#pragma mark ======== 【猩猩商城--花篮赠送明细】========
- (void)fetchNetData{
    
    NSString *pageStr = [NSString stringWithFormat:@"%ld", page];
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/fbasket_record";
    NSDictionary *params = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"page": pageStr
                           };
//    NSLog(@"params ****** %@", params);
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        
        NSDictionary *dict =responseObj;
        
//        NSLog(@"花篮 == %@", responseObj);
        
        
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
            
            NSArray *modelArr = [NSArray array];
            modelArr = [XXEFlowerbasketModel parseResondsData:dict[@"data"]];
            [_dataSourceArray addObjectsFromArray:modelArr];

        }
        
        [self customContent];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"获取数据失败!"];
    }];
    
}

// 有数据 和 无数据 进行判断
- (void)customContent{
    // 如果 有占位图 先 移除
    [self removePlaceholderImageView];
    
    if (_dataSourceArray.count == 0) {
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 1、无数据的时候
        [self createPlaceholderView];
        
    }else{
        //2、有数据的时候

    }
    
    [_tableView reloadData];
    
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

- (void)createHeaderView{
 
    UIView *headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 55)];
    [self.view addSubview:headView];
    
    UIButton *sentBtn =[HHControl createButtonWithFrame:CGRectMake(0, 0, kWidth / 2, 30) backGruondImageName:nil Target:self Action:@selector(sentBtnClick:) Title:@"赠送"];
    sentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sentBtn setTitleColor:UIColorFromRGB(0, 170, 42) forState:UIControlStateNormal];
    [headView addSubview:sentBtn];
    
    UIButton *buyBtn =[HHControl createButtonWithFrame:CGRectMake(kWidth/2, 0, kWidth / 2, 30) backGruondImageName:nil Target:self Action:@selector(buy:) Title:@"购买"];
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [buyBtn setTitleColor:UIColorFromRGB(0, 170, 42) forState:UIControlStateNormal];
    [headView addSubview:buyBtn];
    
    leftLb =[HHControl createLabelWithFrame:CGRectMake(0, 30, kWidth / 2, 15) Font:10 Text:[NSString stringWithFormat:@"剩余花篮数: %ld", (long)[fbasketStr integerValue]]];
    [leftLb setTextColor:[UIColor lightGrayColor]];
    leftLb.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:leftLb];
    
    overLb =[HHControl createLabelWithFrame:CGRectMake(kWidth / 2, 30, kWidth / 2, 15) Font:10 Text:[NSString stringWithFormat:@"已赠花篮数: %ld",[basketStr integerValue]-[fbasketStr integerValue]]];
    [overLb setTextColor:[UIColor lightGrayColor]];
    overLb.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:overLb];
    
    //投影750x4
    UIImageView *lineOne = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - 1, 0, 1, 45)];
    lineOne.image = [UIImage imageNamed:@"投影750x4"];
    UIImageView *lineTwo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45, kWidth, 1)];
    lineTwo.image = [UIImage imageNamed:@"投影750x4"];
    [headView addSubview:lineOne];
    [headView addSubview:lineTwo];
    
}


- (void)createTableView{
    
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 55, kWidth, kHeight - 55) style:UITableViewStyleGrouped];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    [self.view addSubview:_tableView];

    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooterNewData)];
    
}

-(void)loadNewData{
    page ++;
    
    [self fetchNetData];
    [ _tableView.header endRefreshing];
}
-(void)endRefresh{
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
}

- (void)loadFooterNewData{
    page ++ ;
    
    [self fetchNetData];
    [ _tableView.footer endRefreshing];
    
}

#pragma mark ========= 赠送 花篮 ============
- (void)sentBtnClick:(UIButton*)btn{
    FlowersPresentViewController *flowersPresentVC =[[FlowersPresentViewController alloc]init];
    flowersPresentVC.flowersRemain =flowersNum;
    [self.navigationController pushViewController:flowersPresentVC animated:NO];
    
}
- (void)buy:(UIButton*)bt{
    
    if ([XXEUserInfo user].login) {
        FlowersBuyViewController *flowerBuyVC =[[FlowersBuyViewController alloc]init];
        flowerBuyVC.flowersRemain =flowersNum;
        [self.navigationController pushViewController:flowerBuyVC animated:NO];
        
    }else{
        [SVProgressHUD showInfoWithStatus:@"请用账号登录后查看"];
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataSourceArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FlowerBascketCell *cell =(FlowerBascketCell*)[tableView dequeueReusableCellWithIdentifier:kPData];
    
    if (!cell) {
        NSArray *nib =[[NSBundle mainBundle]loadNibNamed:kPData owner:[FlowerBascketCell class] options:nil];
        cell =(FlowerBascketCell*)[nib objectAtIndex:0];
        
    }
    XXEFlowerbasketModel *model = _dataSourceArray[indexPath.row];
    
    cell.imageV.layer.cornerRadius = cell.imageV.frame.size.width / 2;
    cell.imageV.layer.masksToBounds =YES;
    /*
     0 :表示 自己 头像 ，需要添加 前缀
     1 :表示 第三方 头像 ，不需要 添加 前缀
     //判断是否是第三方头像
     */
    NSString *headImage;
    if ([model.head_img_type integerValue] == 0) {
        headImage = [NSString stringWithFormat:@"%@%@", picURL , model.head_img];
    }else if ([model.head_img_type integerValue] == 1){
        headImage = [NSString stringWithFormat:@"%@", model.head_img];
    }
    
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:headImage] placeholderImage:[UIImage imageNamed:@"LOGO172x172"]];
    
    
    cell.teacherLabel.text = model.tname;
    cell.numLabel.text =[NSString stringWithFormat:@"花篮: %@",model.num];
    cell.textLabe.text =[NSString stringWithFormat:@"赠言: %@",model.con];

    cell.timeLbl.text =[NSString stringWithFormat:@"%@",[WZYTool dateStringFromNumberTimer:model.date_tm]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     XXEFlowerbasketModel *model = _dataSourceArray[indexPath.row];
    
    if ([XXEUserInfo user].login) {
        
        SendFlowerBaskerDetailController *SendFlowerBaskerDetailVC = [[SendFlowerBaskerDetailController alloc] init];
        SendFlowerBaskerDetailVC.teacherLabel = model.tname;
        SendFlowerBaskerDetailVC.numLabel = model.num;
        SendFlowerBaskerDetailVC.timeLbl = model.date_tm;
        SendFlowerBaskerDetailVC.textLabe = model.con;
        [self.navigationController pushViewController:SendFlowerBaskerDetailVC animated:YES];
    }else{
        [SVProgressHUD showInfoWithStatus:@"请用账号登录后查看"];
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

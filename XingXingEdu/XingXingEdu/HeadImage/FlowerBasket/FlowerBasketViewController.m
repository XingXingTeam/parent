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
@interface FlowerBasketViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSInteger x;
    NSMutableArray *_dateMArr;

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
    
    [_tableView reloadData];
    [_tableView.header beginRefreshing];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(196, 213, 255);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    page = 0;
    self.title =@"花篮";
    
    //获取 花篮赠送/购买 数据
    [self fetchBasketInfo];
    
//    [self createHeadView];
    
     [self fetchNetData];
    
     [self createTableView];
    // Do any additional setup after loading the view.
    
}
- (void)createHeadView{
    //headView
    UIView *headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 55)];
    
    UIButton *sentBtn =[HHControl createButtonWithFrame:CGRectMake(0, 0, kWidth / 2, 30) backGruondImageName:nil Target:self Action:@selector(sent:) Title:@"赠送"];
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
    //    overLb.backgroundColor = [UIColor blueColor];
    overLb.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:overLb];
    
    //投影750x4
    UIImageView *lineOne = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - 1, 0, 1, 45)];
    lineOne.image = [UIImage imageNamed:@"投影750x4"];
    UIImageView *lineTwo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45, kWidth, 1)];
    lineTwo.image = [UIImage imageNamed:@"投影750x4"];
    [headView addSubview:lineOne];
    
    _tableView.tableHeaderView =headView;
    
    
}

- (void)fetchBasketInfo{
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/getUserGlobalInfo";
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"field":@"fbasket_able,fbasket_total",
                           };
    
    [WZYHttpTool post:urlStr params:dict success:^(id responseObj) {
        
//        NSLog(@"花篮kkk  == %@", responseObj);
        
        NSDictionary *dict =responseObj;
        
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
            leftLb.text=[NSString stringWithFormat:@"剩余花篮数: %ld", [[dict[@"data"] objectForKey:@"fbasket_able"] integerValue]];
            flowersNum =[NSString stringWithFormat:@"%ld", [[dict[@"data"] objectForKey:@"fbasket_able"] integerValue]];
            overLb.text =[NSString stringWithFormat:@"已赠花篮数: %ld",[[dict[@"data"] objectForKey:@"fbasket_total"] integerValue] -[[dict[@"data"] objectForKey:@"fbasket_able"] integerValue]];
            
//            [_tableView reloadData];
        }
        [self createHeadView];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"获取数据失败!"];
    }];
    
}

- (void)fetchNetData{

    _dateMArr = [NSMutableArray array];
    
    NSString *pageStr = [NSString stringWithFormat:@"%ld", page];
    //teacher
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/fbasket_record";
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"page": pageStr
                           };
    
    [WZYHttpTool post:urlStr params:dict success:^(id responseObj) {
        
        NSDictionary *dict =responseObj;
        
//        NSLog(@"花篮 == %@", responseObj);
        
        
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
            
            x =[dict[@"data"] count];
            for (int i=0; i<[dict[@"data"] count]; i++) {
                
                NSString *con = [dict[@"data"][i] objectForKey:@"con"];
                NSString *date_tm = [dict[@"data"][i] objectForKey:@"date_tm"];
                NSString *head_img_type = [dict[@"data"][i] objectForKey:@"head_img_type"];
                NSString *head_img = [dict[@"data"][i] objectForKey:@"head_img"];
                NSString *sendId = [dict[@"data"][i] objectForKey:@"id"];
                NSString *num = [dict[@"data"][i] objectForKey:@"num"];
                NSString *tname = [dict[@"data"][i] objectForKey:@"tname"];
                
                NSMutableArray *arr=[NSMutableArray arrayWithObjects:con,date_tm,head_img_type,head_img,sendId, num,tname,nil];
                [_dateMArr addObject:arr];
        
            }
            
//            [_tableView reloadData];
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
    
    if (_dateMArr.count == 0) {
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 1、无数据的时候
        [self createPlaceholderView];
        
    }else{
        //2、有数据的时候
//        [AppDelegate shareAppDelegate].friendsArray = self.friendListDatasource;
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


- (void)createTableView{
    
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
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


- (void)sent:(UIButton*)btn{
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
    
    return x;
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
    
    NSArray *tmp = _dateMArr[indexPath.row];
    
    cell.imageV.layer.cornerRadius =30;
    cell.imageV.layer.masksToBounds =YES;
    
    if ([tmp[2] isEqualToString:@"0"]) {
        [cell.imageV sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picURL,tmp[3]]] placeholderImage:[UIImage imageNamed:@"LOGO172x172@2x"]];

    }else{
         [cell.imageV sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@",tmp[3]]] placeholderImage:[UIImage imageNamed:@"LOGO172x172@2x"]];
    }
    
    
    cell.teacherLabel.text =tmp[6];
    cell.numLabel.text =[NSString stringWithFormat:@"花篮: %@",tmp[5]];
    cell.textLabe.text =[NSString stringWithFormat:@"赠言: %@",tmp[0]];

    cell.timeLbl.text =[NSString stringWithFormat:@"%@",[WZYTool dateStringFromNumberTimer:tmp[1]]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([XXEUserInfo user].login) {
        
        SendFlowerBaskerDetailController *SendFlowerBaskerDetailVC = [[SendFlowerBaskerDetailController alloc] init];
        SendFlowerBaskerDetailVC.teacherLabel = _dateMArr[indexPath.row][6];
        SendFlowerBaskerDetailVC.numLabel = _dateMArr[indexPath.row][5];
        SendFlowerBaskerDetailVC.timeLbl = _dateMArr[indexPath.row][1];
        SendFlowerBaskerDetailVC.textLabe = _dateMArr[indexPath.row][0];
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

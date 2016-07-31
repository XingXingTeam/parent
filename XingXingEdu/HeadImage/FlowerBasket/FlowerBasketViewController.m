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
#import "HHControl.h"
#import "MJRefresh.h"
@interface FlowerBasketViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSInteger x;
    NSMutableArray *conMArr;
    NSMutableArray *date_tmMArr;
    NSMutableArray *head_imgMArr;
    NSMutableArray *idMArr;
    NSMutableArray *numMArr;
    NSMutableArray *tnameMArr;
    NSDateFormatter *fomatter;
    NSString *confromTimespStr;
    NSInteger j;
    NSString *fbasketStr;
    NSString *basketStr;
    UILabel *leftLb;
    UILabel *overLb;
    NSString *flowersNum;
    
}
@end

@implementation FlowerBasketViewController
- (void)viewWillAppear:(BOOL)animated{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self createTableView];
    [self initData];
    
    [self createHeadView];
    [self initUI];
    
    [_tableView reloadData];
    [_tableView.header beginRefreshing];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    conMArr =[[NSMutableArray alloc]init];
    date_tmMArr =[[NSMutableArray alloc]init];
    head_imgMArr =[[NSMutableArray alloc]init];
    idMArr =[[NSMutableArray alloc]init];
    numMArr =[[NSMutableArray alloc]init];
    tnameMArr =[[NSMutableArray alloc]init];
    fomatter =[[NSDateFormatter alloc]init];
    [fomatter setDateStyle:NSDateFormatterMediumStyle];
    [fomatter setTimeStyle:NSDateFormatterShortStyle];
    [fomatter setDateFormat:KT];
    
    self.title =@"花篮";
    self.view.backgroundColor = UIColorFromRGB(196, 213, 255);
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

- (void)initUI{
    
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/getUserGlobalInfo";
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"field":@"fbasket_able,fbasket_total",
                           };
    
    [WZYHttpTool post:urlStr params:dict success:^(id responseObj) {
        
        
        
        NSDictionary *dict =responseObj;
        
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
            leftLb.text=[NSString stringWithFormat:@"剩余花篮数: %ld", [[dict[@"data"] objectForKey:@"fbasket_able"] integerValue]];
            flowersNum =[NSString stringWithFormat:@"%ld", [[dict[@"data"] objectForKey:@"fbasket_able"] integerValue]];
            overLb.text =[NSString stringWithFormat:@"已赠花篮数: %ld",[[dict[@"data"] objectForKey:@"fbasket_total"] integerValue] -[[dict[@"data"] objectForKey:@"fbasket_able"] integerValue]];
            
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}
- (void)initData{
    
    //teacher
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/fbasket_record";
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           };
    
    [WZYHttpTool post:urlStr params:dict success:^(id responseObj) {
        
        NSDictionary *dict =responseObj;
        
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
            
            x =[dict[@"data"] count];
            for (int i=0; i<[dict[@"data"] count]; i++) {
                
                [conMArr addObject:[dict[@"data"][i] objectForKey:@"con"]];
                [date_tmMArr addObject:[dict[@"data"][i] objectForKey:@"date_tm"]];
                [head_imgMArr addObject:[dict[@"data"][i] objectForKey:@"head_img"]];
                [idMArr addObject:[dict[@"data"][i] objectForKey:@"id"]];
                [numMArr addObject:[dict[@"data"][i] objectForKey:@"num"]];
                [tnameMArr addObject:[dict[@"data"][i] objectForKey:@"tname"]];
                
            }
            
            [_tableView reloadData];
            [_tableView.header endRefreshing];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)createTableView{
    
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    [self.view addSubview:_tableView];
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
}
-(void)loadNewData{
    [self initData];
    
}

- (void)sent:(UIButton*)btn{
    FlowersPresentViewController *flowersPresentVC =[[FlowersPresentViewController alloc]init];
    flowersPresentVC.flowersRemain =flowersNum;
    [self.navigationController pushViewController:flowersPresentVC animated:NO];
    
}
- (void)buy:(UIButton*)bt{
    
    FlowersBuyViewController *flowerBuyVC =[[FlowersBuyViewController alloc]init];
    flowerBuyVC.flowersRemain =flowersNum;
    [self.navigationController pushViewController:flowerBuyVC animated:NO];
    
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
    cell.imageV.layer.cornerRadius =30;
    cell.imageV.layer.masksToBounds =YES;
    
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picURL,head_imgMArr[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"LOGO172x172@2x"]];
    cell.teacherLabel.text =tnameMArr[indexPath.row];
    cell.numLabel.text =[NSString stringWithFormat:@"花篮: %@",numMArr[indexPath.row]];
    cell.textLabe.text =[NSString stringWithFormat:@"赠言: %@",conMArr[indexPath.row]];
    j =[NSString stringWithFormat:@"%@",date_tmMArr[indexPath.row]].integerValue;
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:j];
    confromTimespStr = [fomatter stringFromDate:confromTimesp];
    cell.timeLbl.text =[NSString stringWithFormat:@"%@",confromTimespStr];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

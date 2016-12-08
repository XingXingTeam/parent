//
//  CharactersViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/5/19.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define KPATA @"SunDerTableViewCell"
#import "CharactersViewController.h"
#import "CheractersNextViewController.h"
#import "SunDerTableViewCell.h"
#import "detailedViewController.h"
#import "LandingpageViewController.h"
#import "XXERedFlowerModel.h"

@interface CharactersViewController ()<UITableViewDataSource,UITableViewDelegate, UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *dataSourceArray;
    
    UIImageView *placeholderImageView;
    
    NSInteger page;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *collectionId;


@end

@implementation CharactersViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    page = 0;
    
    if (dataSourceArray.count != 0) {
        [dataSourceArray removeAllObjects];
    }
    
    [_tableView reloadData];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_tableView.header beginRefreshing];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(158,235, 199);
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    dataSourceArray = [[NSMutableArray alloc] init];
    [self createTableView];
    
}


- (void)createTableView{
    
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64 - 15) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;

    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooterNewData)];
    
    [self.view addSubview:_tableView];

}



-(void)loadNewData{
    page ++;
    
    [self fetchNetData];
    [ _tableView.header endRefreshing];
}

- (void)loadFooterNewData{
    page ++ ;
    
    [self fetchNetData];
    [_tableView.footer endRefreshing];
}

-(void)endRefresh{
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
}



- (void)fetchNetData{
    /*
     接口:
     http://www.xingxingedu.cn/Global/col_flower_list  */
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/col_flower_list";
    
    //请求参数  page
    
    
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        
//        NSLog(@"---  %@", responseObj);

        if([responseObj[@"code"] integerValue] == 1){
         NSDictionary *dict = responseObj[@"data"];
            if([dict[@"list"] count] != 0){
                NSArray *modelArray = [NSArray array];
                modelArray = [XXERedFlowerModel parseResondsData:dict[@"list"]];
                [dataSourceArray addObjectsFromArray:modelArray];
            }
        }
        
        [self customContent];
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];
    
}

// 有数据 和 无数据 进行判断
- (void)customContent{
    // 如果 有占位图 先 移除
    [self removePlaceholderImageView];
    
    if (dataSourceArray.count == 0) {
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



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataSourceArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SunDerTableViewCell *cell =(SunDerTableViewCell*)[tableView dequeueReusableCellWithIdentifier:KPATA];
    if (cell == nil) {
        NSArray *nib =[[NSBundle mainBundle] loadNibNamed:KPATA owner:[SunDerTableViewCell class] options:nil];
        cell =(SunDerTableViewCell *)[nib objectAtIndex:0];
    }
    
    XXERedFlowerModel *model = dataSourceArray[indexPath.row];
    
    NSString *headImage;
    
    if ([model.head_img_type integerValue] == 0) {
        headImage = [NSString stringWithFormat:@"%@%@", picURL , model.head_img];
    }else if([model.head_img_type integerValue] == 1){
        headImage = [NSString stringWithFormat:@"%@", model.head_img];
    }

    [cell.Rphone sd_setImageWithURL:[NSURL URLWithString:headImage] placeholderImage:[UIImage imageNamed:@"人物头像172x172"]];
    
    cell.TLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",model.tname,model.teach_course,model.school_name,model.class_name];

    cell.TimeLabel.text =[NSString stringWithFormat:@"%@",[WZYTool dateStringFromNumberTimer:model.date_tm]];

    cell.reasonLabel.text = [NSString stringWithFormat:@"赠言: %@",model.con];

    cell.saveBtn.hidden = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressClick:)];
    [cell.contentView addGestureRecognizer:longPress];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XXERedFlowerModel *model = dataSourceArray[indexPath.row];
    if ([XXEUserInfo user].login) {
        detailedViewController *detailVC =[[detailedViewController alloc]init];
        detailVC.model = model;
        [self.navigationController pushViewController:detailVC animated:YES];
   
    }else{
        [SVProgressHUD showInfoWithStatus:@"请用账号登录后查看"];
    }

}

#pragma 取消收藏 代理方法
- (void)longPressClick:(UILongPressGestureRecognizer *)longPress{

    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"取消收藏？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
#pragma mark - 取消收藏=================================================
        SunDerTableViewCell *cell = (SunDerTableViewCell *)[longPress.view superview];
       
        NSIndexPath *path = [_tableView indexPathForCell:cell];
        XXERedFlowerModel *model = dataSourceArray[path.row];
//        [dataArray removeObjectAtIndex:path.row];
        
        _collectionId = model.flowerId;
        
//        NSLog(@"gggggg%@", _collectionId);
        
        [self cancelCollection];
        
        
        [_tableView.header beginRefreshing];
        
        

    }];
    [alertController addAction:ok];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];

}

- (void)cancelCollection{

    /*
     接口:
     http://www.xingxingedu.cn/Global/deleteCollect
     传参:
     collect_id	//收藏id (如果是收藏用户,这里是xid)
     collect_type	//收藏品种类型	1:商品  2:点评  3:用户  4:课程  5:学校  6:花朵
     */
    
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/deleteCollect";
    
    //请求参数
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"collect_id":_collectionId, @"collect_type":@"6"};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        
        if ([responseObj[@"code"] integerValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"取消收藏成功!"];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"取消收藏失败!"];
        }
        
    } failure:^(NSError *error) {
        //
//        NSLog(@"%@", error);
        [SVProgressHUD showErrorWithStatus:@"获取数据失败!"];
    }];

}


@end

//
//  KTCommentViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/5/19.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define KPATA @"KTCommentCell"
#import "KTCommentViewController.h"
#import "KTCommentCell.h"
@interface KTCommentViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *dataArray;
    //老师 名称
    NSMutableArray *titleArray;
    //老师 头像
    NSMutableArray *headImageArray;
    // 评价 内容
    NSMutableArray *detailArray;
    //时间
    NSMutableArray *timeArray;
    
    NSMutableArray *idArray;
//    NSMutableArray *nilArr;
}


@property (nonatomic, copy) NSString *collectionId;


@end

@implementation KTCommentViewController

- (void)viewWillAppear:(BOOL)animated{

    [_tableView reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    [_tableView.header beginRefreshing];
    
}


- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = UIColorFromRGB(229,233, 232);
    
//    [self createData];
    
    [self createTableView];

    
}


- (void)createTableView{
    
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64 - 15) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    [self.view addSubview:_tableView];
    
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
}

- (void)loadNewData{

    [self fetchNetData];
    
    [_tableView.header endRefreshing];

}

- (void)endRefresh{

    [_tableView.header endRefreshing];
    
}

- (void)fetchNetData{

/*
 【我的收藏---点评】
 
 接口:
 http://www.xingxingedu.cn/Global/col_tea_com_list
 
 传参:
 */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/col_tea_com_list";
    
    //请求参数  无
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":XID, @"user_id":USER_ID, @"user_type":USER_TYPE};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        
        titleArray = [[NSMutableArray alloc] init];
        headImageArray = [[NSMutableArray alloc] init];
        detailArray = [[NSMutableArray alloc] init];
        timeArray = [[NSMutableArray alloc] init];
        idArray = [[NSMutableArray alloc] init];
        //
        
//        NSLog(@"%@", responseObj);
        /*
         {
         date_tm = 1462857989,
         teacher_tname = 梁红水,
         id = 11,
         tuser_id = 1,
         head_img_type = 0,
         com_con = ,
         baby_id = 3,
         head_img = app_upload/text/teacher/1.jpg
         }
         */
        
        NSArray *dataSource = responseObj[@"data"];
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            for (NSDictionary *dic in dataSource) {
                
                //                0 :表示 自己 头像 ，需要添加 前缀
                //                1 :表示 第三方 头像 ，不需要 添加 前缀
                //判断是否是第三方头像
                NSString * head_img;
                if([[NSString stringWithFormat:@"%@",dic[@"head_img_type"]]isEqualToString:@"0"]){
                    head_img=[picURL stringByAppendingString:dic[@"head_img"]];
                }else{
                    head_img=dic[@"head_img"];
                }
                
                [headImageArray addObject:head_img];

                [titleArray addObject:dic[@"teacher_tname"]];
                
                [detailArray addObject:dic[@"com_con"]];
            
                NSString *timeStr = [WZYTool dateStringFromNumberTimer:dic[@"date_tm"]];
                
                [timeArray addObject:timeStr];
                
                [idArray addObject:dic[@"id"]];
            }
            
        }else{
        
        
        }
        
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];
  
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return idArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KTCommentCell *cell =(KTCommentCell*)[tableView dequeueReusableCellWithIdentifier:KPATA];
    if (!cell) {
        NSArray *nib =[[NSBundle mainBundle]loadNibNamed:KPATA owner:[KTCommentCell class] options:nil];
        cell =(KTCommentCell*)[nib objectAtIndex:0];
        // cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    }
    
       [cell.headImagV sd_setImageWithURL:[NSURL URLWithString:headImageArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"人物头像172x172"]];
    
    cell.titleLbl.text = titleArray[indexPath.row];
    
    cell.detailLbl.text = detailArray[indexPath.row];
    
    cell.timeLbl.text = timeArray[indexPath.row];
    
    //给cell 添加 长按 取消 收藏 的手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressClick:)];
    
    [cell.contentView addGestureRecognizer:longPress];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    
}

- (void)longPressClick:(UILongPressGestureRecognizer *)longPress{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"取消收藏" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        KTCommentCell *cell = (KTCommentCell *)[longPress.view superview];
        
        NSIndexPath *path = [_tableView indexPathForCell:cell];
        
        _collectionId = idArray[path.row];
        
        
        [self cancelCollection];

        [_tableView.header beginRefreshing];
        
        [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];
    }];

    [alertController addAction:cancelAction];
    [alertController addAction:doneAction];
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
    
    NSDictionary *params = @{@"appkey":@"U3k8Dgj7e934bh5Y", @"backtype":@"json", @"xid":@"18884982", @"user_id":@"1", @"user_type":@"1", @"collect_id":_collectionId, @"collect_type":@"2"};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        
        //        NSLog(@"yyyyy%@", responseObj);
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];


}



@end

//
//  CharactersViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/5/19.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define KPATA @"KTCharactersCell"
#import "CharactersViewController.h"
#import "CheractersNextViewController.h"
#import "KTCharactersCell.h"



@interface CharactersViewController ()<UITableViewDataSource,UITableViewDelegate, UIAlertViewDelegate>
{
UITableView *_tableView;
NSMutableArray *dataArray;
NSMutableArray * iconImageViewArray;
NSMutableArray * nameArray;
NSMutableArray *contentArray;
NSMutableArray *timeArray;
NSMutableArray *idArray;
    
    
//NSMutableArray *imgArr;
//NSMutableArray *nilArr;
}

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *collectionId;


@end

@implementation CharactersViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [_tableView reloadData];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    [_tableView.header beginRefreshing];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(158,235, 199);
    
//    [self createData];
//    [self fetchNetData];
    
    [self createTableView];
    
}

- (void)createTableView{
    
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64 - 15) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    
    
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    [self.view addSubview:_tableView];

}



-(void)loadNewData{
    [self fetchNetData];
    [ _tableView.header endRefreshing];
}
-(void)endRefresh{
    [_tableView.header endRefreshing];
    //    [self.tableView.footer endRefreshing];
}

- (void)fetchNetData{
    /*
     接口:
     http://www.xingxingedu.cn/Global/col_flower_list     */
    
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/col_flower_list";
    
    //请求参数  无
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":XID, @"user_id":USER_ID, @"user_type":USER_TYPE};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        
        iconImageViewArray = [[NSMutableArray alloc] init];
        nameArray = [[NSMutableArray alloc] init];
        contentArray = [[NSMutableArray alloc] init];
        timeArray = [[NSMutableArray alloc] init];
        idArray = [[NSMutableArray alloc] init];
    
        //                        NSLog(@"（（（（（（（（（（%@", responseObj);
        /*
         (
         {
         "baby_id" = 1;
         con = "\U5f88\U597d";
         "date_tm" = 1464931533;
         "head_img" = "app_upload/text/teacher/1.jpg";
         "head_img_type" = 0;
         id = 3;
         "teacher_tname" = "\U6881\U7ea2\U6c34";
         tid = 1;
         },
         
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
                
                [iconImageViewArray addObject:head_img];
                
                [nameArray addObject:dic[@"teacher_tname"]];
                
                [contentArray addObject:dic[@"con"]];
                
                NSString *timeStr = [WZYTool dateStringFromNumberTimer:dic[@"date_tm"]];
                
                [timeArray addObject:timeStr];
                
                [idArray addObject:dic[@"id"]];
            }
            
            
        }else{
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"获取数据失败"]];
            
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
    
    return iconImageViewArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KTCharactersCell *cell =(KTCharactersCell*)[tableView dequeueReusableCellWithIdentifier:KPATA];
    if (!cell) {
        NSArray *nib =[[NSBundle mainBundle]loadNibNamed:KPATA owner:[KTCharactersCell class] options:nil];
        cell =(KTCharactersCell*)[nib objectAtIndex:0];
     cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconImageViewArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"人物头像172x172"]];
    
    cell.CharacterLbl.text = nameArray[indexPath.row];
    
    cell.contentLabel.text = contentArray[indexPath.row];
    
    cell.timeLbl.text = timeArray[indexPath.row];
    
//    cell.timeLbl.text =@"2016-5-20 18:20";
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressClick:)];
    [cell.contentView addGestureRecognizer:longPress];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    CheractersNextViewController *cheractersVC =[[CheractersNextViewController alloc]init];
//    [self.navigationController pushViewController:cheractersVC animated:YES];
}

#pragma 取消收藏 代理方法
- (void)longPressClick:(UILongPressGestureRecognizer *)longPress{

    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"取消收藏？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
#pragma mark - 取消收藏=================================================
        KTCharactersCell *cell = (KTCharactersCell *)[longPress.view superview];
       
        NSIndexPath *path = [_tableView indexPathForCell:cell];
        
//        [dataArray removeObjectAtIndex:path.row];
        
        _collectionId = idArray[path.row];
        
//        NSLog(@"gggggg%@", _collectionId);
        
        [self cancelCollection];
        
        
        [_tableView.header beginRefreshing];
        
        [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];

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
    
    NSDictionary *params = @{@"appkey":@"U3k8Dgj7e934bh5Y", @"backtype":@"json", @"xid":@"18884982", @"user_id":@"1", @"user_type":@"1", @"collect_id":_collectionId, @"collect_type":@"6"};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        
//        NSLog(@"yyyyy%@", responseObj);
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];

}


@end

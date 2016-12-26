//
//  ContactPersonViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/5/19.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define KPATA @"KTConnectCell"
#import "ContactPersonViewController.h"
#import "KTConnectCell.h"
//家人 详情
#import "OtherPeopleViewController.h"
//老师 详情
#import "TeleTeachInfoViewController.h"

@interface ContactPersonViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
//    NSMutableArray *dataArray;
//    NSMutableArray * textArr;
    NSMutableArray * typeArray;
    NSMutableArray *iconImageArray;
//    NSMutableArray *speakArr;
    NSMutableArray *nameArray;
    NSMutableArray *idArray;
    NSMutableArray *xingIdArray;
    NSMutableArray *timeArray;
    
    UIImageView *placeholderImageView;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@property (nonatomic, copy) NSString *xingId;
@property (nonatomic, copy) NSString *typeStr;


@end

@implementation ContactPersonViewController

- (void)viewWillAppear:(BOOL)animated{

//    [_tableView reloadData];

}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    [_tableView.header beginRefreshing];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(158,235, 199);
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
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
     【我的收藏---用户列表】
     接口:
     http://www.xingxingedu.cn/Global/col_user_list
     传参:
     */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/col_user_list";
    
    //请求参数  无
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        
        iconImageArray = [[NSMutableArray alloc] init];
        nameArray = [[NSMutableArray alloc] init];
        idArray = [[NSMutableArray alloc] init];
        xingIdArray = [[NSMutableArray alloc] init];
        typeArray = [[NSMutableArray alloc] init];
        timeArray = [[NSMutableArray alloc] init];
        
//                NSLog(@"bbbb%@", responseObj);
        /*
         {
         id = 4,
         nickname = 晴雨,
         head_img_type = 0,
         user_type = 1,
         xid = 18886177,
         head_img = app_upload/text/p_head4.jpg,
         date_tm = 1462857989
         }
        
         [user_type] => 1		//1:家长,2:老师
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
                
                [iconImageArray addObject:head_img];
//
                [nameArray addObject:dic[@"nickname"]];
                
                [typeArray addObject:dic[@"user_type"]];

                
//                NSLog(@"ggg %@", dic[@"date_tm"]);
                NSString *timeStr = [WZYTool dateStringFromNumberTimer:dic[@"date_tm"]];
                
                [timeArray addObject:timeStr];
//
                [idArray addObject:dic[@"id"]];
                
                [xingIdArray addObject:dic[@"xid"]];
            }
            
        }else{
            
            
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
    
    if (nameArray.count == 0) {
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
    
    return idArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KTConnectCell *cell =(KTConnectCell*)[tableView dequeueReusableCellWithIdentifier:KPATA];
    if (!cell) {
        NSArray *nib =[[NSBundle mainBundle]loadNibNamed:KPATA owner:[KTConnectCell class] options:nil];
        cell =(KTConnectCell*)[nib objectAtIndex:0];
        // cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [cell.headImgV sd_setImageWithURL:[NSURL URLWithString:iconImageArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"人物头像172x172"]];
    cell.headImgV.layer.cornerRadius= cell.headImgV.bounds.size.width/2;
    cell.headImgV.layer.masksToBounds=YES;
    cell.nameLbl.text = nameArray[indexPath.row];
    
    if ([typeArray[indexPath.row] isEqualToString:@"1"]) {
        cell.detailLbl.text = @"家长";
    }else if ([typeArray[indexPath.row] isEqualToString:@"2"]){
        cell.detailLbl.text = @"老师";
    
    }
    
    cell.timeLbl.text = timeArray[indexPath.row];
    
    
    //长按 取消 收藏
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressClick:)];
    [cell.contentView addGestureRecognizer:longPress];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([typeArray[indexPath.row] isEqualToString:@"1"]) {
    //家长
        OtherPeopleViewController *otherPeopleVC = [[OtherPeopleViewController alloc] init];
        otherPeopleVC.familyIdStr = idArray[indexPath.row];
        [self.navigationController pushViewController:otherPeopleVC animated:YES];
    
    }else if ([typeArray[indexPath.row] isEqualToString:@"2"]){
    //老师
        TeleTeachInfoViewController *teleTeachVC =[[TeleTeachInfoViewController alloc]init];
//        XXEXingClassRoomTeacherListModel *model = teacherModelArray[indexPath.row];
//        teleTeachVC.hidesBottomBarWhenPushed =YES;
        teleTeachVC.teacherId = idArray[indexPath.row];
        teleTeachVC.teacherXid = xingIdArray[indexPath.row];
        [self.navigationController pushViewController:teleTeachVC animated:YES];
        
    }
    
}

- (void)longPressClick:(UILongPressGestureRecognizer *)longPress{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"取消收藏" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        KTConnectCell *cell = (KTConnectCell *)[longPress.view superview];
        
        NSIndexPath *path = [_tableView indexPathForCell:cell];
        
        _xingId = xingIdArray[path.row];
        
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
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"collect_id":_xingId, @"collect_type":@"3"};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        
        //        NSLog(@"yyyyy%@", responseObj);
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];
    
    
}


@end

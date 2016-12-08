//
//  KTCommentViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/5/19.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define KPATA @"CommentsRecordTableViewCell"
#import "KTCommentViewController.h"
#import "CommentsRecordTableViewCell.h"
#import "CommentInfoViewController.h"
#import "LandingpageViewController.h"

@interface KTCommentViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *dataArray;
    
    NSMutableArray *commentArray;
//    NSMutableArray *nilArr;
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
}


@property (nonatomic, copy) NSString *collectionId;


@end

@implementation KTCommentViewController

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    commentArray = [[NSMutableArray alloc] init];
    
//    [_tableView reloadData];
    
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
 【我的收藏---点评】
 
 接口:
 http://www.xingxingedu.cn/Global/col_tea_com_list
 
 传参:
 */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/col_tea_com_list";
    
    //请求参数  无
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        
//        NSLog(@"%@", responseObj);
        /*
         {
         id = 32,
         baby_id = 3,
         t_delete = 0,
         head_img_type = 0,
         school_id = 1,
         puser_id = 1,
         tname = 梁红水,
         head_img = app_upload/text/teacher/1.jpg,
         com_con = ,
         type = 2,
         ask_con = Dasdas,
         tuser_id = 1,
         com_tm = 0,
         com_pic = ,
         class_id = 1,
         teach_course = 语文,
         p_delete = 0,
         ask_tm = 1467555514,
         condit = 0
         }

         */

        if([[NSString stringWithFormat:@"%@",responseObj[@"code"]]isEqualToString:@"1"] ){
            
            for (NSDictionary *dic in responseObj[@"data"] ) {
                //判断是否是第三方头像
                NSString * head_img;
                if([[NSString stringWithFormat:@"%@",dic[@"head_img_type"]]isEqualToString:@"0"]){
                    head_img=[picURL stringByAppendingString:dic[@"head_img"]];
                }else{
                    head_img=dic[@"head_img"];
                }
                
                //老师名称
                NSString * tname=dic[@"tname"];
                //所教科目
                NSString * teach_course=[dic[@"teach_course"] stringByAppendingString:@"老师"];
                //请求评价
                NSString *ask_con = dic[@"ask_con"];
                //评价内容
                NSString * com_con=dic[@"com_con"];
                //家长发送请求时间戳
                NSString * ask_tm=[CodeDingUtil timestampToTimeWith:dic[@"ask_tm"]];
                //点评状态  0:家长发送请求 (待老师点), 1:老师已点评
                NSString * condit=dic[@"condit"];
                //点评id
                NSString * commentId=dic[@"id"];
//                //1:是收藏过这个商品  2:未收藏过
//                NSString * collect_condit=dic[@"collect_condit"];
                //点评图
                NSString * com_pic= dic[@"com_pic"];
                //老师id
                NSString * tuser_id=dic[@"tuser_id"];
                //老师 回复点评的时间
                NSString * com_tm= [CodeDingUtil timestampToTimeWith:dic[@"com_tm"]];
                
                //数组中 0：头像 1：老师名称 2：所教课程 3：请求评价 4：回复评价内容 5：时间 6：是否收藏过 7：点评id 8：点评 状态 9：回复点评 图片 10：老师 id 11:老师回复点评的时间
                NSMutableArray *arr=[NSMutableArray arrayWithObjects:head_img, tname, teach_course, ask_con, com_con, ask_tm, @"", commentId, condit, com_pic, tuser_id, com_tm,nil];
                
                [commentArray addObject:arr];
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
    
    if (commentArray.count == 0) {
        // 1、无数据的时候
        UIImage *myImage = [UIImage imageNamed:@"人物"];
        CGFloat myImageWidth = myImage.size.width;
        CGFloat myImageHeight = myImage.size.height;
        
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - myImageWidth / 2, (kHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
        myImageView.image = myImage;
        [self.view addSubview:myImageView];
        
    }else{
        //2、有数据的时候
        [_tableView reloadData];
        
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return commentArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentsRecordTableViewCell *cell =(CommentsRecordTableViewCell*)[tableView dequeueReusableCellWithIdentifier:KPATA];
    if (!cell) {
        NSArray *nib =[[NSBundle mainBundle]loadNibNamed:KPATA owner:[CommentsRecordTableViewCell class] options:nil];
        cell =(CommentsRecordTableViewCell*)[nib objectAtIndex:0];
        
    }
    
    /*
     //数组中 0：头像 1：老师名称 2：所教课程 3：请求评价 4：回复评价内容 5：时间 6：是否收藏过 7：点评id 8：点评 状态 9：回复点评 图片 10：老师 id 11:老师回复点评的时间
     NSMutableArray *arr=[NSMutableArray arrayWithObjects:head_img, tname, teach_course, ask_con, com_con, date_tm, collect_condit, commentId, condit, com_pic, tuser_id, com_tm,nil];
     */
    
    NSArray * tmp=commentArray[indexPath.row];
    cell.iconImg.layer.cornerRadius= cell.iconImg.bounds.size.width/2;
    cell.iconImg.layer.masksToBounds=YES;
    [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:tmp[0]] placeholderImage:[UIImage imageNamed:@"sdimg1.png"]];
    
    cell.subjectLabel.text  = [NSString stringWithFormat:@"%@  %@",tmp[1],tmp[2]];
    cell.commentLabel.text = [NSString stringWithFormat:@"点评:  %@",tmp[4]];
    cell.timeLabel.text=tmp[5];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([XXEUserInfo user].login) {
        NSArray * tmp=commentArray[indexPath.row];
        CommentInfoViewController *vc=  [[CommentInfoViewController alloc]init];
        
        /*
         //数组中 0：头像 1：老师名称 2：所教课程 3：请求评价 4：回复评价内容 5：时间 6：是否收藏过 7：点评id 8：点评 状态 9：回复点评 图片 10：老师 id 11:老师回复点评的时间
         NSMutableArray *arr=[NSMutableArray arrayWithObjects:head_img, tname, teach_course, ask_con, com_con, date_tm, collect_condit, commentId, condit, com_pic, tuser_id, com_tm,nil];
         */
        
        vc.tnameStr=tmp[1];
        vc.ask_conStr=tmp[3];
        vc.com_conStr=tmp[4];
        vc.ask_tmStr=tmp[5];
        //    vc.collect_conditStr=tmp[6];
        vc.commentIdStr=tmp[7];
        vc.com_picStr=tmp[9];
        vc.tuser_idStr=tmp[10];
        
        [self.navigationController pushViewController:vc animated:YES];
  
    }else{
        [SVProgressHUD showInfoWithStatus:@"请用账号登录后查看"];
    }
    
}

- (void)longPressClick:(UILongPressGestureRecognizer *)longPress{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"取消收藏" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        CommentsRecordTableViewCell *cell = (CommentsRecordTableViewCell *)[longPress.view superview];
        
        NSIndexPath *path = [_tableView indexPathForCell:cell];
        
        _collectionId = commentArray[path.row][7];
        
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
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"collect_id":_collectionId, @"collect_type":@"2"};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        
        //        NSLog(@"yyyyy%@", responseObj);
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];


}



@end

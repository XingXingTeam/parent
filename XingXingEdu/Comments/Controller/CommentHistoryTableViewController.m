//
//  CommentHistoryTableViewController.m
//  XingXingStore
//
//  Created by codeDing on 16/2/17.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "CommentHistoryTableViewController.h"
#import "CommentsRecordTableViewCell.h"
#import "CommentInfoViewController.h"
#import "HHControl.h"
#import "MJRefresh.h"

#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height
#define W(x) WinWidth*(x)/375.0
#define H(y) WinHeight*(y)/667.0
@interface CommentHistoryTableViewController (){
    NSMutableArray * commentArray;
    BOOL isCollect;
}

@end

@implementation CommentHistoryTableViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView.header beginRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"self.teacherId-%@",self.teacherId);
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WinWidth, WinHeight)];
    UINib *nib = [UINib nibWithNibName:@"CommentsRecordTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
     [self getCommentInfo];
//        
//    if(commentArray.count==0){
//        UIImageView *bg=[HHControl createImageViewWithFrame:CGRectMake(0, 0, WinWidth, WinHeight) ImageName:@"nodatabg.png"];
//        [self.view addSubview:bg];
//    }

    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
}
-(void)loadNewData{
    [self getCommentInfo];
    [self.tableView.header endRefreshing];
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return commentArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentsRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil){
        cell=[[CommentsRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSArray * tmp=commentArray[indexPath.row];
    cell.iconImg.layer.cornerRadius= cell.iconImg.bounds.size.width/2;
    cell.iconImg.layer.masksToBounds=YES;
    [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:tmp[0]] placeholderImage:[UIImage imageNamed:@"sdimg1.png"]];

    cell.subjectLabel.text=  [NSString stringWithFormat:@"%@  %@",tmp[1],tmp[2]];
    cell.commentLabel.text=  [NSString stringWithFormat:@"点评:%@",tmp[3]];
    cell.timeLabel.text = tmp[4];
    
    cell.commentLabel.adjustsFontSizeToFitWidth=YES;
    cell.commentLabel.minimumScaleFactor=0.1;
    
    if([[NSString stringWithFormat:@"%@",tmp[5]]isEqualToString:@"2"]){
        [cell.collect setBackgroundImage:[UIImage imageNamed:@"commentCollect36.png"] forState:UIControlStateNormal];
        [[cell.collect currentBackgroundImage] setAccessibilityIdentifier:@"0"];
    }else if([[NSString stringWithFormat:@"%@",tmp[5]]isEqualToString:@"1"]){
        [cell.collect setBackgroundImage:[UIImage imageNamed:@"commentCollecthigh36.png"] forState:UIControlStateNormal];
        [[cell.collect currentBackgroundImage] setAccessibilityIdentifier:@"1"];
    }
    
    

    cell.collect.tag=1000+(int)indexPath.row;
    [cell.collect addTarget:self action:@selector(collectPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


-(void)collectPressed:(UIButton *)btn{
    if([[[btn currentBackgroundImage] accessibilityIdentifier] isEqualToString:@"0"]){
        [self collectArticle:btn];
    }else if([[[btn currentBackgroundImage] accessibilityIdentifier] isEqualToString:@"1"]){
        [self deleteCollectArticle:btn];
    }

  
    

    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSArray * tmp=commentArray[indexPath.row];
//    CommentInfoViewController *vc=  [[CommentInfoViewController alloc]init];
    
    /*
     //数组中 0：头像 1：老师名称 2：所教课程 3：请求评价 4：回复评价内容 5：时间 6：是否收藏过 7：点评id 8：点评 状态 9：回复点评 图片 10：老师 id 11:老师回复点评的时间
     NSMutableArray *arr=[NSMutableArray arrayWithObjects:head_img, tname, teach_course, ask_con, com_con, date_tm, collect_condit, commentId, condit, com_pic, tuser_id, com_tm,nil];
     */
    
    
    
//    vc.tnameStr=tmp[1];
////    =tmp[2];
//    vc.com_conStr=tmp[4];
//    vc.=tmp[5];
//    vc.commentcollect=tmp[6];
//    vc.commentid=tmp[7];
//    vc.commentimg=tmp[8];
//    vc.teacherId=tmp[9];

//    vc.isHistory=YES;
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 网络
- (void)getCommentInfo
{
    
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/teacher_com_msg";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":@"U3k8Dgj7e934bh5Y",
                           @"backtype":@"json",
                           @"xid":@"18884982",
                           @"user_id":@"1",
                           @"user_type":@"1",
                           @"baby_id":@"3",
                           @"require_con":@"3",
                           @"tid":self.teacherId,
                           };
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         //         NSLog(@"%@",dict);
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             
             commentArray=[NSMutableArray array];
             
             for (NSDictionary *dic in dict[@"data"] ) {
                 //判断是否是第三方头像
                 NSString * head_img;
                 if([[NSString stringWithFormat:@"%@",dic[@"head_img_type"]]isEqualToString:@"0"]){
                     head_img=[picURL stringByAppendingString:dic[@"head_img"]];
                 }else{
                     head_img=dic[@"head_img"];
                 }
                 
                 
                 NSString * tname=dic[@"tname"];
                 NSString * teach_course=[dic[@"teach_course"] stringByAppendingString:@"老师"];
                 NSString *  com_con=dic[@"com_con"];
                 NSString * date_tm=[CodeDingUtil timestampToTimeWith:dic[@"ask_tm"]];
                 NSString * collect_condit=dic[@"collect_condit"];
                 NSString * collectid=dic[@"id"];
                 NSString * com_pic=dic[@"com_pic"];
                 NSString * tuser_id=dic[@"tuser_id"];
                 NSMutableArray *arr=[NSMutableArray arrayWithObjects:head_img, tname,teach_course,com_con,date_tm,collect_condit,collectid,com_pic,tuser_id,nil];
                 
                 [commentArray addObject:arr];
             }
             //             NSLog(@"%@",commentArray);
             if(commentArray.count==0){
                 UIImageView *bg=[HHControl createImageViewWithFrame:CGRectMake(0, 0, WinWidth, WinHeight) ImageName:@"nodatabg.png"];
                 [self.view addSubview:bg];
             }else
             {
                 [self.tableView reloadData];
             }
             
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"获取点评失败，%@",dict[@"msg"]]];
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}
//收藏商品
- (void)collectArticle:(UIButton *)collectbtn
{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/collect";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    int tag=[[NSString stringWithFormat:@"%ld",collectbtn.tag-1000]intValue];
    
    NSDictionary *dict = @{@"appkey":@"U3k8Dgj7e934bh5Y",
                           @"backtype":@"json",
                           @"xid":@"18884982",
                           @"user_id":@"1",
                           @"user_type":@"1",
                           @"collect_id":commentArray[tag][6],
                           @"collect_type":@"2",
                           
                           };
    //        NSLog(@"%@",dict);
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         //                  NSLog(@"%@",dict);
         //        NSLog(@"%@",dict[@"code"]);
         
         
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             [SVProgressHUD showSuccessWithStatus:@"收藏点评成功"];
             [collectbtn setBackgroundImage:[UIImage imageNamed:@"commentCollecthigh36.png"] forState:UIControlStateNormal];
             [[collectbtn currentBackgroundImage] setAccessibilityIdentifier:@"1"];
             commentArray[tag][5]=@"1";
             
             
             
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"收藏点评失败，%@",dict[@"msg"]]];
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}

//取消收藏商品
- (void)deleteCollectArticle:(UIButton *)collectbtn
{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/deleteCollect";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    int tag=[[NSString stringWithFormat:@"%d",collectbtn.tag-1000]intValue];
    NSDictionary *dict = @{@"appkey":@"U3k8Dgj7e934bh5Y",
                           @"backtype":@"json",
                           @"xid":@"18884982",
                           @"user_id":@"1",
                           @"user_type":@"1",
                           @"collect_id":commentArray[tag][6],
                           @"collect_type":@"2",
                           };
    //        NSLog(@"%@",dict);
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         //                  NSLog(@"%@",dict);
         //        NSLog(@"%@",dict[@"code"]);
         
         
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];
             [collectbtn setBackgroundImage:[UIImage imageNamed:@"commentCollect36.png"] forState:UIControlStateNormal];
             [[collectbtn currentBackgroundImage] setAccessibilityIdentifier:@"0"];
             
             commentArray[tag][5]=@"2";
             
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"取消收藏商品失败，%@",dict[@"msg"]]];
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}


@end

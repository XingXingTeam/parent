//
//  CommentsRecordTableViewController.m
//  XingXingStore
//
//  Created by codeDing on 16/2/16.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "CommentsRecordTableViewController.h"
#import "CommentsRecordTableViewCell.h"
#import "CommentInfoViewController.h"
#import "LandingpageViewController.h"



@interface CommentsRecordTableViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView * myTableView;
    NSMutableArray * commentArray;
    BOOL isCollect;
    NSInteger page;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@end

@implementation CommentsRecordTableViewController



- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    commentArray = [[NSMutableArray alloc] init];
    
    page = 1;
    
    [myTableView reloadData];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [myTableView.header beginRefreshing];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self settingNavgiationBar];
    
    [self createTableView];
    
    UINib *nib = [UINib nibWithNibName:@"CommentsRecordTableViewCell" bundle:nil];
    [myTableView registerNib:nib forCellReuseIdentifier:@"cell"];
    

//    [self fetchNetData];
    
}

- (void)settingNavgiationBar{
    
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0, 170, 42)];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //1、设置 navigationBar 左边 返回
    UIImage *backImage = [UIImage imageNamed:@"首页90x38"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage: backImage  style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    
    //    2、设置 navigationBar 标题 颜色
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
}


//返回
- (void)backClick{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)createTableView{
    
    myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 49)];
    myTableView.delegate=self;
    myTableView.dataSource=self;
    [self.view addSubview:myTableView];
    
    myTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    myTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooterNewData)];
    
}


-(void)loadNewData{
    
    [self fetchNetData];
    [ myTableView.header endRefreshing];
}


- (void)loadFooterNewData{
    page ++ ;
    
    [self fetchNetData];
    [ myTableView.footer endRefreshing];
    
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
    
    NSString *flagStr = [NSString stringWithFormat:@"%@",tmp[6]];
    if([flagStr isEqualToString:@"2"]){
        [cell.collect setBackgroundImage:[UIImage imageNamed:@"commentCollect36.png"] forState:UIControlStateNormal];
        [[cell.collect currentBackgroundImage] setAccessibilityIdentifier:@"0"];
    }else if([flagStr isEqualToString:@"1"]){
        [cell.collect setBackgroundImage:[UIImage imageNamed:@"commentCollecthigh36.png"] forState:UIControlStateNormal];
        [[cell.collect currentBackgroundImage] setAccessibilityIdentifier:@"1"];
    }
    
    cell.collect.tag=1000+(int)indexPath.row;
//    [cell.collect addTarget:self action:@selector(collectPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
        vc.collect_conditStr=tmp[6];
        vc.commentIdStr=tmp[7];
        vc.com_picStr=tmp[9];
        vc.tuser_idStr=tmp[10];
        
        [self.navigationController pushViewController:vc animated:YES];

    }else{
        [SVProgressHUD showInfoWithStatus:@"请用账号登录后查看"];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
//滑动删除
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
//{
//    if(editingStyle == UITableViewCellEditingStyleDelete)
//    {
//    [commentArray removeObjectAtIndex:indexPath.row];
//     [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//
//    }
//}




#pragma mark 网络
- (void)fetchNetData{
    /*
     【点评历史】(所有历史,请求历史,某个老师历史), 注:历史点评列表点进去的详情,没有做额外接口,由前端页面之间传递数据
     
     接口:
     http://www.xingxingedu.cn/Parent/teacher_com_msg
     
     传参:
     class_id
     baby_id		//孩子id, 测试用值3
     require_con	//指定查询内容, 1:查询所有历史,2:查询请求点评历史,3:某个老师点评历史
     tid		//老师id ,测试用1或2 (只有require_con=3时,才需要此传参)
     */
    
    //查询历史
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/teacher_com_msg";
    
    //请求参数  无
    
    NSString *class_idStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"CLASS_ID"];
    
    NSString *babyIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"BABYID"];
    
    NSString *pageStr = [NSString stringWithFormat:@"%ld", page];
    
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE,
                             @"require_con":@"1",
                             @"baby_id": babyIdStr,
                             @"class_id":class_idStr,
                             @"page":pageStr
                             };
    
//    NSLog(@"%@", params);
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        NSDictionary *dict = responseObj;
//        NSLog(@"===================>%@",dict);
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] ){
            
            for (NSDictionary *dic in dict[@"data"] ) {
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
                //1:是收藏过这个商品  2:未收藏过
                NSString * collect_condit=dic[@"collect_condit"];
                //点评图
                NSString * com_pic= dic[@"com_pic"];
                //老师id
                NSString * tuser_id=dic[@"tuser_id"];
                //老师 回复点评的时间
                NSString * com_tm= [CodeDingUtil timestampToTimeWith:dic[@"com_tm"]];
                
                //数组中 0：头像 1：老师名称 2：所教课程 3：请求评价 4：回复评价内容 5：时间 6：是否收藏过 7：点评id 8：点评 状态 9：回复点评 图片 10：老师 id 11:老师回复点评的时间
                NSMutableArray *arr=[NSMutableArray arrayWithObjects:head_img, tname, teach_course, ask_con, com_con, ask_tm, collect_condit, commentId, condit, com_pic, tuser_id, com_tm,nil];
                
                [commentArray addObject:arr];
            }

        }else{

        }
        
        [self customContent];
        
    } failure:^(NSError *error) {
        //
        NSLog(@"请求失败:%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
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
        [myTableView reloadData];
        
    }
    
}

@end

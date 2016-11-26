//
//  ClassRoomOrderDidAppraiseTableViewController.m
//  XingXingEdu
//
//  Created by codeDing on 16/3/31.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "ClassRoomOrderDidAppraiseTableViewController.h"
#import "ClassRoomOrderNoPayTableViewCell.h"
#import "ClassRoomOrderMessageController.h"

@interface ClassRoomOrderDidAppraiseTableViewController (){
    NSMutableArray * infoArray;
}


@end

@implementation ClassRoomOrderDidAppraiseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,109 , kWidth, kHeight - 125)];
    UINib *nib = [UINib nibWithNibName:@"ClassRoomOrderNoPayTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"ClassRoomOrderDidAppraisecell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewCollectData)];
//     [self RequestData:@"3"];
}

-(void)loadNewCollectData{
    
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}
-(void)endRefresh{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}
-(void)viewWillAppear:(BOOL)animated{
     [self RequestData:@"3"];
    [self.tableView reloadData];
}
-(void)viewDidAppear:(BOOL)animated{
    [self.tableView.header beginRefreshing];
    [self.tableView.footer endRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 分类请求数据 3 已评价
- (void)RequestData:(NSString *)type {
    
    infoArray = [NSMutableArray array];
    for (UIView *subviews in [self.view subviews]) {
        if (subviews.tag==100) {
            [subviews removeFromSuperview];
        }
    }
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/course_order_list";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"condit":type,
                           };
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
//                  NSLog(@"===============%@",dict);
         if([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"] ){
             
             for (NSDictionary *dic in dict[@"data"] ) {
                 //课程图片
                 NSString * pic = [picURL stringByAppendingString:dic[@"pic"]];
                 //课程名字
                 NSString * course_name = [NSString stringWithFormat:@"%@",dic[@"course_name"]];
                 //培训机构
                 NSString * school_name = [NSString stringWithFormat:@"%@",dic[@"school_name"]];
                 //购买ID
                  NSString *order_id = [NSString stringWithFormat:@"%@",dic[@"id"]];
                 

                 NSMutableArray *dataArr = [NSMutableArray arrayWithObjects:pic,course_name,school_name,order_id, nil];
                 
                 [infoArray addObject:dataArr];
             }
             [self.tableView reloadData];
         }
         else{
             UIImageView *bg=[HHControl createImageViewWithFrame:CGRectMake(0, 0, WinWidth, WinHeight) ImageName:@"nodatabg.png"];
             [self.view addSubview:bg];
//             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",dict[@"msg"]]];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return infoArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassRoomOrderNoPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassRoomOrderDidAppraisecell"];
    if(cell==nil){
        cell=[[ClassRoomOrderNoPayTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ClassRoomOrderDidAppraisecell"];
    }
    NSArray * tmp = infoArray[indexPath.row];
    [cell.img sd_setImageWithURL:[NSURL URLWithString:tmp[0]] placeholderImage:[UIImage imageNamed:@"sdimg1.png"]];
    cell.nameLabel.text=tmp[1];
    cell.schoolLabel.text=tmp[2];
    cell.priceLabel.text = @"已评价";
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassRoomOrderMessageController *vc=[[ClassRoomOrderMessageController alloc]init];
    vc.hiddenBuyBtn=YES;
    vc.hiddencancelBtn=YES;
    vc.appraiseHistory=YES;
    vc.hiddenLeftButton = YES;
    vc.isBuy = YES;
     vc.orderId = infoArray[indexPath.row][3];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        [infoArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}
@end

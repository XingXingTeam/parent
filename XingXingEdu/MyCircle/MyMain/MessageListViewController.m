//
//  MessageListViewController.m
//  XingXingEdu
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "MessageListViewController.h"
#import "MessageListDetailController.h"
#import "MessageListViewCell.h"
@interface MessageListViewController (){

    NSMutableArray *_dataArr;
  
    
}

@end

@implementation MessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.view.backgroundColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    self.title = @"消息列表";
    
    [self createNewMessageNetRequest];
    
}

-(void)viewWillAppear:(BOOL)animated{
   
}
//新消息的网络请求 判断是否有新消息
-(void)createNewMessageNetRequest{
    _dataArr = [NSMutableArray array];
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/circle_new_msg";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           };
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"===============createNewMessageNetRequest=====================%@",dict);
         if([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"] ){
             NSMutableArray *listArr = dict[@"data"];
             if ([listArr count] > 0) {
                     for (NSDictionary *dic in listArr) {
                         NSString *head_img =[picURL stringByAppendingString:dic[@"head_img"]];
                         NSString *talk_id = dic[@"talk_id"];
                         NSString *con = [NSString stringWithFormat:@"%@",dic[@"con"]];
                         NSString *nickName = [NSString stringWithFormat:@"%@",dic[@"nickname"]];
                         NSString *date_tm = [NSString stringWithFormat:@"%@",dic[@"date_tm"]];
                         
                         NSMutableArray *arr =[NSMutableArray arrayWithObjects:head_img, talk_id,con,nickName,date_tm,nil];
                         [_dataArr addObject:arr];
                     }
             }
             
              [self initTableView];
             
             [_tableView reloadData];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}
-(void) initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
//几个  section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//对应的section有多少row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageListViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell==nil){
        cell=[[MessageListViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"messageListViewCell"];
    }
    NSArray * tmp = _dataArr[indexPath.row];
   
    cell.talkId = tmp[1];
    //头像
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10 , 10 , 40, 40)];
    headImage.layer.cornerRadius = headImage.bounds.size.width/2;
    headImage.layer.masksToBounds=YES;
    [headImage sd_setImageWithURL:[NSURL URLWithString:tmp[0]] placeholderImage:nil];
    [cell addSubview:headImage];
    
    UILabel *conLabel = [[UILabel alloc] initWithFrame:CGRectMake(60,30 , 120, 20)];
    conLabel.text = tmp[2];
    conLabel.font = [UIFont systemFontOfSize:10];
    [cell addSubview:conLabel];
    
    UILabel *nickName = [[UILabel alloc] initWithFrame:CGRectMake(60,10 , 120, 20)];
    nickName.text = tmp[3];
    nickName.font = [UIFont systemFontOfSize:12];
    [cell addSubview:nickName];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageListDetailController *messageListDetailVC =[[MessageListDetailController alloc]init];
    messageListDetailVC.talkId = _dataArr[indexPath.row][1];
    //接数据的时候 记得传值
    [self.navigationController pushViewController:messageListDetailVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

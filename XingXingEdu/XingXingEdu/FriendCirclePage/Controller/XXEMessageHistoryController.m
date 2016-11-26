//
//  XXEMessageHistoryController.m
//  teacher
//
//  Created by codeDing on 16/9/21.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMessageHistoryController.h"
#import "XXEMessageHistoryApi.h"
#import "XXEMessageHistoryModel.h"
#import "XXEMessageHistoryCell.h"
#import "MessageListDetailController.h"
#import "XXENewMessageApi.h"
#import "XingXingEdu-swift.h"

@interface XXEMessageHistoryController ()<UITableViewDelegate,UITableViewDataSource>
{

    NSString *parameterXid;
    NSString *parameterUser_Id;

}

@property (nonatomic, strong)UITableView *messageTableView;
/** 数据源 */
@property (nonatomic, strong)NSMutableArray *messageDatasource;

@end

static NSString *const IdentifierHistory = @"messageHistoryCell";

@implementation XXEMessageHistoryController

- (NSMutableArray *)messageDatasource
{
    if (!_messageDatasource) {
        _messageDatasource = [NSMutableArray array];
    }
    return _messageDatasource;
}

- (UITableView *)messageTableView
{
    if (!_messageTableView) {
        _messageTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _messageTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _messageTableView.delegate = self;
        _messageTableView.dataSource = self;
    }
    return _messageTableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = XXEBackgroundColor;
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XXEBackgroundColor;
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
//    [RuningXX.sharedInstance showRuning];
    if ([self.messageNumber isEqualToString:@"1"]) {
        self.title = @"新消息";
        [self setupNewMessageList];
        
    }else{
        self.title = @"历史消息";
        //获取网络请求
//        [RuningXX.sharedInstance showRuning];
        [self setupNetWorkRequest];
    }
    [self.messageTableView registerNib:[UINib nibWithNibName:@"XXEMessageHistoryCell" bundle:nil] forCellReuseIdentifier:IdentifierHistory];
    [self.view addSubview:self.messageTableView];
}


#pragma mark - 获取网络请求
- (void)setupNetWorkRequest
{

    [self.messageDatasource removeAllObjects];
    XXEMessageHistoryApi * messageApi = [[XXEMessageHistoryApi alloc]initWithCircleMeesageHistoryUserXid:parameterXid UserId:parameterUser_Id];
    [messageApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        NSLog(@"消息%@",request.responseJSONObject);
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        if ([code integerValue]==1) {
            NSArray *data = [request.responseJSONObject objectForKey:@"data"];
            for (int i=0; i<data.count; i++) {
                XXEMessageHistoryModel *model = [[XXEMessageHistoryModel alloc]initWithDictionary:data[i] error:nil];
                [self.messageDatasource addObject:model];
            }
            [self.messageTableView reloadData];
        }else if ([code integerValue]==3){
             [self showString:@"没有数据" forSecond:1.f];
        }else{
            [self showString:@"获取数据失败" forSecond:1.f];
        }
//        [RuningXX.sharedInstance dismissWithAnimation];
    } failure:^(__kindof YTKBaseRequest *request) {
//        [RuningXX.sharedInstance dismissWithAnimation];
        [self showString:@"网络异常" forSecond:1.f];
    }];
}

- (void)setupNewMessageList
{

     [self.messageDatasource removeAllObjects];
    XXENewMessageApi *newMessageApi = [[XXENewMessageApi alloc]initWithNewMeesageHistoryUserXid:parameterXid UserId:parameterUser_Id];
    [newMessageApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        NSLog(@"xiaoxi %@",request.responseJSONObject);
        NSLog(@"%@",[request.responseJSONObject objectForKey:@"msg"]);
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        if([code integerValue]==1) {
            NSArray *data = [request.responseJSONObject objectForKey:@"data"];
            for (int i=0; i<data.count; i++) {
                XXEMessageHistoryModel *model = [[XXEMessageHistoryModel alloc]initWithDictionary:data[i] error:nil];
                [self.messageDatasource addObject:model];
            }
            [self.messageTableView reloadData];
        }else if ([code integerValue]==3){
            [self showString:@"没有数据" forSecond:1.f];
        }else{
            [self showString:@"获取数据失败" forSecond:1.f];
        }
//        [RuningXX.sharedInstance dismissWithAnimation];
        
    } failure:^(__kindof YTKBaseRequest *request) {
//        [RuningXX.sharedInstance dismissWithAnimation];
    }];
    
}

#pragma mark - UITableViewDelegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageDatasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XXEMessageHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:IdentifierHistory forIndexPath:indexPath];
    //点击更改点击单元格的颜色
//    cell.selectionStyle = UITableViewCellEditingStyleNone;
    XXEMessageHistoryModel *model = self.messageDatasource[indexPath.row];
    [cell configerGetCircleMessageHistory:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageListDetailController *listVC = [[MessageListDetailController alloc]init];
    XXEMessageHistoryModel *model = self.messageDatasource[indexPath.row];
    listVC.model = model;
    listVC.talkId = model.talk_id;
    NSLog(@"说说的TalkId%@",model.talk_id);
    [self.navigationController pushViewController:listVC animated:YES];
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

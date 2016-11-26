//
//  AuditSetViewController.m
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/1/26.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define KPATA @"AdiutSetingCell"
#import "AdiutSetingCell.h"
#import "AuditSetViewController.h"
#import "HHControl.h"
@interface AuditSetViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *dataArray;
   
}

/*
 //2:开启 1:关闭 (下面几个同理)
 */
//黑名单
@property (nonatomic, copy) NSString *black_userStr;
//不让他看我的朋友圈
@property (nonatomic, copy) NSString *dt_let_him_seeStr;
//不接受对方消息
@property (nonatomic, copy) NSString *refuse_chatStr;
//不看他的朋友圈
@property (nonatomic, copy) NSString *dt_look_at_himStr;

@property (nonatomic) NSMutableArray *dataSourceArray;

//
@property (nonatomic, copy) NSString *action_nameStr;

//
@property (nonatomic, copy) NSString *action_numStr;

//
@property (nonatomic, copy) NSString *flagStr;

@end

@implementation AuditSetViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"权限设置";
    self.view.backgroundColor =UIColorFromRGB(229 , 232, 233);
    
    [self fetchNetData];
    
    [self createTable];
}

- (void)fetchNetData{

    /*
     【权限设置---权限设置列表】
     
     接口:
     http://www.xingxingedu.cn/Global/right_set_list
     
     传参:
     other_xid 	//被访问者xid
     */

    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/right_set_list";
    
    //请求参数
    NSString *parameterXid;
    NSString *parameterUser_Id;
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE,
                             @"other_xid": _XIDStr
                             };
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
       
        
        if ([[NSString stringWithFormat:@"%@", [responseObj objectForKey:@"code"]] isEqualToString:@"1"]) {
            NSDictionary *dic = responseObj[@"data"];
    
            _dt_look_at_himStr = dic[@"dt_look_at_him"];
            _dt_let_him_seeStr = dic[@"dt_let_him_see"];
            _refuse_chatStr = dic[@"refuse_chat"];
            _black_userStr = dic[@"black_user"];
            
         _dataSourceArray = [[NSMutableArray alloc] initWithObjects:_dt_look_at_himStr, _dt_let_him_seeStr, _refuse_chatStr, _black_userStr, nil];
            
        }else{
        
        
        }
        
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];

}


- (void)createTable{
    
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    [self.view addSubview:_tableView];
    
    dataArray =[[NSMutableArray alloc]init];
    NSArray *arr =@[@"不看他(她)的朋友圈",@"不让他(她)看我的朋友圈",@"不接受对方消息",@"拉入黑名单"];
    [dataArray addObjectsFromArray:arr];
//    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00000001;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    AdiutSetingCell *cell =(AdiutSetingCell*)[tableView dequeueReusableCellWithIdentifier:KPATA];
    if (!cell) {
        NSArray *nib =[[NSBundle mainBundle]loadNibNamed:KPATA owner:[AdiutSetingCell class] options:nil];
        cell =(AdiutSetingCell*)[nib objectAtIndex:0];
    }

    cell.titleLbl.text =dataArray[indexPath.row];
    cell.switchBtn.tag =indexPath.row +100;
    if ( [_dataSourceArray[indexPath.row] integerValue] == 1) {
        cell.switchBtn.on = NO;
    }else if([_dataSourceArray[indexPath.row] integerValue] == 2){
        cell.switchBtn.on = YES;
    }
    [cell.switchBtn addTarget:self action:@selector(switchBtn:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}
- (void)switchBtn:(UISwitch*)btn{
    //1 关闭 2 打开
    if (btn.on == YES) {

        _flagStr = @"2";
    }else{

        _flagStr = @"1";
    }
    
    /*
     【权限设置---权限设置操作】
     
     接口:
     http://www.xingxingedu.cn/Global/right_set_action
     
     传参:
     other_xid 	//被访问者xid
     action_name	//要执行的事件名,允许的事件名有: dt_look_at_him,dt_let_him_see,refuse_chat,black_user  每次只能写一个,注释见上一个接口
     action_num	//执行内容,传数字  1:关闭  2:开启
     */
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/right_set_action";
    
    //请求参数
    NSMutableArray *_action_nameArray = [[NSMutableArray alloc] initWithObjects:@"dt_look_at_him", @"dt_let_him_see", @"refuse_chat", @"black_user", nil];
    _action_nameStr = _action_nameArray[btn.tag - 100];

    _action_numStr = _flagStr;
    
//    NSLog(@"%@-----%@-----", _action_nameStr, _action_numStr);
    NSString *parameterXid;
    NSString *parameterUser_Id;
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"other_xid": _XIDStr, @"action_name":_action_nameStr, @"action_num":_action_numStr};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
//        NSLog(@"%@", responseObj);
        
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self performSelector:@selector(select) withObject:nil afterDelay:0.5f];

}
- (void)select{

    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];

}

@end

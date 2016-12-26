//  FriendsListViewController.m
//
//  Created by codeDing on 16/2/26.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "FriendsListViewController.h"
#import "AppDelegate.h"
#import "FriendCell.h"
#import "UIImageView+WebCache.h"
#import "RCUserInfo+Addition.h"
#import "WMConversationViewController.h"
#import "MyCenterViewController.h"
#import "PersonCenterViewController.h"
#import "RCAddFriendViewController.h"

#import "KxMenu.h"

@interface FriendsListViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    NSMutableArray *friendsArray;
    
    //头像
    NSMutableArray *iconImageArray;
    //昵称
    NSMutableArray *nicknamearray;
    //年龄
    NSMutableArray *ageArray;
    //xingId
    NSMutableArray *xingIdArray;
    
    
    
    
}
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation FriendsListViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [_table reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [_table.header beginRefreshing];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    //    friendsArray = [AppDelegate shareAppDelegate].friendsArray;
    self.navigationItem.title=@"聊天首页";
    _table.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
//    self.tabBarController.navigationItem.title=@"聊天";
    
    //    [self addFriend];
    
//    friendsArray = [AppDelegate shareAppDelegate].friendsArray;
    

    
    [self.table registerNib:[UINib nibWithNibName:@"FriendCell" bundle:nil] forCellReuseIdentifier:@"FriendCell"];
    self.table.tableFooterView = [UIView new];
    [_table.header beginRefreshing];
}

- (void)loadNewData{
    
    [self fetchNetData];
    
    [_table.header endRefreshing];
    
}

- (void)endRefresh{
    
    [_table.header endRefreshing];
    
}

- (void)fetchNetData{
    
    /*
     【聊天--好友列表】
     
     接口:
     http://www.xingxingedu.cn/Global/friend_list
     
     传参:
     */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/friend_list";
    
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
    
    NSDictionary *pragm = @{   @"appkey":APPKEY,
                               @"backtype":BACKTYPE,
                               @"xid":parameterXid,
                               @"user_id":parameterUser_Id,
                               @"user_type":USER_TYPE,
                               };
    
    [WZYHttpTool post:urlStr params:pragm success:^(id responseObj) {
        //
        
        friendsArray = [[NSMutableArray alloc] init];
        
        iconImageArray = [[NSMutableArray alloc] init];
        ageArray = [[NSMutableArray alloc] init];
        nicknamearray = [[NSMutableArray alloc] init];
        xingIdArray = [[NSMutableArray alloc] init];
    
//                        NSLog(@"好友列表---yyyyttt%@", responseObj);
        /*
         {
         head_img = app_upload/text/parent/p7.jpg,
         age = 40,
         nickname = 唐唐,
         head_img_type = 0,
         xid = 18886387
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
                
                RCUserInfo *aUserInfo =[[RCUserInfo alloc]initWithUserId:dic[@"xid"] name:dic[@"nickname"] portrait:head_img QQ:nil sex:nil];
                
                [friendsArray addObject:aUserInfo];
                
            }
            
        }else{
            
            
            
        }
        
        [AppDelegate shareAppDelegate].friendsArray = friendsArray;
        
//        NSLog(@"[AppDelegate shareAppDelegate].friendsArray======%@", [AppDelegate shareAppDelegate].friendsArray);
        
        [_table reloadData];
        
    } failure:^(NSError *error) {
        //
        
    }];
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return friendsArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendCell  *cell = (FriendCell *)[tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
    
    RCUserInfo *aUserInfo = friendsArray[indexPath.row];
    [cell.portraitImageView sd_setImageWithURL:[NSURL URLWithString:aUserInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"人物头像172x172"]];
    cell.portraitImageView.layer.cornerRadius= cell.portraitImageView.bounds.size.width/2;
    cell.portraitImageView.layer.masksToBounds=YES;
    
    cell.userNameLabel.text = aUserInfo.name;
    cell.QQLabel.text = aUserInfo.QQ;
    cell.sexLabel.text = aUserInfo.sex;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RCUserInfo *aUserInfo = friendsArray[indexPath.row];
    PersonCenterViewController *personCenterVC = [[PersonCenterViewController alloc]init];
    personCenterVC.showUserInfo = aUserInfo;
    personCenterVC.title = aUserInfo.name;
    personCenterVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personCenterVC animated:YES];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        [friendsArray removeObjectAtIndex:indexPath.row];
        [self.table deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

@end

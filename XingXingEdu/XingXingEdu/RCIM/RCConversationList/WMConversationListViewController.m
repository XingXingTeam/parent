

//
//  WMConversationListViewController.m
//  RCIM
//
//  Created by codeDing on 16/3/4.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "WMConversationListViewController.h"
#import "WMConversationViewController.h"
#import "AppDelegate.h"
#import "RCDataManager.h"
#import "RCCustomCell.h"
#import "UIImageView+WebCache.h"
#import "HHControl.h"
@interface WMConversationListViewController ()<RCIMReceiveMessageDelegate,RCIMConnectionStatusDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{

    //点击  某一个 cell ,找他聊天,他的xid
    NSString *otherXid;

    NSString *parameterXid;
    NSString *parameterUser_Id;
}


@property (nonatomic,strong) RCConversationModel *tempModel;

@property (nonatomic,assign) BOOL isClick;


- (void) updateBadgeValueForTabBarItem;

@end

@implementation WMConversationListViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_GROUP),@(ConversationType_CHATROOM)]];
        [RCIM sharedRCIM].receiveMessageDelegate = self;
        [RCIM sharedRCIM].connectionStatusDelegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveMessageNotification:)name:RCKitDispatchMessageNotification object:nil];
        
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if (self) {
        //设置要显示的会话类型
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_GROUP),@(ConversationType_CHATROOM)]];
        [self setConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[RCDataManager shareManager] refreshBadgeValue];
    [self.conversationListTableView reloadData];

}
/*!
 接收消息的回调方法
 *
 */
-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    NSLog(@" onRCIMReceiveMessage %@",message.content);
    [[RCDataManager shareManager] refreshBadgeValue];
    [self.conversationListTableView reloadData];
}
#pragma mark - RCIMConnectionStatusDelegate

/**
 *  网络状态变化。
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    NSLog(@"RCConnectionStatus = %ld",(long)status);
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:nil
                              message:@"您的帐号已在别的设备上登录，\n您被迫下线！"
                              delegate:self
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [[RCIMClient sharedRCIMClient] disconnect:YES];
    }];
    
  
}
#pragma mark
#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.title=@"会话列表";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.conversationListTableView.tableFooterView = [UIView new];
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }

}
#pragma mark
#pragma mark 禁止右滑删除
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//左滑删除
-(void)rcConversationListTableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //可以从数据库删除数据
        RCConversationModel *model = self.conversationListDataSource[indexPath.row];
        [[RCIMClient sharedRCIMClient] removeConversation:model.conversationType targetId:model.targetId];
        [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
        [self.conversationListTableView reloadData];
        [[RCDataManager shareManager] refreshBadgeValue];
}
//高度
-(CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCellHeight;
}
//插入自定义会话model
-(NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource{
    for (int i=0; i<dataSource.count; i++) {
        RCConversationModel *model = dataSource[i];
        if(model.conversationType == ConversationType_PRIVATE){
            model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        }
    }
    return dataSource;
}
-(NSString *)getyyyymmdd{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyyMMdd";
    NSString *dayStr = [formatDay stringFromDate:now];
    return dayStr;
    
}
-(NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}
#pragma mark
#pragma mark onSelectedTableRow
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath{
    //点击cell，拿到cell对应的model，然后从model中拿到对应的RCUserInfo，然后赋值会话属性，进入会话
    //先 判断 身份
    otherXid = model.targetId;
    [self judgePosition:model];
}

#pragma Mark========== 判断身份 ========
- (void)judgePosition:(RCConversationModel *)model{
    /*
     【聊天--发起聊天(获取双方token)]
     接口类型:2
     接口:
     http://www.xingxingedu.cn/Global/chat_token
     传参:
     other_xid	//对方xid
     
     ★其他结果需提醒用户
     code:5	//对方不在你的好友名单中,不能发起聊天,是否要添加好友?(触发添加好友请求接口)
     code:6	//对方设置了不接受您的消息!无法发起聊天!
     code:7	//你不在对方的好友名单中,是否要添加好友?
     code:8 //你在对方的黑名单中,无法发起聊天!
     */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/chat_token";
    
//    NSString *otherXid = _showUserInfo.userId;
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE,
                             @"other_xid":otherXid
                             };
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
        NSLog(@"%@", responseObj);
        
        if ([responseObj[@"code"] integerValue] == 1) {
            //开始聊天
            [self startChart:model];
        }else if ([responseObj[@"code"] integerValue] == 5){
            
            [SVProgressHUD showInfoWithStatus:@"不是好友,不能发起聊天!"];
            //添加好友
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //请求 添加 好友
                [self addFriendRequest];
            });
            
        }else if ([responseObj[@"code"] integerValue] == 6){
            [SVProgressHUD showInfoWithStatus:@"对方设置了不接受您的消息!无法发起聊天!"];
        }else if ([responseObj[@"code"] integerValue] == 7){
            [SVProgressHUD showInfoWithStatus:@"你不在对方的好友名单中,不能发起聊天!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //请求 添加 好友
                [self addFriendRequest];
            });
        }else if ([responseObj[@"code"] integerValue] == 8){
            [SVProgressHUD showInfoWithStatus:@"你在对方的黑名单中,无法发起聊天!"];
        }
        
        
    } failure:^(NSError *error) {
        //
        [SVProgressHUD showErrorWithStatus:@"获取数据失败!"];
    }];
    
    
}

#pragma Mark %%%%%%%%%%%%%%%% //请求 添加 好友 %%%%%%%%%%%%%%%%%
- (void)addFriendRequest{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加好友" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        //
        textField.placeholder = @"申请备注";
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
        [self requestAddFriend];
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)requestAddFriend{
    /*
     【聊天--发起添加好友请求】
     接口类型:2
     接口:
     http://www.xingxingedu.cn/Global/action_friend_request
     传参:
     other_xid	//对方xid  (测试可用xid: 18886390,18886391,18886393(允许任何人通过),18886378(已是好友),18886177(在对方黑名单中))
     
     //         ★其他结果需提醒用户
     //         code:4	//不能请求自己
     //         code:5	//已经是好友了(不能对好友发起请求)
     //         code:6	//对方在我的黑名单中,无法发起请求!
     //         code:7	//您已经在对方黑名单中,无法发起请求!
     //         code:8	//不能重复对同一个人发起请求!
     //         code:9	//对方已同意,可以直接聊天了 (对方设置了任何人请求直接通过)
     //         code:10	//添加成功 (单方面删除好友,又添加好友)
     */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/action_friend_request";
    
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE,
                             @"other_xid":otherXid
                             };
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
        //        NSLog(@"%@", responseObj);
        if ([responseObj[@"code"] integerValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"请求发送成功!"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else if ([responseObj[@"code"] integerValue] == 4){
            [SVProgressHUD showInfoWithStatus:@"不能请求自己!"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else if ([responseObj[@"code"] integerValue] == 5){
            [SVProgressHUD showInfoWithStatus:@"对方已经是您的好友!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else if ([responseObj[@"code"] integerValue] == 6){
            [SVProgressHUD showInfoWithStatus:@"对方在您的黑名单中,无法发起请求!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else if ([responseObj[@"code"] integerValue] == 7){
            [SVProgressHUD showInfoWithStatus:@"您已经在对方黑名单中,无法发起请求!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else if ([responseObj[@"code"] integerValue] == 8){
            [SVProgressHUD showInfoWithStatus:@"不能重复对同一个人发起请求!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else if ([responseObj[@"code"] integerValue] == 9){
            [SVProgressHUD showInfoWithStatus:@"对方已同意,可以直接聊天了(对方设置了任何人请求直接通过)"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else if ([responseObj[@"code"] integerValue] == 10){
            [SVProgressHUD showInfoWithStatus:@"添加成功!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }

        
    } failure:^(NSError *error) {
        //
        [SVProgressHUD showErrorWithStatus:@"获取数据失败!"];
    }];
    
}


#pragma mark ========= 开始 聊天 =======
- (void)startChart:(RCConversationModel *)model{
    if (model.conversationType==ConversationType_PRIVATE) {//单聊
        WMConversationViewController *_conversationVC = [[WMConversationViewController alloc]init];
        _conversationVC.conversationType = model.conversationType;
        _conversationVC.targetId = model.targetId;
        RCUserInfo *aUserInfo = [[RCDataManager shareManager] currentUserInfoWithUserId:model.targetId];
        _conversationVC.title =aUserInfo.name;
        [self.navigationController pushViewController:_conversationVC animated:YES];
        
    }else if (model.conversationType==ConversationType_GROUP){//群聊
        WMConversationViewController *_conversationVC = [[WMConversationViewController alloc]init];
        _conversationVC.conversationType = model.conversationType;
        _conversationVC.targetId = model.targetId;
        _conversationVC.title = model.conversationTitle;
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }else if (model.conversationType==ConversationType_DISCUSSION){//讨论组
        WMConversationViewController *_conversationVC = [[WMConversationViewController alloc]init];
        _conversationVC.conversationType = model.conversationType;
        _conversationVC.targetId = model.targetId;
        _conversationVC.title = model.conversationTitle;
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }else if (model.conversationType==ConversationType_CHATROOM){//聊天室
        
    }else if (model.conversationType==ConversationType_APPSERVICE){//客服
        
    }


}

-(RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSLog(@"KKKK%@", self.conversationListDataSource);
    
    if (self.conversationListDataSource.count&&indexPath.row < self.conversationListDataSource.count) {
        RCConversationModel *model = self.conversationListDataSource[indexPath.row];
        [[RCDataManager shareManager] getUserInfoWithUserId:model.targetId completion:^(RCUserInfo *userInfo) {
        
            NSLog(@"rcConversationListTableView 名字 ＝ %@  ID ＝ %@ 头像 = %@",userInfo.name,userInfo.userId, userInfo.portraitUri);
        }];
        NSInteger unreadCount = model.unreadMessageCount;
        RCCustomCell *cell = (RCCustomCell *)[[RCCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RCCustomCell"];
        
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.receivedTime/1000];
        NSString *timeString = [[self stringFromDate:date] substringToIndex:10];
        NSString *temp = [self getyyyymmdd];
        NSString *nowDateString = [NSString stringWithFormat:@"%@-%@-%@",[temp substringToIndex:4],[temp substringWithRange:NSMakeRange(4, 2)],[temp substringWithRange:NSMakeRange(6, 2)]];
        
        
//        UIView *view4=[HHControl createViewWithFrame:CGRectMake(10, 78, WinWidth-20, 1)];
//        view4.backgroundColor=UIColorFromRGB(229, 232, 233);
//        [cell addSubview:view4];
        
        if ([timeString isEqualToString:nowDateString]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm"];
            NSString *showtimeNew = [formatter stringFromDate:date];
            cell.timeLabel.text = [NSString stringWithFormat:@"%@",showtimeNew];
            
        }else{
            cell.timeLabel.text = [NSString stringWithFormat:@"%@",timeString];
        }
        cell.ppBadgeView.dragdropCompletion = ^{
            NSLog(@"VC = FFF ，ID ＝ %@",model.targetId);
            
        
            
            [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:ConversationType_PRIVATE targetId:model.targetId];
            model.unreadMessageCount = 0;
            NSInteger ToatalunreadMsgCount = (NSInteger)[[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_GROUP),@(ConversationType_CHATROOM)]];
            
            long tabBarCount = ToatalunreadMsgCount-model.unreadMessageCount;
            
            if (tabBarCount > 0) {
                [AppDelegate shareAppDelegate].tabbarVC.selectedViewController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",tabBarCount];
            }
            else {
                [AppDelegate shareAppDelegate].tabbarVC.selectedViewController.tabBarItem.badgeValue = nil;
            }
        };
        if (unreadCount==0) {
            cell.ppBadgeView.text = @"";
            
        }else{
            if (unreadCount>=100) {
                cell.ppBadgeView.text = @"99+";
            }else{
                cell.ppBadgeView.text = [NSString stringWithFormat:@"%li",(long)unreadCount];
                
            }
        }
        
        
//        NSLog(@"[AppDelegate shareAppDelegate].friendsArray  -----====--  %@", [AppDelegate shareAppDelegate].friendsArray);
        for (RCUserInfo *userInfo in [AppDelegate shareAppDelegate].friendsArray) {
            if ([model.targetId isEqualToString:userInfo.userId]) {
                
                NSLog(@"名称   %@", userInfo.name);
                NSLog(@"头像   %@", userInfo.portraitUri);
                NSLog(@"id     %@", userInfo.userId);
                
                cell.nameLabel.text = [NSString stringWithFormat:@"%@",userInfo.name];
                if ([userInfo.portraitUri isEqualToString:@""]||userInfo.portraitUri==nil) {
                    cell.avatarIV.image = [UIImage imageNamed:@"人物头像172x172"];
                    [cell.contentView bringSubviewToFront:cell.avatarIV];
                }else{
                    [cell.avatarIV sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"人物头像172x172"]];
                }
                
                if ([model.lastestMessage isKindOfClass:[RCTextMessage class]]) {
                    cell.contentLabel.text = [model.lastestMessage valueForKey:@"content"];
                    
                }else if ([model.lastestMessage isKindOfClass:[RCImageMessage class]]){
                    
                    if ([model.senderUserId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
                        //我自己发的
                        RCUserInfo *myselfInfo = [RCIMClient sharedRCIMClient].currentUserInfo;
                        
                        if ([[NSString stringWithFormat:@"%@",myselfInfo.name] isEqualToString:@""]) {
                            cell.contentLabel.text =[NSString stringWithFormat:@"来自\"%@\"的图片消息，点击查看",myselfInfo.name];
                        }else{
                            cell.contentLabel.text =[NSString stringWithFormat:@"来自\"%@\"的图片消息，点击查看",myselfInfo.name];
                            
                        }
                    }else{
                        
                        cell.contentLabel.text =[NSString stringWithFormat:@"来自\"%@\"的图片消息，点击查看",userInfo.name] ;
                    }
                    
                }else if ([model.lastestMessage isKindOfClass:[RCVoiceMessage class]]){
                    if ([model.senderUserId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
                        //我自己发的
                        RCUserInfo *myselfInfo = [RCIMClient sharedRCIMClient].currentUserInfo;
                        if ([[NSString stringWithFormat:@"%@",myselfInfo.name] isEqualToString:@""]) {
                            cell.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的语音消息，点击查看",myselfInfo.name];
                            
                        }else{
                            cell.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的语音消息，点击查看",myselfInfo.name];
                        }
                    }else{
                        cell.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的语音消息，点击查看",userInfo.name];
                    }
                }
                else if ([model.lastestMessage isKindOfClass:[RCLocationMessage class]]){
                    if ([model.senderUserId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
                        //我自己发的
                        RCUserInfo *myselfInfo = [RCIMClient sharedRCIMClient].currentUserInfo;
                        if ([[NSString stringWithFormat:@"%@",myselfInfo.name] isEqualToString:@""]) {
                            cell.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的位置消息，点击查看",myselfInfo.name];
                        }else{
                            cell.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的位置消息，点击查看",myselfInfo.name];
                        }
                    }else{
                        cell.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的位置消息，点击查看",userInfo.name];
                    }
                }
                
            }
        }
        
        return cell;
    }
    else{
        
        return [[RCConversationBaseCell alloc]init];
    }
    
    
}


#pragma mark - 收到消息监听
-(void)didReceiveMessageNotification:(NSNotification *)notification{
    __weak typeof(&*self) blockSelf_ = self;
    //处理好友请求
    RCMessage *message = notification.object;
    
    if ([message.content isMemberOfClass:[RCMessageContent class]]) {
        if (message.conversationType == ConversationType_PRIVATE) {
            NSLog(@"好友消息要发系统消息！！！");
            @throw  [[NSException alloc] initWithName:@"error" reason:@"好友消息要发系统消息！！！" userInfo:nil];
        }
        RCConversationModel *customModel = [RCConversationModel new];
        //自定义cell的type
        customModel.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        customModel.senderUserId = message.senderUserId;
        customModel.lastestMessage = message.content;
        dispatch_async(dispatch_get_main_queue(), ^{
            //调用父类刷新未读消息数
            [blockSelf_ refreshConversationTableViewWithConversationModel:customModel];
            [super didReceiveMessageNotification:notification];
            [blockSelf_ resetConversationListBackgroundViewIfNeeded];
            [self notifyUpdateUnreadMessageCount];
            
            //当消息为RCContactNotificationMessage时，没有调用super，如果是最后一条消息，可能需要刷新一下整个列表。
            //原因请查看super didReceiveMessageNotification的注释。
            
        });
        
    }else if (message.conversationType == ConversationType_PRIVATE){
        //获取接受到会话
        RCConversation *receivedConversation = [[RCIMClient sharedRCIMClient] getConversation:message.conversationType targetId:message.targetId];
        
        //转换新会话为新会话模型
        RCConversationModel *customModel = [[RCConversationModel alloc] init:RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION conversation:receivedConversation extend:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            //调用父类刷新未读消息数
            [blockSelf_ refreshConversationTableViewWithConversationModel:customModel];
            //[super didReceiveMessageNotification:notification];
            [blockSelf_ resetConversationListBackgroundViewIfNeeded];
            [self notifyUpdateUnreadMessageCount];
            
            //当消息为RCContactNotificationMessage时，没有调用super，如果是最后一条消息，可能需要刷新一下整个列表。
            //原因请查看super didReceiveMessageNotification的注释。
            NSNumber *left = [notification.userInfo objectForKey:@"left"];
            if (0 == left.integerValue) {
                [super refreshConversationTableViewIfNeeded];
            }
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            //            调用父类刷新未读消息数
            [super didReceiveMessageNotification:notification];
            [blockSelf_ resetConversationListBackgroundViewIfNeeded];
            [self notifyUpdateUnreadMessageCount];
            
            //        super会调用notifyUpdateUnreadMessageCount
        });
    }
    [[RCDataManager shareManager] getUserInfoWithUserId:message.senderUserId completion:^(RCUserInfo *userInfo) {
        NSLog(@"didReceiveMessageNotification 名字 ＝ %@  ID ＝ %@",userInfo.name,userInfo.userId);
    }];
    [self refreshConversationTableViewIfNeeded];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.conversationListDataSource.count;
}
- (void)showEmptyConversationView{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  RCDataManager.m
//  RCIM
//
//  Created by codeDing on 16/3/2.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "RCDataManager.h"
#import "RCUserInfo+Addition.h"
#import "AppDelegate.h"
@implementation RCDataManager{
        NSMutableArray *dataSoure;
}

- (instancetype)init{
    if (self = [super init]) {
        [RCIM sharedRCIM].userInfoDataSource = self;
    }
    return self;
}

+ (RCDataManager *)shareManager{
    static RCDataManager* manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}
/**
 *  从服务器同步好友列表
 */
-(void)syncFriendList:(void (^)(NSMutableArray* friends,BOOL isSuccess))completion
{
    dataSoure = [[NSMutableArray alloc]init];

    for (NSInteger i = 1; i<4; i++) {
        if(i==1){
            RCUserInfo *aUserInfo =[[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"user%ld",(long)i] name:@"user1" portrait:@"http://img0.pconline.com.cn/pconline/bizi/desktop/1506/Sm2.jpg" QQ:@"好友" sex:@"男"];
            [dataSoure addObject:aUserInfo];
            
        }else if (i==2) {
            RCUserInfo *aUserInfo =[[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"user%ld",(long)i] name:@"user2" portrait:@"http://img0.pconline.com.cn/pconline/bizi/desktop/1506/Sm4.jpg" QQ:@"好友" sex:@"女"];
            [dataSoure addObject:aUserInfo];
        }
        else if (i==3) {
            RCUserInfo *aUserInfo =[[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"user%ld",(long)i] name:@"user3" portrait:@"http://img0.pconline.com.cn/pconline/bizi/desktop/1506/Sm5.jpg" QQ:@"好友" sex:@"女"];
            [dataSoure addObject:aUserInfo];
        }
        

        
        
    }

    [AppDelegate shareAppDelegate].friendsArray = dataSoure;
    completion(dataSoure,YES);

}
/**
 *  从服务器同步群组列表
 */
-(void) syncGroupList:(void (^)(NSMutableArray * groups,BOOL isSuccess))completion{
    if ([AppDelegate shareAppDelegate].groupsArray.count) {
        [[AppDelegate shareAppDelegate].groupsArray removeAllObjects];
    }
    for (NSInteger i = 1; i<4; i++) {
        if (i==1) {
            RCGroup *aGroup = [[RCGroup alloc]initWithGroupId:[NSString stringWithFormat:@"group%ld",i] groupName:@"华高小学（一年级1班）" portraitUri:@"http://farm2.staticflickr.com/1709/24157242566_98d0192315_m.jpg"];
            [[AppDelegate shareAppDelegate].groupsArray addObject:aGroup];
            
        }
//        else if (i==2){
//            RCGroup *aGroup = [[RCGroup alloc]initWithGroupId:[NSString stringWithFormat:@"group%ld",i] groupName:@"群组2" portraitUri:@"http://farm2.staticflickr.com/1715/23815656639_ef86cf1498_m.jpg"];
//            [[AppDelegate shareAppDelegate].groupsArray addObject:aGroup];
//            
//        }
//        else if (i==3){
//            RCGroup *aGroup = [[RCGroup alloc]initWithGroupId:[NSString stringWithFormat:@"%ld",i] groupName:@"群组3" portraitUri:@"http://farm2.staticflickr.com/1455/23888379640_edf9fce919_m.jpg"];
//            [[AppDelegate shareAppDelegate].groupsArray addObject:aGroup];
//        }
    }
    completion([AppDelegate shareAppDelegate].groupsArray,YES);

}
#pragma mark
#pragma mark 根据userId获取RCUserInfo
-(RCUserInfo *)currentUserInfoWithUserId:(NSString *)userId{
    for (NSInteger i = 0; i<[AppDelegate shareAppDelegate].friendsArray.count; i++) {
        RCUserInfo *aUser = [AppDelegate shareAppDelegate].friendsArray[i];
        if ([userId isEqualToString:aUser.userId]) {
            NSLog(@"current ＝ %@",aUser.name);
            return aUser;
        }
    }
    return nil;
}
#pragma mark
#pragma mark 根据userId获取RCGroup
-(RCGroup *)currentGroupInfoWithGroupId:(NSString *)groupId{
    for (NSInteger i = 0; i<[AppDelegate shareAppDelegate].groupsArray.count; i++) {
        RCGroup *aGroup = [AppDelegate shareAppDelegate].groupsArray[i];
        if ([groupId isEqualToString:aGroup.groupId]) {
            return aGroup;
        }
    }
    return nil;
}
-(NSString *)currentNameWithUserId:(NSString *)userId{
    for (NSInteger i = 0; i<[AppDelegate shareAppDelegate].friendsArray.count; i++) {
        RCUserInfo *aUser = [AppDelegate shareAppDelegate].friendsArray[i];
        if ([userId isEqualToString:aUser.userId]) {
            NSLog(@"current ＝ %@",aUser.name);
            return aUser.name;
        }
    }
    return nil;
}
#pragma mark
#pragma mark - RCIMUserInfoDataSource
- (void)getUserInfoWithUserId:(NSString*)userId completion:(void (^)(RCUserInfo*))completion
{
//    NSLog(@"getUserInfoWithUserId ----- %@", userId);
    
    if (userId == nil || [userId length] == 0 )
    {
        [self syncFriendList:^(NSMutableArray *friends, BOOL isSuccess) {
            
        }];
        
        completion(nil);
        return ;
    }
    
    if ([userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        RCUserInfo *myselfInfo = [[RCUserInfo alloc]initWithUserId:[RCIM sharedRCIM].currentUserInfo.userId name:[RCIM sharedRCIM].currentUserInfo.name portrait:[RCIM sharedRCIM].currentUserInfo.portraitUri QQ:[RCIM sharedRCIM].currentUserInfo.QQ sex:[RCIM sharedRCIM].currentUserInfo.sex];
        completion(myselfInfo);
        
    }
    
    for (NSInteger i = 0; i<[AppDelegate shareAppDelegate].friendsArray.count; i++) {
        RCUserInfo *aUser = [AppDelegate shareAppDelegate].friendsArray[i];
        if ([userId isEqualToString:aUser.userId]) {
            completion(aUser);
            break;
        }
    }
}
#pragma mark
#pragma mark - RCIMGroupInfoDataSource
- (void)getGroupInfoWithGroupId:(NSString *)groupId
                     completion:(void (^)(RCGroup *groupInfo))completion{
    for (NSInteger i = 0; i<[AppDelegate shareAppDelegate].groupsArray.count; i++) {
        RCGroup *aGroup = [AppDelegate shareAppDelegate].groupsArray[i];
        if ([groupId isEqualToString:aGroup.groupId]) {
            completion(aGroup);
            break;
        }
    }
}
-(void)loginRongCloudWithUserInfo:(RCUserInfo *)userInfo withToken:(NSString *)token{
                [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
                    [RCIM sharedRCIM].globalNavigationBarTintColor = [UIColor redColor];
                    NSLog(@"login success with userId %@",userId);
                    //同步好友列表
                    [self syncFriendList:^(NSMutableArray *friends, BOOL isSuccess) {
                        NSLog(@"%@",friends);
                        if (isSuccess) {
                            [self syncGroupList:^(NSMutableArray *groups, BOOL isSuccess) {
                                if (isSuccess) {
                                    NSLog(@" success 发送通知");
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"alreadyLogin" object:nil];
                                }
                            }];
                           
                        }
                    }];
                    

                    [RCIMClient sharedRCIMClient].currentUserInfo = userInfo;
                    [[RCDataManager shareManager] refreshBadgeValue];
                } error:^(RCConnectErrorCode status) {
                    NSLog(@"status = %ld",(long)status);
                } tokenIncorrect:^{
                    
                    NSLog(@"token 错误");
                }];
            
            
        
   
}

-(void)refreshBadgeValue{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSInteger unreadMsgCount = (NSInteger)[[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_GROUP),@(ConversationType_CHATROOM)]];

        
        UINavigationController  *chatNav = [AppDelegate shareAppDelegate].tabbarVC.viewControllers[1];
        if (unreadMsgCount == 0) {
            chatNav.tabBarItem.badgeValue = nil;
        }else{
            chatNav.tabBarItem.badgeValue = [NSString stringWithFormat:@"%li",(long)unreadMsgCount];
        }
    });
}
-(BOOL)hasTheFriendWithUserId:(NSString *)userId{
    if ([AppDelegate shareAppDelegate].friendsArray.count) {
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        
        for (RCUserInfo *aUserInfo in [AppDelegate shareAppDelegate].friendsArray) {
            [tempArray addObject:aUserInfo.userId];
        }
        
        if ([tempArray containsObject:userId]) {
            return YES;
        }
    }
    
    
    return NO;
}
@end


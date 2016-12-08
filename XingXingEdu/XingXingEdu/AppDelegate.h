//
//  AppDelegate.h
//  xingxingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/1/13.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
 #import <SMS_SDK/SMSSDK.h>
#import <RongIMKit/RongIMKit.h>
#import "RcRootTabbarViewController.h"
#import "RCDataManager.h"
#import "WMUtil.h"

static NSString *appKey = @"fdab3a52561b68cc14d8a4ae";
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain)RcRootTabbarViewController *tabbarVC;
@property(nonatomic,retain) NSMutableArray *friendsArray;
@property(nonatomic,retain) NSMutableArray *groupsArray;

/// func
+ (AppDelegate* )shareAppDelegate;


@end


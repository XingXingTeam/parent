//
//  XXEUserInfo.h
//  XMPPDemo
//
//  Created by codeDing on 16/7/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXEUserInfo : NSObject
/** 用户电话号码 */
@property (nonatomic, copy) NSString *account;

/** 密码 */
@property (nonatomic, copy) NSString *passWord;
/** QQ */
@property (nonatomic, copy) NSString *qqNumber;
/** 微信 */
@property (nonatomic, copy) NSString *weixin;
/** 新浪 */
@property (nonatomic, copy) NSString *sinaNumber;
/** 支付宝 */
@property (nonatomic, copy) NSString *zhifubao;
/** 用户头像 */
@property (nonatomic, copy) NSString *user_head_img;
/** 用户昵称 */
@property (nonatomic, copy) NSString *nickname;
/** 用户类型  1代表家长端,2代表教师端 */
@property (nonatomic, copy) NSString *user_type;
/** 用户id */
@property (nonatomic, copy) NSString *user_id;
/** 融云用户端的token */
@property (nonatomic, copy) NSString *token;
/** 用户的猩ID */
@property (nonatomic, copy) NSString *xid;
/** 判断次数 */
@property (nonatomic, copy) NSString *login_times;
/** 判断是否登录 */
@property (nonatomic, assign, getter=isLogin) BOOL login;
/** 判断是否注册 */
@property (nonatomic, assign, getter=isRegiste) BOOL registe;


+ (instancetype)user;
- (void)setupUserInfoWithUserInfo:(NSDictionary *)userInfo;
- (void)synchronizeDefaultsInfo;

- (void)cleanUserInfo;

@end

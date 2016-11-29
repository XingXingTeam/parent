//
//  XXESystemNotificationModel.h
//  XingXingEdu
//
//  Created by Mac on 16/9/13.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXESystemNotificationModel : JSONModel

/*
 (
 [id] => 1
 [type] => 0
 [date_tm] => 1458884982
 [title] => APP升级通知
 [con] => 猩猩教室APP版本1.1上线了,请及时更新
 [school_name] => 猩猩教室
 [school_logo] => app_upload/app_logo.png
 )
 */
@property (nonatomic, copy) NSString *notice_id;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *date_tm;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *con;
@property (nonatomic, copy) NSString *school_name;
@property (nonatomic, copy) NSString *school_logo;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;

@end

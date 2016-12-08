//
//  XXESchoolNotificationModel.h
//  XingXingEdu
//
//  Created by Mac on 16/9/13.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXESchoolNotificationModel : JSONModel

/*
 (
 [id] => 7
 [type] => 2		//1:班级通知, 2:学校通知
 [school_id] => 1
 [class_name] =>
 [date_tm] => 1469573367
 [title] => 植树节活动通知
 [con] => 各位尊敬的家长：  3月12日是一年一度的植树节，为了使孩子们亲身体验大自然造绿工程，感受劳动的乐趣，增长植物生长的知识，增强爱护环境保护家园的社会责任感，以植树节为契机，家委会策划并组织班级学生和家长共同开展“播种绿色、放飞希望”植树活动。请您仔细阅读以下相关事项并按要求完成报名工作和准备工作。
 活动时间及集合地点  2015年3月13日（本周五下午2:00—5:00）
 集合地点：学校校门口（晨光文具店对面）
 集合时间：下午2:00
 活动地点:长沙市岳麓区含浦镇
 [tid] => 3
 [examine_tid] => 5
 [school_logo] => app_upload/text/school_logo/1.jpg
 [school_name] =>
 [tname] => 高大京
 )
 */
@property (nonatomic, copy) NSString *notice_id;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *class_name;
@property (nonatomic, copy) NSString *date_tm;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *con;
@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *examine_tid;
@property (nonatomic, copy) NSString *school_logo;
@property (nonatomic, copy) NSString *school_name;
@property (nonatomic, copy) NSString *tname;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;



@end

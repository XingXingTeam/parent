//
//  XXERedFlowerModel.h
//  XingXingEdu
//
//  Created by Mac on 2016/12/7.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXERedFlowerModel : JSONModel


/*
 [id] => 1
 [school_type] => 1			//学校类型
 [date_tm] => 1461900512		//赠送时间戳
 [tid] => 1				//教师id
 [position] => 1			//教师职务,1是普通老师,2是管理(主任),3是校长
 [baby_id] => 1			//孩子id
 [con] => 表现不错			//赠言
 [school_id] => 1			//学校id
 [school_name] => 上海桃园小学	//校名
 [class_name] => 1			//班级名
 [teach_course] => 语文		//授课
 [num] => 1				//赠送数量
 [pic] => app_upload/text/lesson2.jpg,app_upload/text/lesson1.jpg //多个逗号隔开
 [tname] => 梁洪洲				//教师真实姓名
 [head_img] => app_upload/text/hankuke3.jpg	//教师头像
 [head_img_type] => 0			//教师类型 1为第三方头像
 [collect_condit] => 1			//1:代表收藏过,2:代表未收藏过
 
 */
@property (nonatomic, copy) NSString<Optional> *flowerId;
@property (nonatomic, copy) NSString<Optional> *school_type;
@property (nonatomic, copy) NSString<Optional> *date_tm;
@property (nonatomic, copy) NSString<Optional> *tid;
@property (nonatomic, copy) NSString<Optional> *position;
@property (nonatomic, copy) NSString<Optional> *baby_id;
@property (nonatomic, copy) NSString<Optional> *con;
@property (nonatomic, copy) NSString<Optional> *school_id;
@property (nonatomic, copy) NSString<Optional> *school_name;
@property (nonatomic, copy) NSString<Optional> *class_name;
@property (nonatomic, copy) NSString<Optional> *teach_course;
@property (nonatomic, copy) NSString<Optional> *num;
@property (nonatomic, copy) NSString<Optional> *pic;
@property (nonatomic, copy) NSString<Optional> *tname;
@property (nonatomic, copy) NSString<Optional> *head_img;
@property (nonatomic, copy) NSString<Optional> *head_img_type;
@property (nonatomic, copy) NSString<Optional> *collect_condit;
@property (nonatomic, copy) NSString<Optional> *class_id;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;

@end

//
//  XXEHomeworkListModel.h
//  XingXingEdu
//
//  Created by Mac on 2016/12/23.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEHomeworkListModel : JSONModel

/*
 (
 [id] => 11			//作业id
 [school_id] => 1		//学校id
 [class_id] => 1		//班级
 [date_tm] => 1478854540	//发布时间
 [date_end_tm] => 1513673458	//交作业时间
 [month] => 11		//月份
 [tid] => 3			//老师id
 [teach_course] => 英语	//科目
 [title] => 回家作业		//标题
 [condit] => 3		//状态 1:急  2:写  3:新  4:结
 [tname] => 高大京		//老师姓名
 [head_img] => app_upload/text/teacher/3.jpg	//老师头像
 [head_img_type] => 0	//头像类型
 )
 */

@property (nonatomic, copy) NSString<Optional> *homeworkId;
@property (nonatomic, copy) NSString<Optional> *school_id;
@property (nonatomic, copy) NSString<Optional> *class_id;
@property (nonatomic, copy) NSString<Optional> *date_tm;
@property (nonatomic, copy) NSString<Optional> *date_end_tm;
@property (nonatomic, copy) NSString<Optional> *month;
@property (nonatomic, copy) NSString<Optional> *tid;
@property (nonatomic, copy) NSString<Optional> *teach_course;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *condit;
@property (nonatomic, copy) NSString<Optional> *tname;
@property (nonatomic, copy) NSString<Optional> *head_img;
@property (nonatomic, copy) NSString<Optional> *head_img_type;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;


@end

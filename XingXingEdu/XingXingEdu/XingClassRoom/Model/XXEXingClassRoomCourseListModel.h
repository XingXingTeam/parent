//
//  XXEXingClassRoomCourseListModel.h
//  teacher
//
//  Created by Mac on 16/10/20.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEXingClassRoomCourseListModel : JSONModel

/*
 [id] => 7				//课程id
 [date_tm] => 1460645548		//发布课程时间戳
 [course_name] => 新概念英语初级	//课程名
 [need_num] => 8			//开班需要人数
 [now_num] => 2			//已招到人数
 [coin] => 0				//0:不允许猩币抵扣 1:允许猩币抵扣
 [allow_return] => 0			//是否允许退课 0:不允许,1:允许
 [original_price] => 2100		//原价
 [now_price] => 1800			//现价
 [lng] => 121.61663600
 [lat] => 31.28572500
 [distance] => 0.3			//距离,单位km
 [pic] => app_upload/text/course/lesson4.jpg	//封面图
 [teacher_tname_group] => Array		//负责课程的老师,可以多个
 (
 [0] => 韩可可
 
 )
 )
 */

@property (nonatomic, copy) NSString<Optional> *courseId;
@property (nonatomic, copy) NSString<Optional> *course_name;
@property (nonatomic, copy) NSString<Optional> *need_num;
@property (nonatomic, copy) NSString<Optional> *now_num;
@property (nonatomic, copy) NSString<Optional> *original_price;
@property (nonatomic, copy) NSString<Optional> *now_price;
@property (nonatomic, copy) NSString<Optional> *coin;
@property (nonatomic, copy) NSString<Optional> *allow_return;
@property (nonatomic, copy) NSString<Optional> *course_pic;
@property (nonatomic, strong) NSArray<Optional> *teacher_tname_group;
@property (nonatomic, copy) NSString<Optional> *date_tm;
@property (nonatomic, copy) NSString<Optional> *lng;
@property (nonatomic, copy) NSString<Optional> *lat;
@property (nonatomic, copy) NSString<Optional> *distance;
@property (nonatomic, copy) NSString<Optional> *pic;


+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;

@end

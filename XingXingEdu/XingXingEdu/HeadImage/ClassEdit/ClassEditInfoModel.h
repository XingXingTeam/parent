//
//  ClassEditInfoModel.h
//  XingXingEdu
//
//  Created by Mac on 2016/11/18.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ClassEditInfoModel : JSONModel

/*
 {
	id = 64,
	baby_id = 3,
	examine_tname = ,
	class_name = 少儿芭蕾舞201604,
	school_id = 8,
	school_name = 水晶鞋,
	parent_group = 1,3,
	sch_type = 4,
	school_logo = app_upload/text/school_logo/8.jpg,
	date_tm = 1458884982,
	province = 上海市,
	term_end_tm = 1473997548,
	city = 上海市,
	teacher = 姜莉莉,
	district = 浦东新区,
	term_start_tm = 1466864748,
	course_id = 16,
	condit = 1,
	graduate_tm = 1777747200
 }
 */

@property (nonatomic, copy) NSString<Optional> *class_edit_id;
@property (nonatomic, copy) NSString<Optional> *baby_id;
@property (nonatomic, copy) NSString<Optional> *examine_tname;
@property (nonatomic, copy) NSString<Optional> *class_name;
@property (nonatomic, copy) NSString<Optional> *school_id;
@property (nonatomic, copy) NSString<Optional> *school_name;
@property (nonatomic, copy) NSString<Optional> *parent_group;
@property (nonatomic, copy) NSString<Optional> *sch_type;
@property (nonatomic, copy) NSString<Optional> *school_logo;
@property (nonatomic, copy) NSString<Optional> *date_tm;
@property (nonatomic, copy) NSString<Optional> *province;
@property (nonatomic, copy) NSString<Optional> *term_end_tm;
@property (nonatomic, copy) NSString<Optional> *city;
@property (nonatomic, copy) NSString<Optional> *teacher;
@property (nonatomic, copy) NSString<Optional> *district;
@property (nonatomic, copy) NSString<Optional> *term_start_tm;
@property (nonatomic, copy) NSString<Optional> *course_id;
@property (nonatomic, copy) NSString<Optional> *condit;
@property (nonatomic, copy) NSString<Optional> *graduate_tm;



+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;



@end

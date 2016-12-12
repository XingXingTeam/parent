//
//  XXEClassAddressTeacherInfoModel.h
//  teacher
//
//  Created by Mac on 16/8/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEClassAddressTeacherInfoModel : JSONModel

/*
 老师
 
 {
 "head_img" = "app_upload/text/teacher/1.jpg";
 "head_img_type" = 0;
 id = 1;
 "teach_course" = "\U8bed\U6587,\U97f3\U4e50";
 tname = "\U6881\U7ea2\U6c34";
 xid = 18886389;
 }
 */

@property (nonatomic, copy) NSString<Optional> *teacher_id;
@property (nonatomic, copy) NSString<Optional> *head_img_type;
@property (nonatomic, copy) NSString<Optional> *head_img;
@property (nonatomic, copy) NSString<Optional> *teach_course;
@property (nonatomic, copy) NSString<Optional> *tname;
@property (nonatomic, copy) NSString<Optional> *xid;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;


@end

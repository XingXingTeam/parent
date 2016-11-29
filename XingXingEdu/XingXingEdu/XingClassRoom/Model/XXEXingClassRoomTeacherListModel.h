//
//  XXEXingClassRoomTeacherListModel.h
//  teacher
//
//  Created by Mac on 16/10/20.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEXingClassRoomTeacherListModel : JSONModel

/*
 {
 age = 30;
 certification = 0;
 distance = 0;
 "exper_year" = 4;
 "head_img" = "app_upload/text/teacher/7.jpg";
 "head_img_type" = 0;
 id = 7;
 lat = "31.28190300";
 lng = "121.60582400";
 "login_tm" = 1476259972;
 nickname = kidki;
 popularity = "4.6300";
 "score_num" = "4.6200";
 sex = "\U7537";
 "teach_range" = "\U82f1\U8bed";
 tname = "\U94b1\U5e7f\U4e00";
 xid = 18886395;
 }
 */
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *teacher_id;
@property (nonatomic, copy) NSString *certification;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *exper_year;
@property (nonatomic, copy) NSString *head_img;
@property (nonatomic, copy) NSString *head_img_type;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *login_tm;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *popularity;
@property (nonatomic, copy) NSString *score_num;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *teach_range;
@property (nonatomic, copy) NSString *tname;
@property (nonatomic, copy) NSString *xid;


+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;



@end

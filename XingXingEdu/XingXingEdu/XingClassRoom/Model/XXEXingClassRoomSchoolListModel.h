//
//  XXEXingClassRoomSchoolListModel.h
//  teacher
//
//  Created by Mac on 16/10/20.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEXingClassRoomSchoolListModel : JSONModel

/*
 {
 address = "\U91d1\U4eac\U8def107\U53f7";
 "baby_count" = 3;
 city = "\U4e0a\U6d77\U5e02";
 "comment_num" = 0;
 distance = "1.52";
 district = "\U6d66\U4e1c\U65b0\U533a";
 id = 11;
 lat = "31.28547800";
 lng = "121.62123500";
 logo = "app_upload/text/school_logo/11.jpg";
 name = "\U4e0a\U6d77\U4e1c\U7fd4\U6559\U80b2";
 popularity = "4.4000";
 province = "\U4e0a\U6d77\U5e02";
 "score_num" = "4.6000";
 "teacher_count" = 1;
 }
 */
@property (nonatomic, copy) NSString<Optional> *address;
@property (nonatomic, copy) NSString<Optional> *baby_count;
@property (nonatomic, copy) NSString<Optional> *city;
@property (nonatomic, copy) NSString<Optional> *comment_num;
@property (nonatomic, copy) NSString<Optional> *distance;
@property (nonatomic, copy) NSString<Optional> *district;
@property (nonatomic, copy) NSString<Optional> *school_id;
@property (nonatomic, copy) NSString<Optional> *lat;
@property (nonatomic, copy) NSString<Optional> *lng;
@property (nonatomic, copy) NSString<Optional> *logo;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *popularity;
@property (nonatomic, copy) NSString<Optional> *province;
@property (nonatomic, copy) NSString<Optional> *score_num;
@property (nonatomic, copy) NSString<Optional> *teacher_count;



+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;


@end

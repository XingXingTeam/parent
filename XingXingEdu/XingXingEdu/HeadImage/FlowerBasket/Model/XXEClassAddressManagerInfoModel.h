//
//  XXEClassAddressManagerInfoModel.h
//  teacher
//
//  Created by Mac on 16/8/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEClassAddressManagerInfoModel : JSONModel

/*
 {
 "head_img" = "app_upload/text/teacher/4.jpg";
 "head_img_type" = 0;
 id = 4;
 "teach_course" = "\U540e\U52e4";
 tname = "\U59dc\U8389\U8389";
 xid = 18886392;
 }
 */

@property (nonatomic, copy) NSString<Optional> *head_img;
@property (nonatomic, copy) NSString<Optional> *head_img_type;
@property (nonatomic, copy) NSString<Optional> *manager_id;
@property (nonatomic, copy) NSString<Optional> *teach_course;
@property (nonatomic, copy) NSString<Optional> *tname;
@property (nonatomic, copy) NSString<Optional> *xid;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;


@end

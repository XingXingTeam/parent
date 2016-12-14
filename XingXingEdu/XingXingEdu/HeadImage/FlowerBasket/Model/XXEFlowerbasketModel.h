//
//  XXEFlowerbasketModel.h
//  XingXingEdu
//
//  Created by Mac on 2016/12/9.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEFlowerbasketModel : JSONModel

/*
 [id] => 1
 [date_tm] => 1464262407
 [pid] => 1
 [tid] => 1
 [num] => 1
 [con] => 谢谢照顾我的孩子
 [head_img] => app_upload/text/teacher/1.jpg
 [head_img_type] => 0
 [tname] => 梁红水
 */

@property (nonatomic, copy) NSString *flowerbasketId;
@property (nonatomic, copy) NSString *date_tm;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *con;
@property (nonatomic, copy) NSString *tname;
@property (nonatomic, copy) NSString *head_img;
@property (nonatomic, copy) NSString *head_img_type;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;


@end

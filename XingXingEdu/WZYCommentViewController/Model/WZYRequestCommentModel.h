//
//  WZYRequestCommentModel.h
//  XingXingEdu
//
//  Created by Mac on 16/7/3.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZYRequestCommentModel : NSObject

/*
 {
 tname = 姜兰兰,
 teach_course = 英语,
 tid = 15,
 head_img = app_upload/text/teacher/15.jpg,
 head_img_type = 0
 }
 
 
 {
 head_img = app_upload/text/teacher/4.jpg,
 id = 4,
 tname = 姜莉莉,
 teach_course = 后勤,
 head_img_type = 0
 }
 */

@property (nonatomic, copy) NSString *nameStr;
@property (nonatomic, copy) NSString *jobStr;
@property (nonatomic, copy) NSString *iconStr;
@property (nonatomic, copy) NSString *tidStr;
@property (nonatomic, copy) NSString *head_imgStr;
@property (nonatomic, copy) NSString *head_img_typeStr;



//通过字典来赋值
- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)modelWithDictionary:(NSDictionary *)dict;



@end

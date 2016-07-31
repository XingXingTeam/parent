//
//  ClassTimeTableModel.h
//  XingXingEdu
//
//  Created by keenteam on 16/7/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ClassTimeTableModel : JSONModel
@property (nonatomic,strong) NSNumber<Optional> * kId;//id号
@property (nonatomic,copy) NSString<Optional> * week_date;//图片
@property (nonatomic,copy) NSString<Optional> * lesson_start_tm;//标题
@property (nonatomic,copy) NSString<Optional> * course_end_tm;//发布时间
@property (nonatomic,copy) NSString<Optional> * course_name;//描述
@property (nonatomic,strong) NSString<Optional> * teacher_name;//二级页面URL

@property (nonatomic,copy) NSString<Optional> * classroom;//描述
@property (nonatomic,strong) NSString<Optional> * notes;//二级页面URL
@property (nonatomic,copy) NSString<Optional> * type;//描述
@property (nonatomic,strong) NSString<Optional> * wd;//二级页面URL
@end

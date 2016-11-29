//
//  XXECourseManagerClassModel3.h
//  teacher
//
//  Created by Mac on 16/9/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXECourseManagerClassModel3 : JSONModel

/*
 [class3] => 1
 [name] => 艺术
 */

@property (nonatomic, copy) NSString *class3;
@property (nonatomic, copy) NSString *name;

+ (NSArray*)parseResondsData:(id)respondObject;

@end

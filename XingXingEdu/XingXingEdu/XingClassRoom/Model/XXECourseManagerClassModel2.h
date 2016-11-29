//
//  XXECourseManagerClassModel2.h
//  teacher
//
//  Created by Mac on 16/9/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXECourseManagerClassModel2 : JSONModel

/*
 [class2] => 1
 [name] => 艺术
 */

@property (nonatomic, copy) NSString *class2;
@property (nonatomic, copy) NSString *name;

+ (NSArray*)parseResondsData:(id)respondObject;

@end

//
//  XXECourseManagerClassModel1.h
//  teacher
//
//  Created by Mac on 16/9/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXECourseManagerClassModel1 : JSONModel

/*
 [class1] => 1
 [name] => 艺术
 */

@property (nonatomic, copy) NSString *class1;
@property (nonatomic, copy) NSString *name;

+ (NSArray*)parseResondsData:(id)respondObject;



@end

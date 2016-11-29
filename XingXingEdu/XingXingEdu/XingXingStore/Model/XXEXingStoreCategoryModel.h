//
//  XXEXingStoreCategoryModel.h
//  XingXingEdu
//
//  Created by Mac on 16/10/13.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEXingStoreCategoryModel : JSONModel

/*
 {
	id = 2,
	name = 话费
 }
 */

@property (nonatomic, copy) NSString <Optional>*category_id;
@property (nonatomic, copy) NSString <Optional>*category_name;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;

@end

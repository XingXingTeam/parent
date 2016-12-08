//
//  XXESearchHistoryWord.h
//  teacher
//
//  Created by Mac on 16/10/21.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXESearchHistoryWord : NSObject

@property (nonatomic, strong) NSString * searchDate;

@property (nonatomic, strong) NSString * word;

//直接实现静态方法，获取带有name和age的Person对象
+(XXESearchHistoryWord *)hisWordWithSearchDate:(NSString *)date andWord:(NSString *)word;
+ (XXESearchHistoryWord*)changDicToHisWord:(NSMutableDictionary *)dic;

-(NSComparisonResult)compare:(XXESearchHistoryWord *)hisWord;

- (NSMutableDictionary *)changeModelToDic;

@end

//
//  Model_HisWord.h
//  HistoryList
//
//  Created by GE on 16/1/5.
//  Copyright © 2016年 GE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model_HisWord : NSObject

@property (nonatomic, strong) NSString * searchDate;

@property (nonatomic, strong) NSString * word;

//直接实现静态方法，获取带有name和age的Person对象
+(Model_HisWord *)hisWordWithSearchDate:(NSString *)date andWord:(NSString *)word;
+ (Model_HisWord*)changDicToHisWord:(NSMutableDictionary *)dic;

-(NSComparisonResult)compare:(Model_HisWord *)hisWord;

- (NSMutableDictionary *)changeModelToDic;


@end

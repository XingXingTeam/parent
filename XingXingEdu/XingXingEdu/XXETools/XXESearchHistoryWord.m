


//
//  XXESearchHistoryWord.m
//  teacher
//
//  Created by Mac on 16/10/21.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESearchHistoryWord.h"

@implementation XXESearchHistoryWord

+(XXESearchHistoryWord *)hisWordWithSearchDate:(NSString *)date andWord:(NSString *)word{
    XXESearchHistoryWord * hisWord = [[XXESearchHistoryWord alloc] init];
    hisWord.searchDate = date;
    hisWord.word = word;
    return hisWord;
}

+ (XXESearchHistoryWord*)changDicToHisWord:(NSMutableDictionary *)dic
{
    XXESearchHistoryWord * word = [[XXESearchHistoryWord alloc]init];
    word.searchDate = [dic objectForKey:@"date"];
    word.word = [dic objectForKey:@"word"];
    
    return word;
}

//对象转字典
- (NSMutableDictionary *)changeModelToDic
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:self.searchDate forKey:@"date"];
    [dic setObject:self.word forKey:@"word"];
    return dic;
}


//自定义排序方法
-(NSComparisonResult)compare:(XXESearchHistoryWord *)hisWord{
    //按时间排序
    NSComparisonResult result = [hisWord.searchDate compare:self.searchDate];
    
    //    NSLog("");
    return result;
}

@end

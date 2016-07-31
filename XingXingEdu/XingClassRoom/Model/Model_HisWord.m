//
//  Model_HisWord.m
//  HistoryList
//
//  Created by GE on 16/1/5.
//  Copyright © 2016年 GE. All rights reserved.
//

#import "Model_HisWord.h"

@implementation Model_HisWord

+(Model_HisWord *)hisWordWithSearchDate:(NSString *)date andWord:(NSString *)word{
    Model_HisWord * hisWord = [[Model_HisWord alloc] init];
    hisWord.searchDate = date;
    hisWord.word = word;
    return hisWord;
}

+ (Model_HisWord*)changDicToHisWord:(NSMutableDictionary *)dic
{
    Model_HisWord * word = [[Model_HisWord alloc]init];
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
-(NSComparisonResult)compare:(Model_HisWord *)hisWord{
    //按时间排序
    NSComparisonResult result = [hisWord.searchDate compare:self.searchDate];

//    NSLog("");
    return result;
}


@end

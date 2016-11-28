



//
//  WZYTool.m
//  XingXingEdu
//
//  Created by Mac on 16/6/7.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "WZYTool.h"

@implementation WZYTool

+ (NSString *)dateStringFromNumberTimer:(NSString *)timerStr {
    //转化为Double
    double t = [timerStr doubleValue];
    //计算出距离1970的NSDate
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
    //转化为 时间格式化字符串
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //转化为 时间字符串
    return [df stringFromDate:date];
}

+ (NSString *)dateStringFromNumberTime:(NSString *)timeStr {
    //转化为Double
    double t = [timeStr doubleValue];
    //计算出距离1970的NSDate
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
    //转化为 时间格式化字符串
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    //转化为 时间字符串
    return [df stringFromDate:date];
}

//阿拉伯数字转化为大写汉字
+ (NSString *)changeStringFromFigure:(NSString *)figureStr{
    NSString *newStr;
    if ([figureStr isEqualToString:@"1"]) {
        newStr = @"一";
    }else if ([figureStr isEqualToString:@"2"]){
        
        newStr = @"二";
    }else if ([figureStr isEqualToString:@"3"]){
        newStr = @"三";
    }else if ([figureStr isEqualToString:@"4"]){
        newStr = @"四";
    }else if ([figureStr isEqualToString:@"5"]){
        newStr = @"五";
    }else if ([figureStr isEqualToString:@"6"]){
        newStr = @"六";
    }else if ([figureStr isEqualToString:@"7"]){
        newStr = @"七";
    }
    
    return newStr;
}



@end

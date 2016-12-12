//
//  WZYTool.h
//  XingXingEdu
//
//  Created by Mac on 16/6/7.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface WZYTool : NSObject

+ (NSString *)dateStringFromNumberTimer:(NSString *)timerStr;

//时间 转化  年月日 时分秒
+ (NSString *)dateStringFromNumberTime:(NSString *)timeStr;

//阿拉伯数字转化为大写汉字
+ (NSString *)changeStringFromFigure:(NSString *)figureStr;


@end

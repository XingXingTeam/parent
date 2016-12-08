//
//  CheckIDCard.m
//  xingxingEdu
//
//  Created by codeDing on 16/1/18.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "CheckIDCard.h"

@implementation CheckIDCard
+(BOOL)checkIDCard:(NSString * )idCard{

    
NSString *urlStr = [NSString stringWithFormat:@"http://apicloud.mob.com/idcard/query?key=ec9c9a472b8c&cardno=%@",idCard];
 NSURL *url = [NSURL URLWithString:urlStr];
NSData *data = [NSData dataWithContentsOfURL:url];
//NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
NSError *error;
NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if([dict[@"msg"] isEqualToString:@"success"]){
        return YES;
    }else{
        return NO;
        
    }
}

+(BOOL)checkIDCardSexMan:(NSString * )idCard{
    NSString *urlStr = [NSString stringWithFormat:@"http://apicloud.mob.com/idcard/query?key=ec9c9a472b8c&cardno=%@",idCard];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *data = [NSData dataWithContentsOfURL:url];
       NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary * infoDict=dict[@"result"];
    if([infoDict[@"sex"] isEqualToString:@"男"]){
        return YES;
    }else{
        return NO;
        
    }

}
+(NSString *)checkIDCardSex:(NSString * )idCard{
    NSString *urlStr = [NSString stringWithFormat:@"http://apicloud.mob.com/idcard/query?key=ec9c9a472b8c&cardno=%@",idCard];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary * infoDict=dict[@"result"];
    if([infoDict[@"sex"] isEqualToString:@"男"]){
        return @"男";
    }else{
        return @"女";
        
    }

}
+(NSString *)checkIDCardAge:(NSString * )idCard{
 
    NSString * ageStr=[idCard substringWithRange:NSMakeRange(6, 4)];
    NSLog(@"%@",ageStr);
    //计算出当前年份
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSDate *now=[NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: now];
    NSDate *nowDate = [now dateByAddingTimeInterval: interval];
    NSString *dateStr=[formatter stringFromDate:nowDate];
    NSLog(@"%@",dateStr);
    //年龄差距
    int gap=[dateStr intValue]-[ageStr intValue];
    NSString *gapStr=[NSString stringWithFormat:@"%i",gap];
    return gapStr;
}



@end

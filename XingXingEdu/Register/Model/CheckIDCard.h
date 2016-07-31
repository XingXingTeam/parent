//
//  CheckIDCard.h
//  xingxingEdu
//
//  Created by codeDing on 16/1/18.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckIDCard : NSObject
+(BOOL)checkIDCard:(NSString * )idCard;
+(BOOL)checkIDCardSexMan:(NSString * )idCard;
+(NSString *)checkIDCardSex:(NSString * )idCard;
+(NSString *)checkIDCardAge:(NSString * )idCard;
@end

//
//  NSArray+decription.m
//  teacher
//
//  Created by codeDing on 16/12/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "NSArray+decription.h"

@implementation NSArray (decription)
- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *str = [NSMutableString stringWithFormat:@"%lu (\n", (unsigned long)self.count];
    
    for (id obj in self) {
        [str appendFormat:@"\t%@, \n", obj];
    }
    
    [str appendString:@")"];
    
    return str;
}
@end

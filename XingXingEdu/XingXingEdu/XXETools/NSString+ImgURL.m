//
//  NSString+ImgURL.m
//  teacher
//
//  Created by codeDing on 16/12/6.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "NSString+ImgURL.h"

@implementation NSString (ImgURL)
- (NSString*)URL80 {
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@", self];
    [str insertString:@"-80" atIndex:(self.length - 4)];
    return str;
}

- (NSString*)URL100 {
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@", self];
    [str insertString:@"-100" atIndex:(self.length - 4)];
    return str;
}
- (NSString*)URL200 {
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@", self];
    [str insertString:@"-200" atIndex:(self.length - 4)];
    return str;
}

@end

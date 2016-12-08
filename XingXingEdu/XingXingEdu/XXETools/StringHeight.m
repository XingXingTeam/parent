
//
//  StringHeight.m
//  teacher
//
//  Created by codeDing on 16/11/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "StringHeight.h"

@implementation StringHeight
+ (CGFloat)contentSizeOfString:(NSString*)content maxWidth:(CGFloat)width fontSize:(CGFloat)fontSize{
    if (content.length == 0) {
        return CGSizeZero.height;
    }
    //返回包含字符串的边框
    //1:指定限制大小，限制宽度，高度不限制
    //2:指定计算边框时的选项
    //NSStringDrawingUsesLineFragmentOrigin  从左上角开始计算
    //NSStringDrawingUsesFontLeading         包含行间距
    //3:字典，可以指定使用的字体
    //4:上下文 nil
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil];
    return rect.size.height;
}
@end

//
//  XingXingTool.h
//  XingXingEdu
//
//  Created by mac on 16/5/4.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XingXingTool : NSObject
// 创建导航条的按钮
+ (UIBarButtonItem *)createItemWithTitle:(NSString *)title backgroundImage:(NSString *)imageName target:(id)target sel:(SEL)sel;

// 创建cell的图标
+ (UIImageView *)createIconWithFrame:(CGRect)frame;

// 创建cell的标签
+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textAligment:(NSTextAlignment)textAligment;
@end

//
//  XingXingTool.m
//  XingXingEdu
//
//  Created by mac on 16/5/4.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "XingXingTool.h"
#import "UIImage+Extension.h"

@implementation XingXingTool

+ (UIBarButtonItem *)createItemWithTitle:(NSString *)title backgroundImage:(NSString *)imageName target:(id)target sel:(SEL)sel {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 24);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithOriginalImageName:imageName] forState:UIControlStateNormal];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *cateBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return cateBtn;
}


+ (UIImageView *)createIconWithFrame:(CGRect)frame {
    UIImageView *iconIV = [[UIImageView alloc] initWithFrame:frame];
    iconIV.layer.cornerRadius = 10.0f;
    iconIV.layer.masksToBounds = YES;
    iconIV.backgroundColor = [UIColor lightGrayColor];
    
    return iconIV;
}

+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textAligment:(NSTextAlignment)textAligment {
    UILabel *nameLB = [[UILabel alloc] initWithFrame:frame];
    nameLB.text = text;
    nameLB.font = font;
    nameLB.textAlignment = textAligment;
    
    return nameLB;
}



@end

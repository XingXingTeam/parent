//
//  HHControl.h
//  MyUility
//
//  Created by kt on 14-10-10.
//  Copyright (c) 2014年 keenteam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface HHControl : NSObject
#pragma mark 创建UIView
+(UIView *)createViewWithFrame:(CGRect )frame;
#pragma mark 创建UILable
+(UILabel *)createLabelWithFrame:(CGRect )frame Font:(int)font Text:(NSString *)text;
#pragma mark 创建UIButton
+(UIButton *)createButtonWithFrame:(CGRect)frame backGruondImageName:(NSString *)name Target:(id)target Action:(SEL)action Title:(NSString *)title;
#pragma mark 创建UIImageView
+(UIImageView *)createImageViewWithFrame:(CGRect )frame ImageName:(NSString *)imageName;
#pragma mark 创建UITextField
+(UITextField *)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder passWord:(BOOL)yesOrNo leftImageView:(UIImageView *)imageView rightImageView:(UIImageView *)rightImageView Font:(float)font;
#pragma mark 创建UISscrollView
+(UIScrollView *)createScrollViewWithFram:(CGRect)frame andSize:(CGSize)size;
#pragma mark 创建UIPageControl
+(UIPageControl *)createPageControlWithFram:(CGRect )frame andNumberPage:(NSInteger)number;
#pragma mark 创建UISlider
+(UISlider *)createSliderWithFrame:(CGRect)frame andImgaeName:(UIImage *)name;
+(UITextField *)createTextFielfFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder;
+(UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName color:(UIColor *)color;

@end



















//
//  XXENewCourseView.m
//  teacher
//
//  Created by codeDing on 16/11/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXENewCourseView.h"
#import "UIImage+RCImage.h"
#import <Masonry/Masonry.h>
//#import "CGFloat_Extension.h"

@interface XXENewCourseView ()

@property(nonatomic ,strong) UIView *firstView;
@property(nonatomic ,strong) UIView *secondView;
@property(nonatomic ,strong) UIView *thirdView;

@end

@implementation XXENewCourseView


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor alloc] initWithWhite:0 alpha:0.65];
        self.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        [self initFirstView];
//        [self initSecondView];
        
    }
    return self;
}

-(void)initFirstView {
    self.firstView = [[UIView alloc] initWithFrame:self.frame];
    [self addSubview:self.firstView];
    
    UIImage *schoolImg = [UIImage imageNamed:@"xinshouzhidao01"];
    UIImageView *schoolIV = [[UIImageView alloc] init];
    schoolIV.image = schoolImg;
    [self.firstView addSubview:schoolIV];
    [schoolIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(10);
        make.top.mas_equalTo(32 * kScreenRatioHeight);
        make.width.mas_equalTo(schoolImg.imageScale_W);
        make.height.mas_equalTo(schoolImg.imageScale_H);
    }];
    
    UIImage *classImg = [UIImage imageNamed:@"xinshouzhidao03"];
    UIImageView *classIV = [[UIImageView alloc] init];
    classIV.image = classImg;
    [self.firstView addSubview:classIV];
    [classIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(61 * kScreenRatioHeight);
        make.leading.mas_equalTo(156);
        make.width.mas_equalTo(classImg.imageScale_W);
        make.height.mas_equalTo(classImg.imageScale_H);
    }];
    
    
    if (![XXEUserInfo user].login){
        UIImage *registerImg = [UIImage imageNamed:@"xinshouzhidao02"];
        UIImageView *registerIV = [[UIImageView alloc] init];
        registerIV.image = registerImg;
        [self.firstView addSubview:registerIV];
        [registerIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.mas_trailing).offset(-2);
            make.top.mas_equalTo(33 * kScreenRatioHeight);
            make.width.mas_equalTo(registerImg.imageScale_W);
            make.height.mas_equalTo(registerImg.imageScale_H);
        }];
    }
    
    
    UIImage *logoImg = [UIImage imageNamed:@"xinshouzhidao04"];
    UIImageView *logoIV = [[UIImageView alloc] init];
    logoIV.image = logoImg;
    [self.firstView addSubview:logoIV];
    [logoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(38);
        make.top.mas_equalTo(self.mas_top).offset(231 * kScreenRatioHeight);
        make.width.mas_equalTo(logoImg.imageScale_W);
        make.height.mas_equalTo(logoImg.imageScale_H);
    }];
    
    UIImage *knowImg = [UIImage imageNamed:@"zhidaoleicon"];
    UIButton *knowBtn = [[UIButton alloc] init];
//    UIButton *knowBtn = [UIButton buttonWithType:0];
    [knowBtn setImage:knowImg forState:0];
    knowBtn.imageView.userInteractionEnabled = NO;
    [knowBtn addTarget:self action:@selector(firstBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.firstView addSubview:knowBtn];
    [knowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self).offset(-54);
        make.top.mas_equalTo(self).offset(324 * kScreenRatioHeight);
        make.width.mas_equalTo(knowImg.imageScale_W);
        make.height.mas_equalTo(knowImg.imageScale_H);
    }];
    
}

-(void)initSecondView {
    self.secondView = [[UIView alloc] initWithFrame:self.frame];
    [self addSubview:self.secondView];
    
    UIImage *avatarImg = [UIImage imageNamed:@"xinshouzhidao(02)"];
    UIImageView *avatarIV = [[UIImageView alloc] init];
    avatarIV.image = avatarImg;
    [self.secondView addSubview:avatarIV];
    [avatarIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(110 * kScreenRatioHeight);
        make.leading.mas_equalTo(25 * kScreenRatioWidth);
        make.width.mas_equalTo(avatarImg.imageScale_W);
        make.height.mas_equalTo(avatarImg.imageScale_H);
    }];
    
    UIImage *logoImg = [UIImage imageNamed:@"xinshouzhidao(03)"];
    UIImageView *logoIV = [[UIImageView alloc] init];
    logoIV.image = logoImg;
    [self.secondView addSubview:logoIV];
    [logoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(avatarIV.mas_bottom).offset(22 * kScreenRatioHeight);
        make.leading.mas_equalTo(64);
        make.width.mas_equalTo(logoImg.imageScale_W);
        make.height.mas_equalTo(logoImg.imageScale_H);
    }];
    
    UIImage *knowImg = [UIImage imageNamed:@"zhidaoleicon"];
    UIButton *knowBtn = [[UIButton alloc] init];
    //    UIButton *knowBtn = [UIButton buttonWithType:0];
    [knowBtn setImage:knowImg forState:0];
    knowBtn.imageView.userInteractionEnabled = NO;
    [knowBtn addTarget:self action:@selector(secondBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.secondView addSubview:knowBtn];
    [knowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self).offset(-40);
        make.top.mas_equalTo(avatarIV.mas_bottom).offset(22 * kScreenRatioHeight);
        make.width.mas_equalTo(knowImg.imageScale_W);
        make.height.mas_equalTo(knowImg.imageScale_H);
    }];
    
}

-(void)initThirdView {
    self.thirdView = [[UIView alloc] initWithFrame:self.frame];
    [self addSubview:self.thirdView];
    
    UIImage *titleImg = [UIImage imageNamed:@"xinshouzhidao(04)"];
    UIImageView *titleIV = [[UIImageView alloc] init];
    titleIV.image = titleImg;
    [self.thirdView addSubview:titleIV];
    [titleIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(152 * kScreenRatioHeight);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(titleImg.imageScale_W);
        make.height.mas_equalTo(titleImg.imageScale_H);
    }];
    
    UIImage *firstImg = [UIImage imageNamed:@"xinshouzhidao(05)"];
    UIImageView *firstIV = [[UIImageView alloc] init];
    firstIV.image = firstImg;
    [self.thirdView addSubview:firstIV];
    [firstIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(220 * kScreenRatioHeight);
        make.leading.mas_equalTo(self).offset(23 * kScreenRatioWidth);
        make.width.mas_equalTo(firstImg.imageWidth);
        make.height.mas_equalTo(firstImg.imageHeight);
    }];
    
    UIImage *secondImg = [UIImage imageNamed:@"xinshouzhidao(06)"];
    UIImageView *secondIV = [[UIImageView alloc] init];
    secondIV.image = secondImg;
    [self.thirdView addSubview:secondIV];
    [secondIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(220 * kScreenRatioHeight);
        make.leading.mas_equalTo(firstIV.mas_trailing).offset(30 * kScreenRatioWidth);
        make.width.mas_equalTo(secondImg.imageWidth);
        make.height.mas_equalTo(secondImg.imageHeight);
    }];
    
    UIImage *thirdImg = [UIImage imageNamed:@"xinshouzhidao(07)"];
    UIImageView *thirdIV = [[UIImageView alloc] init];
    thirdIV.image = thirdImg;
    [self.thirdView addSubview:thirdIV];
    [thirdIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(220 * kScreenRatioHeight);
        make.leading.mas_equalTo(secondIV.mas_trailing).offset(25 * kScreenRatioWidth);
        make.width.mas_equalTo(thirdImg.imageWidth);
        make.height.mas_equalTo(thirdImg.imageHeight);
    }];
    
    UIImage *forthImg = [UIImage imageNamed:@"xinshouzhidao(08)"];
    UIImageView *forthIV = [[UIImageView alloc] init];
    forthIV.image = forthImg;
    [self.thirdView addSubview:forthIV];
    [forthIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(220 * kScreenRatioHeight);
        make.trailing.mas_equalTo(self).offset(-34 * kScreenRatioWidth);
        make.width.mas_equalTo(forthImg.imageWidth);
        make.height.mas_equalTo(forthImg.imageHeight);
    }];
    
    
    
    UIImage *logoImg = [UIImage imageNamed:@"首页引导04"];
    UIImageView *logoIV = [[UIImageView alloc] init];
    logoIV.image = logoImg;
    [self.thirdView addSubview:logoIV];
    [logoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(forthIV.mas_bottom).offset(20 * kScreenRatioHeight);
        make.trailing.mas_equalTo(self).offset(-52);
        make.width.mas_equalTo(logoImg.imageScale_W);
        make.height.mas_equalTo(logoImg.imageScale_H);
    }];
    
    UIImage *knowImg = [UIImage imageNamed:@"标注03"];
    UIButton *knowBtn = [[UIButton alloc] init];
    //    UIButton *knowBtn = [UIButton buttonWithType:0];
    [knowBtn setImage:knowImg forState:0];
    knowBtn.imageView.userInteractionEnabled = NO;
    [knowBtn addTarget:self action:@selector(thirdBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.thirdView addSubview:knowBtn];
    [knowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(38);
        make.top.mas_equalTo(forthIV.mas_bottom).offset(20 * kScreenRatioHeight);
        make.width.mas_equalTo(knowImg.imageScale_W);
        make.height.mas_equalTo(knowImg.imageScale_H);
    }];
}

-(void)firstBtnAction:(UIButton *)btn {
    [self.firstView removeFromSuperview];
    [self initSecondView];
}

-(void)secondBtnAction {
    [self.secondView removeFromSuperview];
    [self initThirdView];
}

-(void)thirdBtnAction {
    [self removeFromSuperview];
}

@end

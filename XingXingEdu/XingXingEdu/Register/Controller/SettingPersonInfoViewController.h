//
// SettingPersonInfoViewController.h
//  Created by codeDing on 16/1/16.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Availability.h>
#import<QuartzCore/QuartzCore.h>

@interface SettingPersonInfoViewController : UIViewController
@property(nonatomic,strong) NSArray *relationArray;//与学生关系
@property (nonatomic,strong) UIView *comBackView;

@property(nonatomic,strong) NSArray *parentsIDCardArray;//家长身份证号
@property (nonatomic,strong) UIView *parentsIDCardComBackView;

@property(nonatomic,strong) NSArray *studentIDCardArray;//学生身份证号
@property (nonatomic,strong) UIView *studentIDCardComBackView;

@property(nonatomic ,copy)NSString * phone;
@property(nonatomic ,copy)NSString * pwd;
@property(nonatomic ,copy)NSString * nickName;
@property(nonatomic ,copy)NSString * t_head_img;
@property(nonatomic ,copy)NSString * login_type;
@property(nonatomic ,copy)NSString * QQToken;
@property(nonatomic ,copy)NSString * weixinToken;
@property(nonatomic ,copy)NSString * sinaToken;
@property(nonatomic ,copy)NSString * whereFromController;


@end

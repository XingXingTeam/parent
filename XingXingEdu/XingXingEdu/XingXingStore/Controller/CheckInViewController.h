//
//  CheckInViewController.h
//  XingXingStore
//
//  Created by codeDing on 16/2/3.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckInViewController : UIViewController


@property(nonatomic ,strong)NSString * money;//签到获得猩币
@property(nonatomic ,strong)NSString * weekDay;//每周签到几天
@property(nonatomic ,strong)NSString * monthDay;//每月签到几天
@property(nonatomic ,strong)NSString * lastChickIn;//上次签到时间

@property  BOOL isCheck;


@end

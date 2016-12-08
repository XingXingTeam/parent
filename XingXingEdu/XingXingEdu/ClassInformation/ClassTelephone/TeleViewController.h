//
//  TeleViewController.h
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/1/23.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHNavSliderMenu.h"
@interface TeleViewController : UIViewController
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *telephone;
@property(nonatomic, copy)NSString *imagStr;
@property(nonatomic, assign)NSInteger *index;
@property (nonatomic)QHNavSliderMenuType menuType;
@end


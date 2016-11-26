//
//  TeleTeachInfoViewController.h
//  XingXingEdu
//
//  Created by keenteam on 16/4/8.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHNavSliderMenu.h"
@interface TeleTeachInfoViewController : UIViewController
@property (nonatomic)QHNavSliderMenuType menuType;


@property(nonatomic,copy)NSString *teacherId;

@property(nonatomic,copy)NSString *teacherXid;

@property(nonatomic,copy)NSString *managerXid;

@end

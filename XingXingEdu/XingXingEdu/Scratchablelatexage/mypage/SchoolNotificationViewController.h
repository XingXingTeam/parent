//
//  SchoolNotificationViewController.h
//  teacher
//
//  Created by codeDing on 16/12/13.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface SchoolNotificationViewController : XXEBaseViewController
@property (nonatomic, copy) NSString *schoolId;

@property (nonatomic, copy) NSString *classId;

@property (nonatomic, copy) NSString *babyId;

@property(nonatomic)SchoolInfo schoolInfo;
@end

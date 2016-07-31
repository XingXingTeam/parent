//
//  SubEditViewController.h
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/2/17.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubEditViewController : UIViewController
@property (nonatomic,copy)NSString *subjectName;
@property (nonatomic,copy)NSString *teacherName;
@property (nonatomic,copy)NSString *classRoom;
@property (nonatomic,copy)NSString *remarkName;


@property (nonatomic,copy)NSString *goTimeH;
@property (nonatomic,copy)NSString *goTimeM;
@property (nonatomic,copy)NSString *stopTimeH;
@property (nonatomic,copy)NSString *stopTimeM;
@property (nonatomic,strong) UIView *classView;

@end

//
//  OtherPeopleViewController.h
//  XingXingEdu
//
//  Created by keenteam on 16/2/4.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherPeopleViewController : UIViewController


@property (nonatomic, copy)NSString *imageStr;
@property (nonatomic, copy)NSString *familyIdStr;
@property (nonatomic, copy)NSString *babyIdStr;

@property (nonatomic, copy) NSString *familyXidStr;

//收藏
@property (nonatomic, copy) NSString *collect_num;

//家人 是否 收藏
@property (nonatomic) BOOL isCollected;
@property (nonatomic, strong) UIImage *saveImage;

@end

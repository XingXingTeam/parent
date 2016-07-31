//
//  ShoolInfoViewController.h
//  XingXingEdu
//
//  Created by keenteam on 16/3/17.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHNavSliderMenu.h"
@interface ShoolInfoViewController : UIViewController
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *telephone;
@property(nonatomic, copy)NSString *imagStr;
@property(nonatomic, assign)NSInteger *index;
@property (nonatomic)QHNavSliderMenuType menuType;
@end

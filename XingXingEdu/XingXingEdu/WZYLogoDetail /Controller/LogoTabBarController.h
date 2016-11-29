//
//  LogoTabBarController.h
//  XingXingEdu
//
//  Created by Mac on 16/5/9.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogoTabBarController : UITabBarController<UITabBarDelegate>

@property (nonatomic, strong) NSMutableArray *schoolIdArr;
@property (nonatomic, assign) NSInteger index;

@end

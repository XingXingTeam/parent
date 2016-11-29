//
//  XXELocationAddController.h
//  teacher
//
//  Created by codeDing on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "DFBaseViewController.h"
#import <UIKit/UIKit.h>

typedef void (^ReturnTextBlock)(NSString *showText);

@interface XXELocationAddController : DFBaseViewController

@property (nonatomic, copy)ReturnTextBlock returnTextBlock;
- (void)returnText:(ReturnTextBlock)block;

@end

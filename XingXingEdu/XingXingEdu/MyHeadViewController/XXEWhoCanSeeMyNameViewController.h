//
//  XXEWhoCanSeeMyNameViewController.h
//  teacher
//
//  Created by Mac on 16/9/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

typedef void (^ReturnTextBlock)(NSString *showText);
@interface XXEWhoCanSeeMyNameViewController : XXEBaseViewController

@property (nonatomic, copy)ReturnTextBlock returnTextBlock;
- (void)returnText:(ReturnTextBlock)block;

@end

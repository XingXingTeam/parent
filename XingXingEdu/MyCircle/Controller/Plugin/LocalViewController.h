//
//  LocalViewController.h
//  XingXingEdu
//
//  Created by keenteam on 16/3/16.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnTextBlock)(NSString *showText);
@interface LocalViewController : UIViewController
@property (nonatomic, copy)ReturnTextBlock returnTextBlock;
- (void)returnText:(ReturnTextBlock)block;
@end

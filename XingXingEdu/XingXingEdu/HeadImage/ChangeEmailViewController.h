//
//  ChangeEmailViewController.h
//  XingXingEdu
//
//  Created by keenteam on 16/5/16.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnTextBlock)(NSString *showText);
@interface ChangeEmailViewController : UIViewController
@property (nonatomic, copy)ReturnTextBlock returnTextBlock;
- (void)returnText:(ReturnTextBlock)block;
@end


/*


 @interface WhoViewController : UIViewController
 



*/
//
//  WZYSearchPeopleInfoViewController.h
//  XingXingEdu
//
//  Created by Mac on 16/7/14.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReturnCommentNameBlock)(NSString *text);

typedef void(^ReturnArrayBlock)(NSMutableArray *mArr);

@interface WZYSearchPeopleInfoViewController : UIViewController

@property (nonatomic, copy) ReturnCommentNameBlock returnCommentNameBlock;

@property (nonatomic, copy) ReturnArrayBlock returnArrayBlock;

@property (nonatomic) BOOL WZYSearchFlagStr;


- (void)returnText:(ReturnCommentNameBlock)block;

- (void)returnArray:(ReturnArrayBlock)block;



@end

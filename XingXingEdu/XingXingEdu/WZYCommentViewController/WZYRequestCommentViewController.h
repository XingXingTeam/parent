//
//  WZYRequestCommentViewController.h
//  XingXingEdu
//
//  Created by Mac on 16/7/3.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ReturnArrayBlock)(NSMutableArray *selectedTeacherInfoArray);

@interface WZYRequestCommentViewController : UIViewController

@property (nonatomic, copy) ReturnArrayBlock ReturnArrayBlock;

@property (nonatomic, strong) NSMutableArray *didSelectTeacherIdArray;


- (void)returnArray:(ReturnArrayBlock)block;

@end

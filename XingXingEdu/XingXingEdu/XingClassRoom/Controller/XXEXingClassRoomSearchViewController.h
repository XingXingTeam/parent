//
//  XXEXingClassRoomViewController.h
//  teacher
//
//  Created by Mac on 16/10/21.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

//#import "XXEBaseViewController.h"
#import <UIKit/UIKit.h>

typedef void(^ReturnArrayBlock)(NSMutableArray *searchInfoArray);


@interface XXEXingClassRoomSearchViewController : UIViewController

//date_type //需要查询的数据类型,填数字 1: 老师  2:课程 3:机构
@property (nonatomic, copy) NSString *date_type;

@property (nonatomic, copy) ReturnArrayBlock ReturnArrayBlock;

- (void)returnArray:(ReturnArrayBlock)block;

@end

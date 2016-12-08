//
//  XXEMessageHistoryController.h
//  teacher
//
//  Created by codeDing on 16/9/21.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXEMessageHistoryController : XXEBaseViewController

/** 接受值判断有没有值 有值为新消息 没有值为历史信息 */
@property (nonatomic, copy)NSString *messageNumber;

@end

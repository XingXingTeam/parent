//
//  ClassRoomOrderMessageController.h
//  XingXingEdu
//
//  Created by mac on 16/6/17.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassRoomOrderMessageController : UIViewController

@property(nonatomic,copy)NSString *orderId;
//立即购买
@property(nonatomic,assign)BOOL hiddenBuyBtn;
//取消订单
@property(nonatomic,assign)BOOL hiddencancelBtn;
//评价
@property(nonatomic,assign)BOOL hiddenAppraiseBtn;
//历史记录
@property(nonatomic,assign)BOOL appraiseHistory;
//返回按钮
@property(nonatomic,assign)BOOL hiddenLeftButton;

@property(nonatomic,copy)NSString *order_index;

//返回按钮
@property(nonatomic,assign)BOOL isBuy;

@end

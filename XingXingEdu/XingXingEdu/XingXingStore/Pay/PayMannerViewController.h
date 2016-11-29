//
//  PayMannerViewController.h
//  XingXingEdu
//
//  Created by codeDing on 16/5/16.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayMannerViewController : UIViewController
@property(nonatomic,copy)NSString *orderId;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *xingMoney;

@property(nonatomic,copy)NSString *order_index;

@property  (assign, nonatomic) NSInteger actionType;//0:pay;1:query;

@property(nonatomic,assign)BOOL isFlower;
@end

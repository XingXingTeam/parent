//
//  OrderInfoViewController.h
//  XingXingEdu
//
//  Created by codeDing on 16/3/2.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderInfoViewController : UIViewController
@property(nonatomic ,assign)BOOL isDid;
//返回按钮
@property(nonatomic,assign)BOOL hiddenLeftButton;

@property(nonatomic,copy)NSString *orderID;
@property(nonatomic,copy)NSString *order_index;


@end

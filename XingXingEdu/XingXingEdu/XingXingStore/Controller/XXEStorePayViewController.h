//
//  XXEStorePayViewController.h
//  teacher
//
//  Created by Mac on 2016/11/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXEStorePayViewController : XXEBaseViewController

@property (nonatomic, strong) NSDictionary *dict;


//是否是纯猩币支付
@property (nonatomic, assign) BOOL onlyXingCoin;
//pay_coin
@property (nonatomic, copy) NSString *pay_coin;

//pay_price
@property (nonatomic, copy) NSString *pay_price;

//order_index
@property (nonatomic, copy) NSString *order_index;

//order_id
@property (nonatomic, copy) NSString *order_id;


@end

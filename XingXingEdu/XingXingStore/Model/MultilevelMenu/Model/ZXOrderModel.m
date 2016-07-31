//
//  ZXOrderModel.m
//  XingXingEdu
//
//  Created by codeDing on 16/2/29.
//  Copyright © 2016年 codeDing. All rights reserved.
//
#import "ZXOrderModel.h"
#import "MJExtension.h"

@implementation ZXOrderModel

// 实现这个方法的目的：告诉MJExtension框架模型中的属性名对应着字典的哪个key
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"orderID" : @"id",
             @"orderNO" : @"order_index",
             @"orderImage" : @"pic",
             @"orderGoodsid" : @"goods_id",
             @"orderSalePrice" : @"exchange_price",
             @"orderSaleXingMoney" : @"exchange_coin",
             @"orderTime" : @"date_tm",
             @"orderGoodsName" : @"title",
             @"ordercondit" : @"condit"

             };
}

 



@end

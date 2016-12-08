//
//  ZXOrderModel.h
//  XingXingEdu
//
//  Created by codeDing on 16/2/29.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    NonPayment = 0,     // 待付款
    HaveBeenPaid = 1,   // 已完成
    Waited = 2 ,      // 待收货
    All=3,               // 全部
    returnOfGoods = 4    //退货
} OrderStatus;

@interface ZXOrderModel : NSObject
//
//[id] => 2
//[order_index] => 19413243
//[date_tm] => 1459413241
//[exchange_price] => 0.00
//[exchange_coin] => 1000
//[goods_id] => 1
//[pic] => app_upload/goods_img/demo/zhudi1.jpg

/** 订单编号 */
@property (copy, nonatomic) NSString *orderID;
/** 订单编号 */
@property (copy, nonatomic) NSString *order_index;
/** 订单序号 */
@property (copy, nonatomic) NSString *orderNO;  // 作用：排序

/** 订单生成时间 */
@property (copy, nonatomic) NSString *orderTime;
/** 订单图片 */
@property (copy, nonatomic) NSString *orderImage;




/** 订单人民币售价 */
@property (copy, nonatomic) NSString *orderSalePrice;
/** 订单猩币售价 */
@property (copy, nonatomic) NSString *orderSaleXingMoney;


/** 商品id */
@property (copy, nonatomic) NSString * orderGoodsid;

/** 商品名称 */
@property (copy, nonatomic) NSString * orderGoodsName;

/** 商品状态 */
@property (copy, nonatomic) NSString * ordercondit;


@end

//
//  XXEStoreGoodsOrderListModel.h
//  teacher
//
//  Created by Mac on 2016/11/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEStoreGoodsOrderListModel : JSONModel
/*
 (
 [id] => 2
 [title] => 3D动物马克杯
 [order_index] => 19413243
 [date_tm] => 1459413241
 [exchange_price] => 0.00
 [exchange_coin] => 1000
 [goods_id] => 1
 [condit] => 1	//0:待付款 1:待发货 2:待收货 3:完成 10:退货中  11:退货驳回  12:退货完成
 [pic] => app_upload/goods_img/demo/zhudi1.jpg
 )
 
 */


@property (nonatomic, copy) NSString<Optional> *order_id;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *order_index;
@property (nonatomic, copy) NSString<Optional> *date_tm;
@property (nonatomic, copy) NSString<Optional> *exchange_price;
@property (nonatomic, copy) NSString<Optional> *exchange_coin;
@property (nonatomic, copy) NSString<Optional> *goods_id;
@property (nonatomic, copy) NSString<Optional> *condit;
@property (nonatomic, copy) NSString<Optional> *pic;


+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;

@end

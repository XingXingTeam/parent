//
//  XXEStoreListModel.h
//  teacher
//
//  Created by Mac on 16/11/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEStoreListModel : JSONModel

/*
 (
 [id] => 1			//商品id
 [date_tm] => 1459330258	//商品发布时间戳
 [type] => 1			//1:实物  2:虚拟商品
 [class] => 3		//类目
 [title] => 朱迪毛绒玩具	//商品标题
 [price] => 35.00		//商品原价
 [exchange_price] => 0.00	//兑换所需金额,如果是0,代表全猩币兑换,否则,猩币+钱兑换
 [exchange_coin] => 1000	//猩币兑换数
 [goods_num] => 200		//商品数量
 [sale_num] => 0		//销售数量
 [con] => 电影疯狂动物城主角,可爱的朱迪,兔警官		//商品描述
 [goods_pic] => app_upload/goods_img/demo/zhudi1.jpg		//商品首图
 )
 */

@property (nonatomic, copy) NSString<Optional> *good_id;
@property (nonatomic, copy) NSString<Optional> *date_tm;
@property (nonatomic, copy) NSString<Optional> *type;
@property (nonatomic, copy) NSString<Optional> *classStr;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *price;
@property (nonatomic, copy) NSString<Optional> *exchange_price;
@property (nonatomic, copy) NSString<Optional> *exchange_coin;
@property (nonatomic, copy) NSString<Optional> *goods_num;
@property (nonatomic, copy) NSString<Optional> *sale_num;
@property (nonatomic, copy) NSString<Optional> *con;
@property (nonatomic, copy) NSString<Optional> *goods_pic;



+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;



@end

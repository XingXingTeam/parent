//
//  XXEXingStoreGoodInfoModel.h
//  XingXingEdu
//
//  Created by Mac on 16/10/13.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEXingStoreGoodInfoModel : JSONModel

/*
 {
	id = 10,
	exchange_price = 2.00,
	goods_num = 0,
	exchange_coin = 0,
	goods_pic = app_upload/flower2.png,
	date_tm = 0,
	type = 2,
	title = 花篮,
	price = 0.00,
	sale_num = 15,
	col_num = 0,
	con = 如果您想感谢老师对自己孩子的照顾,可以购买花篮赠送,老师可以用花篮兑换一些等价的超市购物券,话费等,
	class = 1,
	condit = 1
 }
 */

@property (nonatomic, copy) NSString <Optional>*good_id;
@property (nonatomic, copy) NSString <Optional>*exchange_price;
@property (nonatomic, copy) NSString <Optional>*goods_num;
@property (nonatomic, copy) NSString <Optional>*exchange_coin;
@property (nonatomic, copy) NSString <Optional>*goods_pic;
@property (nonatomic, copy) NSString <Optional>*date_tm;
@property (nonatomic, copy) NSString <Optional>*type;
@property (nonatomic, copy) NSString <Optional>*title;
@property (nonatomic, copy) NSString <Optional>*price;
@property (nonatomic, copy) NSString <Optional>*sale_num;
@property (nonatomic, copy) NSString <Optional>*col_num;
@property (nonatomic, copy) NSString <Optional>*con;
@property (nonatomic, copy) NSString <Optional>*class_id;
@property (nonatomic, copy) NSString <Optional>*condit;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;

@end

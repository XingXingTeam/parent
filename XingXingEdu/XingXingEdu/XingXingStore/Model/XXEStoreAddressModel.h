//
//  XXEStoreAddressModel.h
//  teacher
//
//  Created by Mac on 16/11/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEStoreAddressModel : JSONModel

/*
 (
 [id] => 1			//地址id在选择默认地址时用到
 [xid] => 18884982
 [date_tm] => 1459390260
 [province] => 上海市
 [city] => 上海市
 [district] => 浦东新区
 [address] => 巨峰路1058弄新紫茂国际3号楼1607号
 [name] => 顾政星
 [phone] => 15026511452
 [zip_code] => 302034
 [selected] => 1		//0和1, 1是默认地址
 )
 */
@property (nonatomic, copy) NSString <Optional>*address_id;
@property (nonatomic, copy) NSString <Optional>*xid;
@property (nonatomic, copy) NSString <Optional>*date_tm;
@property (nonatomic, copy) NSString <Optional>*province;
@property (nonatomic, copy) NSString <Optional>*city;
@property (nonatomic, copy) NSString <Optional>*district;
@property (nonatomic, copy) NSString <Optional>*address;
@property (nonatomic, copy) NSString <Optional>*name;
@property (nonatomic, copy) NSString <Optional>*phone;
@property (nonatomic, copy) NSString <Optional>*zip_code;
@property (nonatomic, copy) NSString <Optional>*selected;


+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;


@end

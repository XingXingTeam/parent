//
//  XXEClassRoomCustomerServicesModel.h
//  XingXingEdu
//
//  Created by Mac on 2016/12/13.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEClassRoomCustomerServicesModel : JSONModel

/*
 [id] => 7
 [school_id] => 2
 [tid] => 14
 [name] => 晓晓
 [condit] => 1
 [xid] => 18886402
 */

@property (nonatomic, copy) NSString<Optional> *service_id;
@property (nonatomic, copy) NSString<Optional> *school_id;
@property (nonatomic, copy) NSString<Optional> *tid;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *condit;
@property (nonatomic, copy) NSString<Optional> *xid;



+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;



@end

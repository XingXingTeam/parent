//
//  XXERongCloudPhoneNumListModel.h
//  teacher
//
//  Created by Mac on 16/10/13.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXERongCloudPhoneNumListModel : JSONModel
/*
 [id] => 1
 [xid] => 18884982
 [head_img] => app_upload/head_img/2016/06/21/20160621172448_8123.png
 [head_img_type] => 0
 [tname] => 李少伟
 [nickname] => 早总钱
 [user_type] => 1
 [friend_type] => 2	//1:是好友  2:自己   3:其他
 */

@property (nonatomic, copy) NSString <Optional> *phoneNum_id;
@property (nonatomic, copy) NSString <Optional> *xid;
@property (nonatomic, copy) NSString <Optional> *head_img;
@property (nonatomic, copy) NSString <Optional> *head_img_type;
@property (nonatomic, copy) NSString <Optional>*tname;
@property (nonatomic, copy) NSString <Optional>*nickname;
@property (nonatomic, copy) NSString <Optional>*user_type;
@property (nonatomic, copy) NSString <Optional>*friend_type;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;

@end

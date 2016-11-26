//
//  KTFriendsInfoModel.h
//  XingXingEdu
//
//  Created by keenteam on 16/6/20.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface KTFriendsInfoModel : JSONModel
@property(nonatomic,strong)NSString *lv;
@property(nonatomic,strong)NSString *relation_name;
@property(nonatomic,strong)NSString *tname;
@property(nonatomic,strong)NSString *xid;
@end

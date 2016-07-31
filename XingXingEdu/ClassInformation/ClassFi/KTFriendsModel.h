//
//  KTFriendsModel.h
//  XingXingEdu
//
//  Created by keenteam on 16/6/20.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "KTFriendsInfoModel.h"
@interface KTFriendsModel : JSONModel


@property(nonatomic,strong)NSString *age;
@property(nonatomic,strong)NSString *head_img;
@property(nonatomic,strong)NSString *tname;
@property(nonatomic,strong)NSArray *parent_list;
@end

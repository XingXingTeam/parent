//
//  XXEStoreAddUserAddressViewController.h
//  teacher
//
//  Created by Mac on 16/11/14.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"
#import "XXEStoreAddressModel.h"


@interface XXEStoreAddUserAddressViewController : XXEBaseViewController

@property (nonatomic, assign) BOOL isModify;

@property (nonatomic, strong) XXEStoreAddressModel *model;

@property (nonatomic, copy) NSString * defaultAddress;//设置默认地址,可以传值0或者1, 1代表设为默认

@end

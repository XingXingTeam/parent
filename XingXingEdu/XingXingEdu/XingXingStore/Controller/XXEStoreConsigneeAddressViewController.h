//
//  XXEStoreConsigneeAddressViewController.h
//  teacher
//
//  Created by Mac on 16/11/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"


typedef void(^returnArrayBlock)(NSMutableArray *returnArray);

@interface XXEStoreConsigneeAddressViewController : XXEBaseViewController

@property (nonatomic, copy) returnArrayBlock returnArrayBlock;
//判断从哪个控制器跳转进来 ,如果是购买的时候 选择地址
@property(nonatomic ,assign)BOOL isBuy;


- (void)returnArrayBlock:(returnArrayBlock)block;

@end

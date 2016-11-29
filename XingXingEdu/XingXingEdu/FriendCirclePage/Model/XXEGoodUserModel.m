//
//  XXEGoodUserModel.m
//  teacher
//
//  Created by codeDing on 16/8/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEGoodUserModel.h"
#import "DFLineLikeItem.h"

@implementation XXEGoodUserModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"xid":@"goodXid",@"nickname":@"goodNickName"}];
}

-(void)configure:(DFLineLikeItem *)model {
    self.goodNickName = model.userNick;
    self.goodXid = [NSString stringWithFormat:@"%lu", (unsigned long)model.userId];;
}

@end

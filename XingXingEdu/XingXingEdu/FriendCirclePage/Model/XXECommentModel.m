//
//  XXECommentModel.m
//  teacher
//
//  Created by codeDing on 16/8/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECommentModel.h"
#import "DFLineCommentItem.h"

@implementation XXECommentModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXECommentModel *model = [[XXECommentModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"commentId",@"xid":@"commentXid",@"nickname":@"commentNicknName"}];
}

-(void)configure:(DFLineCommentItem*)model {
    
}

@end

//
//  WZYRequestCommentModel.m
//  XingXingEdu
//
//  Created by Mac on 16/7/3.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "WZYRequestCommentModel.h"

@implementation WZYRequestCommentModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        
        /*
         {
         tname = 姜兰兰,
         teach_course = 英语,
         tid = 15,
         head_img = app_upload/text/teacher/15.jpg,
         head_img_type = 0
         }
         */
        
        _nameStr = dict[@"tname"];
        _jobStr = dict[@"teach_course"];
        _tidStr = dict[@"id"];
        _head_imgStr = dict[@"head_img"];
        _head_img_typeStr = dict[@"head_img_type"];
        
        //                0 :表示 自己 头像 ，需要添加 前缀
        //                1 :表示 第三方 头像 ，不需要 添加 前缀
        //判断是否是第三方头像
        
        if([_head_img_typeStr isEqualToString:@"0"]){
            _iconStr = [picURL stringByAppendingString:_head_imgStr];
        }else{
            _iconStr = _head_imgStr;
        }
        
    }
    return self;
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dict{

    return [[self alloc] initWithDictionary:dict];
}


@end

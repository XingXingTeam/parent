//
//  XXEXingCommunityClassesModel.h
//  teacher
//
//  Created by Mac on 2016/12/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEXingCommunityClassesModel : JSONModel

/*
 (
 [id] => 98		//文章id
 [date_tm] => 1481786634	//发布时间
 [class] => 1	//分类
 [title] => 测试新闻测试新闻测试新闻测试新闻
 [summary] => 测试简介测试简介测试简介测试简介测试简介试简介测试简介测试简介测试简介
 [pic] => app_upload/xtd_article/2016/12/15/20161215152257_4809.jpg	//如果要用缩略图, 拼接-110
 )
 
*/

@property (nonatomic, copy) NSString *articleId;
@property (nonatomic, copy) NSString *date_tm;
@property (nonatomic, copy) NSString *xingCommunity_class;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *pic;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;


@end

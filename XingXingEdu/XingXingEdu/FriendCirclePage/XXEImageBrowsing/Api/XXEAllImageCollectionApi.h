//
//  XXEAllImageCollectionApi.h
//  teacher
//
//  Created by Mac on 16/9/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXEAllImageCollectionApi : YTKRequest

/*
 【收藏图片】通用接口,用于不同页面的图片收藏
 
 接口类型:2
 
 接口:
 http://www.xingxingedu.cn/Global/col_pic_all
 
 传参:
	url	//图片地址,不带http...头部,是我们服务器中的图片,比如:app_upload/text/class/class_c1.jpg
 */
- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id url:(NSString *)url;


@end

//
//  XXEFriendCircleApi.h
//  teacher
//
//  Created by codeDing on 16/8/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXEFriendCircleApi : YTKRequest

/*
 【我的圈子--查询我发布的】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Global/select_mycircle
 传参:
 other_xid	//别人查看某人时,传某人的xid,如果是查看自己发布的,不需要这个参数
 page	//加载第几次(第几页),默认1
 */


- (id)initWithFriendCircleXid:(NSString *)xid CircleUserId:(NSString *)userId  PageNumber:(NSString *)pageNum;

@end

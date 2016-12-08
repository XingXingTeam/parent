//
//  XXEMessageHistoryModel.h
//  teacher
//
//  Created by codeDing on 16/9/21.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEMessageHistoryModel : JSONModel

/** 每一条历史的ID */
@property (nonatomic, copy)NSString <Optional>*historyId;
/** 时间 */
@property (nonatomic, copy)NSString <Optional>*date_tm;
/** 每一条的说说ID */
@property (nonatomic, copy)NSString <Optional>*talk_id;
/** 本人的xingXId */
@property (nonatomic, copy)NSString <Optional>*xid;
/**  */
@property (nonatomic, copy)NSString <Optional>*com_type;
/** 给谁回复的XID */
@property (nonatomic, copy)NSString <Optional>*to_who_xid;
/** 发表的内容 */
@property (nonatomic, copy)NSString <Optional>*con;
//内容 图片
@property (nonatomic, copy) NSString <Optional> *pic_url;

/** 用户昵称 */
@property (nonatomic, copy)NSString <Optional>*nickname;
/** 头像地址 */
@property (nonatomic, copy)NSString <Optional>*head_img;
/** 头像来源于哪里 */
@property (nonatomic, copy)NSString <Optional>*head_img_type;


@end

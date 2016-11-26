//
//  XXECircleModel.h
//  teacher
//
//  Created by codeDing on 16/8/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "XXECommentModel.h"
#import "XXEGoodUserModel.h"

@interface XXECircleModel : JSONModel

/** 评论的model */
@property (nonatomic, strong)NSMutableArray <XXECommentModel>*comment_group;
/** 点赞的Model */
@property (nonatomic, strong)NSMutableArray <XXEGoodUserModel>*good_user;
/** 朋友圈用户头像 */
@property (nonatomic, copy)NSString <Optional>*head_img;
///** 朋友圈头像类型 0为系统头像1为第三方图像*/
@property (nonatomic, copy)NSString <Optional>*head_img_type;
/** 发布时间 */
@property (nonatomic, copy)NSString <Optional>*date_tm;
/** 发布地点 位置 */
@property (nonatomic, copy)NSString <Optional>*position;
/** 文件类型  1为图片 2为XXX */
@property (nonatomic, copy)NSString <Optional>*file_type;

/** 发表人昵称 */
@property (nonatomic, copy)NSString <Optional>*nickname;

/** 发布内容 <文字>*/
@property (nonatomic, copy)NSString <Optional>*words;
/** 发布图片 */
@property (nonatomic, copy)NSString <Optional>*pic_url;
/** 发布的视频 */
@property (nonatomic, copy)NSString <Optional>*video_url;
/** 发布人的猩ID */
@property (nonatomic, copy)NSString <Optional>*xid;
/** 每一个说说的id */
@property (nonatomic, copy)NSString <Optional>*talkId;

//circle_set
@property (nonatomic, copy)NSString <Optional>*circle_set;

@end

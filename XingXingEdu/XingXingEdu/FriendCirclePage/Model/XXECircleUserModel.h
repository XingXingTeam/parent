//
//  XXECircleUserModel.h
//  teacher
//
//  Created by codeDing on 16/8/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXECircleUserModel : JSONModel
/** 本人用户昵称 */
@property (nonatomic, copy)NSString <Optional>*nickname;
/** 本人头像 */
@property (nonatomic, copy)NSString <Optional>*head_img;
/** 本人的什么类型 */
@property (nonatomic, copy)NSString <Optional>*head_img_type;
/** 提示有没有消息 1为有未读消息 0 为没有未读消息 */
@property (nonatomic, copy)NSString <Optional>*circle_noread;

@end

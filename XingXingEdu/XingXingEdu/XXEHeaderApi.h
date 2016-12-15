//
//  XXEHeaderApi.h
//  teacher
//
//  Created by codeDing on 16/8/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#ifndef XXEHeaderApi_h
#define XXEHeaderApi_h


#define UMSocialAppKey @"56d4096e67e58ef29300147c"

//微博信息

#define SinaWebAppKey @"2875286507"
#define SinaWebAppSecret @"d26a462ef16055e1a9010a1d5489b3a6"

//微信
//AppID：wxed731a36270b5a4f
//App Secret 55bf91c8002799d1fe13045e3f5cee7c
/** 微信的APPID */
#define WeChatAppId @"wx7c4249886c93e20e"
/** 微信的APPSecret */
#define WeChatAppSecret @"e452142ebe813f5dfab564a95b2ccc02"

//QQ
//APP ID1105651422
//APP KEYk9FfqqGIWGNH6TDX
#define QQAppId @"1105603411"
#define QQAppSecret @"Xc9DlnWQqpG8hbH7"

#define kRemoteNotification @"remoteNotification" //远程推送通知
#define kSystemMessage @"systemMessage" //系统消息通知

#define kChatNotification @"ChatNotification"
#define kChatRemoteNotification @"ChatRemoteNotification"

//#define JPushAppKey @"4246476d42da75a98d9e01f2"

//访客登录XID不变
#define XID  @"18884982"
#define APPKEY  @"U3k8Dgj7e934bh5Y"
#define BACKTYPE @"json"
#define USER_ID  @"1"
#define USER_TYPE @"1"
#define MyRongCloudAppKey @"4z3hlwrv3t0dt"
//友盟分享 猩猩教室校园端

#define XXEYouMengAppKey @"57c01a13f43e48118e000e55"

//图片地址
#define picURL    @"http://www.xingxingedu.cn/Public/"

//版本号
#define CheckoutVersionURL @"http://www.xingxingedu.cn/Parent/versionCheck"
//登录
#define XXELoginUrl @"http://www.xingxingedu.cn/Teacher/login"
//忘记密码
#define XXEForgetPassUrl @"http://www.xingxingedu.cn/Global/update_pass"
//首页
#define XXEHomePageUrl @"http://www.xingxingedu.cn/Teacher/home_data"
//相册
#define XXEClassAlubmUrl @"http://www.xingxingedu.cn/Teacher/class_album_new"
//我的相册
#define  XXEMySelfAlubmUrl @"http://www.xingxingedu.cn/Teacher/class_teacher_album"
//添加相册
#define XXEMySelfAlubmAddUrl @"http://www.xingxingedu.cn/Teacher/class_album_add"
//删除相册
#define XXEAlbumDelegateUrl @"http://www.xingxingedu.cn/Teacher/class_album_delete"
//收藏图片
#define XXEHomeCollectionPhotoUrl @"http://www.xingxingedu.cn/Global/col_pic_all"
//上传图片
#define XXEAblumUpdataUrl @"http://www.xingxingedu.cn/Teacher/class_pic_upload"
/** 注册页面上传图片 */
#define XXERegisterUpLoadPicUrl @"http://www.xingxingedu.cn/Global/uploadFile"

//相册的内容
#define XXEAblumPhotoUrl @"http://www.xingxingedu.cn/Teacher/class_album_pic"
//举报列表
#define XXEHomeReportListUrl @"http://www.xingxingedu.cn/Global/report_list"
//举报提交
#define XXEHomeReportSubmitUrl @"http://www.xingxingedu.cn/Global/report_sub"


//搜索学校
#define XXESearchSchoolUrl @"http://www.xingxingedu.cn/Global/get_school_info"

//【通过学校获取年级】

#define XXESearchGradeUrl @"http://www.xingxingedu.cn/Global/give_school_get_grade" 

//【通过年级获取班级】
#define XXESearchClassUrl @"http://www.xingxingedu.cn/Global/give_grade_get_class"


/** 注册页的教学类型 */
#define XXERegisTeachTypeUrl @"http://www.xingxingedu.cn/Teacher/get_teach_name"

/** 教师端获取审核人 */
#define XXEReviewerUrl @"http://www.xingxingedu.cn/Teacher/get_examine_teacher"

/** 注册网服务器发送信息 */
#define XXERegisterTeacherUrl @"http://www.xingxingedu.cn/Teacher/register"


#endif /* XXEHeaderApi_h */

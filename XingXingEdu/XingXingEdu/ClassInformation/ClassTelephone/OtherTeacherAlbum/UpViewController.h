//
//  UpViewController.h
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/3/15.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpViewController : UIViewController
@property (nonatomic, assign)NSInteger i;
@property (nonatomic, assign)NSInteger index;
@property (nonatomic, assign)NSMutableArray *imageA;
@property (nonatomic, assign)NSMutableArray *goodNMArr;
@property (nonatomic, assign)NSMutableArray *idMArr;
@property (nonatomic, copy)NSString *albumID;

/*
 接口:
 http://www.xingxingedu.cn/Global/report_sub
 
 传参:
	other_xid	//被举报人xid (举报用户时才有此参数)
	report_name_id	//举报内容id , 多个逗号隔开
	report_type	//举报类型 1:举报用户  2:举报图片
	url		//被举报的链接(report_type非等于1时才有此参数),如果是图片,不带http头部的,例如:app_upload/........
	origin_page	//举报内容来源(report_type非等于1时才有此参数),传参是数字:
 1:小红花赠言中的图片
 2:圈子图片
 3:猩课堂发布的课程图片

 5:班级相册
 6:老师点评
 7:作业图片
 */



// 4:学校相册图片
@property (nonatomic, assign) BOOL isFromSchoolIntroduction;

@property (nonatomic, copy) NSString *origin_pageStr;


@end

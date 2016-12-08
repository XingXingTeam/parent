//
//  ReportPicViewController.h
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/2/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportPicViewController : UIViewController
/*
 举报 图片 的URL
 */
@property (nonatomic, copy) NSString *picUrlStr;
//举报 来源
@property (nonatomic, copy) NSString *origin_pageStr;


//被举报 人 other_xid
@property (nonatomic, copy) NSString *other_xidStr;



@end

//
//  WZYAlbumDateISectionViewController.h
//  XingXingEdu
//
//  Created by Mac on 16/7/25.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZYAlbumDateISectionViewController : UIViewController

/*
 {
 id = 11,
 pic = app_upload/text/class/class_a2.jpg,
 good_num = 1,
 date_tm = 1458994864
 }
 */

//数据源数组
@property (nonatomic, strong) NSMutableArray *dataArray;
//组头
@property (nonatomic, strong) NSMutableArray *sectionTitleArray;

//图片
@property (nonatomic, strong) NSMutableArray *imageDataSource;
@property (nonatomic, strong) NSMutableArray *idDataSource;
@property (nonatomic, strong) NSMutableArray *good_numDataSource;


@property (nonatomic, strong) NSMutableArray *idArray;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *good_numArray;




@property (nonatomic, copy) NSString *albumID;


@end

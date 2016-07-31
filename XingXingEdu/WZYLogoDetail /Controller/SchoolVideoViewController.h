//
//  SchoolVideoViewController.h
//  XingXingEdu
//
//  Created by Mac on 16/5/20.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchoolVideoViewController : UIViewController

@property (nonatomic) NSMutableArray *dataSource;
//视频 图片
@property (nonatomic) NSMutableArray *videoImageViewArray;

//视频 标题
@property (nonatomic) NSMutableArray *videoTitleArray;
//视频 时间
@property (nonatomic) NSMutableArray *videoTimeArray;



@end

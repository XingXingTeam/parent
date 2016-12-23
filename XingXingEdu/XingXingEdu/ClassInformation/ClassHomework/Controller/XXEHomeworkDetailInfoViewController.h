//
//  XXEHomeworkDetailInfoViewController.h
//  teacher
//
//  Created by Mac on 16/8/18.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXEHomeworkDetailInfoViewController : XXEBaseViewController


@property (nonatomic, copy) NSString *homeworkId;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *publishTime;
@property (nonatomic, copy) NSString *submitTime;

//照片墙 照片数组
@property (nonatomic, strong) NSMutableArray *picWallArray;


@end

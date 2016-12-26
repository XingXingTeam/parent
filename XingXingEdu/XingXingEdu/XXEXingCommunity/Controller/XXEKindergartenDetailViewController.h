//
//  XXEKindergartenDetailViewController.h
//  teacher
//
//  Created by Mac on 2016/12/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXEKindergartenDetailViewController : XXEBaseViewController

/*
 get传参:
 cat	//分类,1:幼儿园  2:小学  3:中学  4:培训机构
 id	//文章id
 */

@property (nonatomic, copy) NSString *cat;
@property (nonatomic, copy) NSString *articleId;




@end

//
//  RedFlowerViewController.h
//  XingXingEdu
//
//  Created by keenteam on 16/3/24.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedFlowerViewController : UIViewController
//@property(nonatomic,assign,readwrite) int s;

@property(nonatomic,retain) NSArray * imageArr;

@property(nonatomic ,assign)BOOL isUrlImage;

@property (nonatomic, assign) BOOL isFromStarRemark;

@property (nonatomic, assign) NSInteger index;

//举报 来源
@property (nonatomic, copy) NSString *origin_pageStr;


@end

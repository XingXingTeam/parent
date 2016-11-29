//
//  DFTextImageLineItem.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseLineItem.h"
#import "XXECircleModel.h"
#import "XXEGoodUserModel.h"

@interface DFTextImageLineItem : DFBaseLineItem

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSMutableArray *thumbImages;
@property (nonatomic, strong) NSMutableArray *srcImages;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) NSAttributedString *attrText;



//说说ID
@property (nonatomic, strong)NSString *speak_Id;
-(void)configure:(XXECircleModel*)circleModel;
-(void)configureWithGoodUser:(XXEGoodUserModel*)model;

@end

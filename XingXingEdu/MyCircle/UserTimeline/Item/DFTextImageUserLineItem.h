//
//  DFTextImageUserLineItem.h
//  DFTimelineView
//
//  Created by keenteam on 16/2/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "DFBaseUserLineItem.h"

@interface DFTextImageUserLineItem : DFBaseUserLineItem

@property (nonatomic, strong) NSString *cover;

@property (nonatomic, strong) NSString *text;

@property (nonatomic, assign) NSUInteger photoCount;

@property (nonatomic, strong) NSMutableArray *imageMrr;

@end

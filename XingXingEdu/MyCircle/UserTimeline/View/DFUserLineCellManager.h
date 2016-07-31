//
//  DFLineCellAdapterManager.h
//  DFTimelineView
//
//  Created by keenteam on 16/2/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "DFBaseLineItem.h"
#import "DFBaseUserLineCell.h"

#import "DFTextImageUserLineItem.h"
#import "DFTextImageUserLineCell.h"

@interface DFUserLineCellManager : NSObject


+(instancetype) sharedInstance;

-(void) registerCell:(Class) itemClass cellClass:(Class ) cellClass;

-(DFBaseUserLineCell *) getCell:(Class) itemClass;


@end

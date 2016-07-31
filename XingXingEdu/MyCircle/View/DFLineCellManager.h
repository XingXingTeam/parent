//
//  DFLineCellAdapterManager.h
//  DFTimelineView
//
//  Created by keenteam on 16/2/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "DFBaseLineItem.h"
#import "DFBaseLineCell.h"

#import "DFTextImageLineItem.h"
#import "DFVideoLineItem.h"

#import "DFTextImageLineCell.h"
#import "DFVideoLineCell.h"

@interface DFLineCellManager : NSObject


+(instancetype) sharedInstance;

-(void) registerCell:(Class) itemClass cellClass:(Class ) cellClass;

-(DFBaseLineCell *) getCell:(Class) itemClass;


@end

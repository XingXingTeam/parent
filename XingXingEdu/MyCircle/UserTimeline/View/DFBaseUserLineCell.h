//
//  DFBaseUserLineCell.h
//  DFTimelineView
//
//  Created by keenteam on 16/2/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "DFBaseUserLineItem.h"
#import "UIImageView+WebCache.h"

@protocol DFBaseUserLineCellDelegate <NSObject>

@required

-(void) onClickItem:(DFBaseUserLineItem *) item;

@end



@interface DFBaseUserLineCell : UITableViewCell


@property (nonatomic, weak) id<DFBaseUserLineCellDelegate> delegate;


@property (nonatomic, strong) UIButton *bodyView;


-(void) updateWithItem:(DFBaseUserLineItem *) item;

-(CGFloat) getCellHeight:(DFBaseUserLineItem *) item;


-(void) updateBodyWithHeight:(CGFloat)height;

@end

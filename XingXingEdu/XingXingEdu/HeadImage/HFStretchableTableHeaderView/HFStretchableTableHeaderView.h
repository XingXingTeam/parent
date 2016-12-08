//
//  HFStretchableTableHeaderView.h
//  xingxingEdu
//
//  Created by keenteam on 16/1/23.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFStretchableTableHeaderView : NSObject

@property (nonatomic,retain) UITableView* tableView;
@property (nonatomic,retain) UIView* view;

- (void)stretchHeaderForTableView:(UITableView*)tableView withView:(UIView*)view;
- (void)scrollViewDidScroll:(UIScrollView*)scrollView;
- (void)resizeView;

@end

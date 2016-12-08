//
//  StarView.h
//
//  Created by codeDing on 16/3/31.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol StarDelegate <NSObject>
- (void)starView:(UIView*)starView selectIndex:(NSInteger)index;
@end

@interface StarView : UIView
@property (nonatomic,assign) id<StarDelegate>delegate;
@property (nonatomic,assign) NSString *title;
@end

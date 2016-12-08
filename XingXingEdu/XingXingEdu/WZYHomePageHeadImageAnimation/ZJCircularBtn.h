//
//  ZJCircularBtn.h
//  CircularBtn
//
//  Created by zhuoyue on 16/3/14.
//  Copyright © 2016年 YZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZJCircularBtnDelegate <NSObject>

-(void)clickCircularBtnNum:(NSInteger)num;

@end

@interface ZJCircularBtn : UIView

@property(nonatomic,weak)id<ZJCircularBtnDelegate>delegate;

-(void)createCircularBtnWithBtnNum:(NSInteger)btnNum center:(CGPoint)center raiuds:(CGFloat)raiuds btnRaiuds:(CGFloat)btnRaiuds btnImages:(NSArray *)imageArray titleArray:(NSArray *)titleArray  superView:(UIView *)superView;

@end

//
//  ProgressView.m
//  下载进度条
//
//  Created by 咪咕 on 16/6/22.
//  Copyright © 2016年 咪咕. All rights reserved.
//

#import "ProgressView.h"

@interface ProgressView ()

@property (nonatomic, strong) CALayer *progressLayer;
@property (nonatomic, assign) CGFloat currentViewWidth;

@end

@implementation ProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.progressLayer       = [CALayer layer];
        self.progressLayer.frame = CGRectMake(0, 0, 0, frame.size.height);
        self.progressLayer.backgroundColor = [UIColor redColor].CGColor;
        [self.layer addSublayer:self.progressLayer];
        
        //存储当前view的宽度值
        self.currentViewWidth = frame.size.width;
    }
    return self;
}

#pragma mark - 重写setter getter

@synthesize progress = _progress;

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    if (progress <= 0) {
        self.progressLayer.frame = CGRectMake(0, 0, 0, self.frame.size.height);
    }else if (progress <= 1){
        self.progressLayer.frame = CGRectMake(0, 0, progress * self.currentViewWidth, self.frame.size.height);
    }else{
        self.progressLayer.frame = CGRectMake(0, 0, self.currentViewWidth, self.frame.size.height);
    }
}

- (CGFloat)progress
{
    return _progress;
}

@synthesize layerColor = _layerColor;

- (void)setLayerColor:(UIColor *)layerColor
{
    _layerColor = layerColor;
    self.progressLayer.backgroundColor = layerColor.CGColor;
}

- (UIColor *)layerColor
{
    return _layerColor;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

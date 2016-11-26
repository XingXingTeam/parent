//
//  ProgressView.h
//  下载进度条
//
//  Created by 咪咕 on 16/6/22.
//  Copyright © 2016年 咪咕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView

@property (nonatomic, assign) CGFloat progress;//进度参数取值范围(0% - 100%)
@property (nonatomic, strong) UIColor *layerColor;//修改颜色


@end

//
//  HeaderFooterCollectionReusableView.m
//  XingXingEdu
//
//  Created by Mac on 16/7/25.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "HeaderFooterCollectionReusableView.h"

@implementation HeaderFooterCollectionReusableView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}
-(void)createSubViews{
    UILabel *label = [[UILabel alloc]initWithFrame:self.bounds];
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:12];
    label.tag = 10;
    [self addSubview:label];
}
-(void)setTitle:(NSString *)title{
    _title = title;
    UILabel *label = [self viewWithTag:10];
    label.text = _title;
}


@end

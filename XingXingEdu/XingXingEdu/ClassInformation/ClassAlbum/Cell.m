//
//  Cell.m
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/1/20.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "Cell.h"

@implementation Cell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageview=[[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_imageview];
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(1, 8, 20, 20);
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"notSelected"] forState:UIControlStateNormal];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateHighlighted];
        
        _deleteBtn.hidden =NO;
        [_deleteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_deleteBtn];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _imageview.frame=CGRectInset(self.bounds, 0, 2);
}
- (void)btnClick:(UIButton*)btn{
    if (btn.selected ==YES) {
        btn.selected=NO;
    }else{
        
        btn.selected =YES;
    }
    
}

@end

//
//  StarView.m
//
//  Created by codeDing on 16/3/31.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//


#import "StarView.h"
static NSInteger SELECT = 0;
@implementation StarView
{
    NSMutableArray *arrays;
    BOOL           isRise;
    UILabel        *titleLab;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        arrays = [[NSMutableArray alloc] init];
        isRise = YES;
        
        titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 20)];
        titleLab.backgroundColor = [UIColor clearColor];
        titleLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:titleLab];
        for (int i = 0; i < 5; i++)
        {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(30+40*i, 0, 40, 40)];
            [btn setBackgroundImage:[UIImage imageNamed:@"pj_sar_big_gray"]
                           forState:UIControlStateNormal];
            
            [btn setBackgroundImage:[UIImage imageNamed:@"pj_star_big_yellow"]
                           forState:UIControlStateHighlighted];
            
            [btn setBackgroundImage:[UIImage imageNamed:@"pj_star_big_yellow"] forState:UIControlStateSelected];
            
            [btn addTarget:self action:@selector(selectStare:) forControlEvents:UIControlEventTouchUpInside];
            
            btn.tag = 100 + i;
            [self addSubview:btn];
            [arrays addObject:btn];
        }
    }
    return self;
}
- (void)setTitle:(NSString *)title
{
    titleLab.text = title;
}
- (void)selectStare:(UIButton*)btn
{
    NSInteger index = btn.tag - 100;
    
    if(!btn.selected)
    {
        for (int i = 0; i < arrays.count; i ++)
        {
            UIButton *button = (UIButton*)arrays[i];
            if (i <= index)
            {
                SELECT = index;
                button.selected = YES;
                
            }
            else
            {
                button.selected = NO;
            }
        }
    }
    else
    {
        for (int i = 0; i < arrays.count; i ++)
        {
            UIButton *button = (UIButton*)arrays[i];
            if (i < index)
            {
                SELECT = index-1;
                button.selected = YES;
                
            }
            else
            {
                SELECT = index-1;

                button.selected = NO;
            }
        }
    }
    if (_delegate&&[_delegate respondsToSelector:@selector(starView:selectIndex:)])
    {
        [_delegate starView:self  selectIndex:SELECT+1];
    }
    
    
}

@end

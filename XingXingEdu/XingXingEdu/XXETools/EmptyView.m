//
//  EmptyView.m
//  teacher
//
//  Created by codeDing on 16/12/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "EmptyView.h"

@implementation EmptyView

+ (EmptyView*)conveniceWithTitle:(NSString *)title frame:(CGRect)frame {
    EmptyView *empty = [[EmptyView alloc] init];
    empty.frame = frame;
    empty.backgroundColor = [UIColor whiteColor];
    UIImage *mainImg = [UIImage imageNamed:@"emptv"];
    CGFloat imgHeight = mainImg.size.height;
    CGFloat imgWidth = mainImg.size.width;
    
    UIImageView *mainIV = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth - imgWidth)/2, (frame.size.height - imgHeight)/2, imgWidth, imgHeight)];
    mainIV.image = mainImg;
    [empty addSubview:mainIV];
    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.text = title;
    titleLbl.textColor = UIColorFromHex(0x666666);
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont systemFontOfSize:16];
    [empty addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(mainIV);
        make.top.mas_equalTo(mainIV.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(KScreenWidth - 20);
    }];
    
    return empty;
}
@end

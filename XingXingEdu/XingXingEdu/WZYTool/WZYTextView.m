


//
//  WZYTextView.m
//  XingXingEdu
//
//  Created by Mac on 16/5/15.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "WZYTextView.h"

@interface WZYTextView() <UITextViewDelegate>

@property (nonatomic, weak) UILabel *placehoderLabel;

@end

@implementation WZYTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        //添加一个显示占位符的label
        UILabel *placehoderLabel = [[UILabel alloc] init];
        placehoderLabel.numberOfLines = 0;
        placehoderLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:placehoderLabel];
        self.placehoderLabel = placehoderLabel;
        
        //设置默认的占位文字的颜色
        self.placehoderColor = [UIColor lightGrayColor];
        
        //设置默认的字体
        self.font = [UIFont systemFontOfSize:14];
        
        //监听内部文字的改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        
    }
    return self;
}

//取消监听
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)textDidChange{
    
    self.placehoderLabel.hidden = self.hasText;

}

#pragma mark - 公共方法
//text:只包含普通的文本字符串
- (void)setText:(NSString *)text{
    [super setText:text];
    [self textDidChange];
}

//attributedText:还包含了显示在textView里面的所有的内容(表情)
- (void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    [self textDidChange];

}

- (void)setPlacehoder:(NSString *)placehoder{

    _placehoder = [placehoder copy];
    
    //设置文字
    self.placehoderLabel.text = placehoder;
    
    //重新计算子控件的frame
    [self setNeedsLayout];

}

- (void)setPlacehoderColor:(UIColor *)placehoderColor{
    _placehoderColor = placehoderColor;
    
    //设置颜色
    self.placehoderLabel.textColor = placehoderColor;
}

- (void)setFont:(UIFont *)font{
    [super setFont:font];

    self.placehoderLabel.font = font;

    //重新计算子控件的frame
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.placehoderLabel.y = 8;
    self.placehoderLabel.x = 5;
    self.placehoderLabel.width = self.width - 2 * self.placehoderLabel.x;
    
    //根据文字计算label的高度
    CGSize maxSize = CGSizeMake(self.placehoderLabel.width, MAXFLOAT);
    CGSize placehoderSize = [self.placehoder sizeWithFont:self.placehoderLabel.font constrainedToSize:maxSize];
    self.placehoderLabel.height = placehoderSize.height;
}


@end

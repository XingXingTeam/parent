//
//  LSSAlertView.m
//  LSSAlertView
//
//  Created by MS on 16/5/11.
//  Copyright © 2016年 LSS. All rights reserved.
//

#import "LSSAlertView.h"
#define LAVSCREEN [UIScreen mainScreen].bounds
#define LAVSCREENW [UIScreen mainScreen].bounds.size.width
#define LAVSCREENH [UIScreen mainScreen].bounds.size.height
#define RGBa(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
//默认宽度
#define LAVWIDTH LAVSCREENW-60
///各个栏目之间的距离
#define LAVSPACE 10.0
@interface LSSAlertView()
//根window
@property (nonatomic) UIWindow *rootWindow;
//弹窗
@property (nonatomic) UIView *alertView;
//title,默认为一行，多行还未做
@property (nonatomic) UILabel *titleLabel;
//图片
@property (nonatomic) UIImageView *picImgae;
//内容
@property (nonatomic) UILabel *mesLabel;
//确认按钮
@property (nonatomic) UIButton *sureBtn;
//取消按钮
@property (nonatomic) UIButton *cancleBtn;
///闲的记录一下高度吧
@property (nonatomic) CGFloat alertHeight;
@end
@implementation LSSAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message  picImage:(NSString *)imageName sureBtn:(NSString *)sureBtn cancleBtn:(NSString *)cancleBtn{
    if (self == [super init]) {
        self.frame = LAVSCREEN;
        self.backgroundColor = [UIColor colorWithWhite:.7 alpha:.7];
        self.alertView = [[UIView alloc] init];
        self.alertView.backgroundColor = [UIColor whiteColor];
        self.alertView.layer.cornerRadius = 10.0;
        if (title) {
            self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, LAVSPACE *4, LAVWIDTH, 20)];
            self.titleLabel.text = title;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            [self.alertView addSubview:self.titleLabel];
        }
        if (imageName) {
            
            self.picImgae = [[UIImageView alloc] initWithFrame:CGRectMake(15, LAVSPACE *3, 60, 60)];
            self.picImgae.image = [UIImage imageNamed:imageName];
            [self.alertView addSubview:self.picImgae];
        }
        
        if (message) {
            //首先计算当前字体的高度,默认信息用15号
            CGFloat mesHeight = [self getTextHeightWithText:message AndFont:[UIFont systemFontOfSize:14]];
            self.mesLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.picImgae.frame) + 5 , CGRectGetMaxY(self.titleLabel.frame)+LAVSPACE, 180, mesHeight)];
            self.mesLabel.text = message;
            self.mesLabel.font = [UIFont systemFontOfSize:12];
            self.mesLabel.numberOfLines = 0;
            [self.alertView addSubview:self.mesLabel];
        }
        if (sureBtn) {
            self.sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.sureBtn.frame = CGRectMake(15, CGRectGetMaxY(self.picImgae.frame)+LAVSPACE *2, (LAVWIDTH-40)/2, 40);
            self.sureBtn.backgroundColor = RGBa(86, 192, 77, 1);
            [self.sureBtn setTitle:sureBtn forState:UIControlStateNormal];
            [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.sureBtn.tag = 0;
            [self.sureBtn addTarget:self action:@selector(buttonBeClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:self.sureBtn];
        }
        if(cancleBtn){
            self.cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.cancleBtn.frame = CGRectMake(CGRectGetMaxX(self.sureBtn.frame)+20, CGRectGetMaxY(self.picImgae.frame) + LAVSPACE*2, (LAVWIDTH-40)/2-10, 40);
            self.cancleBtn.backgroundColor = RGBa(86, 192, 77, 1);
            [self.cancleBtn setTitle:cancleBtn forState:UIControlStateNormal];
            [self.cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.cancleBtn.tag = 1;
            [self.cancleBtn addTarget:self action:@selector(buttonBeClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:self.cancleBtn];
        }
        self.alertHeight = 50+CGRectGetHeight(self.titleLabel.frame)+10+CGRectGetHeight(self.mesLabel.frame)+10+CGRectGetHeight(self.sureBtn.frame)+10;
        self.alertView.frame = CGRectMake(0, 0, LAVWIDTH, self.alertHeight);
        [self addSubview:self.alertView];
    }
    return self;
}
#pragma mark - 弹出 -
- (void)showAlertView{
    self.rootWindow = [UIApplication sharedApplication].keyWindow;
    [self.rootWindow addSubview:self];
    ///创建动画
    [self creatShowAnimation];
}
- (void)creatShowAnimation{
    CGPoint startPoint = CGPointMake(self.frame.size.height, -self.alertHeight);
    self.alertView.layer.position = startPoint;
    self.alertView.layer.position = self.center;
    
}
#pragma mark - 点击按钮的回调 -
- (void)buttonBeClicked:(UIButton *)button{
    if (self.returnIndex) {
        self.returnIndex(button.tag);
    }
    [self removeFromSuperview];
}
#pragma mark - 得到高度 -
-(CGFloat)getTextHeightWithText:(NSString *)text AndFont:(UIFont *)font
{
    return [text boundingRectWithSize:CGSizeMake(LAVWIDTH-40, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor blackColor]} context:nil].size.height;
}


@end

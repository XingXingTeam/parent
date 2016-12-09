//
//  SendFlowerBaskerDetailController.m
//  XingXingEdu
//
//  Created by mac on 16/8/2.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "SendFlowerBaskerDetailController.h"

@interface SendFlowerBaskerDetailController ()

@end

@implementation SendFlowerBaskerDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"花篮详情页";
    self.view.backgroundColor = UIColorFromRGB(255, 255, 255);
    
    [self createSendFlowerBaskerDetailView];
}

-(void)createSendFlowerBaskerDetailView{
    
    UILabel *ZengSongName = [HHControl createLabelWithFrame:CGRectMake(20, 0, kWidth - 40,40 ) Font:14 Text:[NSString stringWithFormat:@"赠送人:    %@",_teacherLabel]];
    ZengSongName.backgroundColor = [UIColor clearColor];
    [self.view addSubview:ZengSongName];
    
    UIImageView *lineView = [HHControl createImageViewWithFrame:CGRectMake(0, CGRectGetMaxY(ZengSongName.frame), kWidth, 5) ImageName:@""];
    lineView.backgroundColor = UIColorFromRGB(241, 242, 241);
    [self.view addSubview:lineView];
    
    UILabel *numberLabel = [HHControl createLabelWithFrame:CGRectMake(20, CGRectGetMaxY(lineView.frame), kWidth - 40, 40) Font:14 Text:[NSString stringWithFormat:@"数目 :    %@",_numLabel]];
    numberLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:numberLabel];
    
    UIImageView *lineView2 = [HHControl createImageViewWithFrame:CGRectMake(0, CGRectGetMaxY(numberLabel.frame), kWidth, 5) ImageName:@""];
    lineView2.backgroundColor = UIColorFromRGB(241, 242, 241);
    [self.view addSubview:lineView2];
    
    
    NSString *timeStr = [WZYTool dateStringFromNumberTimer:_timeLbl];
    UILabel *timeLabel = [HHControl createLabelWithFrame:CGRectMake(20, CGRectGetMaxY(lineView2.frame), kWidth - 20, 40) Font:14 Text:[NSString stringWithFormat:@"时间:     %@",timeStr]];
    timeLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:timeLabel];
    
    UIImageView *lineView3 = [HHControl createImageViewWithFrame:CGRectMake(0, CGRectGetMaxY(timeLabel.frame), kWidth, 5) ImageName:@""];
    lineView3.backgroundColor = UIColorFromRGB(241, 242, 241);
    [self.view addSubview:lineView3];
    
    
    UITextView *subjectSayView = [[UITextView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(lineView3.frame) + 10, kWidth - 40 , 120)];
    subjectSayView.text = _textLabe;
    subjectSayView.font = [UIFont systemFontOfSize:14];
    subjectSayView.userInteractionEnabled = NO;
    [subjectSayView flashScrollIndicators];   // 闪动滚动条
    //自动适应行高
    static CGFloat maxHeight = 130.0f;
    CGRect frame = subjectSayView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [subjectSayView sizeThatFits:constraintSize];
    if (size.height >= maxHeight){
        size.height = maxHeight;
        subjectSayView.scrollEnabled = YES;   // 允许滚动
    }
    else{
        subjectSayView.scrollEnabled = NO;    // 不允许滚动，当textview的大小足以容纳它的text的时候，需要设置scrollEnabed为NO，否则会出现光标乱滚动的情况
    }
    subjectSayView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    [self.view addSubview:subjectSayView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

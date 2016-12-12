


//
//  XXESystemNotificationDetailViewController.m
//  teacher
//
//  Created by Mac on 16/9/13.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESystemNotificationDetailViewController.h"

@interface XXESystemNotificationDetailViewController ()
{
    NSMutableArray *titleArray;
    NSMutableArray *contentArray;
    
    
    //下部 downBgView
    UIView *downBgView;
    
    UITextView *contentTextView;
}

@end

@implementation XXESystemNotificationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor = UIColorFromRGB( 229, 232, 233);
    titleArray = [[NSMutableArray alloc] initWithObjects:@"发布人:", @"发布主题:", @"发布时间:", nil];
    contentArray = [[NSMutableArray alloc] initWithObjects:_name, _titleStr, _time, nil];
    
    [self createContent];

}

- (void)createContent{
    
#pragma mark ======== //发布人 bgView ========
    UIView *cellBgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    cellBgView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cellBgView1];
    
    //标题
    UILabel *titleLabel1 = [HHControl createLabelWithFrame:CGRectMake(10, 10, 70, 20) Font:14 Text:titleArray[0]];
    [cellBgView1 addSubview:titleLabel1];
    
    //内容
    UILabel *contentLabel1 = [HHControl createLabelWithFrame:CGRectMake(titleLabel1.frame.origin.x + titleLabel1.width, titleLabel1.frame.origin.y, KScreenWidth - 100, 20) Font:14 Text:contentArray[0]];//
    
    [cellBgView1 addSubview:contentLabel1];
    
    
#pragma mark ======== //通知主题 bgView ========
    UIView *cellBgView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 45, KScreenWidth, 40)];
    cellBgView3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cellBgView3];
    
    //标题
    UILabel *titleLabel3 = [HHControl createLabelWithFrame:CGRectMake(10, 10, 70, 20) Font:14 Text:titleArray[1]];
    [cellBgView3 addSubview:titleLabel3];
    
    //内容
    UILabel *contentLabel3 = [HHControl createLabelWithFrame:CGRectMake(titleLabel3.frame.origin.x + titleLabel3.width, titleLabel3.frame.origin.y, KScreenWidth - 100, 20) Font:14 Text:contentArray[1]];//
    
    CGFloat height = [StringHeight contentSizeOfString:contentArray[1] maxWidth:contentLabel1.width fontSize:14];
    
    CGSize size3 = contentLabel3.size;
    size3.height = height;
    contentLabel3.size = size3;
    [cellBgView3 addSubview:contentLabel3];
    
    CGSize size33 = cellBgView3.size;
    size33.height = 10 + height + 10;
    cellBgView3.size = size33;
    
#pragma mark ======== //时间 bgView ========
    UIView *cellBgView4 = [[UIView alloc] initWithFrame:CGRectMake(0, cellBgView3.frame.origin.y + cellBgView3.height + 5, KScreenWidth, 40)];
    cellBgView4.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cellBgView4];
    
    //标题
    UILabel *titleLabel4 = [HHControl createLabelWithFrame:CGRectMake(10, 10, 70, 20) Font:14 Text:titleArray[2]];
    [cellBgView4 addSubview:titleLabel4];
    
    //内容
    UILabel *contentLabel4 = [HHControl createLabelWithFrame:CGRectMake(titleLabel4.frame.origin.x + titleLabel4.width, titleLabel4.frame.origin.y, KScreenWidth - 100, 20) Font:14 Text:contentArray[2]];//
    [cellBgView4 addSubview:contentLabel4];
    
#pragma mark ============ 创建 下部  ===========
    //创建 下部
    contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, cellBgView4.frame.origin.y + cellBgView4.height + 5, KScreenWidth, KScreenHeight - cellBgView4.height - 100)];
    contentTextView.font = [UIFont systemFontOfSize:14];
    contentTextView.backgroundColor = [UIColor whiteColor];
    contentTextView.text = _content;
    contentTextView.editable = NO;
    [self.view addSubview:contentTextView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

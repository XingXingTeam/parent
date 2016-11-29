//
//  TeleHomepageViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/2/3.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "TeleHomepageViewController.h"
#import "AuditSetViewController.h"
#import "HHControl.h"
#import "UIView+MJ.h"



#define KLabelH 40.0f
#define Kmarg 20.0f
#define KLabelX 20.0f
#define KLabelW 70.0f
#define KImageW 20.0f
#define KImageH 25.0f


@interface TeleHomepageViewController (){
    UIScrollView *bgScrollView;
  
}

@end

@implementation TeleHomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =  [UIColor whiteColor];
    

    [self createLbl];

}

- (void)createLbl{
    NSMutableArray *nameLabelArr = [[NSMutableArray alloc] initWithObjects:@"位置icon40x50",@"授课范围icon40x50",@"教龄icon40x50",@"认证icon40x50",@"手机号icon40x50",@"QQicon40x50",@"邮箱icon40x50",@"权限设置icon40x50",nil];
    
    NSMutableArray *detailedLabelArr = [[NSMutableArray alloc]initWithObjects:@"位置:",@"课程:",@"年龄:",@"认证:",@"手机:",@"QQ:",@"邮箱:",@"权限设置",nil];
    
    //背景
    bgScrollView = [[UIScrollView alloc] init];
    bgScrollView.frame = CGRectMake(0, 0, kWidth,kHeight);
    bgScrollView.pagingEnabled = NO;
    bgScrollView.showsHorizontalScrollIndicator = YES;
    bgScrollView.showsVerticalScrollIndicator  = YES;
    bgScrollView.alwaysBounceVertical = YES;
    [self.view addSubview:bgScrollView];
    
    
    for (int i = 0 ; i < nameLabelArr.count; i ++) {
        UIImageView *fisrtView = [[UIImageView alloc] initWithFrame:CGRectMake(KLabelX, KLabelH * i  + 6, KImageW, KImageH)];
        fisrtView.image = [UIImage imageNamed:nameLabelArr[i]];
        [bgScrollView addSubview:fisrtView];
     
        if (i == 7) {
            UIButton *powerBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(fisrtView.frame) + Kmarg, KLabelH * 7  , kWidth  - 80, KLabelH)];
            [powerBtn setTitle:detailedLabelArr[7] forState:UIControlStateNormal];
            powerBtn.backgroundColor = [UIColor clearColor];
            [powerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            powerBtn.titleLabel.font = [UIFont systemFontOfSize: 16.0];
            
            UIImageView *headAlbumLblAorrw = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(powerBtn.frame) - Kmarg, KLabelH * 7  + 14 , 7, 13)];
            headAlbumLblAorrw.image = [UIImage imageNamed:@"箭头icon14x26"];
            [bgScrollView addSubview:headAlbumLblAorrw];
            powerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            powerBtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
            [powerBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [bgScrollView addSubview:powerBtn];
            
        }else{
            UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(fisrtView.frame) + Kmarg, KLabelH * i , KLabelW, KLabelH)];
            secondLabel.text = detailedLabelArr[i];
            secondLabel.font = [UIFont systemFontOfSize:16];
            secondLabel.textAlignment = NSTextAlignmentLeft;
            [bgScrollView addSubview:secondLabel];
            
            UITextField *detailedText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(secondLabel.frame) , KLabelH * i, kWidth - CGRectGetMaxX(secondLabel.frame) - KLabelH , KLabelH)];
            detailedText.text = self.homePageArr[i];
            detailedText.borderStyle = UITextBorderStyleNone;
            detailedText.font = [UIFont systemFontOfSize:14];
            detailedText.userInteractionEnabled = NO;
            detailedText.textColor = [UIColor grayColor];
            [bgScrollView addSubview:detailedText];
            if ([self.homePageArr[i] isEqualToString:@""]) {
                detailedText.text = @"暂时没有";
            }
            //判断是否认证
            if (i == 3) {
                if ([detailedLabelArr[3] isEqualToString:@"1"]) {
                    detailedText.text = @"已认证";
                }else{
                    detailedText.text = @"未认证";
                }
            }
        }
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(KLabelX, KLabelH * (i+1) - 2, kWidth - KLabelX * 2, 1)];
        line.backgroundColor = UIColorFromRGB(204, 204, 204);
        [bgScrollView addSubview:line];
        
    }
    
    CGFloat maxH =  nameLabelArr.count * (KLabelH + 5) + 300;
    bgScrollView.contentSize = CGSizeMake(0, maxH);
}

//权限跳转

- (void)clickBtn:(UIBarButtonItem*)btn{
    AuditSetViewController *auditSetVC =[[AuditSetViewController alloc]init];
    auditSetVC.XIDStr = @"18884982";
    [self.navigationController pushViewController:auditSetVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


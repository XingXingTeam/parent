//
//  OrganInfoViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/3/17.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "OrganInfoViewController.h"
#import "PicterLargeViewController.h"
#import "RedFlowerViewController.h"
@interface OrganInfoViewController ()
{
    NSMutableArray *imageArr;
    int ss;
}
@end

@implementation OrganInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =  UIColorFromRGB(239, 239, 239);
    [self createLbl];
    // Do any additional setup after loading the view.
}
- (void)createLbl{
    UILabel *localLbl =[[UILabel alloc]initWithFrame:CGRectMake(10, 10, kWidth, 20)];
    NSString *text =@"民办学校";
    localLbl.font = [UIFont systemFontOfSize:10];
    localLbl.text = [NSString stringWithFormat:@"资质: %@",text];
    [self.view addSubview:localLbl];
    
    NSString *teachText =@"语文&体育";
    UILabel *teachLbl = [HHControl createLabelWithFrame:CGRectMake(10, 40, kWidth, 20) Font:10 Text:[NSString stringWithFormat:@"特点: %@",teachText]];
    [self.view addSubview:teachLbl];
    
    NSString *ageText =@"诞生于1898年，初名京师大学堂，是中国近代第一所国立大学.";
    UILabel *ageLbl = [HHControl createLabelWithFrame:CGRectMake(10, 70, kWidth, 20) Font:10 Text:[NSString stringWithFormat:@"简介: %@",ageText]];
    [self.view addSubview:ageLbl];
    
    
    NSString *auditText =@"17081377258";
    UILabel *auditLbl = [HHControl createLabelWithFrame:CGRectMake(10, 100, kWidth, 20) Font:10 Text:[NSString stringWithFormat:@"联系方式: %@",auditText]];
    [self.view addSubview:auditLbl];
    
    NSString *teleText =@"812144991";
    UILabel *teleLbl = [HHControl createLabelWithFrame:CGRectMake(10, 130, kWidth, 20) Font:10 Text:[NSString stringWithFormat:@"联系QQ: %@",teleText]];
    [self.view addSubview:teleLbl];
    //mail
    NSString *QQText =@"keen_team@163.com";
    UILabel *QQLbl = [HHControl createLabelWithFrame:CGRectMake(10, 160, kWidth, 20) Font:10 Text:[NSString stringWithFormat:@"联系邮箱: %@",QQText]];
    [self.view addSubview:QQLbl];
    //QQ
    NSString *mailText =@"  ";
    UILabel *mailLbl = [HHControl createLabelWithFrame:CGRectMake(10, 190, kWidth, 20) Font:10 Text:[NSString stringWithFormat:@"相册: %@",mailText]];
    [self.view addSubview:mailLbl];
    
    imageArr = [NSMutableArray arrayWithObjects:@"00000.jpg",@"11111",@"22222", nil];
    UIScrollView *scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 213, 100*imageArr.count, 200)];
    [self.view addSubview:scrollV];
    [self.view addSubview:scrollV];
    for (int i=0; i<imageArr.count; i++) {
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10+80*i, 0, 60, 60)];
        imageV.image = [UIImage imageNamed:imageArr[i]];
        imageV.tag =100+i;
        [scrollV addSubview:imageV];
        imageV.userInteractionEnabled =YES;
        
        UITapGestureRecognizer *tapImage =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bigImage: )];
        [imageV addGestureRecognizer:tapImage];
    }

    
}
- (void)bigImage:(UITapGestureRecognizer*)tap{
   
    NSLog(@"%ld",tap.view.tag);
    RedFlowerViewController *redFlowerVC =[[RedFlowerViewController alloc]init];
//    redFlowerVC.s =(int)tap.view.tag-100+1;
    redFlowerVC.imageArr =imageArr;
    [self.navigationController pushViewController:redFlowerVC animated:YES];
    
//    PicterLargeViewController *picterLargeVC =[[PicterLargeViewController alloc]init];
//  
//    [self.navigationController pushViewController:picterLargeVC animated:YES];
    
}

@end

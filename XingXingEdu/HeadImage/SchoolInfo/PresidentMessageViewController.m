//
//  PresidentMessageViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/3/17.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "PresidentMessageViewController.h"
#import "PicterLargeViewController.h"
#import "RedFlowerViewController.h"
#import "HHControl.h"
@interface PresidentMessageViewController ()
{
    UIImageView *imageV;
    NSMutableArray *imageArr;
}
@end

@implementation PresidentMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor =UIColorFromRGB(239, 239, 239);
    // Do any additional setup after loading the view.
    [self createMessage];
}
- (void)createMessage{

    UILabel *mailLbl = [HHControl createLabelWithFrame:CGRectMake(10, 10, kWidth, 20) Font:10 Text:@"相册:"];
    [self.view addSubview:mailLbl];
    
    imageArr = [NSMutableArray arrayWithObjects:@"00000.jpg",@"11111",@"22222", nil];
    UIScrollView *scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 33, 100*imageArr.count, 200)];
    [self.view addSubview:scrollV];
    [self.view addSubview:scrollV];
    for (int i=0; i<imageArr.count; i++) {
        imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10+80*i, 0, 70, 70)];
        imageV.tag =100+i;
        imageV.image = [UIImage imageNamed:imageArr[i]];
        
        [scrollV addSubview:imageV];
        imageV.userInteractionEnabled =YES;
        
        UITapGestureRecognizer *tapImage =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bigImage: )];
        [imageV addGestureRecognizer:tapImage];
    }
    
    
    UILabel *localLbl =[[UILabel alloc]initWithFrame:CGRectMake(10, 120, kWidth-20, 50)];
    NSString *text =@"北大是不可复制的，每一个北大人的人生也是不可复制的。希望大家永远不要被喧嚣、浮躁所迷惑，请勇敢地做你自己，一个更好的自己，做一个堂堂正正、独一无二的北大人。";
    localLbl.numberOfLines =0;
    localLbl.font = [UIFont systemFontOfSize:10];
    localLbl.text = [NSString stringWithFormat:@"致辞: %@",text];
    [self.view addSubview:localLbl];
    
    NSString *teachText =@"一个好校长，就是一所好学校，就有一种好教育。走进北大三生幸，少时宿愿老大成。博雅塔下拜名师，未名湖畔会高人。耳闻目睹振肺腑，言传身教撼心灵。高端培训增动力，罗湖教育启新程。";
    UILabel *teachLbl = [HHControl createLabelWithFrame:CGRectMake(10, 190, kWidth, 50) Font:10 Text:[NSString stringWithFormat:@"教学感悟: %@",teachText]];
    teachLbl.numberOfLines =0;
    [self.view addSubview:teachLbl];


}
- (void)bigImage:(UITapGestureRecognizer*)tap{
    NSLog(@"bigImage");
    NSLog(@"%ld",tap.view.tag-100+1);
    RedFlowerViewController * RedFlowerVC =[[RedFlowerViewController alloc]init];
    RedFlowerVC.s =(int) tap.view.tag-100+1;
    RedFlowerVC.imageArr =imageArr;
    [self.navigationController pushViewController:RedFlowerVC animated:YES];
    
//    PicterLargeViewController *picLargeVC =[[PicterLargeViewController alloc]init];
//   
//    
//    
//    [self.navigationController pushViewController:picLargeVC animated:YES];
    
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

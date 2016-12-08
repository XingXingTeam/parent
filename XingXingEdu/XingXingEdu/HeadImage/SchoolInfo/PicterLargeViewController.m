//
//  PicterLargeViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/3/21.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "PicterLargeViewController.h"

@interface PicterLargeViewController ()
{
    UIScrollView *_scrollView;

}
@end

@implementation PicterLargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =@"图片";
    self.view.backgroundColor = UIColorFromRGB(116,205, 169);
    [self  createPicter];
}
- (void)createPicter{
 NSArray *imageArr = [NSArray arrayWithObjects:@"00000.jpg",@"11111",@"22222", nil];
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator =NO;
    _scrollView.contentSize =CGSizeMake(imageArr.count*kWidth, 0);
    [self.view addSubview:_scrollView];
    
    for (int i =0; i<imageArr.count; i++) {
        UIImageView * imV = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth*i, 0, kWidth, kHeight)];
        imV.image = [UIImage imageNamed:imageArr[i]];
        [_scrollView addSubview:imV];
    }



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

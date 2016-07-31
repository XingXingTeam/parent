//
//  aboutusViewController.m
//  Homepage
//
//  Created by super on 16/1/23.
//  Copyright © 2016年 Edu. All rights reserved.
//

#import "aboutusViewController.h"
#import "HHControl.h"
@interface aboutusViewController ()<UITextViewDelegate>
{
    UIImageView *groundImage;
    UILabel *aboutLable;
    UILabel *tPhoneLable;
    
}



@end

@implementation aboutusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    groundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    groundImage.image = [UIImage imageNamed:@"background"];
    [self.view addSubview:groundImage];
    [self createLabels];
}

-(void)createLabels
{
    
    aboutLable = [HHControl createLabelWithFrame:CGRectMake(40, 150, 300, 300) Font:20 Text:@"猩猩教室为国内首个专注于青少年培训和幼儿培训托管的O2O教育品牌。品牌以移动互联技术为基础，用互联网＋思维建设运营，力图用自主研发的APP结合线下培训机构的方式，给客户带来极致便利的体验，重塑目前混乱，抵消，无规模，无标准的青少年培训和幼儿培训托管市场。公司力争在3—5年内将猩猩教室品牌做到细分市场的领导者。"];
    [self.view addSubview:aboutLable];
    
    tPhoneLable = [HHControl createLabelWithFrame:CGRectMake(40, 100, 400, 40) Font:15 Text:@"我们的联系电话：021-60548858"];
    [groundImage addSubview:tPhoneLable];
    
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

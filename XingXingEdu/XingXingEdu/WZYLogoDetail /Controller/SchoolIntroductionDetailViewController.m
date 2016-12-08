



//
//  SchoolIntroductionDetailViewController.m

//  XingXingEdu
//
//  Created by Mac on 16/6/6.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "SchoolIntroductionDetailViewController.h"

@interface SchoolIntroductionDetailViewController ()

@property (nonatomic) UITextView *contentTextView;


@end

@implementation SchoolIntroductionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self createContent];
    
}

- (void)createContent{
    
    if ([_contentText isEqualToString:@""]) {
        
        // 无数据的时候
        UIImage *myImage = [UIImage imageNamed:@"人物"];
        CGFloat myImageWidth = myImage.size.width;
        CGFloat myImageHeight = myImage.size.height;
        
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - myImageWidth / 2, (kHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
        myImageView.image = myImage;
        [self.view addSubview:myImageView];
        
            }else{
                _contentTextView = [[UITextView alloc] init];
                _contentTextView.frame = CGRectMake(10, 10, kWidth - 20, kHeight - 20 - 64);
                _contentTextView.backgroundColor = [UIColor whiteColor];
                _contentTextView.editable = NO;
                _contentTextView.font = [UIFont systemFontOfSize:16];
                _contentTextView.text = _contentText;
                [self.view addSubview:_contentTextView];

            }
    
}

@end

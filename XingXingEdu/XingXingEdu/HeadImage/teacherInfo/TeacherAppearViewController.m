//
//  TeacherAppearViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/2/3.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "TeacherAppearViewController.h"

#import "SJAvatarBrowser.h"
#define Kmarg 10.0f
#define KLabelH 25.0f
@interface TeacherAppearViewController ()
{
    UIScrollView *_scrollV;
    UIScrollView *scrollView;//老师详情图片滚动
    NSMutableArray *_picImageArr;
  
}
@property(nonatomic,retain)NSMutableArray *bigViewArr;
@end

@implementation TeacherAppearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(225, 225, 225);

    [self createLbl];

}

- (void)createLbl{
    
    _scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    _scrollV.backgroundColor = UIColorFromRGB(230, 230, 230);
    _scrollV.userInteractionEnabled =YES;
    _scrollV.pagingEnabled = NO;
    _scrollV.showsHorizontalScrollIndicator = YES;
    _scrollV.showsVerticalScrollIndicator  = YES;
    _scrollV.alwaysBounceVertical = YES;
    [self.view addSubview:_scrollV];
    //教学经历
    UIView *teachImage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 150)];
    teachImage.backgroundColor = [UIColor whiteColor];
    [_scrollV addSubview:teachImage];
    
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(Kmarg + 3, Kmarg + 3, 20, 20)];
    headImage.image = [UIImage imageNamed:@"教学经历icon40x40"];
    [teachImage addSubview:headImage];
    
    
    UILabel *teachLbl = [HHControl createLabelWithFrame:CGRectMake(headImage.x + headImage.size.width + Kmarg, Kmarg, kWidth - 20, KLabelH) Font:16 Text:@"教学经历:"];
    teachLbl.textColor = [UIColor blackColor];
    [teachImage addSubview:teachLbl];
    
    UILabel *contextLbl = [HHControl createLabelWithFrame:CGRectMake(headImage.x, teachLbl.y + teachLbl.size.height + Kmarg, kWidth - 20, 80) Font:14 Text:self.techerLifeArr[0]];
    contextLbl.textColor = UIColorFromRGB(118, 118, 118);
    contextLbl.numberOfLines = 0;
    [_scrollV addSubview:contextLbl];
    
    //老师感悟
    
    UIView *teachThinkImage = [[UIView alloc] initWithFrame:CGRectMake(0, teachImage.y + teachImage.size.height + Kmarg, kWidth, 120)];
    teachThinkImage.backgroundColor = [UIColor whiteColor];
    [_scrollV addSubview:teachThinkImage];
    
    UIImageView *headThinkImage = [[UIImageView alloc] initWithFrame:CGRectMake(Kmarg + 3, Kmarg + 3, 20, 20)];
    headThinkImage.image = [UIImage imageNamed:@"教学感悟icon40x40"];
    [teachThinkImage addSubview:headThinkImage];
    
    UILabel *teachThinkLbl = [HHControl createLabelWithFrame:CGRectMake(headThinkImage.x + headThinkImage.size.width +Kmarg, Kmarg, kWidth - 20, KLabelH) Font:16 Text:@"教学感悟:"];
    teachThinkLbl.textColor = [UIColor blackColor];
    [teachThinkImage addSubview:teachThinkLbl];
    UILabel *contextThinkLbl = [HHControl createLabelWithFrame:CGRectMake(headThinkImage.x, teachThinkLbl.y +teachThinkLbl.size.height + Kmarg, kWidth - 20, 60) Font:14 Text:self.techerLifeArr[1]];
    contextThinkLbl.textColor = UIColorFromRGB(118, 118, 118);
    contextThinkLbl.numberOfLines =0;
    [teachThinkImage addSubview:contextThinkLbl];
    
    
    //相册
    UIView *teachAlbumLbl = [[UIView alloc] initWithFrame:CGRectMake(0, teachThinkImage.y + teachThinkImage.size.height + Kmarg, kWidth, 180)];
    teachAlbumLbl.backgroundColor = [UIColor whiteColor];
//    teachAlbumLbl.userInteractionEnabled = YES;
    [_scrollV addSubview:teachAlbumLbl];
    
    UIImageView *headAlbumLblImage = [[UIImageView alloc] initWithFrame:CGRectMake(Kmarg + 3, Kmarg + 3, 20, 20)];
    headAlbumLblImage.image = [UIImage imageNamed:@"相册icon40x40"];
    [teachAlbumLbl addSubview:headAlbumLblImage];
    
    UILabel *teachAlbumLblL = [HHControl createLabelWithFrame:CGRectMake(headAlbumLblImage.x + headAlbumLblImage.size.width +Kmarg, Kmarg, kWidth - 20, KLabelH) Font:14 Text:@"老师相册"];
    teachAlbumLblL.textColor = [UIColor blackColor];
    [teachAlbumLbl  addSubview:teachAlbumLblL];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(Kmarg, CGRectGetMaxY(teachAlbumLblL.frame) + Kmarg,kWidth -  Kmarg *2 , 120)];
    scrollView.backgroundColor = [UIColor whiteColor];
    CGFloat imgW = kWidth/3;
    CGFloat imgH = scrollView.frame.size.height;
    CGFloat imgY = 0;
    
        _picImageArr = [NSMutableArray array];
    for (int j = 0; j < self.teacher_pic_group.count; j ++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        NSString *imgName = [picURL stringByAppendingString:self.teacher_pic_group[j]];
        [_picImageArr addObject:imgName];
        
        [imgView sd_setImageWithURL:[NSURL URLWithString:imgName] placeholderImage:nil];
        CGFloat imgX = j * imgW;
        imgView.tag = j;
        imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonpress:)];
        [imgView addGestureRecognizer:singleTap1];
        imgView.frame = CGRectMake(imgX, imgY, imgW, imgH);
        [scrollView addSubview:imgView];
    }
    
    CGFloat maxW = imgW * self.teacher_pic_group.count + 20;
    scrollView.contentSize = CGSizeMake(maxW, 0);
    scrollView.pagingEnabled = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [teachAlbumLbl addSubview:scrollView];
    
    CGFloat maxH =  CGRectGetMaxY(teachAlbumLbl.frame) + 300;
    _scrollV.contentSize = CGSizeMake(0, maxH);
    
}



-(void)buttonpress:(UIButton *)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    int tag = tap.view.tag;
    UIImageView *imgView = [[UIImageView alloc] init];
    [imgView sd_setImageWithURL:[NSURL URLWithString:_picImageArr[tag]] placeholderImage:nil];
    [SJAvatarBrowser showImage:imgView];//调用方法
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end





//
//  SpeechViewController.m
//  XingXingEdu
//
//  Created by Mac on 16/5/9.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "SpeechViewController.h"
#import "HHControl.h"
#import "StarRemarkViewController.h"

#define kScreenWidth self.view.frame.size.width
#define kScreenHeight self.view.frame.size.height
#define Space 10

@interface SpeechViewController ()
{
    NSString *parameterXid;
    NSString *parameterUser_Id;
}
@property (nonatomic) UIImageView *backgroundImageView;
@property (nonatomic) UIImageView *iconImageView;
@property (nonatomic, strong) MBProgressHUD *HUDSave;


//LOGO  图标
@property (nonatomic ,copy) NSString *logoIconStr;
//学校名称
@property (nonatomic, copy) NSString *schoolNameStr;
//评分
@property (nonatomic, copy) NSString *score_num;
//浏览
@property (nonatomic, copy) NSString *read_num;
//收藏
@property (nonatomic, copy) NSString *collect_num;
//校长致辞
@property (nonatomic, copy) NSString *pdt_speech;

//校长 头像
@property (nonatomic, copy) NSString * head_img;


@end

@implementation SpeechViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    [self fetchNetData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);

    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0, 170, 42)];
    self.navigationController.navigationBar.translucent = NO;
    
    [self settingNavgiationBar];
    
}

- (void)settingNavgiationBar{

    //1、设置 navigationBar 左边 返回
    UIImage *backImage = [UIImage imageNamed:@"首页90x38"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage: backImage  style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    
    //    2、设置 navigationBar 标题 颜色
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    
//    //3、设置 navigationBar 右边 收藏
//    UIButton *saveButton = [HHControl createButtonWithFrame:CGRectMake(kScreenWidth - 100, 0, 22, 22) backGruondImageName:@"收藏icon44x44" Target:self Action:@selector(saveButtonClick:) Title:nil];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
//    self.navigationItem.rightBarButtonItem = rightItem;

}

- (void)fetchNetData{
    /*
     接口:
     http://www.xingxingedu.cn/Global/xkt_school_detail
     传参:
     school_id		//学校id
     */
    
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/xkt_school_detail";
    
    //请求参数
    //获取学校id数组
    NSString *schoolIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"SCHOOL_ID"];
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"school_id":schoolIdStr};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
//                NSLog(@"=================%@", responseObj);
        NSDictionary *dic = responseObj[@"data"];
        //LOGO 图标
        _logoIconStr = dic[@"logo"];
        //学校 名称
        _schoolNameStr = dic[@"name"];
        //评分
        _score_num = dic[@"score_num"];
        //浏览
        _read_num = dic[@"read_num"];
        //收藏
        _collect_num = dic[@"collect_num"];
        
        //校长致辞
        _pdt_speech = dic[@"pdt_speech"];
        
      /*
       "president_head_img" = "";
       "president_head_img_type" = "";
       */
        //校长 头像 类型
        NSString *head_img_type = dic[@"president_head_img_type"];
        
        //头像
        //判断是否是第三方头像
        //    0 :表示 自己 头像 ，需要添加 前缀
        //    1 :表示 第三方 头像 ，不需要 添加 前缀

        if([[NSString stringWithFormat:@"%@",head_img_type]isEqualToString:@"0"]){
            _head_img=[picURL stringByAppendingString:dic[@"president_head_img"]];
        }else{
            _head_img=dic[@"president_head_img"];
        }


        [self createImageView];
        
        
        if ([_pdt_speech isEqualToString:@""]) {
            // 1、无数据的时候
            UIImage *myImage = [UIImage imageNamed:@"人物"];
            CGFloat myImageWidth = myImage.size.width;
            CGFloat myImageHeight = myImage.size.height;
            
            UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - myImageWidth / 2, kHeight / 2, myImageWidth, myImageHeight)];
            myImageView.image = myImage;
            [self.view addSubview:myImageView];
            
        }else{
            
        [self createContentImageView];
            
        }
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];
    
}



- (void)starRankButtonClick{
    
    if ([XXEUserInfo user].login) {
        StarRemarkViewController *starRemarkVC = [[StarRemarkViewController alloc] init];
        starRemarkVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:starRemarkVC animated:YES];
        
    }else{
        [SVProgressHUD showInfoWithStatus:@"请用账号登录后查看"];
    }
}


- (void)createImageView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120 * kWidth / 375)];
    headView.backgroundColor = UIColorFromRGB(0, 170, 42);
    
    //设置头像
    CGFloat iconWidth = 87.0 * kWidth / 375;
    CGFloat iconHeight = 87.0 * kWidth / 375;
    
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.frame = CGRectMake(iconWidth / 4, headView.frame.size.height / 2 - iconHeight / 2, iconWidth, iconHeight);
    //    _iconImageView.image = [UIImage imageNamed:@"头像174x174@2x.png"];
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picURL, _logoIconStr]] placeholderImage:[UIImage imageNamed:@"头像174x174"]];
    
    _iconImageView.layer.cornerRadius = iconWidth / 2;
    _iconImageView.layer.masksToBounds = YES;
    
    [headView addSubview:_iconImageView];
    
    //设置头像右边文字
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconWidth * 1.4, headView.frame.size.height / 2 - iconHeight / 2, 150 * kWidth / 375, 30 * kWidth / 375)];
    //    titleLabel.text = @"北京大学";
    titleLabel.text = _schoolNameStr;
    titleLabel.font = [UIFont systemFontOfSize:16 * kWidth / 375];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [headView addSubview:titleLabel];
    
    //星级评分
    UIButton *starRankButton = [UIButton buttonWithType:UIButtonTypeCustom];
    starRankButton.frame = CGRectMake(iconWidth * 1.4, headView.frame.size.height / 2 - iconHeight / 2 + 30 * kWidth / 375, 100 * kWidth / 375, 40 * kWidth / 375);
    starRankButton.backgroundColor = [UIColor clearColor];
    
    NSString *str1 = _score_num;
    [starRankButton setTitle:[NSString stringWithFormat:@"星级评分:%.2f", str1.floatValue] forState:UIControlStateNormal];
    [starRankButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [starRankButton addTarget:self action:@selector(starRankButtonClick) forControlEvents:UIControlEventTouchUpInside];
    starRankButton.titleLabel.font = [UIFont boldSystemFontOfSize:14 * kWidth / 375];
    starRankButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [headView addSubview:starRankButton];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 30 * kWidth / 375, 95 * kWidth / 375, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [starRankButton addSubview:lineView];
    
    
    //浏览
    UILabel *browseLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconWidth * 1.4 + 100, headView.frame.size.height / 2 - iconHeight / 2 + 40 * kWidth / 375, 80 * kWidth / 375, 20 * kWidth / 375)];
    browseLabel.backgroundColor = [UIColor clearColor];
    NSString *str2 = _read_num;
    browseLabel.text = [NSString stringWithFormat:@"浏览:%@", str2];
    browseLabel.textColor = [UIColor whiteColor];
    browseLabel.font = [UIFont boldSystemFontOfSize:14 * kWidth / 375];
    [headView addSubview:browseLabel];
    
    
    //收藏
    UILabel *collectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconWidth * 1.4 + 100 * kWidth / 375 + 80 * kWidth / 375, headView.frame.size.height / 2 - iconHeight / 2 + 40 * kWidth / 375, 100 * kWidth / 375, 20 * kWidth / 375)];
    collectionLabel.backgroundColor = [UIColor clearColor];
    NSString *str3 = _collect_num;
    collectionLabel.text = [NSString stringWithFormat:@"收藏:%@", str3];
    collectionLabel.textColor = [UIColor whiteColor];
    collectionLabel.font = [UIFont boldSystemFontOfSize:14 * kWidth / 375];
    
    [headView addSubview:collectionLabel];
    
    [self.view addSubview:headView];
}

- (void)createContentImageView{
    UIImageView *contentView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 120 * kWidth / 375 + 5, kWidth - 10, kHeight - 10)];
    contentView.userInteractionEnabled = YES;
    contentView.backgroundColor = [UIColor whiteColor];
    CGFloat contentViewWidth = contentView.frame.size.width;
    CGFloat contentViewHeight = contentView.frame.size.height;
    
    //校长头像
  
    UIImageView *headmasterIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - 60 / 2,15, 60, 60)];
    
    headmasterIconImageView.layer.cornerRadius = headmasterIconImageView.frame.size.width / 2;
    headmasterIconImageView.layer.masksToBounds = YES;
    
    [headmasterIconImageView sd_setImageWithURL:[NSURL URLWithString:_head_img] placeholderImage:[UIImage imageNamed:@"校长头像(1)118x118"]];
    
//    headmasterIconImageView.image = headmasterIconImage;
    [contentView addSubview:headmasterIconImageView];
    
    //文字
    UITextView *myTextView = [[UITextView alloc] initWithFrame:CGRectMake(0,15 + 59 +10, kWidth - 5 * 2, contentViewHeight - 59 - 200)];
    myTextView.text = _pdt_speech;
//    myTextView.scrollEnabled = YES;
    myTextView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:myTextView];
    
    [self.view addSubview:contentView];

}


//返回
- (void)backClick{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

////收藏
//- (void)saveButtonClick:(UIButton *)saveBtn{
//    self.HUDSave = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:self.HUDSave];
//    if (saveBtn.selected) {
//        saveBtn.selected = NO;
//        self.HUDSave.dimBackground = YES;
//        [saveBtn setBackgroundImage:[UIImage imageNamed:@"收藏icon44x44"] forState:UIControlStateNormal];
//        self.HUDSave.labelText = @"取消收藏";
//        [self.HUDSave showAnimated:YES whileExecutingBlock:^{
//            sleep(1);
//        } completionBlock:^{
//            [self.HUDSave removeFromSuperview];
//            self.HUDSave = nil;
//        }];
//    }else{
//        saveBtn.selected = YES;
//        self.HUDSave.dimBackground = YES;
//        [saveBtn setBackgroundImage:[UIImage imageNamed:@"收藏(H)icon44x44"] forState:UIControlStateNormal];
//        self.HUDSave.labelText = @"已收藏";
//        [self.HUDSave showAnimated:YES whileExecutingBlock:^{
//            sleep(1);
//        } completionBlock:^{
//            [self.HUDSave removeFromSuperview];
//            self.HUDSave = nil;
//        }];
//        
//    }
//    
//}



@end

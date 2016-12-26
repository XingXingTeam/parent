

//
//  XXEXingCommunityBabyLibraryViewController.m
//  teacher
//
//  Created by Mac on 16/9/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEXingCommunityBabyLibraryViewController.h"
//儿歌
#import "XXEXingCommunityChildrenSongViewController.h"
//故事
#import "XXEXingCommunityStoryViewController.h"
//美食
#import "XXEXingCommunityCookingViewController.h"
//游戏
#import "XXEXingCommunityPlayViewController.h"
//咨询
#import "XXEXingCommunityConsultViewController.h"
//英语
#import "XXEXingCommunityEnglishViewController.h"

@interface XXEXingCommunityBabyLibraryViewController ()
{

    //上部 背景 图片
    UIView *upBgView;
    //上部 六宫格
    CGFloat buttonWidth;
    CGFloat buttonHeight;
    
    //按钮 图片 数组
    NSMutableArray *iconArray;
    //按钮 标题 数组
    NSMutableArray *titleArray;
    
    //竖向  分割线
    UIView *verticalLineView;
    //横向 分割线
    UIView *horizontalLineView;

    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}


@end

@implementation XXEXingCommunityBabyLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    self.edgesForExtendedLayout=UIRectEdgeNone;
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    iconArray = [[NSMutableArray alloc] initWithObjects:@"ergeicon", @"gushiicon", @"meishiicon", @"youxiicon", @"zixunicon", @"yingyuicon", nil];
    titleArray = [[NSMutableArray alloc] initWithObjects:@"儿歌", @"故事", @"美食", @"游戏", @"咨询", @"英语", nil];
    
    [self createContentView];
}

#pragma mark ======= 创建 内容 =========
- (void)createContentView{

    //创建 十二宫格  三行、四列
    buttonWidth = KScreenWidth / 3;
    buttonHeight = buttonWidth;
    
    upBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, buttonHeight * 2)];
    upBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:upBgView];
    
    
    for (int i = 0; i < 6; i++) {
        
        //行
        int buttonRow = i / 3;
        
        //列
        int buttonLine = i % 3;
        
        CGFloat buttonX = buttonWidth * buttonLine;
        CGFloat buttonY = buttonHeight * buttonRow;
        
        UIButton *button = [HHControl createButtonWithFrame:CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight) backGruondImageName:@"" Target:self Action:@selector(buttonClick:) Title:titleArray[i]];
        [button setImage:[UIImage imageNamed:iconArray[i]] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(-20 * kScreenRatioWidth, 20 * kScreenRatioWidth, 20 * kScreenRatioWidth, -20 * kScreenRatioWidth);
        button.titleEdgeInsets = UIEdgeInsetsMake(30 * kScreenRatioWidth, -30 * kScreenRatioWidth, -30 * kScreenRatioWidth, 30 * kScreenRatioWidth);
        button.tag = 500 + i;
        [upBgView addSubview:button];
        
        //创建 四条 竖向 分割线
        if (i != 2 || i != 5) {
            UIView *line1 = [[UIView alloc] init];
            line1.backgroundColor = UIColorFromRGB(213, 214, 221);;
            line1.frame = CGRectMake(buttonX + buttonWidth, buttonY + (buttonHeight - 100 * kScreenRatioWidth) / 2, 1, 100 * kScreenRatioWidth);
            [upBgView addSubview:line1];
        }
        
        //创建 三条 横向 分割线
        if (i >= 0 && i <= 2) {
            UIView *line2 = [[UIView alloc] init];
            line2.backgroundColor = UIColorFromRGB(213, 214, 221);
            line2.frame = CGRectMake(buttonX + (buttonWidth - 100 * kScreenRatioWidth) / 2, buttonY + buttonHeight, 100 * kScreenRatioWidth, 1);
            [upBgView addSubview:line2];
        }
        
    }
}


- (void)buttonClick:(UIButton *)button{

    if (button.tag == 500) {
        //儿歌
//        NSLog(@"儿歌");
        XXEXingCommunityChildrenSongViewController *childrenSongVC = [[XXEXingCommunityChildrenSongViewController alloc] init];
        [self.navigationController pushViewController:childrenSongVC animated:YES];
        
    }else if (button.tag == 501){
        //故事
//        NSLog(@"故事");
        XXEXingCommunityStoryViewController *storyVC = [[XXEXingCommunityStoryViewController alloc] init];
        [self.navigationController pushViewController:storyVC animated:YES];
    }else if (button.tag == 502){
        //美食
//        NSLog(@"美食");
        XXEXingCommunityCookingViewController *cookingVC = [[XXEXingCommunityCookingViewController alloc] init];
        [self.navigationController pushViewController:cookingVC animated:YES];
    }else if (button.tag == 503){
        //游戏
//        NSLog(@"游戏");
        XXEXingCommunityPlayViewController *playVC = [[XXEXingCommunityPlayViewController alloc] init];
        [self.navigationController pushViewController:playVC animated:YES];
    }else if (button.tag == 504){
        //咨询
//        NSLog(@"咨询");
        XXEXingCommunityConsultViewController *consultVC = [[XXEXingCommunityConsultViewController alloc] init];
        [self.navigationController pushViewController:consultVC animated:YES];
    }else if (button.tag == 505){
        //英语
//        NSLog(@"英语");
        XXEXingCommunityEnglishViewController *EnglishVC = [[XXEXingCommunityEnglishViewController alloc] init];
        [self.navigationController pushViewController:EnglishVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

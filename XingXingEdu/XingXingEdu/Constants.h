//
//  Constants.h
//  XingXingEdu
//
//  Created by keenteam on 16/1/14.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#ifndef Constants_h
#define Constants_h
//屏幕宽度
#define kWidth [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define kHeight [UIScreen mainScreen].bounds.size.height
//rgb颜色转换
#define UIColorFromRGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
//16>10
#define UIColorFromHex(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]
//rgb颜色转换
#define is_IOS_7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#endif /* Constants_h */

#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

<<<<<<< HEAD
#define kScreenRatioHeight  WinHeight/667
#define kScreenRatioWidth  WinWidth/375
=======
#define kScreenRatioHeight  WinWidth/667
#define kScreenRatioWidth  WinHeight/375
>>>>>>> 635d5bd74bcb23068c8e23776c53bc63c206b6fc


#define W(x) WinWidth*(x)/375.0
#define H(y) WinHeight*(y)/667.0

#define XID  @"18884982"
#define APPKEY  @"U3k8Dgj7e934bh5Y"
#define BACKTYPE @"json"
#define USER_ID  @"1"
#define USER_TYPE @"1"
#define MyRongCloudAppKey @"4z3hlwrv3t0dt"


#define DEFAULTS [NSUserDefaults standardUserDefaults]

#define UMSocialAppKey @"57c01a13f43e48118e000e55"

#define kXXEPicURL @"http://www.xingxingedu.cn/Public/"

/**
 *  第一次启动App的Key
 */
#define kAppFirstLoadKey @"kAppFirstLoadKey"

#define XXEBackgroundColor [[UIColor colorWithRed:229.0/255.0f green:232.0/255.0f blue:233.0/255.0f alpha:1]]

/**
 *  颜色:粉红色
 */
#define kPinkColor [UIColor colorWithRed:232.0/255.0f green:154.0/255.0f blue:190.0/255.0f alpha:1]

/**
 *  颜色:草绿色
 */
#define kGreenColor [UIColor colorWithRed:17.0/255.0f green:195.0/255.0f blue:110.0/255.0f alpha:1]
/**
 *  颜色:Naples黄
 */
#define kNaplesYellow [UIColor colorWithRed:242.0/255.0f green:216.0/255.0f blue:143.0/255.0f alpha:1]

/**
 *  颜色:薄荷绿
 */
#define kMintGreen [UIColor colorWithRed:102.0/255.0f green:249.0/255.0f blue:207.0/255.0f alpha:1]
/**
 *  颜色:墨绿色
 */
#define kGrassGreen [UIColor colorWithRed:0.0/255.0f green:87.0/255.0f blue:55.0/255.0f alpha:1]

/**
 *  颜色:亮黄色
 */
#define kOrangeColor [UIColor colorWithRed:239.0/255.0f green:179.0/255.0f blue:54.0/255.0f alpha:1]

//#define MyRongCloudToken @"J01ZcEH+xvE3J2RDgjjdyiMfl6Wang6DqF0T9GLD+MJT6ja2L/UbbLGcZwTxRBRK2HjnDGlqqy5Egm7zF/Z7lg=="


//图片地址
#define picURL    @"http://www.xingxingedu.cn/Public/"



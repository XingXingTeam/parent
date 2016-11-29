//
//  SubjectInfoViewController.h
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/1/28.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ReturnTextBlock) (NSString *classText);

@interface SubjectInfoViewController : UIViewController
@property (nonatomic, assign)NSUInteger ClassTag;
@property (nonatomic, copy)NSString *className;
@property (nonatomic, copy)NSString *classInfo;
@property (nonatomic, copy)NSString *weekStr;

@property (nonatomic, retain)NSMutableArray *detailMArr;

@property (nonatomic, copy)ReturnTextBlock returnTextBlock;

- (void)returnText:(ReturnTextBlock)block;
@end

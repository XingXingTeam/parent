//
//  WZYCommentViewController.h
//  XingXingEdu
//
//  Created by Mac on 16/6/2.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnCommentNameBlock)(NSString *text);

typedef void (^ReturnCommentIconBlock)(NSString *iconStr);

@interface WZYCommentViewController : UIViewController

@property(nonatomic,assign)NSInteger tag;
@property(nonatomic,assign)BOOL  isFlowerView;
@property(nonatomic,assign)BOOL  isRCIM;
@property(nonatomic,assign)BOOL  isComment;

@property (nonatomic, copy)ReturnCommentNameBlock returnCommentNameBlock;

@property (nonatomic, copy)ReturnCommentIconBlock returnCommentIconBlock;

- (void)returnText:(ReturnCommentNameBlock)block;
- (void)returnIcon:(ReturnCommentIconBlock)block;


@end

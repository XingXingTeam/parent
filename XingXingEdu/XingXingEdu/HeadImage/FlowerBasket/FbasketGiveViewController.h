//
//  FbasketGiveViewController.h
//  XingXingEdu
//
//  Created by keenteam on 16/6/6.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnTextBlock)(NSString *text);

typedef void (^ReturnIDBlock)(NSString *text);
@interface FbasketGiveViewController : UIViewController

@property (nonatomic, copy)ReturnTextBlock textblock;
@property (nonatomic, copy)ReturnIDBlock idblock;
@property(nonatomic,assign)NSInteger tag;
@property(nonatomic,assign)BOOL  isFlowerView;
@property(nonatomic,assign)BOOL  isRCIM;
@property(nonatomic,assign)BOOL  isComment;
- (void)ReturnTextBlock:(ReturnTextBlock)block;
- (void)ReturnIDBlock:(ReturnIDBlock)block;
@end

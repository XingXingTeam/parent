//
//  ClassTelephoneViewController.h
//  XingXingEdu
//
//  Created by keenteam on 16/1/18.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnTextBlock)(NSString *text);

@interface ClassTelephoneViewController : UIViewController

@property (nonatomic, copy)ReturnTextBlock textblock;
@property(nonatomic,assign)NSInteger tag;
@property(nonatomic,assign)BOOL  isFlowerView;
@property(nonatomic,assign)BOOL  isRCIM;
@property(nonatomic,assign)BOOL  isComment;
- (void)ReturnTextBlock:(ReturnTextBlock)block;
@end

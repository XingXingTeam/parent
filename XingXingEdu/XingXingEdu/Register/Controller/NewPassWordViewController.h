//
//  newPassWardViewController.h

//  Created by codeDing on 16/1/16.
//  Copyright © 2016年 codeDing. All rights reserved.
//
#import <UIKit/UIKit.h>
@class  login;
@interface NewPassWordViewController : UIViewController
@property(nonatomic,strong)NSMutableDictionary* dict;
@property(nonatomic,copy) login *logininfo;

//从a传值到b  属性必须定义在.h文件中
@property(nonatomic,strong)NSString *userPhone;
@end

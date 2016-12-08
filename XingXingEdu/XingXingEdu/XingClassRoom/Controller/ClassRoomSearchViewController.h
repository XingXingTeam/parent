//
//  ClassRoomSearchViewController.h
//  XingXingStore
//
//  Created by codeDing on 16/2/3.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassRoomSearchViewController : UIViewController
@property(nonatomic,strong) NSArray *relationArray;//下拉选择框
@property (nonatomic,strong) UIView *comBackView;


@property (weak, nonatomic) IBOutlet UIImageView *hotBgView;

@end

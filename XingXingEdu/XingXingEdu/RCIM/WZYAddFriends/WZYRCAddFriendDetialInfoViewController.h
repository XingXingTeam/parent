//
//  WZYRCAddFriendDetialInfoViewController.h
//  XingXingEdu
//
//  Created by Mac on 16/7/15.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZYRCAddFriendDetialInfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (nonatomic, copy) NSString *nicknameStr;
@property (nonatomic, copy) NSString *iconStr;
@property (nonatomic, copy) NSString *xidStr;


@end

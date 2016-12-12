//
//  XXESystemNotificationDetailViewController.h
//  teacher
//
//  Created by Mac on 16/9/13.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXESystemNotificationDetailViewController : XXEBaseViewController

//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//
//@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//
//@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *content;

@property (nonatomic , copy) NSString *titleStr;

@end

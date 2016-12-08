//
//  RCAddFriendInfoViewController.h
//  XingXingEdu
//
//  Created by codeDing on 16/4/3.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCAddFriendInfoViewController : UIViewController
//头像
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

//请求者名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

//来源
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;

//请求者 内容
@property (weak, nonatomic) IBOutlet UILabel *requestContentLabel;


//被请求者回复

@property (nonatomic, copy) NSString *iconStr;
@property (nonatomic, copy) NSString *nicknameStr;



- (IBAction)recordbtn:(id)sender;
- (IBAction)passbtn:(id)sender;
- (IBAction)toblackbtn:(id)sender;
- (IBAction)complaintbtn:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *replyLabel;

@property (weak, nonatomic) IBOutlet UILabel *replyInfoLabel;





@end

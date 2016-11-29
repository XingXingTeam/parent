//
//  ClassRoomOrderDidAppraiseViewController.h
//  XingXingEdu
//
//  Created by codeDing on 16/5/16.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassRoomOrderDidAppraiseViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIImageView *imgview1;
@property (weak, nonatomic) IBOutlet UIImageView *imgview2;
@property (weak, nonatomic) IBOutlet UIImageView *imgview3;
@property (weak, nonatomic) IBOutlet UIImageView *imgview4;
@property (weak, nonatomic) IBOutlet UITextView *appraiseCon;

@property(nonatomic,copy)NSString *comment_id;

@end

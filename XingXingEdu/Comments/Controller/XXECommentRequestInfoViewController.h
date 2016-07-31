//
//  XXECommentRequestInfoViewController.h
//  XingXingEdu
//
//  Created by Mac on 16/7/29.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXECommentRequestInfoViewController : UIViewController


//1 老师 名称
@property(nonatomic,copy)NSString * tnameStr;
//2 所教 课程
@property(nonatomic,copy)NSString * teach_courseStr;

//3 请求评价
@property(nonatomic,copy)NSString * ask_conStr;
//4 评价回复
@property(nonatomic,copy)NSString * com_conStr;
//5 请求 评论时间
@property(nonatomic,copy)NSString * ask_tmStr;
//6 是否收藏过
@property(nonatomic,copy)NSString * collect_conditStr;
//7 点评 id
@property(nonatomic,copy)NSString * commentIdStr;

// 9评价 图片
@property(nonatomic,copy)NSString * com_picStr;
//10 老师 id
@property(nonatomic,copy)NSString * tuser_idStr;



@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property (weak, nonatomic) IBOutlet UITextView *requestContentTextView;


- (IBAction)commentHistoryButton:(id)sender;

- (IBAction)deleteButton:(id)sender;



@end

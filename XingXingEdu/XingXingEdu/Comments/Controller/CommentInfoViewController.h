//
//  CommentInfoViewController.h
//  XingXingStore
//
//  Created by codeDing on 16/2/16.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface CommentInfoViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *teacherNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *requestContentTextView;
@property (weak, nonatomic) IBOutlet UITextView *replyContentTextView;


@property (weak, nonatomic) IBOutlet UIView *PicView;

@property (nonatomic, copy) NSString *flagStr;


//@property(nonatomic ,strong)NSString * teacherName;
//@property(nonatomic ,strong)NSString * requestContent;
//@property(nonatomic ,strong)NSString * replyContent;


@property(nonatomic ,strong)NSIndexPath *indexpath;
@property(nonatomic ,strong)NSString * collectLabel;

/*
 //数组中 0：头像 1：老师名称 2：所教课程 3：请求评价 4：回复评价内容 5：时间 6：是否收藏过 7：点评id 8：点评 状态 9：回复点评 图片 10：老师 id
 NSMutableArray *arr=[NSMutableArray arrayWithObjects:head_img, tname, teach_course, ask_con, com_con, date_tm, collect_condit, commentId, condit, com_pic, tuser_id, nil];
 */
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



@property(nonatomic ,assign)BOOL isHistory;


@end

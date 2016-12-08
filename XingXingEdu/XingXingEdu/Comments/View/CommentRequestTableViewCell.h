//
//  CommentRequestTableViewCell.h
//  XingXingStore
//
//  Created by codeDing on 16/2/17.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentRequestTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stateImg;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLael;

@end

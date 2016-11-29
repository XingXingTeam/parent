//
//  KTCommentCell.h
//  XingXingEdu
//
//  Created by keenteam on 16/5/19.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImagV;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;
@property (weak, nonatomic) IBOutlet UIImageView *commentImagV;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@end

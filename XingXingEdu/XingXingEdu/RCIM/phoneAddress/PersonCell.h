//
//  PersonCell.h
//  RCIM
//
//  Created by codeDing on 16/2/26.
//  Copyright © 2016年 codeDing. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import "PersonModel.h"
@class CDFInitialsAvatar;
@interface PersonCell : UITableViewCell
{
    UIImageView *_tximg;
    UILabel  *_txtName;
    UILabel  *_nickName;
    UILabel  *_phoneNum;
}
@property(strong,nonatomic)PersonModel *personDel;
@property(strong,nonatomic)UILabel *youlable;
@property(strong,nonatomic)CDFInitialsAvatar *topAvatar;
-(void)setData:(PersonModel*)personDel;

@end

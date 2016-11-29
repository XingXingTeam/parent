//
//  MoneyHistoryTableViewCell.h
//  XingXingStore
//
//  Created by codeDing on 16/1/21.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoneyHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *useLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property(nonatomic,copy)NSString *use;
@property(nonatomic,copy)NSString *date;
@property(nonatomic,copy)NSString *price;
@end

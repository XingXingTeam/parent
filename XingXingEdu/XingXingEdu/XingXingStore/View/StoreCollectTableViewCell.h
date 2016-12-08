//
//  StoreCollectTableViewCell.h
//  XingXingStore
//
//  Created by codeDing on 16/1/21.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreCollectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *articleImageView;
@property (weak, nonatomic) IBOutlet UILabel *articleName;
@property (weak, nonatomic) IBOutlet UILabel *articlePrice;
@property (weak, nonatomic) IBOutlet UILabel *articleDate;


@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *date;
@property(nonatomic,copy)NSString *img;
@property(nonatomic,copy)NSString *price;
@end

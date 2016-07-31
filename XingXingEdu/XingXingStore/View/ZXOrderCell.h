//
//  ZXOrderCell.h
//  XingXingStore
//
//  Created by codeDing on 16/3/2.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZXOrderModel;

@interface ZXOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderTypeName;

@property (weak, nonatomic) IBOutlet UILabel *orderIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderXingMoney;

@property (weak, nonatomic) IBOutlet UIImageView *orderImage;

@property (weak, nonatomic) IBOutlet UILabel *orderCondit;
@property (weak, nonatomic) IBOutlet UIView *BgView;
/** 订单模型 */
@property (strong, nonatomic) ZXOrderModel *order;

@end

//
//  AddressTableViewCell.h
//  XingXingStore
//
//  Created by codeDing on 16/1/25.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;
@property (weak, nonatomic) IBOutlet UILabel *defaultLabel;

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *address;

@end

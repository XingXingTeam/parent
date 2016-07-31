//
//  StoreArticleBuyViewController.h
//  XingXingEdu
//
//  Created by codeDing on 16/3/4.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreArticleBuyViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rmbMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *xingMoneyLabel;
@property (weak, nonatomic) IBOutlet UITextField *messageText;

@property (weak, nonatomic) IBOutlet UITextField *billNameText;

@property(nonatomic ,strong)NSMutableArray * addressArray;

@property(nonatomic,copy)NSString *orderNum;
@property(nonatomic,copy)NSString *addressId;

@property(nonatomic,copy)NSString *rmbMoney;
@property(nonatomic,copy)NSString *xingMoney;
@property(nonatomic,copy)NSString *order_id;
@property (nonatomic, copy)NSString *moneyStr;
@property (nonatomic, copy)NSString *flowerBacketStr;
@property (nonatomic, copy)NSString *titleName;
@end

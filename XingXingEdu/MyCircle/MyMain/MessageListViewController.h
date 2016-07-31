//
//  MessageListViewController.h
//  XingXingEdu
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@end

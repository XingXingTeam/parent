//
//  ClassSubjectCell.h
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/2/16.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassSubjectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *classSubjectName;
@property (weak, nonatomic) IBOutlet UILabel *classRoomName;
@property (weak, nonatomic) IBOutlet UILabel *teacherName;
@property (weak, nonatomic) IBOutlet UILabel *remarkName;
@property (weak, nonatomic) IBOutlet UILabel *goTimeHour;
@property (weak, nonatomic) IBOutlet UILabel *stopTimeHour;

@end

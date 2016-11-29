//
//  ClassHomeWorkContentViewController.m
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/6/16.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "ClassHomeWorkContentViewController.h"

@interface ClassHomeWorkContentViewController ()
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation ClassHomeWorkContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"作业内容";
    self.automaticallyAdjustsScrollViewInsets =NO;
    [self initData];
    // Do any additional setup after loading the view from its nib.
}
- (void)initData{
    self.contentTextView.text =self.contentStr;



}


@end

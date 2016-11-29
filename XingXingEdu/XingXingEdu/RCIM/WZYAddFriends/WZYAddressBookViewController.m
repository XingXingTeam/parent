


//
//  WZYAddressBookViewController.m
//  XingXingEdu
//
//  Created by Mac on 16/7/15.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "WZYAddressBookViewController.h"

@interface WZYAddressBookViewController ()




@end

@implementation WZYAddressBookViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _addressBookTemp = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNewAddressBook];
    
}

- (void)createNewAddressBook{


}

@end

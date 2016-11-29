//
//  TermsViewController.m
//  xingxingEdu
//
//  Created by codeDing on 16/1/18.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "TermsViewController.h"
#import "AuthenticationViewController.h"
@interface TermsViewController ()
- (IBAction)determineBtn:(id)sender;

@end

@implementation TermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)determineBtn:(id)sender {
    AuthenticationViewController * auVC=[[AuthenticationViewController alloc]init];
    [self dismissViewControllerAnimated:auVC completion:nil];
}
@end

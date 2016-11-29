//
//  SSVideoPlayContainer.m
//  SSVideoPlayer
//
//  Created by KT on 16/1/22.
//  Copyright © 2016年 KT. All rights reserved.
//

#import "SSVideoPlayContainer.h"

@interface SSVideoPlayContainer ()

@end

@implementation SSVideoPlayContainer

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

@end

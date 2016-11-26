//
//  SchoolVideoPlayViewController.h
//  XingXingEdu
//
//  Created by Mac on 16/5/20.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchoolVideoModel : NSObject

@property (nonatomic,copy) NSString *path;
@property (nonatomic,copy) NSString *name;

@end

@interface SchoolVideoPlayViewController : UIViewController

@property (nonatomic, copy)NSString *urlPath;


- (instancetype)initWithVideoList:(NSArray <SchoolVideoModel *> *)videoList;


@end

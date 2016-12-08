//
//  SSVideoPlayContainer.m
//  SSVideoPlayer
//
//  Created by KT on 16/1/22.
//  Copyright © 2016年 KT. All rights reserved.
//
//

#import <UIKit/UIKit.h>

@interface SSVideoModel : NSObject

@property (nonatomic,copy) NSString *path;
@property (nonatomic,copy) NSString *name;

@end


@interface SSVideoPlayController : UIViewController
@property (nonatomic, copy)NSString *urlPath;


- (instancetype)initWithVideoList:(NSArray <SSVideoModel *> *)videoList;

@end

//
//  DFImagesSendViewController.h
//  DFTimelineView
//
//  Created by Allen Zhong on 16/2/15.
//  Copyright © 2016年 Datafans, Inc. All rights reserved.
//

#import <DFCommon/DFCommon.h>

@protocol DFImagesSendViewControllerDelegate <NSObject>

@optional

-(void)onSendTextImage:(NSString *) text images:(NSArray *)images Location:(NSString *)location PersonSee:(NSString *)personSee;

//定位的地点
- (void)locationMessageText:(NSString *)text;
//给谁看
- (void)xxe_whoCanLookMessage:(NSString *)personLook;


@end
@interface DFImagesSendViewController : DFBaseViewController

@property (nonatomic, weak) id<DFImagesSendViewControllerDelegate> delegate;

- (instancetype)initWithImages:(NSArray *) images;

@end

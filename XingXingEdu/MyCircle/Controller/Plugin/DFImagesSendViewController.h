//
//  DFImagesSendViewController.h
//  DFTimelineView
//
//  Created by keenteam on 16/2/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <DFCommon/DFCommon.h>

@protocol DFImagesSendViewControllerDelegate <NSObject>

@optional

-(void) onSendTextImage:(NSString *) text images:(NSArray *)images;


@end
@interface DFImagesSendViewController : DFBaseViewController

@property (nonatomic, weak) id<DFImagesSendViewControllerDelegate> delegate;

- (instancetype)initWithImages:(NSArray *) images;

@property(nonatomic ,strong)NSArray *imagesArr;

@end

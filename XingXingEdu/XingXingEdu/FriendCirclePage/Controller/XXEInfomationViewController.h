//
//  XXEInfomationViewController.h
//  teacher
//
//  Created by codeDing on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"
@class XXECircleModel;

typedef void(^XXEInfomationViewControllerDeteleModel)(XXECircleModel *, NSString *);

@class XXECircleModel;

@protocol  XXEInfomationViewControllerDelegate<NSObject>

- (void)onLike;
- (void)onComment;

@end

@interface XXEInfomationViewController : XXEBaseViewController
@property (nonatomic, assign)long ts;
@property (nonatomic,copy) NSString *itemId;
@property (nonatomic,copy) NSString *conText;
@property (nonatomic, copy) NSString *imagesArr;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSArray *goodArr;
@property (nonatomic, weak) id<XXEInfomationViewControllerDelegate> delegate;

@property (nonatomic, copy) XXEInfomationViewControllerDeteleModel deteleModelBlock;
/** 直接传每一个说说的Model */
@property (nonatomic, strong)XXECircleModel *infoCircleModel;

/** 删除需要判断XID是否一样 */
@property (nonatomic, assign)NSInteger deleteOtherXid;

@end

//
//  UserInformationViewController.h
//  XingXingEdu
//
//  Created by keenteam on 16/4/8.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserInformationViewControllerDelegate <NSObject>

@required
-(void) onLike;
-(void) onComment;
@end

@interface UserInformationViewController : UIViewController
@property (nonatomic, assign) long  ts;
//id
@property (nonatomic,copy) NSString *itemId;
@property (nonatomic,copy) NSString *conText;
@property (nonatomic, strong) NSMutableArray *imagesArr;
@property (nonatomic, strong) NSMutableArray *goodArr;
@property (nonatomic, weak) id<UserInformationViewControllerDelegate> delegate;

@end

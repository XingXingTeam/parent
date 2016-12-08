//
//  PersonModel.h
//  RCIM
//
//  Created by codeDing on 16/2/26.
//  Copyright © 2016年 codeDing. All rights reserved.
//
//

#import <Foundation/Foundation.h>

@interface PersonModel : NSObject
@property (nonatomic,copy) NSString *firstName;
@property (nonatomic,copy) NSString *lastName;
@property (nonatomic,copy) NSString *name1;
@property (nonatomic,copy) NSString *phoneNumber;
@property(nonatomic,copy)  NSString *phonename;
@property(nonatomic,copy)  NSString *friendId;
@property NSInteger sectionNumber;
@property NSInteger recordID;
@property BOOL rowSelected;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *tel;
@property(nonatomic, strong) NSData *icon;//图片
@end

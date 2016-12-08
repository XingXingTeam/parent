//
//  SchoolRecipeInfoViewController.h
//  XingXingEdu
//
//  Created by keenteam on 16/5/9.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchoolRecipeInfoViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *mealPicDataSource;
@property (nonatomic, assign)NSInteger i;
@property (nonatomic, copy)NSString *detailStr;
@property (nonatomic, copy) NSString *contentStr;

@end

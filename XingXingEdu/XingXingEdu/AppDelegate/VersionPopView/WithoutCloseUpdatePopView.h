//
//  WithoutCloseUpdatePopView.h
//  teacher
//
//  Created by codeDing on 16/12/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^UpdateClickAction)();
@interface WithoutCloseUpdatePopView : UIView
@property(nonatomic ,strong) UIButton *updateBtn;
@property(nonatomic ,strong) UILabel *versionLbl;
@property(nonatomic ,copy) UpdateClickAction updateClickAction;//立即更新按钮

+ (WithoutCloseUpdatePopView *)convenicenWithTitle:(NSString *)versionText;

- (void)clickUpdateBtn:(UpdateClickAction)block;

@end

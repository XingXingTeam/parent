//
//  UpdatePopView.h
//  teacher
//
//  Created by codeDing on 16/12/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

typedef void(^UpdateClickAction)();
#import <UIKit/UIKit.h>
@interface UpdatePopView : UIView
@property(nonatomic ,strong) UIButton *updateBtn;
@property(nonatomic ,strong) UILabel *versionLbl;
@property(nonatomic ,copy) UpdateClickAction updateClickAction;//立即更新按钮
//@property(nonatomic ,weak) UpdateClickAction dissmisPopViewTapAction;//dismis提示框

+ (UpdatePopView *)convenicenWithTitle:(NSString *)versionText;

- (void)clickUpdateBtn:(UpdateClickAction)block;

- (void)dissmispopView;
@end

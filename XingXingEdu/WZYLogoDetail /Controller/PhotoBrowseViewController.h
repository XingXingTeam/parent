//
//  PhotoBrowseViewController.h
//  XingXingEdu
//
//  Created by Mac on 16/5/11.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoBrowseViewController : UIViewController


////待显示的图片数组
//@property(nonatomic)NSMutableArray *photoArray;
//
////当前选中的次序
//@property(nonatomic)NSInteger currentSelectIndex;
//

@property (nonatomic, copy)NSString *imageName;
@property (nonatomic, assign)NSInteger i;
@property (nonatomic, assign)NSInteger index;
@property (nonatomic, assign)NSMutableArray *imageA;

@property (nonatomic, strong) NSMutableArray *goodNMArr;

@property (nonatomic, strong) NSMutableArray *idMArr;


@end

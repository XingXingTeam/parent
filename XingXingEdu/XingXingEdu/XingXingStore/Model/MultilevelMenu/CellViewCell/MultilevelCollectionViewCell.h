
//
//  MultilevelCollectionViewCell.h
//  MultilevelMenu
//
//  Created by gitBurning on 15/3/13.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MultileveModel;
@interface MultilevelCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)MultileveModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titile;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *sale_num;
@property (weak, nonatomic) IBOutlet NSString *ID;
@end

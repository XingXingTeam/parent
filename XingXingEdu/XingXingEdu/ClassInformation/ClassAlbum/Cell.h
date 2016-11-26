//
//  Cell.h
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/1/20.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellDelegate <NSObject>


@end

@interface Cell : UICollectionViewCell
{
    UIImageView *_imageview;
    UIButton *_deleteBtn;
    
}

@property (nonatomic,readonly)UIImageView *imageview;
@property (nonatomic,strong)UIButton *deleteBtn;
@end

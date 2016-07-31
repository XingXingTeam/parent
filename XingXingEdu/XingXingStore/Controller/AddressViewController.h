//
//  AddressViewController.h
//  XingXingStore
//
//  Created by codeDing on 16/1/25.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol selectAddreseeIdDelegate <NSObject>

- (void)sendAddressArray:(NSArray *)array;

@end
@interface AddressViewController : UIViewController

@property(nonatomic ,strong)NSMutableArray * addressArray;
@property(nonatomic ,assign)BOOL isBuy;

@property (nonatomic,assign) id<selectAddreseeIdDelegate> delegate;


@end

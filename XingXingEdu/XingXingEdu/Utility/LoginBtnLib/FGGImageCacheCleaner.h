//
//  FGGImageCacheCleaner.h
//
//  Created by kt-.- on 15/6/26.
//  Copyright (c) 2015年 keenteam-.-. All rights reserved.
//
/**
 用于计算、和清除SDWebImage缓存的类。
 用法：
 ==>>计算缓存:
 [[FGGImageCacheCleaner currentCleaner] caculateCacheSize];
 返回的是NSString (缓存大小xx B，缓存大小xx kB， 缓存大小xx M ，缓存大小xx G)
 ==>>清除缓存:
 [[FGGImageCacheCleaner currentCleaner] clearImageCache];
 清除缓存后，请再次使用计算缓存的方法，更新界面上缓存大小的显示。
 [[FGGImageCacheCleaner currentCleaner] caculateCacheSize];
 */

#import <Foundation/Foundation.h>
/**清除SDWebImageCache图片缓存的类*/
@interface FGGImageCacheCleaner : NSObject

@property(nonatomic,strong)NSString *imageCachePath;

/**单例类*/
+(instancetype)currentCleaner;

/**清除缓存*/
-(void)clearImageCache;

/**计算缓存大小*/
-(NSString *)caculateCacheSize;

@end

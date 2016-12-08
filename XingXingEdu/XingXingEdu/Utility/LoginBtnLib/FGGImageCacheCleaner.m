//
//  FGGImageCacheCleaner.m
//
//  Created by kt-.- on 15/6/26.
//  Copyright (c) 2015年 keenteam-.-. All rights reserved.
//


#import "FGGImageCacheCleaner.h"

@implementation FGGImageCacheCleaner

-(instancetype)init
{
    if(self=[super init])
    {
//        获取Library目录
        NSString *libraryPath=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
//            获取SDWebImageCache的图片缓存目录
        NSLog(@"~~~~~~~%@",libraryPath);
        self.imageCachePath=[libraryPath stringByAppendingPathComponent:@"Caches/com.hackemist.SDWebImageCache.default"];
    }
    return self;
}

/**获取单列类*/
+(instancetype)currentCleaner
{
    static FGGImageCacheCleaner *cleaner=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cleaner=[[FGGImageCacheCleaner alloc] init];
    });
    return cleaner;
}

/**计算缓存大小*/
-(NSString *)caculateCacheSize
{
    NSFileManager *mgr=[NSFileManager defaultManager];
    //            判断路径是否存在
    BOOL exist=[mgr fileExistsAtPath:_imageCachePath];
    if(exist)
    {
        //        用于累计缓存图片总大小
        NSInteger totalSize=0;
        //        列出图片缓存文件夹下的所有图片
        NSArray *imageArray=[mgr contentsOfDirectoryAtPath:_imageCachePath error:nil];
        if(imageArray.count>0)
        {
            for(NSString *fileName in imageArray)
            {
                NSString *fullPath=[_imageCachePath stringByAppendingPathComponent:fileName];
    //            判断是否存在
                exist=[mgr fileExistsAtPath:fullPath];
                if(exist)
                {
                    //                 计算大小
                    NSDictionary *attributesDict=[mgr attributesOfItemAtPath:fullPath error:nil];
//                    byte为单位
                    NSString *fileSize=attributesDict[NSFileSize];
                    totalSize+=fileSize.integerValue;
                }
            }
        }
        return [self convertSize:totalSize];
    }
    else
        return nil;
}

/**清除缓存*/
-(void)clearImageCache
{
    NSFileManager *mgr=[NSFileManager defaultManager];
    //            列出图片缓存文件夹下的所有图片
    NSArray *imageArray=[mgr contentsOfDirectoryAtPath:_imageCachePath error:nil];
    if(imageArray.count>0)
    {
        for(NSString *fileName in imageArray)
        {
            NSString *fullPath=[_imageCachePath stringByAppendingPathComponent:fileName];
            BOOL exist=[mgr fileExistsAtPath:fullPath];
            if(exist)
            {
//                        删除图片
                [mgr removeItemAtPath:fullPath error:nil];
            }
        }
    }
}
//计算缓存的占用存储大小
-(NSString *)convertSize:(NSInteger)cacheSize
{
    if(cacheSize<1024)
        return [NSString stringWithFormat:@"缓存大小 %ld B",(long)cacheSize];
    else if(cacheSize>1024&&cacheSize<1024*1024)
        return [NSString stringWithFormat:@"缓存大小 %.2f K",(float)cacheSize/1024];
    else if(cacheSize >1024*1024&&cacheSize<1024*1024*1024)
        return [NSString stringWithFormat:@"缓存大小 %.2f M",(float)cacheSize/(1024*1024)];
    else
        return [NSString stringWithFormat:@"缓存大小 %.2f G",(float)cacheSize/(1024*1024*1024)];
}
@end

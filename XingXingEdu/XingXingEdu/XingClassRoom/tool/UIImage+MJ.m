//

//
//  Created by teacher on 14-6-6.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "UIImage+MJ.h"

@implementation UIImage (MJ)

+ (UIImage *)imageWithName:(NSString *)name
{
    // 0.需要返回的图片
    UIImage *image = nil;
    
//    // 1.判断系统版本
//    if (iOS7) {
//        NSString *ios7Name = [name stringByAppendingString:@"_os7"];
//        // 加载iOS7的图片
//        image = [self imageNamed:ios7Name];
//    }
//    
    // 2.图片不存在
    if (image == nil) {
        image = [self imageNamed:name];
    }
    
    return image;
}

+ (UIImage *)resizableImage:(NSString *)name
{
    return [self resizableImage:name leftRatio:0.5 topRatio:0.5];
}

+ (UIImage *)resizableImage:(NSString *)name leftRatio:(CGFloat)leftRatio topRatio:(CGFloat)topRatio
{
    UIImage *image = [self imageWithName:name];
    CGFloat left = image.size.width * leftRatio;
    CGFloat top = image.size.height * topRatio;
    return [image stretchableImageWithLeftCapWidth:left topCapHeight:top];
}
@end

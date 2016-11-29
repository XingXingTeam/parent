//
//  MJPhotoToolbar.m
//  FingerNews
//
//  Created by mj on 13-9-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoToolbar.h"
#import "MJPhoto.h"
// UM
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "APOpenAPI.h"
@interface MJPhotoToolbar()<UMSocialUIDelegate>
{
    // 显示页码
    UILabel *_indexLabel;
    UIButton *_saveImageBtn;
    UIButton *_shareImageBtn;
    UIButton *_reportImageBtn;
    UIButton *saveBtn;
}
@end

@implementation MJPhotoToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    if (_photos.count > 1) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = [UIFont boldSystemFontOfSize:20];
        _indexLabel.frame = self.bounds;
        _indexLabel.backgroundColor = [UIColor clearColor];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_indexLabel];
    }
    
    // 保存图片按钮
//    CGFloat btnWidth = self.bounds.size.height;
//    _saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _saveImageBtn.frame = CGRectMake(0, 0, btnWidth, btnWidth);
//    _saveImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    [_saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon.png"] forState:UIControlStateNormal];
//    [_saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon_highlighted.png"] forState:UIControlStateHighlighted];
//    [_saveImageBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_saveImageBtn];
//    
//    // shareBTN
//    CGFloat shareWidth = self.bounds.size.height;
//    _shareImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _shareImageBtn.frame = CGRectMake(325, 0, shareWidth, shareWidth);
//    _shareImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    [_shareImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon.png"] forState:UIControlStateNormal];
//    [_shareImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon_highlighted.png"] forState:UIControlStateHighlighted];
//    [_shareImageBtn addTarget:self action:@selector(shareImage:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_shareImageBtn];
    

    
}
//- (void)shareImage:(UIButton*)shareBtn{
//    NSLog(@"share");
//    
//    if (saveBtn.selected ==NO) {
//        shareBtn.selected=YES;
//        saveBtn=shareBtn;
//        
//        [SVProgressHUD showSuccessWithStatus:@"已收藏"];
//        
//    }
//    else{
//        shareBtn.selected=NO;
//        saveBtn=shareBtn;
//        
//        [SVProgressHUD showSuccessWithStatus:@"取消收藏"];
//    }
//    
//}
//
//
//- (void)saveImage
//{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        MJPhoto *photo = _photos[_currentPhotoIndex];
//        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//    });
//}
//
//- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
//{
//    if (error) {
//        [SVProgressHUD showErrorWithStatus:@"保存失败"];
//    } else {
//        MJPhoto *photo = _photos[_currentPhotoIndex];
//        photo.save = YES;
//        _saveImageBtn.enabled = NO;
//        [SVProgressHUD showSuccessWithStatus:@"成功保存到相册"];
//    }
//}
//
//- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
//{
//    _currentPhotoIndex = currentPhotoIndex;
//    
//    // 更新页码
//    _indexLabel.text = [NSString stringWithFormat:@"%d / %d", (int)_currentPhotoIndex + 1, (int)_photos.count];
//    
//    MJPhoto *photo = _photos[_currentPhotoIndex];
//    // 按钮
//    _saveImageBtn.enabled = photo.image != nil && !photo.save;
//    _saveImageBtn.hidden =!_showSaveBtn;
//}

@end

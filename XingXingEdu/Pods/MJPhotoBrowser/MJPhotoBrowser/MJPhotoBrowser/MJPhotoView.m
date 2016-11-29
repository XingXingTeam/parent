//
//  MJZoomingScrollView.m
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoView.h"
#import "MJPhoto.h"
#import "MJPhotoLoadingView.h"
#import <QuartzCore/QuartzCore.h>
// UM
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "WXApi.h"
#import "WXApiObject.h"
#define ESWeak(var, weakVar) __weak __typeof(&*var) weakVar = var
#define ESStrong_DoNotCheckNil(weakVar, _var) __typeof(&*weakVar) _var = weakVar
#define ESStrong(weakVar, _var) ESStrong_DoNotCheckNil(weakVar, _var); if (!_var) return;

#define ESWeak_(var) ESWeak(var, weak_##var);
#define ESStrong_(var) ESStrong(weak_##var, _##var);

/** defines a weak `self` named `__weakSelf` */
#define ESWeakSelf      ESWeak(self, __weakSelf);
/** defines a strong `self` named `_self` from `__weakSelf` */
#define ESStrongSelf    ESStrong(__weakSelf, _self);

@interface MJPhotoView ()<UMSocialUIDelegate,UIActionSheetDelegate>
{
    BOOL _zoomByDoubleTap;
    YLImageView *_imageView;
    MJPhotoLoadingView *_photoLoadingView;
    UIView *_sifterView;
    UIView *shadowView;
    NSArray *shareArray;
}
@end

@implementation MJPhotoView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.clipsToBounds = YES;
		// 图片
		_imageView = [[YLImageView alloc] init];
        _imageView.backgroundColor = [UIColor blackColor];
		_imageView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:_imageView];
        
        // 进度条
        _photoLoadingView = [[MJPhotoLoadingView alloc] init];
		
		// 属性
		self.delegate = self;
//		self.showsHorizontalScrollIndicator = NO;
//		self.showsVerticalScrollIndicator = NO;
		self.decelerationRate = UIScrollViewDecelerationRateFast;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // 监听点击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongTap:)];
        [self addGestureRecognizer:longTap];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
    }
    return self;
}

//设置imageView的图片
- (void)configImageViewWithImage:(UIImage *)image{
    _imageView.image = image;
}


#pragma mark - photoSetter
- (void)setPhoto:(MJPhoto *)photo {
    _photo = photo;
    
    [self showImage];
}

#pragma mark 显示图片
- (void)showImage
{
    [self photoStartLoad];

    [self adjustFrame];
}

#pragma mark 开始加载图片
- (void)photoStartLoad
{
    if (_photo.image) {
        [_photoLoadingView removeFromSuperview];
        _imageView.image = _photo.image;
        self.scrollEnabled = YES;
    } else {
        _imageView.image = _photo.placeholder;
        self.scrollEnabled = NO;
        // 直接显示进度条
        [_photoLoadingView showLoading];
        [self addSubview:_photoLoadingView];
        
        ESWeakSelf;
        ESWeak_(_photoLoadingView);
        ESWeak_(_imageView);
        
        [SDWebImageManager.sharedManager downloadImageWithURL:_photo.url options:SDWebImageRetryFailed| SDWebImageLowPriority| SDWebImageHandleCookies progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            ESStrong_(_photoLoadingView);
            if (receivedSize > kMinProgress) {
                __photoLoadingView.progress = (float)receivedSize/expectedSize;
            }
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            ESStrongSelf;
            ESStrong_(_imageView);
            __imageView.image = image;
            [_self photoDidFinishLoadWithImage:image];
        }];
    }
}

#pragma mark 加载完毕
- (void)photoDidFinishLoadWithImage:(UIImage *)image
{
    if (image) {
        self.scrollEnabled = YES;
        _photo.image = image;
        [_photoLoadingView removeFromSuperview];
        
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewImageFinishLoad:)]) {
            [self.photoViewDelegate photoViewImageFinishLoad:self];
        }
    } else {
        [self addSubview:_photoLoadingView];
        [_photoLoadingView showFailure];
    }
    
    // 设置缩放比例
    [self adjustFrame];
}
#pragma mark 调整frame
- (void)adjustFrame
{
	if (_imageView.image == nil) return;
    
    // 基本尺寸参数
    CGFloat boundsWidth = self.bounds.size.width;
    CGFloat boundsHeight = self.bounds.size.height;
    CGFloat imageWidth = _imageView.image.size.width;
    CGFloat imageHeight = _imageView.image.size.height;
	
	// 设置伸缩比例
    CGFloat imageScale = boundsWidth / imageWidth;
    CGFloat minScale = MIN(1.0, imageScale);
    
	CGFloat maxScale = 2.0; 
	if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
		maxScale = maxScale / [[UIScreen mainScreen] scale];
	}
	self.maximumZoomScale = maxScale;
	self.minimumZoomScale = minScale;
	self.zoomScale = minScale;
    
    CGRect imageFrame = CGRectMake(0, MAX(0, (boundsHeight- imageHeight*imageScale)/2), boundsWidth, imageHeight *imageScale);
    
    self.contentSize = CGSizeMake(CGRectGetWidth(imageFrame), CGRectGetHeight(imageFrame));
    _imageView.frame = imageFrame;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (_zoomByDoubleTap) {
        CGFloat insetY = (CGRectGetHeight(self.bounds) - CGRectGetHeight(_imageView.frame))/2;
        insetY = MAX(insetY, 0.0);
        if (ABS(_imageView.frame.origin.y - insetY) > 0.5) {
            CGRect imageViewFrame = _imageView.frame;
            imageViewFrame = CGRectMake(imageViewFrame.origin.x, insetY, imageViewFrame.size.width, imageViewFrame.size.height);
            _imageView.frame = imageViewFrame;
        }
    }
	return _imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    _zoomByDoubleTap = NO;
    CGFloat insetY = (CGRectGetHeight(self.bounds) - CGRectGetHeight(_imageView.frame))/2;
    insetY = MAX(insetY, 0.0);
    if (ABS(_imageView.frame.origin.y - insetY) > 0.5) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect imageViewFrame = _imageView.frame;
            imageViewFrame = CGRectMake(imageViewFrame.origin.x, insetY, imageViewFrame.size.width, imageViewFrame.size.height);
            _imageView.frame = imageViewFrame;
        }];
    }
}
//长按手势
- (void)handleLongTap:(UITapGestureRecognizer*)recognizer{
    NSLog(@"长按");
    //解决响应两次的问题
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        return;
        
    } else if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        UIActionSheet *actionSheet =[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"发送给QQ好友" otherButtonTitles:@"发送给微信好友",@"分享到朋友圈",@"分享到Qzone",@"举报", nil];
        [actionSheet showInView:self];
        actionSheet.tag=100;
        
        
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld",(long)buttonIndex);
    if (actionSheet.tag==100) {
        if (buttonIndex ==0) {
            NSLog(@"发送给QQ好友");
            
            //QQ好友
            [self performSelector:@selector(delayView) withObject:nil afterDelay:0.6];
            
        }
        else if (buttonIndex==1){
            NSLog(@"发送给微信好友");
            
            [self performSelector:@selector(delayWX) withObject:nil afterDelay:0.6];
            
            
        }
        else  if (buttonIndex==2){
            NSLog(@"分享到朋友圈");
            [self performSelector:@selector(delayWXQzone) withObject:nil afterDelay:0.6];
            
        }
        else if (buttonIndex==3){
            NSLog(@"分享到Qzone");
            [self performSelector:@selector(delayQzone) withObject:nil afterDelay:0.6];
        }
        else if (buttonIndex==4){
            NSLog(@"举报");
            UIActionSheet *actionSheet =[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"色情低俗" otherButtonTitles:@"政治敏感",@"广告骚扰",@"诱导分享",@"侵权投诉",@"其他", nil];
            [actionSheet showInView:self];
            actionSheet.tag=200;
            
        }
        else{
            NSLog(@"cancel");
        }
    }
    else if (actionSheet.tag==200){
        [SVProgressHUD showSuccessWithStatus:@"感谢您的举报,我们会在第一时间进行审核,谢谢您的支持!" maskType:SVProgressHUDMaskTypeNone];
        
    }
    else{
        
        
    }
    
    
}
- (void)delayQzone{
    
    [[UMSocialControllerService defaultControllerService] setShareText:@"猩猩教室" shareImage:[UIImage imageNamed:@"11111.png"]socialUIDelegate:self];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQzone].snsClickHandler([UIApplication sharedApplication].keyWindow.rootViewController,[UMSocialControllerService defaultControllerService],YES);
}
- (void)delayWXQzone{
    [[UMSocialControllerService defaultControllerService] setShareText:@"猩猩教室" shareImage:[UIImage imageNamed:@"11111.png"]socialUIDelegate:self];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler([UIApplication sharedApplication].keyWindow.rootViewController,[UMSocialControllerService defaultControllerService],YES);
    
}
- (void)delayWX{
    [[UMSocialControllerService defaultControllerService] setShareText:@"猩猩教室" shareImage:[UIImage imageNamed:@"11111.png"]socialUIDelegate:self];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler([UIApplication sharedApplication].keyWindow.rootViewController,[UMSocialControllerService defaultControllerService],YES);
    
}
- (void)delayView{
    [[UMSocialControllerService defaultControllerService] setShareText:@"猩猩教室" shareImage:[UIImage imageNamed:@"11111.png"]socialUIDelegate:self];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler([UIApplication sharedApplication].keyWindow.rootViewController,[UMSocialControllerService defaultControllerService],YES);
    
 
    
}

#pragma mark - 手势处理
//单击隐藏
- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    // 移除进度条
    [_photoLoadingView removeFromSuperview];
    
    // 通知代理
    if ([self.photoViewDelegate respondsToSelector:@selector(photoViewSingleTap:)]) {
        [self.photoViewDelegate photoViewSingleTap:self];
    }
}
//双击放大
- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    _zoomByDoubleTap = YES;

	if (self.zoomScale == self.maximumZoomScale) {
		[self setZoomScale:self.minimumZoomScale animated:YES];
	} else {
        CGPoint touchPoint = [tap locationInView:self];
        CGFloat scale = self.maximumZoomScale/ self.zoomScale;
        CGRect rectTozoom=CGRectMake(touchPoint.x * scale, touchPoint.y * scale, 1, 1);
        [self zoomToRect:rectTozoom animated:YES];
	}
}

- (void)dealloc
{
    // 取消请求
    [_imageView sd_setImageWithURL:[NSURL URLWithString:@"file:///abc"]];
}
@end
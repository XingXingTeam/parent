//
//  DFImagesSendViewController.m
//  DFTimelineView
//
//  Created by Allen Zhong on 16/2/15.
//  Copyright © 2016年 Datafans, Inc. All rights reserved.
//

#import "DFImagesSendViewController.h"
#import "DFPlainGridImageView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "MMPopupItem.h"
#import "MMSheetView.h"
#import "MMPopupWindow.h"

#import "XXEWhoCanLookController.h"
#import "XXELocationAddController.h"

#import "TZImagePickerController.h"

#import <AssetsLibrary/AssetsLibrary.h>

#define ImageGridWidth [UIScreen mainScreen].bounds.size.width*0.7
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define XXEColorFromRGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

@interface DFImagesSendViewController()<DFPlainGridImageViewDelegate,TZImagePickerControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate>{
    UIView *bgView;
    UIScrollView *bgScrollView;
    UIView *bgBtnView;
    UITapGestureRecognizer * _gesture;
    UILabel *lineLabel;
}

@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, strong) UITextView *contentView;

@property (nonatomic, strong) UIView *mask;

@property (nonatomic, strong) UILabel *placeholder;

@property (nonatomic, strong) DFPlainGridImageView *gridView;

@property (nonatomic, strong) UIImagePickerController *pickerController;

@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

//按钮定位
@property (nonatomic, strong) UIButton *locationButton;
//谁可以看
@property (nonatomic, strong) UIButton *whoButton;

//位置
@property (nonatomic,copy)NSString *positionStr;
//谁可以看见
@property (nonatomic, copy)NSString *whoSeeStr;

@property (nonatomic, strong) UIView *backView;

@end


@implementation DFImagesSendViewController

- (instancetype)initWithImages:(NSArray *) images
{
    self = [super init];
    if (self) {
        _images = [NSMutableArray array];
        if (images != nil) {
            [_images addObjectsFromArray:images];
            [_images addObject:[UIImage imageNamed:@"AlbumAddBtn"]];
        }
    }
    return self;
}

- (void)dealloc
{
    
    [_mask removeGestureRecognizer:_panGestureRecognizer];
    [_mask removeGestureRecognizer:_tapGestureRecognizer];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0, 170, 42)];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    _whoSeeStr = @"";
    _positionStr = @"";
    
}

-(void) initView
{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //背景
    bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth,KScreenHeight - 64)];
    bgScrollView.backgroundColor= XXEColorFromRGB(229, 232, 233);
    bgScrollView.pagingEnabled = NO;
    bgScrollView.showsHorizontalScrollIndicator = YES;
    bgScrollView.showsVerticalScrollIndicator  = YES;
    bgScrollView.alwaysBounceVertical = YES;
    [self.view addSubview:bgScrollView];
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 300)];
    bgView.backgroundColor = [UIColor whiteColor];
    [bgScrollView addSubview:bgView];
    
    
    CGFloat x, y, width, heigh;
    x=10;
    y=10;
    width = self.view.frame.size.width -2*x;
    heigh = 100;
    _contentView = [[UITextView alloc] initWithFrame:CGRectMake(x, y, width, heigh)];
    _contentView.scrollEnabled = YES;
    _contentView.delegate = self;
    _contentView.font = [UIFont systemFontOfSize:17];
    //_contentView.layer.borderColor = [UIColor redColor].CGColor;
    //_contentView.layer.borderWidth =2;
    [bgScrollView addSubview:_contentView];
    
    //placeholder
    _placeholder = [[UILabel alloc] initWithFrame:CGRectMake(x+5, y+5, 150, 25)];
    _placeholder.text = @"这一刻的想法...";
    _placeholder.font = [UIFont systemFontOfSize:14];
    _placeholder.textColor = [UIColor lightGrayColor];
    _placeholder.enabled = NO;
    [bgScrollView addSubview:_placeholder];
    
    bgBtnView = [[UIView alloc]init];
    bgBtnView.backgroundColor = [UIColor whiteColor];
    [bgScrollView  addSubview:bgBtnView];
    
    _gridView = [[DFPlainGridImageView alloc] initWithFrame:CGRectZero];
    _gridView.delegate = self;
    [bgScrollView addSubview:_gridView];
    
    self.locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgBtnView addSubview:self.locationButton];
    
    lineLabel = [[UILabel alloc]init];
    [bgBtnView addSubview:lineLabel];
    
    self.whoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgBtnView addSubview:self.whoButton];
    
    _mask = [[UIView alloc] initWithFrame:self.view.bounds];
    _mask.backgroundColor = [UIColor clearColor];
    _mask.hidden = YES;
    [self.view addSubview:_mask];
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanAndTap:)];
    [_mask addGestureRecognizer:_panGestureRecognizer];
    _panGestureRecognizer.maximumNumberOfTouches = 1;
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPanAndTap:)];
    [_mask addGestureRecognizer:_tapGestureRecognizer];
    
    
    
    [self refreshGridImageView];
}

-(void) refreshGridImageView
{
    CGFloat x, y, width, heigh;
    x=10;
    y = CGRectGetMaxY(_contentView.frame)+10;
    width  = ImageGridWidth;
    heigh = [DFPlainGridImageView getHeight:_images maxWidth:width];
    _gridView.frame = CGRectMake(x, y, width, heigh);
    [_gridView updateWithImages:_images];
    
    CGFloat bgViewH = CGRectGetMaxY(_gridView.frame)+10;
    bgView.frame = CGRectMake(0, 0, KScreenWidth, bgViewH);
    bgBtnView.frame = CGRectMake(0, CGRectGetMaxY(bgView.frame)+20, KScreenWidth, 110);
    
    //所在位置
    self.locationButton.frame = CGRectMake(10, 10, KScreenWidth-20, 40);
    [self.locationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.locationButton setTitle:@"所在位置" forState:UIControlStateNormal];
    self.locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.locationButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.locationButton addTarget:self action:@selector(locationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    lineLabel.frame = CGRectMake(10, CGRectGetMaxY(self.locationButton.frame)+5, KScreenWidth-20, 1);
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    
    
    //有谁可以看
    
//    self.whoButton.backgroundColor = [UIColor redColor];
    self.whoButton.frame = CGRectMake(10, CGRectGetMaxY(self.locationButton.frame)+10, KScreenWidth-20, 40);
    [self.whoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.whoButton setTitle:@"谁可以看" forState:UIControlStateNormal];
    self.whoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.whoButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.whoButton addTarget:self action:@selector(whoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 所在位置的定位
- (void)locationButtonAction:(UIButton *)sender
{
    NSLog(@"定位布标");
    XXELocationAddController *localVC =[[XXELocationAddController alloc]init];
    [localVC returnText:^(NSString *showText) {
        if (showText) {
            _positionStr = showText;
            [sender setTitle:_positionStr forState:UIControlStateNormal];
        }
    }];
    [self.navigationController pushViewController:localVC animated:YES];
}

- (void)whoButtonAction:(UIButton *)sender
{
    XXEWhoCanLookController *whoVC =[[XXEWhoCanLookController alloc]init];
    [whoVC returnText:^(NSString *showText) {
        if (showText) {
            _whoSeeStr = showText;
            [sender setTitle:_whoSeeStr forState:UIControlStateNormal];
        }
    }];
    [self.navigationController pushViewController:whoVC animated:YES];
}

-(UIBarButtonItem *)leftBarButtonItem
{
    return [UIBarButtonItem text:@"取消" selector:@selector(cancel) target:self];
}

-(UIBarButtonItem *)rightBarButtonItem
{
    return [UIBarButtonItem text:@"发送" selector:@selector(send) target:self];
}

-(void) cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) send
{
    if (_delegate && [_delegate respondsToSelector:@selector(onSendTextImage:images:Location:PersonSee:)]) {
        
        [_images removeLastObject];
        [_delegate onSendTextImage:_contentView.text images:_images Location:_positionStr PersonSee:_whoSeeStr];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void) onPanAndTap:(UIGestureRecognizer *) gesture
{
    _mask.hidden = YES;
    _placeholder.hidden = YES;
    [_contentView resignFirstResponder];
}



#pragma mark - UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![text isEqualToString:@""])
    {
        
    }else if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
    {
        _placeholder.hidden = NO;
        
    }
//    if ([text isEqualToString:@"\n"]){
//        _mask.hidden = YES;
//        [_contentView resignFirstResponder];
//        _placeholder.hidden = YES;
//        if (range.location == 0)
//        {
//            _placeholder.hidden = NO;
//        }
//        return NO;
//    }
    
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    _mask.hidden = NO;
    _placeholder.text = @"";
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    _mask.hidden = YES;
}

#pragma mark - DFPlainGridImageViewDelegate

-(void)onClick:(NSUInteger)index
{
    
    if (_images.count <9 && index == _images.count-1) {
        [self chooseImage];
    }else{
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        
        NSMutableArray *photos = [NSMutableArray array];
        NSUInteger count;
        if (_images.count > 9)  {
            count = 9;
        }else{
            count = _images.count - 1;
        }
        for (int i=0; i<count; i++) {
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.image = [_images objectAtIndex:i];
            [photos addObject:photo];
        }
        browser.photos = photos;
        browser.currentPhotoIndex = index;
        
        [browser show];
        
    }
}


-(void)onLongPress:(NSUInteger)index
{
    
    if (_images.count <9 && index == _images.count-1) {
        return;
    }
    
    MMPopupItemHandler block = ^(NSInteger i){
        switch (i) {
            case 0:
                [_images removeObjectAtIndex:index];
                [self refreshGridImageView];
                break;
            default:
                break;
        }
    };
    
    NSArray *items = @[MMItemMake(@"删除", MMItemTypeNormal, block)];
    
    MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:@"" items:items];
    [sheetView show];
    
}

-(void) chooseImage
{
    MMPopupItemHandler block = ^(NSInteger index){
        switch (index) {
            case 0:
                [self takePhoto];
                break;
            case 1:
                [self pickFromAlbum];
                break;
            default:
                break;
        }
    };
    
    NSArray *items = @[MMItemMake(@"拍照", MMItemTypeNormal, block),
                       MMItemMake(@"从相册选取", MMItemTypeNormal, block)];
    
    MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:@"" items:items];
    [sheetView show];
}

-(void) takePhoto
{
    _pickerController = [[UIImagePickerController alloc] init];
    _pickerController.delegate = self;
    _pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:_pickerController animated:YES completion:nil];
}

-(void) pickFromAlbum
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:(10-_images.count) delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark - TZImagePickerControllerDelegate
#pragma mark - TZImagePickerControllerDelegate

-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    NSLog(@"%@", photos);
    
    for (UIImage *image in photos) {
        [_images insertObject:image atIndex:(_images.count-1)];
    }
    
    [self refreshGridImageView];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [_pickerController dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [_images insertObject:image atIndex:(_images.count-1)];
    
    [self refreshGridImageView];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_pickerController dismissViewControllerAnimated:YES completion:nil];
}

@end

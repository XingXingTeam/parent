//
//  DFImagesSendViewController.m
//  DFTimelineView
//
//  Created by keenteam on 16/2/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "DFImagesSendViewController.h"
#import "DFPlainGridImageView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "MMPopupItem.h"
#import "MMSheetView.h"
#import "MMPopupWindow.h"
#import "TZImagePickerController.h"
#import "WhoViewController.h"
#import "LocalViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define ImageGridWidth [UIScreen mainScreen].bounds.size.width*0.7
#define Kmarg 10.0f

@interface DFImagesSendViewController()<DFPlainGridImageViewDelegate,TZImagePickerControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>{
    UIButton *localBtn;
    UIButton *whoBtn;
    UIScrollView *bgScrollView;
    UIView *bgView;
    NSString *_positionStr;
    NSString *_whoSeeStr;
    UIImage * image;
    UIView *_bgBtnView;
    UITapGestureRecognizer * _gesture;
}
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) UITextView *contentView;
@property (nonatomic, strong) DFPlainGridImageView *gridView;
@property (nonatomic, strong) UIImagePickerController *pickerController;

@end

@implementation DFImagesSendViewController

- (instancetype)initWithImages:(NSArray *) images
{
    self = [super init];
    if (self) {
        _images = [NSMutableArray array];
        [_images addObjectsFromArray:images];
        
        [_images addObject:[UIImage imageNamed:@"AlbumAddBtn"]];
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0, 170, 42);
    
    _positionStr = @"";
    _whoSeeStr = @"";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
   
    [self initView];
}
//监听方法
- (void)keyboardWillShow {
    _gesture.enabled = YES;
}
//隐藏键盘
- (void)hidesKeyboard{
    [self.view endEditing:YES];
    _gesture.enabled = NO;
}

-(void) initView{
    //背景
    bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth,kHeight + 64)];
    bgScrollView.backgroundColor= UIColorFromRGB(229, 232, 233);
    bgScrollView.pagingEnabled = NO;
    bgScrollView.showsHorizontalScrollIndicator = YES;
    bgScrollView.showsVerticalScrollIndicator  = YES;
    bgScrollView.alwaysBounceVertical = YES;
    [self.view addSubview:bgScrollView];
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 300)];
    bgView.backgroundColor = [UIColor whiteColor];
    [bgScrollView addSubview:bgView];
   
    //添加点击收起键盘手势
    _gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidesKeyboard)];
    _gesture.enabled = NO;//最开始手势设为no
    [bgScrollView addGestureRecognizer:_gesture];
    
    _contentView = [[UITextView alloc] initWithFrame:CGRectMake(Kmarg, Kmarg, kWidth - Kmarg *2, 120)];
    _contentView.text = @"这一刻的想法.....";
    _contentView.textAlignment = NSTextAlignmentLeft;
    _contentView.dataDetectorTypes = UIDataDetectorTypeAll;
    _contentView.scrollEnabled = YES;
    _contentView.editable =YES;
    _contentView.font = [UIFont systemFontOfSize:15];
    _contentView.delegate =self;
    _contentView.textColor = [UIColor lightGrayColor];
    [bgView addSubview:_contentView];
    
    
    _gridView = [[DFPlainGridImageView alloc] initWithFrame:CGRectZero];
    _gridView.delegate = self;
    [bgView addSubview:_gridView];
    
    [self refreshGridImageView];
    
}

- (void)localBtn{
    LocalViewController *localVC =[[LocalViewController alloc]init];
    [localVC returnText:^(NSString *showText) {
        if (showText) {
            _positionStr = showText;
            [localBtn setTitle:_positionStr forState:UIControlStateNormal];
        }
    }];
    [self.navigationController pushViewController:localVC animated:YES];
}

- (void)whoBtn{
    WhoViewController *whoVC =[[WhoViewController alloc]init];
    [whoVC returnText:^(NSString *showText) {
        
        if (showText) {
            _whoSeeStr = showText;
            [whoBtn setTitle:_whoSeeStr forState:UIControlStateNormal];
        }
    }];
    [self.navigationController pushViewController:whoVC animated:YES];
  
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
    
    CGFloat maxH =  CGRectGetMaxY(_gridView.frame) + Kmarg;
    bgView.frame =  CGRectMake(0, 0, kWidth, maxH);
    
    _bgBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame) + Kmarg *2 , kWidth, 110)];
    _bgBtnView.backgroundColor = UIColorFromRGB(255, 255, 255);
    [bgScrollView addSubview:_bgBtnView];
    //所在位置
    localBtn =[HHControl createButtonWithFrame:CGRectMake(Kmarg,Kmarg , kWidth - Kmarg*2, 40) backGruondImageName:nil Target:self Action:@selector(localBtn) Title:@"所在位置"];
    localBtn.titleLabel.font =[UIFont systemFontOfSize:14];
    localBtn.backgroundColor =UIColorFromRGB(255, 255, 255);
    localBtn.layer.cornerRadius =4;
    localBtn.layer.masksToBounds =YES;
    localBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_bgBtnView addSubview:localBtn];
    if ([_positionStr isEqualToString:@"" ]) {
        [localBtn setTitle:@"所在位置" forState:UIControlStateNormal];
    }else{
        [localBtn setTitle:_positionStr forState:UIControlStateNormal];
    }
    
    //btn之间的间隔线
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(Kmarg, CGRectGetMaxY(localBtn.frame) + 5, kWidth - Kmarg * 2, 1)];
    line.backgroundColor = UIColorFromRGB(204, 204, 204);
    [_bgBtnView addSubview:line];
    
    //谁可以看 提醒谁看
    whoBtn =[HHControl createButtonWithFrame:CGRectMake(Kmarg, CGRectGetMaxY(localBtn.frame) + Kmarg, kWidth - Kmarg*2, 40) backGruondImageName:nil Target:self Action:@selector(whoBtn) Title:@"谁可以看"];
    whoBtn.titleLabel.font =[UIFont systemFontOfSize:14];
    whoBtn.backgroundColor =UIColorFromRGB(255, 255, 255);
    whoBtn.layer.cornerRadius =4;
    whoBtn.layer.masksToBounds =YES;
    whoBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_bgBtnView addSubview:whoBtn];
    if ([_whoSeeStr isEqualToString:@"" ]) {
        [whoBtn setTitle:@"所在位置" forState:UIControlStateNormal];
    }else{
        [whoBtn setTitle:_whoSeeStr forState:UIControlStateNormal];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.textColor = [UIColor blackColor];
    if ([textView.text isEqualToString:@"这一刻的想法....."]) {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (textView.text.length<1) {
        textView.text = @"这一刻的想法.....";
        textView.textColor = [UIColor lightGrayColor];
    }
}
//内容将要发生改变编辑
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location >= 300){
        //控制输入文本的长度
        return  NO;
    }if ([text isEqualToString:@"\n"]) {
        //禁止输入换行
        return YES;
    }else{
        return YES;
    }

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

-(void) send{
    
//    // 【我的圈子--发布】
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/mycircle_publish";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"position":_positionStr,
                           @"file_type":@"1",
                           @"words":_contentView.text,
                           };
//    NSLog(@"=============>%@",_imagesArr);
    
    
    // 服务器返回的数据格式
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:urlStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        int i=0;
        for ( UIImage *img in _imagesArr) {
            
            NSData *data =UIImagePNGRepresentation(img);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd HHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            
            [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"file%@",@(i)] fileName:[NSString stringWithFormat:@"%@%@",str,@(i)] mimeType:@"image/png"];
            i++;
            
        }
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSLog(@"=======%@================",responseObject);
        //id
        NSString *imageTextId =[NSString stringWithFormat:@"%@",responseObject[@"data"][@"id"]];
        //位置
        NSString *position = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"position"]];
        NSMutableArray *user_info = [[NSMutableArray alloc] initWithObjects:imageTextId,position,nil];
        [[NSUserDefaults standardUserDefaults] setObject:user_info forKey:@"USER_INFO"];
        
        if (_delegate && [_delegate respondsToSelector:@selector(onSendTextImage:images:)]) {
            
            [_images removeLastObject];
            [_delegate onSendTextImage:_contentView.text images:_images];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [SVProgressHUD showSuccessWithStatus:@"发表成功"];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"Error:%@", error);
        
        [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
        
    }];
    
}


#pragma mark - DFPlainGridImageViewDelegate
-(void)onClick:(NSUInteger)index{

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

-(void)onLongPress:(NSUInteger)index{
   
    if (_images.count <9 && index == _images.count-1) {
        return;
    }
    MMPopupItemHandler block = ^(NSInteger i){
        switch (i) {
            case 0:
                
                [_images removeObjectAtIndex:index];
                [_bgBtnView removeFromSuperview];
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

//选择照片
-(void) chooseImage{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:(10-_images.count) delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.delegate = self;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    for (UIImage *image in photos) {
        [_images insertObject:image atIndex:(_images.count-1)];
    }
    
    [_bgBtnView removeFromSuperview];
    [self refreshGridImageView];
    
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{

    
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [_pickerController dismissViewControllerAnimated:YES completion:nil];

    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [_images insertObject:image atIndex:(_images.count-1)];
    [_bgBtnView removeFromSuperview];
    [self refreshGridImageView];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_pickerController dismissViewControllerAnimated:YES completion:nil];
}


-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

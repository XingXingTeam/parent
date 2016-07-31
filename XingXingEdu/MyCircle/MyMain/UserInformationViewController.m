//
//  UserInformationViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/4/8.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "UserInformationViewController.h"
// UM
#import "CoreUMeng.h"
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "APOpenAPI.h"
#import "MBProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MessageListDetailController.h"
#import "CommentInputViewController.h"

//个人信息状态
@interface UserInformationViewController ()<UIActionSheetDelegate,UIScrollViewDelegate,UMSocialUIDelegate>
{
    UIImageView *imageview;
    UIScrollView *_scrollView;
    UIButton *_detaileBtn;
    BOOL isGood;
}

@property (nonatomic, strong) UIView *panelView;

/**
 *  加载视图
 */
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
//@property(nonatomic,retain) NSMutableArray *ittms;

@property (nonatomic, strong) UIButton *likeButton;

@property (nonatomic, strong) UIButton *commentButton;
@end

@implementation UserInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor= [UIColor colorWithRed:229/255.0f green:232/255.0f blue:234/255.0f alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0, 170, 42);
    //时间戳转时间
    NSDateFormatter *fomatter =[[NSDateFormatter alloc]init];
    [fomatter setDateStyle:NSDateFormatterMediumStyle];
    [fomatter setTimeStyle:NSDateFormatterShortStyle];
    [fomatter setDateFormat:@"yyyy年MM月dd日 HH:MM:ss"];
    NSString *str =[NSString stringWithFormat:@"%ld",self.ts];
//    str =[str substringToIndex:10];
    NSInteger i =str.integerValue;
    //时间戳转时间
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:i];
    NSString *confromTimespStr = [fomatter stringFromDate:confromTimesp];
    self.title =[NSString stringWithFormat:@"%@",confromTimespStr];
 
    [self createscrollView];
    [self createToolbtn];
    
}


-(void)createscrollView{
    
    _scrollView =  [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 85)];
    _scrollView.pagingEnabled =YES;
    _scrollView.showsHorizontalScrollIndicator =NO;
    [self.view addSubview:_scrollView];
    //
    //加载等待视图
    self.panelView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.panelView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.panelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.loadingView.frame = CGRectMake((self.view.frame.size.width - self.loadingView.frame.size.width) / 2, (self.view.frame.size.height - self.loadingView.frame.size.height) / 2, self.loadingView.frame.size.width, self.loadingView.frame.size.height);
    self.loadingView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [self.panelView addSubview:self.loadingView];


    //  加载图片
    for (int i=0; i<_imagesArr.count; i++) {
        UIImageView *imV = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth*i, 0, kWidth, kHeight)];
        NSURL *url =[NSURL URLWithString:_imagesArr[i]];
        [imV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"11111"] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [_scrollView addSubview:imV];
            
        }];
        dispatch_queue_t queue  = dispatch_queue_create("loadImage", NULL);
        
        dispatch_async(queue, ^{
            NSData *reslut =[NSData dataWithContentsOfURL:url];
            UIImage *imag =[UIImage imageWithData:reslut];
            dispatch_sync(dispatch_get_main_queue(), ^{
                imV.image =imag;
                [_scrollView addSubview:imV];
            });
        });
    }
    CGPoint contentOffset = _scrollView.contentOffset;
    [_scrollView setContentOffset:contentOffset animated:YES];
    [self createToolBarItems];
    _scrollView.contentSize =CGSizeMake(_imagesArr.count*kWidth, kHeight-64);
    _scrollView.delegate =self;

}
- (void)createToolbtn{
    
    //UILabel 加白字
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kHeight-94, kWidth, 50)];
    textLabel.backgroundColor =UIColorFromRGB(125, 130, 147);
    [self.view addSubview:textLabel];
    textLabel.numberOfLines =0;
    textLabel.font =[UIFont systemFontOfSize:15];
    textLabel.text = _conText;
    textLabel.textColor =UIColorFromRGB(255, 255, 255);
    
    UIImageView *imageV= [[UIImageView alloc]initWithFrame:CGRectMake(0, kHeight-44, kWidth, 44)];
    imageV.backgroundColor = UIColorFromRGB(0, 0, 0 );
    [self.view addSubview:imageV];
    imageV.userInteractionEnabled =YES;
    
    if (![_goodArr isEqual:@""]) {
        _likeButton = [self getButton:CGRectMake(5, 2, 60, 40) title:@"取消" image:@"AlbumLike"];
        [_likeButton addTarget:self action:@selector(onLike:) forControlEvents:UIControlEventTouchUpInside];
        [imageV addSubview:_likeButton];
        _likeButton.selected = NO;
    }else{
        _likeButton = [self getButton:CGRectMake(5, 2, 60, 40) title:@"赞" image:@"AlbumLike"];
        [_likeButton addTarget:self action:@selector(onLike:) forControlEvents:UIControlEventTouchUpInside];
        [imageV addSubview:_likeButton];
        _likeButton.selected = YES;
    }
   
    
    _commentButton = [self getButton:CGRectMake(70, 2, 60, 40) title:@"评" image:@"AlbumComment"];
    [_commentButton addTarget:self action:@selector(commentButton:) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:_commentButton];

    _detaileBtn = [self getButton:CGRectMake(kWidth-45, 2, 40, 40) title:@"" image:@"AlbumOperateMoreHL"];
    [_detaileBtn addTarget:self action:@selector(detaileButton:) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:_detaileBtn];
    
}
- (void)createToolBarItems{
    UIBarButtonItem *deletBar =[[UIBarButtonItem alloc]initWithTitle:@". . ." style:UIBarButtonItemStylePlain target:self action:@selector(delete:)];
    self.navigationItem.rightBarButtonItem = deletBar;
    
}
- (void)delete:(UINavigationItem*)sender{
    UIActionSheet *actionSheet =[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"发送给QQ好友" otherButtonTitles:@"发送给微信好友",@"保存图片",@"删除", nil];
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
    actionSheet.tag=100;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag==100) {
        if (buttonIndex ==0) {
            NSLog(@"发送给QQ好友");
            [self performSelector:@selector(delayView) withObject:nil afterDelay:0.6];
            
        }
        else if (buttonIndex==1){
            NSLog(@"发送给微信好友");
            
            [self performSelector:@selector(delayWX) withObject:nil afterDelay:0.6];
        }
        else  if (buttonIndex==2){
            NSLog(@"保存图片");
            [self performSelector:@selector(delaySavePic) withObject:nil afterDelay:0.6];
            
        } else  if (buttonIndex==3){
            NSLog(@"删除");
            [self performSelector:@selector(delayDelete) withObject:nil afterDelay:0.6];
        }
        else{
            NSLog(@"cancel");
        }
    }else{
        
    }
}

- (void)delaySavePic{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImageWriteToSavedPhotosAlbum(nil, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            });
}

- (void)delayDelete{
 
    [SVProgressHUD showSuccessWithStatus:@"删除成功"];
}
- (void)delayWX{
    [[UMSocialControllerService defaultControllerService] setShareText:@"猩猩教室" shareImage:[UIImage imageNamed:@"11111.png"]socialUIDelegate:self];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler([UIApplication sharedApplication].keyWindow.rootViewController,[UMSocialControllerService defaultControllerService],YES);
    
}
- (void)delayView{
    [[UMSocialControllerService defaultControllerService] setShareText:@"猩猩教室" shareImage:[UIImage imageNamed:@"11111.png"]socialUIDelegate:self];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler([UIApplication sharedApplication].keyWindow.rootViewController,[UMSocialControllerService defaultControllerService],YES);
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"成功保存到相册"];
    }
}

- (void)commentButton:(UIButton*)shareBtn{
    CommentInputViewController *commentInputVC = [[CommentInputViewController alloc] init];
    commentInputVC.itemId = _itemId;
    [self.navigationController pushViewController:commentInputVC animated:YES];
    
}
- (void)detaileButton:(UIButton*)btn{
    MessageListDetailController *messageListDetailVC = [[MessageListDetailController alloc] init];
    messageListDetailVC.talkId = _itemId;
    [self.navigationController pushViewController:messageListDetailVC animated:YES];

}

//点赞
-(void)onLike:(UIButton *)shareBtn{
    
    if (_likeButton.selected == NO) {
        
             [self onClickLikeButton];
        
    }else if (_likeButton.selected == YES){
        
             [self onClickLikeButton];
    }
}

-(void)onClickLikeButton{
    //点赞网络请求
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/my_circle_good";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"talk_id":_itemId,
                           };
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject){
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"] ){
             [SVProgressHUD showSuccessWithStatus:@"点赞成功"];
             [_likeButton setTitle:@"取消" forState:UIControlStateSelected];
             _likeButton.selected = !_likeButton.selected;
         }else{
             [SVProgressHUD showSuccessWithStatus:@"取消点赞"];
              [_likeButton setTitle:@"赞" forState:UIControlStateNormal];
             _likeButton.selected = !_likeButton.selected;
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
     }];
}


- (BOOL)isDirectShareInIconActionSheet{
    return YES;
}

-(UIButton *) getButton:(CGRect) frame title:(NSString *) title image:(NSString *) image
{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return btn;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

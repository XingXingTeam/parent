//
//  RedFlowerViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/3/24.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "RedFlowerViewController.h"
#import "MBProgressHUD.h"
#import <ShareSDKUI/ShareSDKUI.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
// UM
#import "CoreUMeng.h"
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "APOpenAPI.h"
#import "HHControl.h"
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "ReportPicViewController.h"
@interface RedFlowerViewController ()<UIActionSheetDelegate,UIScrollViewDelegate,UMSocialUIDelegate>
{
    UIImageView *imageview;
    UIScrollView *_scrollView;
    MBProgressHUD *HUD;
    MBProgressHUD *HUDH;
    UIButton *saveBtn;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}
/**
 *  面板
 */
@property(nonatomic,retain) NSArray *ittms;

@end

@implementation RedFlowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"图片";
    _ittms = [[NSArray alloc]init];
    _ittms =self.imageArr;
    self.view.backgroundColor = [UIColor blackColor];
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    [self createBigImage];
    [self createToolbtn];
    
    
}
//设置收藏
- (void)customCollection{
    
    saveBtn =[HHControl createButtonWithFrame:CGRectMake(251, 0, 26, 26) backGruondImageName:@"收藏icon44x44" Target:self Action:@selector(shareButn:) Title:nil];
    
    
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}


- (void)createBigImage{
    
    _scrollView =  [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-44)];
    _scrollView.pagingEnabled =YES;
    _scrollView.showsHorizontalScrollIndicator =NO;
    [self.view addSubview:_scrollView];
    
    for (int i=0; i<_ittms.count; i++) {
        UIImageView *imV = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth*i, 0, kWidth, kHeight-44)];
        imV.contentMode = UIViewContentModeScaleAspectFit;
        imV.userInteractionEnabled =YES;
        [imV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picURL,_ittms[i]]] placeholderImage:[UIImage imageNamed:@"picterPlace"]];
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(clickWithLongTap:)];
        
        [imV  addGestureRecognizer:longTap];
        
        [_scrollView addSubview:imV];
    }
    
    //    _scrollView.contentSize =CGSizeMake(_ittms.count*kWidth, 0);
    //    _scrollView.delegate =self;
    
    CGPoint contentOffset = _scrollView.contentOffset;
    contentOffset.x = self.index * kWidth;
    [_scrollView setContentOffset:contentOffset animated:YES];
    
    //    [self createToolBarItems];
    _scrollView.contentSize =CGSizeMake(_ittms.count*kWidth, 0);
    _scrollView.delegate =self;
    
}
//收藏
- (void)clickWithLongTap:(UILongPressGestureRecognizer *)longTap
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 =[UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self  collectImagV];
        
    }];
    UIAlertAction *action2 =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)collectImagV{
    
    CGPoint contentOffset =_scrollView.contentOffset;
    int d =contentOffset.x/kWidth;
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/col_pic_all";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"url":[NSString stringWithFormat:@"%@",_ittms[d]],
                           };
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             
             NSLog(@"收藏成功!");
             [SVProgressHUD setBackgroundColor:[UIColor lightGrayColor]];
             [SVProgressHUD showSuccessWithStatus:@"已收藏"];
             
         }
         //@"网络不通，请检查网络！"
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [SVProgressHUD showErrorWithStatus:@"收藏失败"];
         
     }];
    
    
}


- (void)createToolbtn{
    
    UIImageView *imageV;
    if (_isFromStarRemark == YES) {
        imageV= [[UIImageView alloc]initWithFrame:CGRectMake(0, kHeight- 49 - 64, kWidth, 49)];
    }else{
        imageV= [[UIImageView alloc]initWithFrame:CGRectMake(0, kHeight-49, kWidth, 49)];
    }
    
    imageV.backgroundColor = UIColorFromRGB(255, 255, 255 );
    [self.view addSubview:imageV];
    imageV.userInteractionEnabled =YES;
    
    UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth/2-20, 2, 30, 30)];
    [shareBtn setTitle:@"" forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"分享icon60x48"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"分享(H)icon60x48"] forState:UIControlStateHighlighted];
    [shareBtn addTarget:self action:@selector(shareButn:) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:shareBtn];
    
    UILabel *shareLbl =[HHControl createLabelWithFrame:CGRectMake(kWidth/2-15, 30, 20, 18) Font:10 Text:@"分享"];
    [imageV addSubview:shareLbl];
    //jubao
    
    
    UIButton *KTBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth-50, 2, 30, 30)];
    [KTBtn setTitle:@"" forState:UIControlStateNormal];
    [KTBtn setImage:[UIImage imageNamed:@"举报icon48x48"] forState:UIControlStateNormal];
    [KTBtn setImage:[UIImage imageNamed:@"举报(H)icon48x48"] forState:UIControlStateHighlighted];
    [KTBtn addTarget:self action:@selector(KTButn:) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:KTBtn];
    
    UILabel *KTLbl =[HHControl createLabelWithFrame:CGRectMake(kWidth-45, 30, 20, 18) Font:10 Text:@"举报"];
    [imageV addSubview:KTLbl];
    
    UIButton *downBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 2, 30, 30)];
    [downBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [downBtn setTitle:@"" forState:UIControlStateNormal];
    [downBtn setImage:[UIImage imageNamed:@"下载icon48x48"] forState:UIControlStateNormal];
    [downBtn setImage:[UIImage imageNamed:@"下载(H)icon48x48"] forState:UIControlStateHighlighted];
    [downBtn addTarget:self action:@selector(downButn:) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:downBtn];
    
    UILabel *downLbl =[HHControl createLabelWithFrame:CGRectMake(23, 30, 20, 18) Font:10 Text:@"下载"];
    [imageV addSubview:downLbl];
    
}
- (void)KTButn:(UIButton*)btn{
    ReportPicViewController *reportPicVC = [[ReportPicViewController alloc]init];
    
    CGPoint contentOffset =_scrollView.contentOffset;
    int d =contentOffset.x/kWidth;
    //    NSLog(@"当前 图片 URL %@", _ittms[d]);
    reportPicVC.picUrlStr = _ittms[d];
    reportPicVC.origin_pageStr = _origin_pageStr;
    
    //    NSLog(@"当前 图片 URL %@  ---  举报 来源  %@", _ittms[d], _origin_pageStr);
    
    [self.navigationController pushViewController:reportPicVC animated:YES];
    
}
- (void)createToolBarItems{
    
}

- (void)savePic{
    
    
    
    
}
- (void)shareButn:(UIButton*)btn{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 =[UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [CoreUmengShare show:self text:@"为了孩子的未来,这里有你想要的一切,快点点击下载吧！https://itunes.apple.com/cn/app/jie-dian-qian-zhuan-ye-ban/id1112373854?mt=8&v0=WWW-GCCN-ITSTOP100-FREEAPPS&l=&ign-mpt=uo%3D4" image:[UIImage imageNamed:@"猩猩教室.png"]];
    }];
    
    UIAlertAction *action3 =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:action1];
    // [alertController addAction:action2];
    [alertController addAction:action3];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (BOOL)isDirectShareInIconActionSheet{
    return YES;
}
- (void)downButn:(UIButton*)btn{
    HUD =[[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:HUD];
    //下载图片
    CGPoint contentOffset = _scrollView.contentOffset;
    int i =contentOffset.x/kWidth;
    NSString *numStr =[NSString stringWithFormat:@"%@",_ittms[i]];
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",picURL,numStr]);
    UIImageView *imagV =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    imagV.contentMode =UIViewContentModeScaleAspectFit;
    [imagV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picURL,numStr]]];
    
    HUD.dimBackground =YES;
    HUD.labelText =@"正在下载中.....";
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        UIImageWriteToSavedPhotosAlbum(imagV.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        [HUD removeFromSuperview];
        HUD =nil;
    }];
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void*)contextInfo{
    
    if (error == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已存入手机相册" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [alert show];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
}
@end

//
//  UpViewController.m
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/3/15.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "UpViewController.h"
#import "MBProgressHUD.h"
#import <ShareSDKUI/ShareSDKUI.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
// UM
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "APOpenAPI.h"
#import "HHControl.h"
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "ReportPicViewController.h"
#import "CoreUMeng.h"
@interface UpViewController ()<UIActionSheetDelegate,UIScrollViewDelegate,UMSocialUIDelegate>
{
    UIImageView *imageview;
    UIScrollView *_scrollView;
    MBProgressHUD *HUD;
    MBProgressHUD *HUDH;
    UIButton *saveBtn;
    NSArray *arrayForData;
    UIButton *redBtn;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}
/**
 *  面板
 */
@property (nonatomic, strong) UIView *panelView;

/**
 *  加载视图
 */
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property(nonatomic,retain) NSMutableArray *ittms;
@end

@implementation UpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self createRightBar];
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    [self.navigationController.navigationBar setTintColor:UIColorFromRGB(255, 255, 255)];
    _scrollView =  [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-44)];
    _scrollView.pagingEnabled =YES;
    _scrollView.delegate =self;
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
    //
    [self createToolbtn];
    
    _ittms = [[NSMutableArray alloc]init];
   
    
    for (int i=0; i<self.imageA.count; i++) {
        
        if ([self.imageA[i] isEqualToString:@""]) {
        
            
        }
        else{
        
            [_ittms addObject:self.imageA[i]];
        }
        
    }
    self.title =@"照片";
    self.view.backgroundColor = UIColorFromRGB(255, 255, 255);
    
    
    for (int i=0; i<_ittms.count; i++) {
        UIImageView *imV = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth*i, 0, kWidth, kHeight-44)];
        imV.contentMode =UIViewContentModeScaleAspectFit;
        [imV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picURL,_ittms[i]]] placeholderImage:[UIImage imageNamed:@"picterPlace"]];
        imV.userInteractionEnabled =YES;
        //headImage
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(clickWithLongTap:)];
        //0.5
        [imV addGestureRecognizer:longTap];

        [_scrollView addSubview:imV];
    }
    CGPoint contentOffset = _scrollView.contentOffset;
    contentOffset.x = self.index * kWidth;
    [_scrollView setContentOffset:contentOffset animated:YES];
    
    [self createToolBarItems];
    _scrollView.contentSize =CGSizeMake((_ittms.count*kWidth+1), 0);
    _scrollView.delegate =self;
   
}
//收藏
- (void)clickWithLongTap:(UILongPressGestureRecognizer *)longTap
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 =[UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self createRightBar];
        
    }];
    UIAlertAction *action2 =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
 
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:nil];

}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld",buttonIndex);
}
- (void)createRightBar{

    HUDH =[[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:HUDH];
    CGPoint contentOffset =_scrollView.contentOffset;
    int d =contentOffset.x/kWidth;
    
    /*
     【收藏图片】通用接口,用于不同页面的图片收藏
     接口:
     http://www.xingxingedu.cn/Global/col_pic_all
     传参:
     url	//图片地址,不带http...头部,是我们服务器中的图片,比如:app_upload/text/class/class_c1.jpg
     */
    
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/col_pic_all";
    
    //请求参数
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE,@"url":[NSString stringWithFormat:@"%@",_ittms[d]]};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
        
//        NSLog(@"%@", responseObj);
        
        NSDictionary *dict = responseObj;
        
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
                     {
            
                         NSLog(@"收藏成功!");
                         [SVProgressHUD setBackgroundColor:[UIColor lightGrayColor]];
                         [SVProgressHUD showSuccessWithStatus:@"已收藏"];
                         
                     }
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
        [SVProgressHUD showErrorWithStatus:@"收藏失败"];
    }];
    
        
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
 
    CGPoint contentOffset =scrollView.contentOffset;
    NSInteger i =contentOffset.x/kWidth;
    if (self.goodNMArr.count>=i) {
        
        [redBtn setTitle:[NSString stringWithFormat:@"%@",self.goodNMArr[i]] forState:UIControlStateNormal];
    }

}
- (void)createToolbtn{

    UIImageView *imageV;
    if (_isFromSchoolIntroduction == YES) {
        imageV= [[UIImageView alloc]initWithFrame:CGRectMake(0, kHeight- 49 - 64, kWidth, 49)];
    }else{
        imageV= [[UIImageView alloc]initWithFrame:CGRectMake(0, kHeight-49, kWidth, 49)];
    }
    imageV.backgroundColor = UIColorFromRGB(240, 240, 240);
    [self.view addSubview:imageV];
    imageV.userInteractionEnabled =YES;
    
    CGFloat buttonWidth = kWidth / 2;
    CGFloat buttonHeight = 49;
    
    UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 2, buttonWidth, buttonHeight)];
    [shareBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"分享icon60x48"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"分享(H)icon60x48"] forState:UIControlStateHighlighted];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [shareBtn addTarget:self action:@selector(shareButn:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置 图片 位置
    shareBtn.imageEdgeInsets = UIEdgeInsetsMake(-10 * kHeight/667, buttonWidth / 2 - 65 * kWidth/375, 0, 0);
    //设置title在button上的位置（上top，左left，下bottom，右right）
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(30 * kHeight/667, -shareBtn.titleLabel.bounds.size.width-20, 0, 0);
    
    [imageV addSubview:shareBtn];
    
    UIButton *downBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth / 2, 2, buttonWidth, buttonHeight)];
     [downBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [downBtn setTitle:@"下载" forState:UIControlStateNormal];
    [downBtn setImage:[UIImage imageNamed:@"下载icon48x48"] forState:UIControlStateNormal];
    [downBtn setImage:[UIImage imageNamed:@"下载(H)icon48x48"] forState:UIControlStateHighlighted];
    downBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [downBtn addTarget:self action:@selector(downButn:) forControlEvents:UIControlEventTouchUpInside];
    //设置 图片 位置
    downBtn.imageEdgeInsets = UIEdgeInsetsMake(-10 * kHeight/667, buttonWidth / 2 - 65 * kWidth/375, 0, 0);
    //设置title在button上的位置（上top，左left，下bottom，右right）
    downBtn.titleEdgeInsets = UIEdgeInsetsMake(30 * kHeight/667, -downBtn.titleLabel.bounds.size.width-20, 0, 0);
    
    
    [imageV addSubview:downBtn];

//    saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth-45, 2, 30, 30)];
//     [saveBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [saveBtn setTitle:@"" forState:UIControlStateNormal];
//    [saveBtn setImage:[UIImage imageNamed:@"点赞icon48x48@2x"] forState:UIControlStateNormal];
//     [saveBtn setImage:[UIImage imageNamed:@"点赞（H）icon48x48@2x"] forState:UIControlStateHighlighted];
//    [imageV addSubview:saveBtn];
//    //点赞数量
//    redBtn = [[UIButton alloc]initWithFrame:CGRectMake(20,-10, 20, 20) ];
//    [redBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    
//    if (self.goodNMArr.count!=0) {
//        [redBtn setTitle:[NSString stringWithFormat:@"%@",self.goodNMArr[0]] forState:UIControlStateNormal];
//    }
//    redBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    redBtn.titleLabel.font =[UIFont boldSystemFontOfSize:12.0f];
//    //[UIFont systemFontOfSize:12.0f];
//    redBtn.backgroundColor = [UIColor whiteColor];
//    
//    [redBtn.layer setMasksToBounds:YES];   //设置yes
//    [redBtn.layer setCornerRadius:10.0f];   //弧度等于宽度的一半 就是圆角
//    
//    [saveBtn addSubview:redBtn];
//
//    [saveBtn addTarget:self action:@selector(shareBtn:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UILabel *saveLbl =[HHControl createLabelWithFrame:CGRectMake(kWidth-43, 30, 20, 18) Font:10 Text:@"点赞"];
//    [imageV addSubview:saveLbl];
    
}
- (void)createToolBarItems{
    
}

//- (void)shareBtn:(UIButton*)shareB{
//    CGPoint contentOffset =_scrollView.contentOffset;
//    NSInteger i =contentOffset.x/kWidth;
//    
//    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/class_album_good";
//    NSDictionary *dict = @{@"appkey":APPKEY,
//                           @"backtype":BACKTYPE,
//                           @"xid":parameterXid,
//                           @"user_id":parameterUser_Id,
//                           @"user_type":USER_TYPE,
//                           @"pic_id":self.idMArr[i],
//                           };
//    
//    [WZYHttpTool post:urlStr params:dict success:^(id responseObj) {
//        NSDictionary *dict =responseObj;
//        
//        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"3"] )
//        {
//            [self badTap:shareB];
//            
//        }
//
//        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
//        {
////            [self goodTap:shareB];
//            
//        }
//        
//    } failure:^(NSError *error) {
//        
//    }];
//    
//}
//- (void)badTap:(UIButton*)btn{
//    
//    [SVProgressHUD showErrorWithStatus:@"已点过赞!"];
//
//}
//- (void)goodTap:(UIButton*)btn{
//
//
//    HUDH =[[MBProgressHUD alloc]initWithView:self.view];
//    [self.view addSubview:HUDH];
//    
//    [btn setImage:[UIImage  imageNamed:@"点赞（H）icon48x48@2x"] forState:UIControlStateNormal];
//    HUDH.dimBackground =YES;
//    HUDH.labelText =@"已点赞";
//    
//    [redBtn setTitle:[NSString stringWithFormat:@"%d",[[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@",redBtn.currentTitle]] intValue]+1]   forState:UIControlStateNormal];
//    [HUDH showAnimated:YES whileExecutingBlock:^{
//        sleep(1);
//    } completionBlock:^{
//        [btn setImage:[UIImage  imageNamed:@"点赞icon48x48@2x"] forState:UIControlStateNormal];
//        [HUDH removeFromSuperview];
//        HUDH =nil;
//    }];
//
//
//}

- (void)shareButn:(UIButton*)btn{
    CGPoint contentOffset = _scrollView.contentOffset;
    int i =contentOffset.x/kWidth;
//    NSString *numStr =[NSString stringWithFormat:@"%@",_ittms[i]];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 =[UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
       [CoreUmengShare show:self text:@"为了孩子的未来,这里有你想要的一切,快点点击下载吧！https://itunes.apple.com/cn/app/jie-dian-qian-zhuan-ye-ban/id1112373854?mt=8&v0=WWW-GCCN-ITSTOP100-FREEAPPS&l=&ign-mpt=uo%3D4" image:[UIImage imageNamed:@"猩猩教室.png"]];
        
    }];
    UIAlertAction *action2 =[UIAlertAction actionWithTitle:@"举报 " style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ReportPicViewController *reportPicVC = [[ReportPicViewController alloc]init];
        reportPicVC.origin_pageStr = _origin_pageStr;
        reportPicVC.picUrlStr = _ittms[i];
        
//        NSLog(@"举报 来源 %@ ----  图片 URL %@", _origin_pageStr, _ittms[i]);
        
        [self.navigationController pushViewController:reportPicVC animated:YES];
        
    }];
    UIAlertAction *action3 =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:action1];
    [alertController addAction:action2];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

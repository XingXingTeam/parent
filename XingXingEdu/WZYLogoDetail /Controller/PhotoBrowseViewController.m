//
//  PhotoBrowseViewController.m
//  XingXingEdu
//
//  Created by Mac on 16/5/11.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "PhotoBrowseViewController.h"
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



#define kScreenWidth self.view.frame.size.width
#define kScreenHeight self.view.frame.size.height


@interface PhotoBrowseViewController ()<UIActionSheetDelegate,UIScrollViewDelegate,UMSocialUIDelegate>
{
    UIImageView *imageview;
    UIScrollView *_scrollView;
    MBProgressHUD *HUD;
    MBProgressHUD *HUDH;
    UIButton *saveBtn;
    NSArray *arrayForData;
    
    UIButton *redBtn;
    
    NSString *flagStr;
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

@implementation PhotoBrowseViewController

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self supportClickFetchNetData];

}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _imageA = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self createRightBar];
    [self.navigationController.navigationBar setTintColor:UIColorFromRGB(255, 255, 255)];
    _scrollView =  [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-44)];
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
    //
    [self createToolbtn];
    
    
    _ittms = [[NSMutableArray alloc]init];
    _ittms =self.imageA;
    
//    NSLog(@"hhhhhh%@  %ld",self.imageA,self.imageA.count);
    self.title =@"照片";
    self.view.backgroundColor = [UIColor blackColor];
    
    
    for (int i=0; i<self.imageA.count; i++) {
        UIImageView *imV = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth*i, 0, kWidth, kHeight-44)];
        imV.contentMode = UIViewContentModeScaleAspectFit;
        [imV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", picURL, _ittms[i]]] placeholderImage:nil];
//        imV.image =[UIImage imageNamed:_ittms[i]];
        imV.userInteractionEnabled =YES;
        //长按 收藏
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(clickWithLongTap:)];
        
        [imV addGestureRecognizer:longTap];
        
        
        [_scrollView addSubview:imV];
    }
    CGPoint contentOffset = _scrollView.contentOffset;
    contentOffset.x = self.index * kWidth;
    [_scrollView setContentOffset:contentOffset animated:YES];
    
//    [self createToolBarItems];
    _scrollView.contentSize =CGSizeMake(_ittms.count*kWidth, 0);
    _scrollView.delegate =self;
    
    
}
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
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":XID, @"user_id":USER_ID, @"user_type":USER_TYPE,@"url":[NSString stringWithFormat:@"%@",_ittms[d]]};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        
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


- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated{
    
    
}
- (void)createToolbtn{
    
    UIImageView *imageV= [[UIImageView alloc]initWithFrame:CGRectMake(0, kHeight-110, kWidth, 110)];
    imageV.backgroundColor = UIColorFromRGB(255, 255, 255 );
    [self.view addSubview:imageV];
    imageV.userInteractionEnabled =YES;
    
    UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth/2-20, 5, 24, 24)];
    [shareBtn setTitle:@"" forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"分享icon60x48"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"分享(H)icon60x48"] forState:UIControlStateHighlighted];
    [shareBtn addTarget:self action:@selector(shareButn:) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:shareBtn];
    
    UILabel *shareLbl =[HHControl createLabelWithFrame:CGRectMake(kWidth/2-15, 30, 20, 14) Font:8 Text:@"分享"];
    [imageV addSubview:shareLbl];
    
    UIButton *downBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 5, 24, 24)];
    [downBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [downBtn setTitle:@"" forState:UIControlStateNormal];
    [downBtn setImage:[UIImage imageNamed:@"下载icon48x48"] forState:UIControlStateNormal];
    [downBtn setImage:[UIImage imageNamed:@"下载(H)icon48x48"] forState:UIControlStateHighlighted];
    [downBtn addTarget:self action:@selector(downButn:) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:downBtn];
    
    UILabel *downLbl =[HHControl createLabelWithFrame:CGRectMake(23, 30, 20, 14) Font:8 Text:@"下载"];
    [imageV addSubview:downLbl];
    

    saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth-45, 5, 24, 24)];
    [saveBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [saveBtn setTitle:@"" forState:UIControlStateNormal];
    [saveBtn setImage:[UIImage imageNamed:@"点赞icon48x48"] forState:UIControlStateNormal];
    [saveBtn setImage:[UIImage imageNamed:@"点赞（H）icon48x48"] forState:UIControlStateHighlighted];
    [imageV addSubview:saveBtn];
    
    //点赞数量
    redBtn = [[UIButton alloc]initWithFrame:CGRectMake(20,-10, 20, 20) ];
    [redBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
//    NSLog(@"%ld", _index);
//    NSLog(@"%@", _goodNMArr);
//    NSLog(@"%@", _goodNMArr[_index]);
    
    NSString *numStr;
    
    if (self.goodNMArr.count!=0) {
        numStr = [NSString stringWithFormat:@"%@",self.goodNMArr[_index]];
        
        flagStr = numStr;
        
        [redBtn setTitle: flagStr forState:UIControlStateNormal];
    }
    
    
//    NSLog(@"%@", redBtn.titleLabel.text);
    
    redBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    redBtn.titleLabel.font =[UIFont boldSystemFontOfSize:12.0f];
    //[UIFont systemFontOfSize:12.0f];
    redBtn.backgroundColor = [UIColor whiteColor];
    
    [redBtn.layer setMasksToBounds:YES];   //设置yes
    [redBtn.layer setCornerRadius:10.0f];   //弧度等于宽度的一半 就是圆角
    
    [saveBtn addSubview:redBtn];

    [saveBtn addTarget:self action:@selector(shareBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *saveLbl =[HHControl createLabelWithFrame:CGRectMake(kWidth-43, 30, 20, 14) Font:8 Text:@"点赞"];
    [imageV addSubview:saveLbl];
    
}

- (void)shareBtn:(UIButton*)shareB{

    [self supportClickFetchNetData];
    
    if ([flagStr isEqualToString:@"1"]) {
        
        [self goodTap:shareB];
        
    }else if ([flagStr isEqualToString:@"3"]){
        
        [self badTap:shareB];
    
    }
    
}


- (void)supportClickFetchNetData{

    CGPoint contentOffset =_scrollView.contentOffset;
    NSInteger i =contentOffset.x/kWidth;
    
    /*
     【猩课堂--对学校相册的图片点赞】
     
     接口:
     http://www.xingxingedu.cn/Global/school_album_good
     
     传参:
     pic_id		//图片id
     */
    //    NSLog(@"idMarr -- %@", _idMArr);
    //
    //    NSLog(@"i --- %ld", _i);
    //
    NSLog(@"index -- %ld", _index);
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/school_album_good";
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"pic_id":self.idMArr[i],
                           };
    
    [WZYHttpTool post:urlStr params:dict success:^(id responseObj) {
        NSDictionary *dict =responseObj;
        
        //        NSLog(@"%@", dict);
        /*
         {
         msg = Error!已点过赞!,
         data = ,
         code = 3
         }
         */
        
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"3"] )
        {
            flagStr = @"3";
//            [self badTap:shareB];
            
        }
        
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
            flagStr = @"1";
//            [self goodTap:shareB];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)badTap:(UIButton*)btn{
    
    [SVProgressHUD showErrorWithStatus:@"已点过赞!"];
    
}
- (void)goodTap:(UIButton*)btn{
    
    
    HUDH =[[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:HUDH];
    
    [btn setImage:[UIImage  imageNamed:@"点赞（H）icon48x48@2x"] forState:UIControlStateNormal];
    HUDH.dimBackground =YES;
    HUDH.labelText =@"已点赞";
    
    [redBtn setTitle:[NSString stringWithFormat:@"%d",[[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@",redBtn.currentTitle]] intValue]+1]   forState:UIControlStateNormal];
    [HUDH showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [btn setImage:[UIImage  imageNamed:@"点赞icon48x48@2x"] forState:UIControlStateNormal];
        [HUDH removeFromSuperview];
        HUDH =nil;
    }];
    
    
}


//@"56d4096e67e58ef29300147c"
- (void)shareButn:(UIButton*)btn{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 =[UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"share");
//        [UMSocialSnsService  presentSnsIconSheetView:self appKey:@"56d4096e67e58ef29300147c" shareText:@"keenteam" shareImage:[UIImage imageNamed:@"11111.png"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToQzone,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToSina,UMShareToQQ,nil] delegate:self];
//
         [CoreUmengShare show:self text:@"为了孩子的未来,这里有你想要的一切,快点点击下载吧！https://itunes.apple.com/cn/app/jie-dian-qian-zhuan-ye-ban/id1112373854?mt=8&v0=WWW-GCCN-ITSTOP100-FREEAPPS&l=&ign-mpt=uo%3D4" image:[UIImage imageNamed:@"猩猩教室.png"]];
        //
        
    }];
    UIAlertAction *action2 =[UIAlertAction actionWithTitle:@"举报 " style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ReportPicViewController *reportPicVC = [[ReportPicViewController alloc]init];
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
//     NSLog(@"%@",[NSString stringWithFormat:@"88888%@%@",picURL,numStr]);
    UIImageView *imagV =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    imagV.contentMode =UIViewContentModeScaleAspectFit;
    [imagV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picURL,numStr]]];
    
    HUD.dimBackground =YES;
    HUD.labelText =@"正在下载中.....";
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
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
       
        NSLog(@"%@", error);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
}



@end

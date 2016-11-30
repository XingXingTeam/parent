

//
//  XXEImageBrowsingViewController.m
//  teacher
//
//  Created by Mac on 16/9/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEImageBrowsingViewController.h"
//#import "XXEAlbumDetailsModel.h"
//#import "SDCycleScrollView.h"
//#import "XXEVerticalButton.h"
//#import "KTActionSheet.h"
#import "ReportPicViewController.h"
<<<<<<< HEAD
//#import "XXEAllImageCollectionApi.h"
=======
#import "XXEAllImageCollectionApi.h"
>>>>>>> 635d5bd74bcb23068c8e23776c53bc63c206b6fc
//#import "XXEHomePageCollectionPhotoApi.h"
//#import "AppDelegate.h"
#import "UMSocial.h"
#import "HHControl.h"
<<<<<<< HEAD
#import "AllImageCollectionServer.h"
=======
>>>>>>> 635d5bd74bcb23068c8e23776c53bc63c206b6fc



@interface XXEImageBrowsingViewController ()<UIActionSheetDelegate, UIScrollViewDelegate, UMSocialUIDelegate>
{
    //图片浏览 的 底层 scrollview
    UIScrollView *bgScrollView;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
    //下载 按钮
    UIButton *downloadButton;
    //分享 按钮
    UIButton *shareButton;
    //举报 按钮
    UIButton *reportButton;
}


@end

@implementation XXEImageBrowsingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    [self createContent];
    
    //创建 底部 view
    [self createBottomViewButton];
}

- (void)createContent{
<<<<<<< HEAD
    self.automaticallyAdjustsScrollViewInsets = YES;
=======
>>>>>>> 635d5bd74bcb23068c8e23776c53bc63c206b6fc
    //--------  bgScrollView  ---------
    bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 44)];
    bgScrollView.pagingEnabled = YES;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    
    //判断 进入 图片 浏览 模式 时,应该 从 什么位置 开始
    CGPoint contentOffset = bgScrollView.contentOffset;
    contentOffset.x = _currentIndex * KScreenWidth;
    [bgScrollView setContentOffset:contentOffset animated:YES];
    
    bgScrollView.contentSize = CGSizeMake(_imageUrlArray.count * KScreenWidth, 0);
    bgScrollView.delegate = self;
    
    [self.view addSubview:bgScrollView];
    
     //创建 一个个 图片 视图
    if (_imageUrlArray.count != 0) {
        for (int i = 0; i < _imageUrlArray.count; i++ ) {
           
            UIImageView *imageCell = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth * i, 0, KScreenWidth, KScreenHeight - 44)];
            imageCell.contentMode = UIViewContentModeScaleAspectFit;
            imageCell.userInteractionEnabled = YES;
            [imageCell sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kXXEPicURL, _imageUrlArray[i]]] placeholderImage:[UIImage imageNamed:@""]];
            [bgScrollView addSubview:imageCell];
            
            //图片 长按 收藏
            UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapClick:)];
            [imageCell addGestureRecognizer:longTap];
        }
    }

}

//图片 长按 收藏
- (void)longTapClick:(UILongPressGestureRecognizer *)longTap{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //收藏 图片
        [self imageCollecting];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //取消 无操作
    }];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)imageCollecting{
    
    CGPoint contentOffset =bgScrollView.contentOffset;
    int d =contentOffset.x/kWidth;
    
<<<<<<< HEAD
    [[AllImageCollectionServer sharedInstance] allImageCollectionWitnXid:parameterXid user_id:parameterUser_Id url:_imageUrlArray[d] succeed:^(id request) {
        //
        //            NSLog(@"收藏 -- %@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request[@"code"]];
=======
    XXEAllImageCollectionApi *allImageCollectionApi = [[XXEAllImageCollectionApi alloc] initWithXid:parameterXid user_id:parameterUser_Id url:_imageUrlArray[d]];
    [allImageCollectionApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //
//            NSLog(@"收藏 -- %@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
>>>>>>> 635d5bd74bcb23068c8e23776c53bc63c206b6fc
        if ([codeStr isEqualToString:@"1"]) {
            [self showHudWithString:@"收藏成功!" forSecond:1.5];
        }else{
            [self showHudWithString:@"收藏失败!" forSecond:1.5];
        }
        
<<<<<<< HEAD
    } fail:^{
        //
        [self showHudWithString:@"请检查网络!" forSecond:1.5];
    }];
    
//    XXEAllImageCollectionApi *allImageCollectionApi = [[XXEAllImageCollectionApi alloc] initWithXid:parameterXid user_id:parameterUser_Id url:_imageUrlArray[d]];
//    [allImageCollectionApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        //
////            NSLog(@"收藏 -- %@", request.responseJSONObject);
//        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
//        if ([codeStr isEqualToString:@"1"]) {
//            [self showHudWithString:@"收藏成功!" forSecond:1.5];
//        }else{
//            [self showHudWithString:@"收藏失败!" forSecond:1.5];
//        }
//        
//    } failure:^(__kindof YTKBaseRequest *request) {
//        //
//        [self showHudWithString:@"请检查网络!" forSecond:1.5];
//    }];
=======
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"请检查网络!" forSecond:1.5];
    }];
>>>>>>> 635d5bd74bcb23068c8e23776c53bc63c206b6fc

    

}

- (void)createBottomViewButton{
    //发起聊天/查看圈子/分享/举报
<<<<<<< HEAD
    UIImageView *bottomView= [[UIImageView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 49, KScreenWidth, 49)];
=======
    UIImageView *bottomView= [[UIImageView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 49 - 64, KScreenWidth, 49)];
>>>>>>> 635d5bd74bcb23068c8e23776c53bc63c206b6fc
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    bottomView.userInteractionEnabled =YES;
    
    CGFloat itemWidth = KScreenWidth / 3;
    CGFloat itemHeight = 49;
    
    CGFloat buttonWidth = itemWidth;
    CGFloat buttonHeight = itemHeight;
    
    //----------------------------下载 ---------
    downloadButton = [UIButton buttonWithType:0];
    downloadButton.frame = CGRectMake(buttonWidth / 2 * 0, 2 * kScreenRatioHeight, buttonWidth, buttonHeight);
<<<<<<< HEAD
    [downloadButton setTitle:@"保存" forState:UIControlStateNormal];
    [downloadButton setTitleColor:[UIColor grayColor] forState:0];
=======
    [downloadButton setTitle:@"下载" forState:UIControlStateNormal];
>>>>>>> 635d5bd74bcb23068c8e23776c53bc63c206b6fc
    [downloadButton addTarget:self action:@selector(downloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    downloadButton = [UIButton createButtonWithFrame:CGRectMake backGruondImageName:nil Target:self Action:@selector(downloadButtonClick:) Title:@"下载"];
    [downloadButton setImage:[UIImage imageNamed:@"album_down_icon_click"] forState:UIControlStateNormal];
    [downloadButton setImage:[UIImage imageNamed:@"album_down_icon"] forState:UIControlStateHighlighted];
    downloadButton.titleLabel.font = [UIFont systemFontOfSize:10];
    //设置 图片 位置
    downloadButton.imageEdgeInsets = UIEdgeInsetsMake(-10 * kScreenRatioHeight, buttonWidth / 2 - 80 * kScreenRatioWidth, 0, 0);
    //设置title在button上的位置（上top，左left，下bottom，右right）
    downloadButton.titleEdgeInsets = UIEdgeInsetsMake(30 * kScreenRatioHeight, -downloadButton.titleLabel.bounds.size.width-60, 0, 0);
    [bottomView addSubview:downloadButton];
    
    //--------------------------------分享-------
    shareButton = [UIButton buttonWithType:0];
    shareButton.frame = CGRectMake(buttonWidth * 1, 2 * kScreenRatioHeight, buttonWidth, buttonHeight);
<<<<<<< HEAD
    [shareButton setTitleColor:[UIColor grayColor] forState:0];
=======
>>>>>>> 635d5bd74bcb23068c8e23776c53bc63c206b6fc
    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    shareButton = [UIButton createButtonWithFrame:CGRectMake backGruondImageName:nil Target:self Action:@selector(shareButtonClick:) Title:@"分享"];
    [shareButton setImage:[UIImage imageNamed:@"classAddress_share_unseleted_icon"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"classAddress_share_seleted_icon"] forState:UIControlStateHighlighted];
    shareButton.titleLabel.font = [UIFont systemFontOfSize:10];
    //设置 图片 位置
    shareButton.imageEdgeInsets = UIEdgeInsetsMake(-10 * kScreenRatioHeight, buttonWidth / 2 - 30 * kScreenRatioWidth, 0, 0);
    //设置title在button上的位置（上top，左left，下bottom，右right）
    shareButton.titleEdgeInsets = UIEdgeInsetsMake(30 * kScreenRatioHeight, -shareButton.titleLabel.bounds.size.width-20, 0, 0);
    [bottomView addSubview:shareButton];
    
    //--------------------------------举报-------
    reportButton = [UIButton buttonWithType:0];
    reportButton.frame = CGRectMake(buttonWidth * 2, 2 * kScreenRatioHeight, buttonWidth, buttonHeight);
<<<<<<< HEAD
    [reportButton setTitleColor:[UIColor grayColor] forState:0];
=======
>>>>>>> 635d5bd74bcb23068c8e23776c53bc63c206b6fc
    [reportButton setTitle:@"举报" forState:UIControlStateNormal];
    [reportButton addTarget:self action:@selector(reportButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    reportButton = [UIButton createButtonWithFrame:CGRectMake(buttonWidth * 2, 2 * kScreenRatioHeight, buttonWidth, buttonHeight) backGruondImageName:nil Target:self Action:@selector(reportButtonClick:) Title:@"举报"];
    [reportButton setImage:[UIImage imageNamed:@"classAddress_report_unseleted_icon"] forState:UIControlStateNormal];
    [reportButton setImage:[UIImage imageNamed:@"classAddress_report_seleted_icon"] forState:UIControlStateHighlighted];
    reportButton.titleLabel.font = [UIFont systemFontOfSize:10];
    //设置 图片 位置
    reportButton.imageEdgeInsets = UIEdgeInsetsMake(-10 * kScreenRatioHeight, buttonWidth / 2 + 7 * kScreenRatioWidth, 0, 0);
    //设置title在button上的位置（上top，左left，下bottom，右right）
    reportButton.titleEdgeInsets = UIEdgeInsetsMake(30 * kScreenRatioHeight, -reportButton.titleLabel.bounds.size.width + 20, 0, 0);
    [bottomView addSubview:reportButton];
    
}

#pragma mark - 下载
- (void)downloadButtonClick:(UIButton *)button{
    
//    NSLog(@"********下载 *******");
    CGPoint contentOffset =bgScrollView.contentOffset;
    int d =contentOffset.x/kWidth;
    NSString *imageUrl = _imageUrlArray[d];
    NSString *stringUtl = [NSString stringWithFormat:@"%@%@",kXXEPicURL,imageUrl];
    NSURL *url = [NSURL URLWithString:stringUtl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
//    NSLog(@"%@",image);
    [self saveImageToPgoto:image];
    
}

#pragma mark - 保存图片
- (void)saveImageToPgoto:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL) {
        [self showString:@"保存失败" forSecond:1.f];
    }else {
        [self showString:@"保存成功" forSecond:1.f];
    }
}


#pragma mark - 分享
- (void)shareButtonClick:(UIButton *)button
{
    CGPoint contentOffset =bgScrollView.contentOffset;
    int d =contentOffset.x/kWidth;
    NSString *imageUrl = _imageUrlArray[d];
    
    NSString *shareText = @"来自猩猩教室:";
    NSString *PicURL= [NSString stringWithFormat:@"%@%@",kXXEPicURL,imageUrl];
    UIImage *shareImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:PicURL]]];
    NSLog(@"%@",shareImage);
    
    //    snsNames 你要分享到的sns平台类型，该NSArray值是`UMSocialSnsPlatformManager.h`定义的平台名的字符串常量，有UMShareToSina，UMShareToTencent，UMShareToRenren，UMShareToDouban，UMShareToQzone，UMShareToEmail，UMShareToSms等
    //调用快速分享接口
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMSocialAppKey shareText:shareText shareImage:shareImage shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQzone,UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline,nil] delegate:self];
}

//分享的代理方法
- (void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    NSLog(@"关闭的是%u",fromViewControllerType);
}

//分享完成后的回调
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"信息是什么%@",response);
    //根据responseCode得到发送结果,如果分享成功
    if (response.responseCode == UMSResponseCodeSuccess) {
        //得到分享的微博平台名
        NSLog(@"share to sns name is%@",[[response.data allKeys]objectAtIndex:0]);
    }
    
}


#pragma mark - //举报
- (void)reportButtonClick:(UIButton *)button{
    
//    NSLog(@"********举报 *******");
    
    ReportPicViewController *reportVC = [[ReportPicViewController alloc]init];
    /*
     other_xid	//被举报人xid (举报用户时才有此参数)
     report_name_id	//举报内容id , 多个逗号隔开
     report_type	//举报类型 1:举报用户  2:举报图片
     url		//被举报的链接(report_type非等于1时才有此参数),如果是图片,不带http头部的,例如:app_upload/........
     origin_page	//举报内容来源(report_type非等于1时才有此参数),传参是数字:
     1:小红花赠言中的图片
     2:圈子图片
     3:猩课堂发布的课程图片
     4:学校相册图片
     5:班级相册
     6:老师点评
     7:作业图片
     8:星级评分图片
     */
    
    CGPoint contentOffset =bgScrollView.contentOffset;
    int d =contentOffset.x/kWidth;
    NSString *imageUrl = _imageUrlArray[d];
    reportVC.picUrlStr = imageUrl;
    reportVC.origin_pageStr = _origin_pageStr;
//    reportVC.report_type = @"2";
    [self.navigationController pushViewController:reportVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

//
//  ClassAlbumPicCollectionViewController.m
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/1/20.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define kTextLimit 3
#define kDataLimit 0
#define kData 1
#define kPreviewDataLimit @"Image"
#define kPreviewData @"Country"
#define kPreview @"Place"
#define kTiTleview @"相册图片"
#import "ClassAlbumPicCollectionViewController.h"
#import "ReportPicViewController.h"
#import "Cell.h"
#import "PhotosController.h"
#import "MBProgressHUD.h"
#import "HHControl.h"

#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "CoreUMeng.h"
@interface ClassAlbumPicCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate,UICollectionViewDataSource,CellDelegate,UMSocialUIDelegate>
{
    UIButton *checkBt;
    UIButton *saveBtn;
    NSMutableArray *dataSourceArray;
    NSMutableArray *itm;
    NSMutableArray *itms;
    MBProgressHUD *HUDH;
    Cell *cell;
    BOOL x;
}
@property (nonatomic, strong)NSMutableIndexSet *selectedIndexSet;
@property (assign,nonatomic)BOOL canDelete;
@end

@implementation ClassAlbumPicCollectionViewController

static NSString * const REUSEABLE_CELL_IDENTITY = @"Cell";
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationItem setHidesBackButton:NO];
    [self.navigationController setToolbarHidden:YES];
    self.navigationItem.rightBarButtonItem.title =@"选择";
    [self.collectionView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =kTiTleview;
    _canDelete =NO;
    [self createLeftBtn];
    [self createToolBar];
    self.selectedIndexSet = [NSMutableIndexSet indexSet];
    self.collectionView.backgroundColor = UIColorFromRGB(192, 192, 192);
    self.collectionView.delegate = self;
    self.collectionView.dataSource =self;
    self.view.backgroundColor = UIColorFromRGB(255, 255, 255);
    self.collectionView.allowsMultipleSelection =YES;
    itm = [[NSMutableArray alloc]init];
    itms = [[NSMutableArray alloc]init];
    itm=self.itmms;
    
        NSDictionary *dict = [[NSDictionary alloc]init];
        dict=itm[kDataLimit];
        [itms addObject:[UIImage imageNamed:[dict objectForKey:kPreviewDataLimit]]];
        [itms addObject:[UIImage imageNamed:[dict objectForKey:kPreviewData]]];
        [itms addObject:[UIImage imageNamed:[dict objectForKey:kPreview]]];
   
   [self.collectionView registerClass:[Cell class] forCellWithReuseIdentifier:REUSEABLE_CELL_IDENTITY];
    
    // Do any additional setup after loading the view.
}
- (void)createToolBar{
    UIBarButtonItem *placeBtn =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *downLoadBtn =[[UIBarButtonItem alloc]initWithTitle:@"下载" style:UIBarButtonItemStylePlain target:self action:@selector(downLoad:)];
    UIBarButtonItem *reportBtn =[[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(report:)];

    saveBtn =[HHControl createButtonWithFrame:CGRectMake(0, 0, 40, 40) backGruondImageName:@"" Target:self Action:@selector(share:) Title:@"收藏"];
    
    
    UIBarButtonItem *shareBt =[[UIBarButtonItem alloc]initWithCustomView:saveBtn];

    NSArray *arr =[[NSArray alloc]initWithObjects:downLoadBtn,placeBtn,reportBtn,placeBtn,shareBt, nil];
    self.toolbarItems =arr;
}
- (void)downLoad:(UIBarButtonItem*)down{
    HUDH =[[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:HUDH];
    
    HUDH.dimBackground =YES;
    HUDH.labelText =@"正在下载中.....";
    [HUDH showAnimated:YES whileExecutingBlock:^{
        sleep(3);
        HUDH.labelText =@"下载完成";
        
    } completionBlock:^{
        [HUDH removeFromSuperview];
        HUDH =nil;
        [self.navigationItem setHidesBackButton:NO];
        [self.navigationController setToolbarHidden:YES];
        self.navigationItem.rightBarButtonItem.title =@"选择";
        [self.collectionView reloadData];
    }];
    
}
//分享
- (void)report:(UIBarButtonItem*)report{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 =[UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

       [CoreUmengShare show:self text:@"为了孩子的未来,这里有你想要的一切,快点点击下载吧！https://itunes.apple.com/cn/app/jie-dian-qian-zhuan-ye-ban/id1112373854?mt=8&v0=WWW-GCCN-ITSTOP100-FREEAPPS&l=&ign-mpt=uo%3D4" image:[UIImage imageNamed:@"猩猩教室.png"]];
        
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
//收藏
- (void)share:(UIButton*)shareBtn{
    HUDH =[[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:HUDH];
    
    if (saveBtn.selected ==NO) {
        shareBtn.selected=YES;
        saveBtn=shareBtn;
        [saveBtn setBackgroundColor:[UIColor redColor]];
        HUDH.dimBackground =YES;
        HUDH.labelText =@"已收藏";
        [HUDH showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [HUDH removeFromSuperview];
            HUDH =nil;
            [self.navigationItem setHidesBackButton:NO];
            [self.navigationController setToolbarHidden:YES];
            self.navigationItem.rightBarButtonItem.title =@"选择";
            [self.collectionView reloadData];
        }];
    }
    else{
        shareBtn.selected=NO;
        saveBtn=shareBtn;
        HUDH.dimBackground =YES;
        [saveBtn setBackgroundColor:[UIColor whiteColor]];
        HUDH.labelText =@"取消收藏";
        [HUDH showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [HUDH removeFromSuperview];
            HUDH =nil;
            [self.navigationItem setHidesBackButton:NO];
            [self.navigationController setToolbarHidden:YES];
            self.navigationItem.rightBarButtonItem.title =@"选择";
            [self.collectionView reloadData];
        }];
    }
}
- (BOOL)isDirectShareInIconActionSheet{
    return YES;
}
- (void)createLeftBtn{
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(clickaddBtn:)];
    addBtn.tintColor = UIColorFromRGB(35, 78, 98);
    [self.navigationItem setRightBarButtonItem:addBtn];
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;

}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)clickaddBtn:(UIBarButtonItem*)btn{
    _canDelete =!_canDelete;
    [self.collectionView reloadData];
    
    UIBarButtonItem *button =btn;
    if(_canDelete)
    {
        button.title = @"取消";
        [self.navigationItem setHidesBackButton:YES];
        self.navigationController.toolbarHidden =NO;
        [self.collectionView reloadData];
    }
    else
    {
        button.title = @"选择";
        [self.navigationItem setHidesBackButton:NO];
        self.navigationController.toolbarHidden =YES;
        [self.collectionView reloadData];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark <UICollectionViewDataSource>
//
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return kData;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return kTextLimit;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:REUSEABLE_CELL_IDENTITY forIndexPath:indexPath];

    cell.imageview.image =[itms objectAtIndex:indexPath.row];
    //ceshi测试
    UIImageView *imageV =[[UIImageView alloc]initWithFrame:CGRectMake(50, 0, 40, 40)];
    imageV.image = [UIImage imageNamed:@"11111"];
    [cell.imageview addSubview:imageV];
    cell.bounds = CGRectMake(0,5,90,90);
    if ([self.navigationItem.rightBarButtonItem.title isEqual:@"选择"]) {
        cell.deleteBtn.hidden =YES;
    }
    else{
        cell.deleteBtn.hidden =NO;
      
    }
    return cell;
}

- (void)deleteCellAtIndexpath:(NSIndexPath *)path{
    if (itms.count==1) {
        return;
    }
    [self.collectionView performBatchUpdates:^{
        [itms removeObjectAtIndex:path.item];
        [self.collectionView deleteItemsAtIndexPaths:@[path]];
    } completion:^(BOOL finished) {
        [self.collectionView reloadData];
    }];

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  
    PhotosController *photo = [[PhotosController alloc]init];
    photo.imageArr =itms;
    photo.s =(int)indexPath.row;
    [self.navigationController pushViewController:photo animated:YES];

}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;

}

#pragma mark <UICollectionViewDelegate>



//- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
//	return YES;
//}



// Uncomment this method to specify if the specified item should be selected



/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end

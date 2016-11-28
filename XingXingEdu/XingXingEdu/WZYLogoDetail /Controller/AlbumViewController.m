//
//  AlbumViewController.m
//  XingXingEdu
//
//  Created by Mac on 16/5/10.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "AlbumViewController.h"
#import "AlbumCollectionViewCell.h"
#import "HHControl.h"

#import "UpViewController.h"

#define kScreenWidth self.view.frame.size.width
#define kScreenHeight self.view.frame.size.height


@interface AlbumViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSString *parameterXid;
    NSString *parameterUser_Id;
}
//    UICollectionView 是IOS6之后出现的控件，继承自UIScrollView,多用于展示图片
@property (nonatomic, strong) UICollectionView *myCollcetionView;

//  相册下方后退、播放 工具条
@property (nonatomic, strong) UIView *albumToolBarView;

@property (nonatomic ,copy) NSString *schoolIdStr;

@end

@implementation AlbumViewController

//刷新

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    //初始化数据源
    [self createData];
    
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataArray = [[NSMutableArray alloc] init];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    _dataArray = [[NSMutableArray alloc]init];
    
//  设置 navigationBar 上左右字体 颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = UIColorFromRGB(223, 226, 226);
    
    self.title = @"相册";

    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    //初始化数据源
    [self createData];
  
}

- (void)createData{
    
    /*
     【学校相册->图片列表】
     接口:
     http://www.xingxingedu.cn/Global/school_album_list
     传参:
     school_id		//学校id
     */
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/school_album_list";
    
    //请求参数
    //获取学校id数组
    NSString *schoolIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"SCHOOL_ID"];
    _schoolIdStr = schoolIdStr;
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"school_id":_schoolIdStr};
    
[WZYHttpTool post:urlStr params:params success:^(id responseObj) {
    
    _idArray = [[NSMutableArray alloc] init];
    _imageArray = [[NSMutableArray alloc] init];
    _good_numArray = [[NSMutableArray alloc] init];
    //
//    NSLog(@"%@", responseObj);
    
    _dataArray = responseObj[@"data"];
    
    for (NSDictionary *dic in _dataArray) {
        
        [_idArray addObject:dic[@"id"]];
        
        [_imageArray addObject:dic[@"url"]];
        
        [_good_numArray addObject:dic[@"good_num"]];
    }
    
    //设置内容
    [self customContent];
    
} failure:^(NSError *error) {
    //
    NSLog(@"%@", error);
}];

}



//相册 有数据 和 无数据 进行判断
- (void)customContent{
    if (_dataArray.count == 0) {
            // 1、无数据的时候
            UIImage *myImage = [UIImage imageNamed:@"人物"];
            CGFloat myImageWidth = myImage.size.width;
            CGFloat myImageHeight = myImage.size.height;
        
            UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - myImageWidth / 2, (kScreenHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
            myImageView.image = myImage;
            [self.view addSubview:myImageView];

    }else{
        //2、有数据的时候
        if (_myCollcetionView == nil) {
            
            [self createCollectionView];
            
        }else{
            
            [_myCollcetionView reloadData];
        
        }

    }
    
}


//初始化CollectionView
-(void)createCollectionView{
    
    //    UICollectionViewLayout 是苹果提供一个布局类，他是一个抽象类。
    //    苹果给我们提供了UICollectionViewFlowLayout，网格布局类
    //    当创建一个UICollectionView对象的时候，需要一个布局类的对象来布局
    
    //    布局对象
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //    默认是垂直滚动
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    //    设置行间距
    layout.minimumLineSpacing = 10;
    //    设置列间距
    layout.minimumInteritemSpacing = 10;
    //    设置item的大小
    layout.itemSize = CGSizeMake((kScreenWidth - 4 * 10) / 3, (kScreenWidth - 4 * 10) / 3);
    
    //    初始化UICollectionView,并设置布局对象
    self.myCollcetionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
    
    //    设置代理
    self.myCollcetionView.dataSource = self;
    self.myCollcetionView.delegate = self;
    
    [self.view addSubview:self.myCollcetionView];
    
    //    提前告诉_collectionView用什么视图作为显示的复用视图，并且设置复用标识
    //    一定要实现，否则会崩溃
    [self.myCollcetionView registerClass:[AlbumCollectionViewCell class] forCellWithReuseIdentifier:@"AlbumCollectionViewCell"];
}
#pragma mark -
//返回有几组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//返回每组有几个
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"AlbumCollectionViewCell";
    //    到复用池中找标识为AlbumCollectionViewCell 的空闲cell,如果有就使用，没有就创建
    AlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
//    NSLog(@"_dataArray[indexPath.item] -- %@",  _dataArray[indexPath.item]);
    
    cell.imageName = [NSString stringWithFormat:@"%@%@",picURL,_dataArray[indexPath.item][@"url"]];
    
    return cell;
}

//设置距离四边的距离
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//选中某一个item时的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    
    UpViewController *upVC =[[UpViewController alloc]init];
    upVC.i = _imageArray.count;
    upVC.index =indexPath.row;
    upVC.imageA = _imageArray;
    upVC.goodNMArr = _good_numArray;
    upVC.idMArr = _idArray;
    
    //举报 来源
    upVC.isFromSchoolIntroduction = YES;
    //4:学校相册图片
    upVC.origin_pageStr = @"4";
    
//    upVC.albumID =[NSString stringWithFormat:@"%@",self.albumID];
    [self.navigationController pushViewController:upVC animated:YES];
}

@end

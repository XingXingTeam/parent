






//
//  WZYAlbumDateISectionViewController.m
//  XingXingEdu
//
//  Created by Mac on 16/7/25.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//




#import "WZYAlbumDateISectionViewController.h"
#import "AlbumCollectionViewCell.h"
#import "PhotoBrowseViewController.h"
#import "HeaderFooterCollectionReusableView.h"
#import "UpViewController.h"


@interface WZYAlbumDateISectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>



//    UICollectionView 是IOS6之后出现的控件，继承自UIScrollView,多用于展示图片
@property (nonatomic, strong) UICollectionView *myCollcetionView;

@end

@implementation WZYAlbumDateISectionViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataArray = [[NSMutableArray alloc] init];
        _sectionTitleArray = [[NSMutableArray alloc] init];
        _imageDataSource = [[NSMutableArray alloc] init];
        _idDataSource = [[NSMutableArray alloc] init];
        _good_numDataSource = [[NSMutableArray alloc] init];
        
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

    //初始化数据源
    [self createData];
    
    //设置内容
    [self createCollectionView];
    
    
}

- (void)createData{


/*
 【班级相册->某个相册内容的照片】
 
 接口:
 http://www.xingxingedu.cn/Parent/class_album_pic
 
 传参:
 
	album_id	//相册id
 */
    
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/class_album_pic";
    
    //请求参数
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":XID, @"user_id":USER_ID, @"user_type":USER_TYPE, @"album_id":[NSString stringWithFormat:@"%@", _albumID]};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
    //
    
//        NSLog(@" 相册 数据  %@", responseObj);
        /*
         {
         msg = Success!,
         data = {
         1460355467 = [
         {
         id = 14,
         pic = app_upload/text/class/class_a5.jpg,
         good_num = 1,
         date_tm = 1460355467
         },
         {
         id = 15,
         pic = app_upload/text/class/class_a6.jpg,
         good_num = 1,
         date_tm = 1460355467
         },
         {
         id = 16,
         pic = app_upload/text/class/class_a7.jpg,
         good_num = 1,
         date_tm = 1460355467
         }
         ],
         1458994874 = [
         {
         id = 10,
         pic = app_upload/text/class/class_a1.jpg,
         good_num = 0,
         date_tm = 1458994874
         },
         {
         id = 13,
         pic = app_upload/text/class/class_a4.jpg,
         good_num = 0,
         date_tm = 1458994874
         }
         ],
         1458994864 = [
         {
         id = 11,
         pic = app_upload/text/class/class_a2.jpg,
         good_num = 1,
         date_tm = 1458994864
         },
         {
         id = 12,
         pic = app_upload/text/class/class_a3.jpg,
         good_num = 0,
         date_tm = 1458994864
         }
         ]
         },
         code = 1
         }
         */
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
        
        //根据 时间戳 对 图片进行 分组
            NSDictionary *dic = responseObj[@"data"];
            
            //遍历 字典
            
            for (NSString *timeStr in dic) {
             
                NSString *newStr = [WZYTool dateStringFromNumberTimer:timeStr];
                
                [_sectionTitleArray addObject:newStr];
            
                [_dataArray addObject:[dic objectForKey:timeStr]];
               
                _idArray = [[NSMutableArray alloc] init];
                _imageArray = [[NSMutableArray alloc] init];
                _good_numArray = [[NSMutableArray alloc] init];
                
                /*
                 {
                 id = 11,
                 pic = app_upload/text/class/class_a2.jpg,
                 good_num = 1,
                 date_tm = 1458994864
                 }
                 */
                for (NSDictionary *dictItem in [dic objectForKey:timeStr]) {
                   
                    [_idArray addObject:dictItem[@"id"]];
                    
                    [_imageArray addObject:dictItem[@"pic"]];
                    
                    [_good_numArray addObject: dictItem[@"good_num"]];
                }
                
                [_imageDataSource addObject:_imageArray];
                
                [_idDataSource addObject:_idArray];
                
                [_good_numDataSource addObject:_good_numArray];
                
            }
        
        }
        
        [_myCollcetionView reloadData];

    } failure:^(NSError *error) {
    //
    
        NSLog(@"%@", error);
        
    }];
    
    
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
    layout.itemSize = CGSizeMake((kWidth - 4 * 10) / 3, (kWidth - 4 * 10) / 3);
    
    //    初始化UICollectionView,并设置布局对象
    self.myCollcetionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64) collectionViewLayout:layout];
    
    _myCollcetionView.backgroundColor = [UIColor whiteColor];
    
    //    设置代理
    self.myCollcetionView.dataSource = self;
    self.myCollcetionView.delegate = self;
    
    [self.view addSubview:self.myCollcetionView];
    
    //    提前告诉_collectionView用什么视图作为显示的复用视图，并且设置复用标识
    //    一定要实现，否则会崩溃
    [self.myCollcetionView registerClass:[AlbumCollectionViewCell class] forCellWithReuseIdentifier:@"AlbumCollectionViewCell"];
    
    
    //    注册_collectionView分组的头视图
    //    提前告诉_collectionView用什么样的视图作为分组头视图的复用视图
    [_myCollcetionView registerClass:[HeaderFooterCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
}


#pragma mark -
//返回有几组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _dataArray.count;
}
//返回每组有几个
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_dataArray[section] count];
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"AlbumCollectionViewCell";
    //    到复用池中找标识为AlbumCollectionViewCell 的空闲cell,如果有就使用，没有就创建
    AlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
//    NSLog(@"%@", _dataArray[indexPath.section][indexPath.item][@"pic"]);
    
    cell.imageName = [NSString stringWithFormat:@"%@%@",picURL,_dataArray[indexPath.section][indexPath.item][@"pic"]];
    
    return cell;
}

//设置距离四边的距离
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//选中某一个item时的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UpViewController *upVC =[[UpViewController alloc]init];
    upVC.i = [self.dataArray[indexPath.section] count];
    upVC.index =indexPath.row;
    upVC.imageA = _imageDataSource[indexPath.section];
    upVC.goodNMArr = _good_numDataSource[indexPath.section];
    upVC.idMArr = _idDataSource[indexPath.section];
    upVC.albumID =[NSString stringWithFormat:@"%@",self.albumID];
    [self.navigationController pushViewController:upVC animated:YES];

    
}

//头视图

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        static NSString *identifier = @"header";
        HeaderFooterCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
        
        header.backgroundColor = UIColorFromRGB(229, 232, 233);
        header.title = _sectionTitleArray[indexPath.section];
        
        return header;
        
    }else{
    
        return nil;
    
    }

    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    return CGSizeMake(20, 20);
}


@end
